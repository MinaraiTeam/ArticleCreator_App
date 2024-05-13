import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:article_creator/others/AppData.dart';

class EndPage extends StatefulWidget {
  const EndPage({Key? key});

  @override
  State<EndPage> createState() => _EndPageState();
}

class _EndPageState extends State<EndPage> {
  @override
  Widget build(BuildContext context) {
    AppData appData = Provider.of<AppData>(context, listen: false);
    
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 234, 234, 234),
      appBar: AppBar(
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
            _endPage(context) 
          ],
        ),
      ),
    );
  }
}

Widget _endPage(BuildContext context) {
  AppData appData = Provider.of<AppData>(context);

  return Center(
    child: Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Last configurations",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Text("Category:"),
              const SizedBox(width: 10,),
              DropdownButton<String>(
                hint: Text('Choose a category'),
                value: appData.selectedCategory,
                onChanged: (String? newValue) {
                  appData.selectedCategory = newValue;
                  appData.notifyListeners();
                },
                items: appData.categories.map((String option) {
                  return DropdownMenuItem<String>(
                    value: option,
                    child: Text(option),
                  );
                }).toList(),
              ),
            ],
          ),
          Row(
            children: [
              const Text("Language:"),
              const SizedBox(width: 10,),
              DropdownButton<String>(
                hint: Text('Choose a language'),
                value: appData.selectedLanguage,
                onChanged: (String? newValue) {
                  appData.selectedLanguage = newValue;
                  appData.notifyListeners();
                },
                items: appData.languages.map((String option) {
                  return DropdownMenuItem<String>(
                    value: option,
                    child: Text(option),
                  );
                }).toList(),
              ),
            ],
          ),
          Row(
            children: [
              const Text("Country:"),
              const SizedBox(width: 10,),
              DropdownButton<String>(
                hint: Text('Choose a country'),
                value: appData.selectedCountry,
                onChanged: (String? newValue) {
                  appData.selectedCountry = newValue;
                  appData.notifyListeners();
                },
                items: appData.countries.map((String option) {
                  return DropdownMenuItem<String>(
                    value: option,
                    child: Text(option),
                  );
                }).toList(),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: () { 
                  // send
                  print("send");
                  appData.prepareToSend(context);
                },
                child: const Text("DONE"),
              ),
              const SizedBox(width: 8),
            ],
          ),
        ],
      ),
    ),
  );
}