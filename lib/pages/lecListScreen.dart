import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class LecListScreen extends StatefulWidget {
  @override 
  _LecListScreen createState() {
    return _LecListScreen();
  }
}

class _LecListScreen extends State<LecListScreen> {
  var lecInfo = new Map();

  @override
  Widget build(BuildContext context) {
    lecInfo = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black, 
        ),
        backgroundColor: Color(0xffFAFAFA),
        elevation: 0.0,
        title: Text('授業リスト'),
      ),
      body: lecInfo['dep'] == '指定しない' ? Container(
        child: Container(
          child:  _buildAllLec(lecInfo),
        ),
      )
      : Container(
        child: Column(
          children: <Widget>[
            _depName(lecInfo['dep']),
            Expanded(
              child:  _buildBody(context, lecInfo),
            ),
          ],  
        ), 
      ),  
    );
  }

  Widget _buildAllLec(Map lecInfo) {
    return ListView.builder(
      itemCount: lecInfo['depList'].length,
      itemBuilder: (BuildContext context, int index) {
        return Container(
          child: Column(
            children: <Widget>[
              _depName(lecInfo['depList'][index]),
              Column(children: <Widget>[
                  StreamBuilder(
                    stream: Firestore.instance.collection('univ_list').document(lecInfo['univ']).collection('dep_list').document(lecInfo['depList'][index]).collection('lec_list')
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
                              padding: EdgeInsets.all(15.0),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey[50]),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                children: <Widget>[
                                  Text(record.name),
                                  _starRate(record.qualityAvg.round()),
                                  _starRate(record.difficultyAvg.round())
                                ],
                              ),
                            ),
                          );
                        }
                      );
                    }
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }

  Widget _depName(dep) {
    return SizedBox(
      child: Container(
        padding: const EdgeInsets.all(8.0),
        alignment: Alignment.centerLeft,
        child: Text(
          dep,
          style: TextStyle(fontSize: 25),
        ),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey)),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, Map lecInfo) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('univ_list').document(lecInfo['univ']).collection('dep_list').document(lecInfo['dep']).collection('lec_list').snapshots(),
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
  
  Widget _starRate(int value) {
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

