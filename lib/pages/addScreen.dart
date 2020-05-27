import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  String _university;
  String _department;
  String _lecture;
  List<String> depList = [];
  List<String> lecList = [];
  bool _universitySelected = false;
  bool _departmentSelected = false;
  bool _lectureSelected = false;
  int _lectureQuality;
  int _lectureDifficulty;
  int _lectureAttendance;
  int _lectureHWFrequency;
  final _commentController = TextEditingController();

  void _setQuality(int value) {
    setState(() {
      _lectureQuality = value; 
    });
  }

  void _setDifficulty(int value) {
    setState(() {
      _lectureDifficulty = value; 
    });
  }

  void _setAttendance(int value) {
    setState(() {
      _lectureAttendance = value; 
    });
  }
  
  void _setHWFrequency(int value) {
    setState(() {
      _lectureHWFrequency = value; 
    });
  }

  Future<QuerySnapshot> getDepList() async {
    QuerySnapshot dlist = await Firestore.instance.collection('univ_list').document(_university).collection('dep_list').getDocuments();
    depList = [];
    depList.add('指定しない');
    for (int i = 0; i < dlist.documents.length; i++) {
      var a = dlist.documents[i].documentID;
      depList.add(a);
    }
    setState(() {
      _universitySelected = true;
    });
  }

  Future<QuerySnapshot> getLecList() async {
    QuerySnapshot llist = await Firestore.instance.collection('univ_list').document(_university).collection('dep_list').document(_department).collection('lec_list').getDocuments();
    lecList = [];
    lecList.add('指定しない');
    for (int i = 0; i < llist.documents.length; i++) {
      var a = llist.documents[i].documentID;
      lecList.add(a);
    }
    setState(() {
      _departmentSelected = true;
    });
  }

  Widget _universityDropdown(context) {
    List<String> univList = ModalRoute.of(context).settings.arguments;
    return Container(
      margin: EdgeInsets.only(top:5.0, left: 14.0),
      child: Row(
        children: <Widget>[
          Text(
            '大学',
            style: TextStyle(fontSize: 18),
          ),
          SizedBox(width: 25.0),
          DropdownButton<String>(
            value: _university,
            onChanged: (String value) {
              setState(() {
                _university = value;
                _department = '指定しない';
                _lecture = '指定しない';
              });
              getDepList();
            },
            items: univList.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _departmentDropdown() {
    if (_universitySelected) {
      return Container(
        margin: EdgeInsets.only(top:5.0, left: 14.0),
        child: Row(
          children: <Widget>[
            Text(
              '学部',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(width: 25.0),
            new DropdownButton<String>(
              value: _department,
              onChanged: (String value) async {
                setState(() {
                  _department = value;
                  _lecture = '指定しない';
                });
                getLecList();
              },
              items: depList.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ), 
          ],
        ),
      );
    }
    else {
      return Container(
        margin: EdgeInsets.only(top:5.0, left: 14.0),
        child: Row(
          children: <Widget>[
            Text(
              '学部',
              style: TextStyle(fontSize: 18),
            ), 
            SizedBox(width: 25.0),
            new DropdownButton<String>(
              value: _department,
              onChanged: (String value) async {
                setState(() {
                  _department = value;
                });
              },
              items: <String>['指定しない'].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ), 
          ],
        ),
      );
    }
  }
    
  Widget _lectureDropdown() {
    if (_universitySelected && _departmentSelected) {
      return Container(
        margin: EdgeInsets.only(top:5.0, left: 14.0),
        child: Row(
          children: <Widget>[
            Text(
              '科目',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(width: 25.0),
            new DropdownButton<String>(
              value: _lecture,
              onChanged: (String value) {
                setState(() {
                  _lecture = value;
                });
              },
              items: lecList.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ), 
          ],
        ),
      );
    }
    else {
      return Container(
        margin: EdgeInsets.only(top:5.0, left: 14.0),
        child: Row(
          children: <Widget>[
            Text(
              '科目',
              style: TextStyle(fontSize: 18),
            ), 
            SizedBox(width: 25.0),
            new DropdownButton<String>(
              value: _lecture,
              onChanged: (String value) async {
                setState(() {
                  _lecture = value;
                });
              },
              items: <String>['指定しない'].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ), 
          ],
        ),
      );
    }
  }
  
  List<ReviewsModel> _lectureQualityButtonGroup = [
    ReviewsModel(title: "非常によい", value: 5),
    ReviewsModel(title: "よい", value: 4),
    ReviewsModel(title: "ふつう", value: 3),
    ReviewsModel(title: "わるい", value: 2),
    ReviewsModel(title: "非常にわるい", value: 1),
  ];

  Widget lectureQualityButton() {
    return Container(
      margin: EdgeInsets.only(top:20.0, bottom: 10.0),
      padding: EdgeInsets.only(left: 10.0),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        border: Border.all(
          color: Colors.grey[50],
          width: 2.0,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top:7.0,),
            alignment: Alignment.centerLeft,
            child: new Text(
              '授業の質',
              style: TextStyle(fontSize: 18),
            )
          ),
          Column(
            children:_lectureQualityButtonGroup.map((data) => RadioListTile(
              title: Text(data.title),
              groupValue: _lectureQuality,
              value: data.value,
              onChanged: (value) {
                setState(() {
                  _lectureQuality = value;
                });
              },
            )).toList(),
          ),
        ],
      ),
    );
  }

  List<ReviewsModel> _lectureDifficlutyButtonGroup = [
    ReviewsModel(title: "非常にやさしい", value: 5),
    ReviewsModel(title: "やさしい", value: 4),
    ReviewsModel(title: "ふつう", value: 3),
    ReviewsModel(title: "むづかしい", value: 2),
    ReviewsModel(title: "非常にむずかしい", value: 1),
  ];

  Widget lectureDifficultyButton() {
    return Container(
      margin: EdgeInsets.only(top:10.0, bottom: 10.0),
      padding: EdgeInsets.only(left: 10.0),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        border: Border.all(
          color: Colors.grey[50],
          width: 2.0,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top:7.0, ),
            alignment: Alignment.centerLeft,
            child: new Text(
              '授業の難易度',
              style: TextStyle(fontSize: 18),
            )
          ),
          Column(
            children:_lectureDifficlutyButtonGroup.map((data) => RadioListTile(
              title: Text(data.title),
              groupValue: _lectureDifficulty,
              value: data.value,
              onChanged: (value) {
                setState(() {
                  _lectureDifficulty = value;
                });
              },
            )).toList(),
          ), 
        ],
      ),
    );
  }

  List<ReviewsModel> _lectureAttendanceButtonGroup = [
    ReviewsModel(title: "必須", value: 1),
    ReviewsModel(title: "必須でない", value: 2),
  ];

  Widget lectureAttendanceButton() {
    return Container(
      margin: EdgeInsets.only(top:10.0, bottom: 10.0),
      padding: EdgeInsets.only(left: 10.0),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        border: Border.all(
          color: Colors.grey[50],
          width: 2.0,
        ),
        borderRadius: BorderRadius.circular(12),
      ),      
      child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top:7.0),
            alignment: Alignment.centerLeft,
            child: new Text(
              '出席',
              style: TextStyle(fontSize: 18),
            )
          ),
          Column(
            children:_lectureAttendanceButtonGroup.map((data) => RadioListTile(
              title: Text(data.title),
              groupValue: _lectureAttendance,
              value: data.value,
              onChanged: (value) {
                setState(() {
                  _lectureAttendance = value;
                });
              },
            )).toList(),
          ), 
        ],
      ),
    );
  }

  List<ReviewsModel> _lectureHWFrequencyButtonGroup = [
    ReviewsModel(title: "毎回ある", value: 1),
    ReviewsModel(title: "たまに", value: 2),
    ReviewsModel(title: "ほとんどない", value: 3),
  ];

  Widget lectureHWFrequencyButton() {
    return Container(
      margin: EdgeInsets.only(top:10.0, bottom: 10.0),
      padding: EdgeInsets.only(left: 10.0),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        border: Border.all(
          color: Colors.grey[50],
          width: 2.0,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top:7.0,),
            alignment: Alignment.centerLeft,
            child: new Text(
              '宿題の頻度',
              style: TextStyle(fontSize: 18),
            )
          ),
          Column(
            children:_lectureHWFrequencyButtonGroup.map((data) => RadioListTile(
              title: Text(data.title),
              groupValue: _lectureHWFrequency,
              value: data.value,
              onChanged: (value) {
                setState(() {
                  _lectureHWFrequency = value;
                });
              },
            )).toList(),
          ), 
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black, 
        ),
        backgroundColor: Color(0xffCBDEFB),
        elevation: 0.0,
        title: Text(''),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
          decoration: BoxDecoration(
            color: Color(0xffCBDEFB),
          ),
          child: SingleChildScrollView(          
            child: Column(
              children: <Widget>[
                Container(
                  alignment: Alignment.topLeft,
                  margin: EdgeInsets.only(top:25.0, bottom: 20.0),
                  child: Text(
                    '授業評価を投稿',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    border: Border.all(
                      color: Colors.grey[50],
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: <Widget>[
                      _universityDropdown(context),
                      _departmentDropdown(),
                      _lectureDropdown(),
                    ],
                  ),
                ),
                lectureQualityButton(),
                lectureDifficultyButton(),
                lectureAttendanceButton(),
                lectureHWFrequencyButton(),
                Container(
                  margin: EdgeInsets.only(top:10.0),
                  padding: EdgeInsets.only(bottom: 8.0),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    border: Border.all(
                      color: Colors.grey[50],
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TextField(
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    controller: _commentController,
                    decoration: InputDecoration(
                      labelText: 'コメント欄',
                    ),
                  ),
                ),
                SizedBox(height: 30.0),
                RaisedButton(
                  child: Text('投稿する'),
                  onPressed: () async {
                    await Firestore.instance.collection(_university).document(_department).collection(_lecture).document().setData(
                      {
                        "quality": _lectureQuality,
                        "difficulty": _lectureDifficulty,
                        "attendance": _lectureAttendance,
                        "hw": _lectureHWFrequency,
                        "comment": _commentController.text,
                      }
                    );
                    Navigator.pop(context);
                  },
                ),
                SizedBox(height: 90.0)
              ],
            ),
          ), 
        ),
      ),
    );
  }
}

class ReviewsModel {
  String title;
  int value;
  ReviewsModel({this.title, this.value});
}