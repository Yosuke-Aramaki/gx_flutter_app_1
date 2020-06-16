import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gx_app_1/api/firestoreState.dart';

class LectureListScreen extends StatefulWidget {
  @override 
  _LectureListScreen createState() {
    return _LectureListScreen();
  }
}

class _LectureListScreen extends State<LectureListScreen> {
  var lectureInformation = new Map();
  var arguments = new Map();
  Map<String, dynamic> lectureSummaryInfo;

  void getLectureSummaryInfo(String _department, String _lecture) async {
    await FirestoreState.getLectureSummaryInfo(lectureInformation['university'], _department, _lecture).then((value) {
      setState(() {
        lectureSummaryInfo = value;
      });
    });
  }

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
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: lectureInformation['department'] == '指定しない' ? Column(
          children: <Widget>[
            _buildUniversityName(lectureInformation['university']),
            Expanded(
              child: _buildAllLecture(lectureInformation),
            ),
          ],
        ) : Column(
          children: <Widget>[
            _buildUniversityName(lectureInformation['university']),
            Container(
              padding: const EdgeInsets.only(top: 15.0, left: 8.0, right: 8.0, bottom: 20.0),
              decoration: BoxDecoration(
                border: Border(top: BorderSide(color: Colors.grey)),
              ),
              child: Column(
                children: <Widget>[
                  _buildDepartmentName(lectureInformation['department']),
                  _buildLectureList(lectureInformation['department']),
                ],
              )
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

  Widget _buildStarRate(int value) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return Icon(
          index < value ? Icons.star : Icons.star_border,
          size: 18.0,
        );
      }),
    );
  }

  Widget _buildAllLecture(Map lectureInformation) {
    return ListView.builder(
      itemCount: lectureInformation['departmentList'].length,
      itemBuilder: (BuildContext context, int index) {
        return Container(
          padding: const EdgeInsets.only(top: 15.0, left: 8.0, right: 8.0, bottom: 20.0),
          decoration: BoxDecoration(
            border: Border(top: BorderSide(color: Colors.grey)),
          ),
          child: Column(
            children: <Widget>[
              _buildDepartmentName(lectureInformation['departmentList'][index]),
              _buildLectureList(lectureInformation['departmentList'][index]),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLectureList(_department) {
    return Column(children: <Widget>[
      StreamBuilder(
        stream: Firestore.instance.collection('univ_list').document(lectureInformation['university']).collection('dep_list').document(_department).collection('lec_list')
          .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Text("Loading...");
          return ListView.builder(
            shrinkWrap: true,
            itemCount: snapshot.data.documents.length,
            itemBuilder: (context, index) {
              final record = LectureSummary.fromSnapshot(snapshot.data.documents[index]);
              return GestureDetector(
                onTap: () async {
                  arguments ={'university': lectureInformation['university'], 'department': _department, 'lecture': record.name, 'lectureSummary': {'quantity': record.quantity, 'qualityAvg': record.qualityAvg, 'difficultyAvg': record.difficultyAvg, 'name': record.name}};
                  Navigator.pushNamed(
                    context,
                    '/LectureInformationScreen',
                    arguments: arguments,
                  );
                },
                child: SizedBox(
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
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              record.name,
                              style: TextStyle(fontSize: 16),
                            ),
                            SizedBox(height: 10.0),
                            Row(
                              children: <Widget>[
                                Text(
                                  '質',
                                  style: TextStyle(fontSize: 12),
                                ),
                                SizedBox(width: 4.0),
                                _buildStarRate(record.qualityAvg.round()),
                                SizedBox(width: 14.0),
                                Text(
                                  '難易度',
                                  style: TextStyle(fontSize: 12),
                                ),
                                SizedBox(width: 4.0),
                                _buildStarRate(record.difficultyAvg.round()),
                              ],
                            ),
                          ],
                        ),
                        Column(
                          children: <Widget>[
                            Icon(
                              Icons.keyboard_arrow_right ,
                            ),
                            Text(
                              record.quantity.toString() + '件の評価',
                              style: TextStyle(fontSize: 10),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }
          );
        }
      ),
    ],);
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

