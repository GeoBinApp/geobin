import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geobin/collections.dart';
import 'package:geobin/nav.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker_platform_interface/image_picker_platform_interface.dart';

class addPostPage extends StatefulWidget {
  addPostPage({super.key});
  String? imgPath;
  Reference? imgUp;

  @override
  State<addPostPage> createState() => _addPostPageState();
}

class _addPostPageState extends State<addPostPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Post"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () async {
                final ImagePicker picker = ImagePicker();
                final XFile? image =
                    await picker.pickImage(source: ImageSource.gallery);
                List<String> parts = image!.name.split('.');
                String extension = parts.last;
                widget.imgUp = FBCollections.photos.child(
                    "${DateTime.now().millisecondsSinceEpoch}.$extension");
                print(extension);
                setState(() {
                  widget.imgPath = image.path;
                });
              },
              child: Container(
                height: 150,
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(20)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.add_a_photo,
                      size: 45,
                    ),
                    Text(
                      "Add Post Picture",
                      style: GoogleFonts.autourOne(
                          fontSize: 30, color: Colors.black),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: nameController,
                keyboardType: TextInputType.name,
                decoration: const InputDecoration(
                  hintText: 'Enter Post Name',
                  // suffixIcon: Icon(Icons.),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(25)),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: descriptionController,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  hintText: 'Enter Post Description',
                  // suffixIcon: Icon(Icons.),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(25)),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: locationController,
                keyboardType: TextInputType.streetAddress,
                decoration: const InputDecoration(
                  hintText: 'Enter Post Location',
                  // suffixIcon: Icon(Icons.),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(25)),
                  ),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  await widget.imgUp!.putFile(File(widget.imgPath!));
                  String url = await widget.imgUp!.getDownloadURL();
                  String docName =
                      DateTime.now().millisecondsSinceEpoch.toString();
                  var data = {
                    "name": nameController.text,
                    "description": descriptionController.text,
                    "location": locationController.text,
                    "pic_url": url,
                    "joined": [],
                    "id": docName
                  };
                  await FBCollections.community.doc(docName).set(data);
                } catch (e) {
                  print(e);
                }
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => navBar(
                              selectedIndex: 2,
                            )));
              },
              child: Text("Add Post"),
            )
          ],
        ),
      ),
    );
  }
}
