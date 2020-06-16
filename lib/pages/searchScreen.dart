import 'package:flutter/material.dart';
import 'package:gx_app_1/api/firestoreState.dart';

class SearchScreen extends StatefulWidget {
  @override 
  State<StatefulWidget> createState() => new _SearchScreen();
}

class _SearchScreen extends State<SearchScreen> {
  String _university;
  String _department = '指定しない';
  String _lecture = '指定しない';
  List<String> _universityList = [];
  List<String> departmentList = [];
  List<String> lectureList = [];
  bool _universitySelected = false;
  bool _departmentSelected = false;
  var arguments = new Map();
  Map<String, dynamic> lectureSummaryInfo;

  @override
  void initState() {
    super.initState();
    FirestoreState.getUniversityList().then((value) {
      setState(() {
        _universityList = value;
      });
    });
  }

  void getDepartmentList() async {
    await FirestoreState.getDepartmentList(_university).then((value) {
      setState(() {
        departmentList = value;
        _universitySelected = true;
      });
    });
  }

  void getLectureList() async {
    await FirestoreState.getLectureList(_university, _department).then((value) {
      setState(() {
        lectureList = value;
        _departmentSelected = true;
      });
    });
  }

  void getLectureSummaryInfo() async {
    await FirestoreState.getLectureSummaryInfo(_university, _department, _lecture).then((value) {
      setState(() {
        lectureSummaryInfo = value;
      });
    });
  }

  Widget _buildUniversityDropdown(context) {
    return Container(
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
          getDepartmentList();
        },
        items: _universityList.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }
  
  Widget _buildDepartmentDropdown() {
    if (_universitySelected) {
      return Container(
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
            getLectureList();
          },
          items: departmentList.map<DropdownMenuItem<String>>((String value) {
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
    
  Widget _buildLectureDropdown() {
    if (_universitySelected && _departmentSelected) {
      return Container(
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
          items: lectureList.map<DropdownMenuItem<String>>((String value) {
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

  Widget _buildDropdownTitle (String value) {
    return Container(
      padding: EdgeInsets.only(top: 40.0, bottom: 8.0),
      child: Text(
        value,
        style: TextStyle(
          fontSize: 18,
        ),
      )
    );
  }

  void removeDefaultValue(List<String> value) {
    departmentList.removeAt(0);
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
              padding: EdgeInsets.only(top:40.0, right: 35.0, left: 35.0, bottom: 40.0),
              alignment: Alignment.topLeft,
              decoration: BoxDecoration(
                color: Colors.grey[50],
                border: Border.all(color: Colors.grey[50]),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    child: Text(
                      '検索',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Container(
                    child: Text(
                      '大学、学部、科目名を選択して検索できます',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 12,
                      ),
                    )
                  ),
                  _buildDropdownTitle('大学'),
                  _buildUniversityDropdown(context),
                  _buildDropdownTitle('学部'),
                  _buildDepartmentDropdown(),
                  _buildDropdownTitle('授業名'),
                  _buildLectureDropdown(),
                  SizedBox(height: 20.0),
                  Container(
                    alignment: AlignmentDirectional.topCenter,
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
                      onPressed: _department == '指定しない' && _lecture == '指定しない' ? () async{
                        removeDefaultValue(departmentList);
                        arguments ={'university': _university, 'department': _department, 'departmentList': departmentList};
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
                        await getLectureSummaryInfo();
                        arguments = {'university': _university, 'department': _department, 'lecture': _lecture, 'lectureSummary': lectureSummaryInfo};
                        Navigator.pushNamed(
                          context, 
                          '/LectureInformationScreen',
                          arguments: arguments,
                        );
                      } 
                    ),
                  ),
                ],
              ),
            ),
          ],  
        ),
      ),
    );
  }
}
