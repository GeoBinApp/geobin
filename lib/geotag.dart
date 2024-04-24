import 'dart:io';
import 'package:geolocator/geolocator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:geobin/collections.dart';
import 'package:geobin/nav.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class geoTagScreen extends StatefulWidget {
  geoTagScreen({super.key, this.imgPath});
  String? imgPath;
  Reference? imgUp;

  @override
  State<geoTagScreen> createState() => _geoTagScreenState();
}

class _geoTagScreenState extends State<geoTagScreen> {
  @override
  void initState() {
    super.initState();
    setState(() {
      widget.imgPath = null;
    });
  }

  Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("GeoTags"),
      ),
      body: Padding(
        padding:
            const EdgeInsets.only(left: 10.0, right: 10.0, top: 50, bottom: 50),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () async {
                  final ImagePicker picker = ImagePicker();
                  final XFile? image =
                      await picker.pickImage(source: ImageSource.camera);
                  List<String> parts = image!.name.split('.');
                  String extension = parts.last;
                  widget.imgUp = FBCollections.geoPics.child(
                      "${DateTime.now().millisecondsSinceEpoch}.$extension");
                  print(extension);
                  setState(() {
                    widget.imgPath = image.path;
                  });
                },
                child: Container(
                  //height: 150,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(20)),

                  child: widget.imgPath != null
                      ? Image.file(
                          File(widget.imgPath!),
                          fit: BoxFit.cover,
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.add_a_photo,
                              size: 45,
                            ),
                            Text(
                              "Click a Picture of the trash to tag it!",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.autourOne(
                                  fontSize: 30, color: Colors.black),
                            ),
                          ],
                        ),
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            ElevatedButton(
              onPressed: () async {
                User user = FirebaseAuth.instance.currentUser!;
                try {
                  Position tag = await determinePosition();
                  await widget.imgUp!.putFile(File(widget.imgPath!));
                  String url = await widget.imgUp!.getDownloadURL();
                  String docName =
                      DateTime.now().millisecondsSinceEpoch.toString();
                  var data = {"pic_url": url, "address": tag.toString()};
                  await FBCollections.geotags.doc(docName).set(data);
                } catch (e) {
                  print(e);
                }
                setState(() {
                  widget.imgPath = null;
                });
              },
              child: Text("Add GeoTag"),
            )
          ],
        ),
      ),
    );
  }
}
