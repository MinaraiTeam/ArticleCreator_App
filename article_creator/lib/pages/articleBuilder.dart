import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:article_creator/others/AppData.dart';

class ArticleBuilder extends StatefulWidget {
  const ArticleBuilder({Key? key});

  @override
  State<ArticleBuilder> createState() => _ArticleBuilderState();
}

class _ArticleBuilderState extends State<ArticleBuilder> {
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
            appData.title.isEmpty 
              ? _articleTitle(context) 
              : appData.previewImage.path == "" 
                ? _articlePreviewImage(context)
                : _articleText(context),
          ],
        ),
      ),
    );
  }
}

Widget _articleTitle(BuildContext context) {
  AppData appData = Provider.of<AppData>(context);

  final TextEditingController titleController = TextEditingController();

  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Title",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: titleController,
          autofocus: true,
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: () { 
                appData.title = titleController.text;
                appData.notifyListeners();
              },
              child: const Text("DONE"),
            ),
            const SizedBox(width: 8),
          ],
        ),
      ],
    ),
  );
}

Widget _articlePreviewImage(BuildContext context) {
  AppData appData = Provider.of<AppData>(context);

  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Preview Image",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          "Choose a preview image",
          style: TextStyle(
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: () async {
                  final ImagePicker _picker = ImagePicker();
                  final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
                  if (image != null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Image selection done")),
                    );
                    appData.previewImage = image;
                    appData.notifyListeners();
                  } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Image selection canceled")),
                  );
                }
                },
              child: const Text("Image"),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: () => appData.changeToEndPage(context), 
              child: const Text("End"),
            ),
            const SizedBox(width: 8),
          ],
        ),
        const Divider(),
      ],
    ),
  );
}


Widget _articleText(BuildContext context) {
  AppData appData = Provider.of<AppData>(context);
  
  
  final TextEditingController contentController = TextEditingController();

  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Content",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: contentController,
          autofocus: true,
          maxLines: null,
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: () { 
                appData.content.add(contentController.text);
                appData.notifyListeners();
              },
              child: const Text("Text"),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: () async {
                  final ImagePicker _picker = ImagePicker();
                  final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
                  if (image!= null) {
                    appData.content.add(image);
                    appData.notifyListeners();
                  }
                },
              child: const Text("Image"),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: () => appData.prepareToSend(), 
              child: const Text("End"),
            ),
            const SizedBox(width: 8),
          ],
        ),
        Text(
          appData.title,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        const Divider(),
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: appData.content.length,
          itemBuilder: (context, index) {
             if (appData.content[index] is String) {
              return articleText(appData, context, index);
            } else {
              return articleImage(appData, context, index);
            }
          },
        ),
      ],
    ),
  );
}

Widget articleText(AppData appData, BuildContext context, int index) {
  return Container(
    child: Text(appData.content[index]),
  );
}

Widget articleImage(AppData appData, BuildContext context, int index) {
  XFile image = appData.content[index];
  
  final imgWidget = Image.file(File(image.path), fit: BoxFit.contain,); 
  return Container(
    constraints: BoxConstraints(maxHeight: 300),
    child: imgWidget,
  );
}