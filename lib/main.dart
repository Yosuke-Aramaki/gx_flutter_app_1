import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';
import 'package:gx_app_1/pages/addScreen.dart';
import 'package:gx_app_1/pages/lecInfoScreen.dart';
import 'package:gx_app_1/pages/lecListScreen.dart';
import 'package:gx_app_1/pages/searchScreen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => HomePage(),
        '/SearchScreen': (context) => SearchScreen(),
        '/AddScreen': (context) => AddScreen(),
        '/LecInfoScreen': (context) => LecInfoScreen(),
        '/LecListScreen': (context) => LecListScreen(),
      },
    );
  }
}


class HomePage extends StatelessWidget {
  List<String> univList = [];

  Future<QuerySnapshot> getUnivList() async {
    univList = [];
    QuerySnapshot ulist = await Firestore.instance.collection('univ_list').getDocuments();
    for (int i = 0; i < ulist.documents.length; i++) {
      var a = ulist.documents[i].documentID;
      univList.add(a);
    }
  }

  @override 
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Home Screen'),
        ),
        body: Container(
          padding: const EdgeInsets.all(32),
          alignment: Alignment.center,
          child: Column(
            children: <Widget>[
              RaisedButton(
                child: Text('授業を検索'),
                onPressed: () async {
                  await getUnivList();
                  Navigator.pushNamed(
                    context, 
                    '/SearchScreen',
                    arguments: (univList),
                  );
                },
              ),
              RaisedButton(
                child: Text('授業評価を投稿'),
                onPressed: () async {
                  await getUnivList();
                  Navigator.pushNamed(
                    context, 
                    '/AddScreen',
                    arguments: (univList),
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}

