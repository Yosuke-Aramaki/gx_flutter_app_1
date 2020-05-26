import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  @override 
  State<StatefulWidget> createState() => new _SearchScreen();
}

class _SearchScreen extends State<SearchScreen> {
  String _univ;
  String _dep = '指定しない';
  String _lec = '指定しない';
  List<String> depList = [];
  List<String> lecList = [];
  bool _univSelected = false;
  bool _depSelected = false;
  bool _lecSelected = false;
  // Set arguments = {};
  var arguments = new Map();
  Map<String, dynamic> lecSummaryInfo;


  Future<QuerySnapshot> getDepList() async {
    QuerySnapshot dlist = await Firestore.instance.collection('univ_list').document(_univ).collection('dep_list').getDocuments();
    depList = [];
    depList.add('指定しない');
    for (int i = 0; i < dlist.documents.length; i++) {
      var a = dlist.documents[i].documentID;
      depList.add(a);
    }
    setState(() {
      _univSelected = true;
    });
  }

  Future<QuerySnapshot> getLecList() async {
    QuerySnapshot llist = await Firestore.instance.collection('univ_list').document(_univ).collection('dep_list').document(_dep).collection('lec_list').getDocuments();
    lecList = [];
    lecList.add('指定しない');
    for (int i = 0; i < llist.documents.length; i++) {
      var a = llist.documents[i].documentID;
      lecList.add(a);
    }
    setState(() {
      _depSelected = true;
    });
  }

  Widget _univDropdown(context) {
    List<String> univList = ModalRoute.of(context).settings.arguments;
    return Container(
      margin: EdgeInsets.only(right: 40.0),
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        decoration: BoxDecoration(
          border: Border.all(color: Color(0xffBEBEBE)),
          borderRadius: BorderRadius.circular(40),
        ),
        child: DropdownButton<String>(
          value: _univ,
          isExpanded: true,
          underline: Container(),
        onChanged: (String value) {
          setState(() {
            _univ = value;
            _dep = '指定しない';
            _lec = '指定しない';
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
  
  Widget _depDropdown() {
    if (_univSelected) {
      return Container(
        margin: EdgeInsets.only(right: 40.0),
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        decoration: BoxDecoration(
          border: Border.all(color: Color(0xffBEBEBE)),
          borderRadius: BorderRadius.circular(40),
        ),
        child: DropdownButton<String>(
          value: _dep,
          isExpanded: true,
          underline: Container(),
          onChanged: (String value) async {
            setState(() {
              _dep = value;
              _lec = '指定しない';
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
          value: _dep,
          isExpanded: true,
          underline: Container(),
          onChanged: (String value) async {
            setState(() {
              _dep = value;
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
    
  Widget _lecDropdown() {
    if (_univSelected && _depSelected) {
      return Container(
        margin: EdgeInsets.only(right: 40.0),
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        decoration: BoxDecoration(
          border: Border.all(color: Color(0xffBEBEBE)),
          borderRadius: BorderRadius.circular(40),
        ),
        child: DropdownButton<String>(
          value: _lec,
          isExpanded: true,
          underline: Container(),
          onChanged: (String value) {
            setState(() {
              _lec = value;
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
          value: _lec,
          isExpanded: true,
          underline: Container(),
          icon: Icon(Icons.keyboard_arrow_down),
          onChanged: (String value) async {
            setState(() {
              _lec = value;
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
      await Firestore.instance.collection('univ_list').document(_univ).collection('dep_list').document(_dep).collection('lec_list').document(_lec).get();
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
                _univDropdown(context),
                _dropDownTitle('学部'),
                _depDropdown(),
                _dropDownTitle('授業名'),
                _lecDropdown(),
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
                    _dep == '指定しない' && _lec == '指定しない' ? () async{
                      await removeDefaultValue(depList);
                      arguments ={'univ': _univ, 'dep': _dep, 'depList': depList};
                      Navigator.pushNamed(
                        context, 
                        '/LecListScreen',
                        arguments: arguments,
                      );
                    } : _dep != '指定しない' && _lec == '指定しない' ? () async{
                      arguments ={'univ': _univ, 'dep': _dep, 'lec': _lec};
                      Navigator.pushNamed(
                        context, 
                        '/LecListScreen',
                        arguments: arguments,
                      );
                    } : () async{
                      await getLecSummaryInfo();
                      arguments ={'univ': _univ, 'dep': _dep, 'lec': _lec, 'lecSummary': lecSummaryInfo};
                      Navigator.pushNamed(
                        context, 
                        '/LecInfoScreen',
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