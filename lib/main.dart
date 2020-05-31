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
          iconTheme: IconThemeData(
            color: Colors.black, 
          ),
          backgroundColor: Color(0xffFAFAFA),
          elevation: 0.0,
          title: Text(''),
        ),
        body: Container(
          padding: const EdgeInsets.all(32),
          alignment: Alignment.center,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              RaisedButton(
                padding: EdgeInsets.all(18.0),
                color: Color(0xff4C8CEB),
                shape: StadiumBorder(),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      '授業を検索',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey[50],
                      ),
                    ),
                    Icon(
                      Icons.search,
                      color: Colors.grey[50],
                      size: 24.0,
                    ),
                  ],
                ),
                onPressed: () async {
                  Navigator.pushNamed(
                    context, 
                    '/SearchScreen',
                  );
                },
              ),
              SizedBox(height: 80),
              RaisedButton(
                padding: EdgeInsets.all(18.0),
                color: Color(0xff4C8CEB),
                shape: StadiumBorder(),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      '授業評価を投稿',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey[50],
                      ),
                    ),
                    Icon(
                      Icons.add_circle_outline,
                      color: Colors.grey[50],
                      size: 24.0,
                    ),
                  ],
                ),
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

