import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:article_creator/others/AppData.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    AppData appData = Provider.of<AppData>(context, listen: false);
    appData.homeContext = context;
    
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 234, 234, 234),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: Colors.white,
        title: const Text(
          'ARTICLE CREATOR',
          style: TextStyle(fontSize: 25, color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            article_creator(context),
          ],
        ),
      ),
    );
  }
}

Widget article_creator(BuildContext context) {
  AppData appData = Provider.of<AppData>(context);

  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text(
          "ARTICLES",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 15),
        ElevatedButton(
          onPressed: () => appData.createArticle(context), 
          child: const Text("Create"),
        ),
        const SizedBox(height: 5),
        ElevatedButton(
          onPressed: () => appData.loginPopup(context), 
          child: const Text("Login"),
        ),
      ],
    ),
  );
}
