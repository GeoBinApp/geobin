import 'dart:io';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geobin/constants.dart';
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
  bool isLoading = false;

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
      body: widget.isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: EdgeInsets.only(
                  left: 10.sp, right: 10.sp, top: 50.sp, bottom: 50.sp),
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
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(20.sp)),
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
                                    size: 45.sp,
                                  ),
                                  Text(
                                    "Click a Picture of the trash to tag it!",
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.autourOne(
                                        fontSize: 30.sp, color: Colors.black),
                                  ),
                                ],
                              ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: Sizes.h30,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      User user = FirebaseAuth.instance.currentUser!;
                      try {
                        setState(() {
                          widget.isLoading = true;
                        });
                        Position tag = await determinePosition();
                        await widget.imgUp!.putFile(File(widget.imgPath!));
                        String url = await widget.imgUp!.getDownloadURL();
                        String docName =
                            DateTime.now().millisecondsSinceEpoch.toString();
                        var data = {
                          "pic_url": url,
                          "latitude": tag.latitude,
                          "longitude": tag.longitude,
                          "uid": user.uid
                        };
                        await FBCollections.geotags.doc(docName).set(data);
                      } catch (e) {
                        print(e);
                      }
                      setState(() {
                        widget.imgPath = null;
                        widget.isLoading = false;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Uploaded Successfully")));
                    },
                    child: Text("Add GeoTag"),
                  )
                ],
              ),
            ),
    );
  }
}
