import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:geobin/collections.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class editProfilePage extends StatefulWidget {
  editProfilePage({super.key});
  String? imgPath;
  Reference? imgUp;

  @override
  State<editProfilePage> createState() => _editProfilePageState();
}

class _editProfilePageState extends State<editProfilePage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Profile"),
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
                widget.imgUp = FBCollections.pics.child(
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
                      "Add Profile Picture",
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
                  hintText: 'Enter New Name',
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
                  hintText: 'Enter Email Address',
                  // suffixIcon: Icon(Icons.),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(25)),
                  ),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                User user = FirebaseAuth.instance.currentUser!;
                try {
                  await widget.imgUp!.putFile(File(widget.imgPath!));
                  String url = await widget.imgUp!.getDownloadURL();
                  var data = {
                    "name": nameController.text,
                    "email": descriptionController.text,
                    "pic_url": url,
                  };
                  await FBCollections.users.doc(user.uid).update(data);
                } catch (e) {
                  print(e);
                }
              },
              child: Text("Add Post"),
            )
          ],
        ),
      ),
    );
  }
}
