import 'package:flutter/material.dart';
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
        '/LectureInformationScreen': (context) => LectureInformationScreen(),
        '/LecListScreen': (context) => LectureListScreen(),
      },
    );
  }
}


class HomePage extends StatelessWidget {

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
                  Navigator.pushNamed(
                    context, 
                    '/SearchScreen',
                  );
                },
              ),
              RaisedButton(
                child: Text('授業評価を投稿'),
                onPressed: () async {
                  Navigator.pushNamed(
                    context, 
                    '/AddScreen',
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

