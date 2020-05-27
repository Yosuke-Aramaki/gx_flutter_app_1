import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  String _univ;
  String _dep;
  String _lec;
  List<String> depList = [];
  List<String> lecList = [];
  bool _univSelected = false;
  bool _depSelected = false;
  bool _lecSelected = false;
  int _lecQuality;
  int _lecDifficulty;
  int _lecAttendance;
  int _lecHWFrequency;
  final _commnetController = TextEditingController();

  void _handleQualityChanged(int value) {
    setState(() {
      _lecQuality = value; 
    });
  }

  void _handleDifficultyChanged(int value) {
    setState(() {
      _lecDifficulty = value; 
    });
  }

  void _handleAttendanceChanged(int value) {
    setState(() {
      _lecAttendance = value; 
    });
  }
  
  void _handleHWFrequencyChanged(int value) {
    setState(() {
      _lecHWFrequency = value; 
    });
  }

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
      margin: EdgeInsets.only(top:5.0, left: 14.0),
      child: Row(
        children: <Widget>[
          Text(
            '大学',
            style: TextStyle(fontSize: 18),
          ),
          SizedBox(width: 25.0),
          DropdownButton<String>(
            value: _univ,
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
        ],
      ),
    );
  }

  Widget _depDropdown() {
    if (_univSelected) {
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
              value: _dep,
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
              value: _dep,
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
          ],
        ),
      );
    }
  }
    
  Widget _lecDropdown() {
    if (_univSelected && _depSelected) {
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
              value: _lec,
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
              value: _lec,
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
          ],
        ),
      );
    }
  }
  
  Widget lecQualityButton() {
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
          children: <Widget>[
              Row(
                children: <Widget>[
                  new Radio(
                    value: 1,
                    groupValue: _lecQuality,
                    onChanged: _handleQualityChanged,
                  ),
                  new Text('非常に悪い'),
                ],
              ),
              Row(
                children: <Widget>[    
                new Radio(
                  value: 2,
                  groupValue: _lecQuality,
                  onChanged: _handleQualityChanged,
                ),
                new Text('悪い'),
                ],
              ),
              Row(
                children: <Widget>[    
                new Radio(
                  value: 3,
                  groupValue: _lecQuality,
                  onChanged: _handleQualityChanged,
                ),
                new Text('ふつう'),
                ],
              ),
              Row(
                children: <Widget>[    
                new Radio(
                  value: 4,
                  groupValue: _lecQuality,
                  onChanged: _handleQualityChanged,
                ),
                new Text('良い'),
                ],
              ),
              Row(
                children: <Widget>[    
                new Radio(
                  value: 5,
                  groupValue: _lecQuality,
                  onChanged: _handleQualityChanged,
                ),
                new Text('非常に良い'),
                ],
              ),
            ],
          ),
        ],
      ),
   );
  }
  
  Widget lecDifficultyButton() {
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
            children: <Widget>[
              Row(
                children: <Widget>[
                  new Radio(
                    value: 1,
                    groupValue: _lecDifficulty,
                    onChanged: _handleDifficultyChanged,
                  ),
                  new Text('非常に優しい'),
                ],
              ),
              Row(
                children: <Widget>[
                new Radio(
                  value: 2,
                  groupValue: _lecDifficulty,
                  onChanged: _handleDifficultyChanged,
                ),
                new Text('優しい'),
                ],
              ),
              Row(
                children: <Widget>[    
                new Radio(
                  value: 3,
                  groupValue: _lecDifficulty,
                  onChanged: _handleDifficultyChanged,
                ),
                new Text('ふつう'),
                ],
              ),
              Row(
                children: <Widget>[    
                new Radio(
                  value: 4,
                  groupValue: _lecDifficulty,
                  onChanged: _handleDifficultyChanged,
                ),
                new Text('難しい'),
                ],
              ),
              Row(
                children: <Widget>[    
                new Radio(
                  value: 5,
                  groupValue: _lecDifficulty,
                  onChanged: _handleDifficultyChanged,
                ),
                new Text('非常に難しい'),
                ],
              ),
            ],
          ), 
       ],
   ),
    );
  }

  Widget lecAttendanceButton() {
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
            children: <Widget>[
              Row(
                children: <Widget>[    
                new Radio(
                  value: 1,
                  groupValue: _lecAttendance,
                  onChanged: _handleAttendanceChanged,
                ),
                new Text('必須'),
                ],
              ),
              Row(
                children: <Widget>[    
                new Radio(
                  value: 2,
                  groupValue: _lecAttendance,
                  onChanged: _handleAttendanceChanged,
                ),
                new Text('必須でない'),
                ],
              ),
            ]
          ),
        ],
      ),
    );
  }

  Widget lecHWFrequencyButton() {
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
            children: <Widget>[
              Row(
                children: <Widget>[    
                new Radio(
                  value: 1,
                  groupValue: _lecHWFrequency,
                  onChanged: _handleHWFrequencyChanged,
                ),
                new Text('毎回ある'),
                ],
              ),
              Row(
                children: <Widget>[    
                new Radio(
                  value: 2,
                  groupValue: _lecHWFrequency,
                  onChanged: _handleHWFrequencyChanged,
                ),
                new Text('たまに'),
                ],
              ),
              Row(
                children: <Widget>[
                new Radio(
                  value: 3,
                  groupValue: _lecHWFrequency,
                  onChanged: _handleHWFrequencyChanged,
                ),
                new Text('ほとんどない'),
                ],
              ),
            ]
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
                      _univDropdown(context),
                      _depDropdown(),
                      _lecDropdown(),
                    ],
                  ),
                ),
                lecQualityButton(),
                lecDifficultyButton(),
                lecAttendanceButton(),
                lecHWFrequencyButton(),
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
                    controller: _commnetController,
                    decoration: InputDecoration(
                      labelText: 'コメント欄',
                    ),
                  ),
                ),
                SizedBox(height: 30.0),
                RaisedButton(
                  child: Text('投稿する'),
                  onPressed: () async {
                    await Firestore.instance.collection(_univ).document(_dep).collection(_lec).document().setData(
                      {
                        "quality": _lecQuality,
                        "difficulty": _lecDifficulty,
                        "attendance": _lecAttendance,
                        "hw": _lecHWFrequency,
                        "comment": _commnetController.text,
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