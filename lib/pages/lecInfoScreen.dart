import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class LectureInformationScreen extends StatefulWidget {
  @override 
  _LectureInformationScreen createState() {
    return _LectureInformationScreen();
  }
}

class _LectureInformationScreen extends State<LectureInformationScreen> {
  var lectureInfo = new Map();
  
  @override
  Widget build(BuildContext context) {
    lectureInfo = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text(lectureInfo['lecture']),
      ),
      body: Column(
        children: <Widget>[
          _buildLectureListHeader(),
          Expanded(
            child: _buildBody(context, lectureInfo),
          ),
        ],  
      ),
    );
  }

  Widget _buildLectureListHeader() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20.0),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(width: 3.0, color: Colors.grey)
        ),
      ),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(10.0),
                child: Column(
                  children: <Widget>[
                    Text(
                      "授業の質",
                      style: TextStyle(fontSize: 15),
                    ),
                    SizedBox(
                      width: 80,
                      height: 70,
                      child: Container(
                        padding: EdgeInsets.all(10.0),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.greenAccent[400],
                          border: Border.all(
                            color: Colors.greenAccent[400],
                            width: 5.0,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          lectureInfo['lectureSummary']['qualityAvg'].toString(),
                          style: TextStyle(fontSize: 30),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.all(10.0),
                child: Column(
                  children: <Widget>[
                    Text(
                      "難易度",
                      style: TextStyle(fontSize: 15),
                    ),
                    SizedBox(
                      width: 80,
                      height: 70,
                      child: Container(
                        padding: EdgeInsets.all(10.0),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.greenAccent[400],
                          border: Border.all(
                            color: Colors.greenAccent[400],
                            width: 5.0,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          lectureInfo['lectureSummary']['difficultyAvg'].toString(),
                          style: TextStyle(fontSize: 30),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Container(
            alignment: Alignment.centerRight,
            padding: EdgeInsets.only(right: 14),
            child: Text(lectureInfo['lectureSummary']['quantity'].toString() + '件の口コミ')
          ),
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context, Map lectureInfo) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection(lectureInfo['university']).document(lectureInfo['department']).collection(lectureInfo['lecture']).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return LinearProgressIndicator();

        return _buildList(context, snapshot.data.documents);
     },
   );
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return ListView(
      children: snapshot.map((data) => _buildListItem(context, data)).toList(),
    );
  }
  
  Widget _buildStarRate(int value) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return Icon(
          index < value ? Icons.star : Icons.star_border,
        );
      }),
    );
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
    final record = LectureInformation.fromSnapshot(data);
    return SizedBox(
      child: Container(
        padding: EdgeInsets.all(15.0),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Text(
                  '授業の質　',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  )
                ),
                SizedBox(width: 18.0),
                _buildStarRate(record.quality),
              ],
            ),
            SizedBox(height: 5.0),
            Row(
              children: <Widget>[
                Text(
                  '難易度　　',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  )
                ),
                SizedBox(width: 18.0),
                _buildStarRate(record.difficulty),
              ],
            ),
            SizedBox(height: 5.0),
            Row(
              children: <Widget>[
                Text(
                  '出席　　　',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  )
                ),
                SizedBox(width: 18.0),
                record.attendance == 1 
                ? Text('必須') : Text('必須でない'),
              ],
            ),
            SizedBox(height: 5.0),
            Row(
              children: <Widget>[
                Text(
                  '宿題の頻度',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  )
                ),
                SizedBox(width: 18.0),
                record.homework == 1 
                ? Text('毎回ある') : 
                  record.homework ==2 
                  ? Text('たまに') : Text('ほとんどない'),
              ],
            ),
            SizedBox(height: 5.0),
            Row(
              children: <Widget>[
                Container(
                  alignment: Alignment.topCenter,
                  child: Text(
                    'コメント　',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                    )
                  ),
                ),
                SizedBox(width: 18.0),
                Flexible(
                  child: Text(record.comment),
                ),
              ],
            ),
          ],
        ),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(width: 1.0, color: Colors.grey)
          ),
        ),
      ),
    );
  }
}

class LectureInformation {
  final int quality;
  final int difficulty;
  final int attendance;
  final int homework;
  final String comment;
  final DocumentReference reference;

  LectureInformation.fromMap(Map<String, dynamic> map, {this.reference})
    : assert(map['quality'] != null),
      assert(map['difficulty'] != null),
      assert(map['attendance'] != null),
      assert(map['hw'] != null),
      assert(map['comment'] != null),
      quality = map['quality'],
      difficulty = map['difficulty'],
      attendance = map['attendance'],
      homework = map['hw'],
      comment = map['comment'];
  
  LectureInformation.fromSnapshot(DocumentSnapshot snapshot)
    : this.fromMap(snapshot.data, reference: snapshot.reference);

  @override
  String toString() => "Record<$quality:$difficulty>";
}
