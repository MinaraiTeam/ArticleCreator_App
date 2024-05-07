import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:article_creator/pages/articleBuilder.dart';
import 'package:article_creator/pages/endPage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';  

class AppData with ChangeNotifier {
  final String urlServer = "https://minarai.ieti.site:443";

  String title = "";
  XFile previewImage = XFile("");
  List<dynamic> content = [];
  String lang = ""; 
  String annex = ""; 
  String country = "";
  String user = "";
  String category = "";
  
  bool isLogegged = true; /// it has to be false
  

  void forceNotify() {
    notifyListeners();
  }

  void createArticle(BuildContext context) {
    if (isLogegged){
      changeToArticleBuilder(context);
    } else {
      _showDialog(context);
    }
  }

  void changeToArticleBuilder(BuildContext context){
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ArticleBuilder()),
    );
  }

  void changeToEndPage(BuildContext context){
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EndPage()),
    );
  }

  void loginPopup(BuildContext context) {
    String userName = '';
    String password = '';

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('MINARAI LOGIN'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                onChanged: (value) {
                  userName = value;
                },
                decoration: InputDecoration(labelText: 'User'),
              ),
              TextField(
                onChanged: (value) {
                  password = value;
                },
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
              ),
            ],
          ),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                if (userName.isNotEmpty && password.isNotEmpty) {
                  loginToServer(userName, password);
                  Navigator.of(context).pop();
                }
              },
              child: Text('OK'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _showDialog(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('NOT LOGGED', style: TextStyle(fontWeight: FontWeight.w600, color: Colors.red),),
          content: Text('You have to login first!'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('DONE'),
            ),
          ],
        );
      },
    );
  }

  Future<void> loginToServer(String userName, String password) async {
    try {
      var response = await http.post(Uri.parse(urlServer + "/api/user/login"),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'name': userName,
            'password': password,
          }));

      if (response.statusCode == 200) {
        isLogegged = true;
        user = userName;
      } else {
        print(response.statusCode);
        isLogegged = false;
      }
    } catch (e) {
      print(e);
    } finally {
      notifyListeners();
    }
    return;
  }

  void prepareToSend() async {
    
    String previewImageB64 = await imageToString(previewImage.path);


    List<String> finalList = [];
    for (int index=0; index < content.length; index++ ) {
      
      if (content[index] is String) {
        finalList.add(content[index]);
      } else {
        XFile image = content[index];
        String base64String = await imageToString(image.path);
        finalList.add(base64String);
      }
    }

    String date = DateFormat('yyyy-MM-dd').format(DateTime.now());   


    sendArticle(previewImageB64, finalList, lang, annex, country, date, user, category);

  }

  Future<String> imageToString(String imagePath) async {
    File imageFile = File(imagePath);
    Uint8List imageBytes = await imageFile.readAsBytes();
    String base64String = base64Encode(imageBytes);
    return base64String;
  }

  Future<void> sendArticle(String previewImageB64, List<String> contentList, String lang, String annex, String country, String date, String user, String category) async {
    try {
      var response = await http.post(Uri.parse(urlServer + "/api/user/login"),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            "title": title,
            "preview_image": previewImageB64,
            "content": contentList,
            "language": lang,
            "annex": annex,
            "country": country,
            "date": date,
            "user": user,
            "category": category
          }));

      if (response.statusCode == 200) {
        isLogegged = true;
      } else {
        print(response.statusCode);
        isLogegged = false;
      }
    } catch (e) {
      print(e);
    } finally {
      notifyListeners();
    }
    return;
  }
}