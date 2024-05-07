
import 'package:article_creator/pages/homePage.dart';
import 'package:article_creator/pages/articleBuilder.dart';
import 'package:article_creator/pages/endPage.dart';
import 'package:flutter/material.dart';

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  AppState createState() => AppState();
}

// Main application state
class AppState extends State<App> {
  // Definir el contingut del widget 'App'
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
      routes: {
        'homePage': (context) => HomePage(),
        'articleBuilder': (context) => ArticleBuilder(),
        'endPage':(context) => EndPage(),
      },
    );
  }
}