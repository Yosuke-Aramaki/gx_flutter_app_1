import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  @override 
  State<StatefulWidget> createState() => new _SearchScreen();
}

class _SearchScreen extends State<SearchScreen> {
  String _university;
  String _department = '指定しない';
  String _lecture = '指定しない';
  List<String> depList = [];
  List<String> lecList = [];
  bool _universitySelected = false;
  bool _departmentSelected = false;
  bool _lectureSelected = false;
  // Set arguments = {};
  var arguments = new Map();
  Map<String, dynamic> lecSummaryInfo;


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
      margin: EdgeInsets.only(right: 40.0),
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        decoration: BoxDecoration(
          border: Border.all(color: Color(0xffBEBEBE)),
          borderRadius: BorderRadius.circular(40),
        ),
        child: DropdownButton<String>(
          value: _university,
          isExpanded: true,
          underline: Container(),
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
    );
  }
  
  Widget _departmentDropdown() {
    if (_universitySelected) {
      return Container(
        margin: EdgeInsets.only(right: 40.0),
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        decoration: BoxDecoration(
          border: Border.all(color: Color(0xffBEBEBE)),
          borderRadius: BorderRadius.circular(40),
        ),
        child: DropdownButton<String>(
          value: _department,
          isExpanded: true,
          underline: Container(),
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
      );
    }
    else {
      return Container(
        margin: EdgeInsets.only(right: 40.0),
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        decoration: BoxDecoration(
          border: Border.all(color: Color(0xffBEBEBE)),
          borderRadius: BorderRadius.circular(40),
        ),
        child: DropdownButton<String>(
          value: _department,
          isExpanded: true,
          underline: Container(),
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
      );
    }
  }
    
  Widget _lectureDropdown() {
    if (_universitySelected && _departmentSelected) {
      return Container(
        margin: EdgeInsets.only(right: 40.0),
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        decoration: BoxDecoration(
          border: Border.all(color: Color(0xffBEBEBE)),
          borderRadius: BorderRadius.circular(40),
        ),
        child: DropdownButton<String>(
          value: _lecture,
          isExpanded: true,
          underline: Container(),
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
      );
    }
    else {
      return Container(
        margin: EdgeInsets.only(right: 40.0),
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        decoration: BoxDecoration(
          border: Border.all(color: Color(0xffBEBEBE)),
          borderRadius: BorderRadius.circular(40),
        ),
        child: DropdownButton<String>(
          value: _lecture,
          isExpanded: true,
          underline: Container(),
          icon: Icon(Icons.keyboard_arrow_down),
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
      );
    }
  }

  Widget _dropDownTitle (String value) {
    return Container(
      alignment: Alignment.topLeft,
      padding: EdgeInsets.only(top: 40.0),
      child: Text(
        value,
        textAlign: TextAlign.left,
        style: TextStyle(
          fontSize: 18,
        ),
      )
    );
  }

  Future<Map<String, dynamic>> getLecSummaryInfo() async {
    DocumentSnapshot docSnapshot =
      await Firestore.instance.collection('univ_list').document(_university).collection('dep_list').document(_department).collection('lec_list').document(_lecture).get();
    lecSummaryInfo = docSnapshot.data;
  }

  void removeDefaultValue(List<String> value) {
    depList.removeAt(0);
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
      body: Container(
        decoration: BoxDecoration(
          color: Color(0xffCBDEFB),
        ),
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top:60.0, right: 20.0, left: 20.0),
              padding: EdgeInsets.only(top:40.0, left: 40.0, bottom: 40.0),
              alignment: Alignment.topLeft,
              decoration: BoxDecoration(
                color: Colors.grey[50],
                border: Border.all(color: Colors.grey[50]),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(children: <Widget>[
                Container(
                  alignment: Alignment.topLeft,
                  child: Text(
                    '検索',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.topLeft,
                  child: Text(
                    '大学、学部、科目名を選択して検索できます',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 12,
                    ),
                  )
                ),
                _dropDownTitle('大学'),
                _universityDropdown(context),
                _dropDownTitle('学部'),
                _departmentDropdown(),
                _dropDownTitle('授業名'),
                _lectureDropdown(),
                SizedBox(height: 20.0),
                Container(
                  child: RaisedButton(
                    padding: EdgeInsets.all(10.0),
                    color: Color(0xff4C8CEB),
                    shape: StadiumBorder(),
                    child:Text(
                      '検索する',
                      style: TextStyle(
                        color: Colors.grey[50],
                      ),
                    ),
                    onPressed: 
                    _department == '指定しない' && _lecture == '指定しない' ? () async{
                      await removeDefaultValue(depList);
                      arguments ={'university': _university, 'department': _department, 'departmentList': depList};
                      Navigator.pushNamed(
                        context, 
                        '/LecListScreen',
                        arguments: arguments,
                      );
                    } : _department != '指定しない' && _lecture == '指定しない' ? () async{
                      arguments ={'university': _university, 'department': _department, 'lecture': _lecture};
                      Navigator.pushNamed(
                        context, 
                        '/LecListScreen',
                        arguments: arguments,
                      );
                    } : () async{
                      await getLecSummaryInfo();
                      arguments ={'university': _university, 'department': _department, 'lecture': _lecture, 'lectureSummary': lecSummaryInfo};
                      Navigator.pushNamed(
                        context, 
                        '/LectureInformationScreen',
                        arguments: arguments,
                      );
                    } 
                  ),
                ),
              ],),
            ),
          ],  
        ),
      ),
    );
  }
}