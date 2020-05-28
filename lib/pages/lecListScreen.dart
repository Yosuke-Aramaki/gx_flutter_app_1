import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class LectureListScreen extends StatefulWidget {
  @override 
  _LectureListScreen createState() {
    return _LectureListScreen();
  }
}

class _LectureListScreen extends State<LectureListScreen> {
  var lectureInformation = new Map();

  @override
  Widget build(BuildContext context) {
    lectureInformation = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black, 
        ),
        backgroundColor: Color(0xffFAFAFA),
        elevation: 0.0,
        title: Text('授業リスト'),
      ),
      body: lectureInformation['department'] == '指定しない' ? Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: <Widget>[
            _buildUniversityName(lectureInformation['university']),
            Expanded(
              child: _buildAllLecture(lectureInformation),
            ),
          ],
        ),
      )
      : Container(
        child: Column(
          children: <Widget>[
            _buildUniversityName(lectureInformation['university']),
            _buildDepartmentName(lectureInformation['department']),
            Expanded(
              child:  _buildBody(context, lectureInformation),
            ),
          ],  
        ), 
      ),  
    );
  }

  Widget _buildUniversityName(university) {
    return SizedBox(
      child: Container(
        margin: const EdgeInsets.only(top: 15.0, bottom: 15.0),
        padding: const EdgeInsets.all(8.0),
        alignment: Alignment.centerLeft,
        child: Text(
          university,
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  Widget _buildDepartmentName(department) {
    return SizedBox(
      child: Container(
        padding: EdgeInsets.only(bottom: 15.0),
        alignment: Alignment.centerLeft,
        child: Text(
          department,
          style: TextStyle(fontSize: 25),
        ),
      ),
    );
  }

  Widget _buildAllLecture(Map lectureInformation) {
    return ListView.builder(
      itemCount: lectureInformation['departmentList'].length,
      itemBuilder: (BuildContext context, int index) {
        return Container(
          padding: const EdgeInsets.only(top: 15.0, bottom: 15.0, left: 8.0),
          decoration: BoxDecoration(
            border: Border(top: BorderSide(color: Colors.grey)),
          ),
          child: Column(
            children: <Widget>[
              _buildDepartmentName(lectureInformation['departmentList'][index]),
              Column(children: <Widget>[
                StreamBuilder(
                  stream: Firestore.instance.collection('univ_list').document(lectureInformation['university']).collection('dep_list').document(lectureInformation['departmentList'][index]).collection('lec_list')
                    .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) return const Text("Loading...");
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data.documents.length,
                      itemBuilder: (context, index) {
                        final record = LectureSummary.fromSnapshot(snapshot.data.documents[index]);
                        return SizedBox(
                          child: Container(
                            margin: EdgeInsets.symmetric(vertical: 10.0),
                            padding: EdgeInsets.all(15.0),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey[600]),
                              borderRadius: BorderRadius.circular(10),
                              color: const Color(0xffFAFAFA),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black26,
                                  spreadRadius: 1.0,
                                  blurRadius: 5.0,
                                  offset: Offset(5, 5),
                                ),
                              ],
                            ),
                            child: Column(
                              children: <Widget>[
                                Container(
                                  padding: EdgeInsets.only(bottom: 10.0),
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    record.name,
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ),
                                Row(
                                  children: <Widget>[
                                    _buildStarRate(record.qualityAvg.round()),
                                    _buildStarRate(record.difficultyAvg.round()),
                                    Text(record.quantity.toString())
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                    );
                  }
                ),
              ],)
            ],
          ),
        );
      },
    );
  }


  Widget _buildBody(BuildContext context, Map lectureInformation) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('univ_list').document(lectureInformation['university']).collection('dep_list').document(lectureInformation['department']).collection('lec_list').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return LinearProgressIndicator();
        return _buildList(context, snapshot.data.documents);
     },
   );
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return ListView(
      padding: const EdgeInsets.only(top: 20.0),
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
    final record = LectureSummary.fromSnapshot(data);
    return SizedBox(
      child: Container(
        padding: EdgeInsets.all(15.0),
        child: Row(
          children: <Widget>[
            Text(record.name),
            Text(record.qualityAvg.toString()),
            Text(record.difficultyAvg.toString()) 
          ],
        ),
      ),
    );
  }
}

class LectureSummary {
  final String name;
  var qualityAvg;
  var difficultyAvg;
  var quantity;
  final DocumentReference reference;
  
  LectureSummary.fromMap(Map<String, dynamic> map, {this.reference})
    : assert(map['name'] != null),
      assert(map['quantity'] != null),
      assert(map['difficultyAvg'] != null),
      assert(map['quantity'] != null),
      name = map['name'],
      qualityAvg = map['qualityAvg'],
      difficultyAvg = map['difficultyAvg'],
      quantity = map['quantity'];

  LectureSummary.fromSnapshot(DocumentSnapshot snapshot)
    : this.fromMap(snapshot.data, reference: snapshot.reference);

  @override
  String toString() => "LectureSummary<$name>";
}

