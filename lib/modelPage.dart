import 'dart:convert';
import 'dart:io';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class ModelPage extends StatefulWidget {
  ModelPage({super.key});
  XFile? file;
  bool isLoading = false;

  @override
  State<ModelPage> createState() => _ModelPageState();
}

class _ModelPageState extends State<ModelPage> {
  Future<dynamic> processPicture(File imageFile) async {
    var request = http.MultipartRequest('POST',
        Uri.parse('https://geobin-bennett.loophole.site/process_picture/'));

    // Add the image file to the request
    request.files
        .add(await http.MultipartFile.fromPath('image', imageFile.path));

    try {
      // Send the request
      var response = await request.send();

      // Check if the request was successful
      if (response.statusCode == 200) {
        // Read the response
        var responseBody = await response.stream.bytesToString();

        // Process the response as needed
        Map<String, dynamic> data = json.decode(responseBody);
        return data['response'];
      } else {
        // Request failed
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      // An error occurred
      print('Error sending request: $e');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget.isLoading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    String result = "Click a Picture of the trash to find out what it is!";
    TextEditingController resultController = TextEditingController();
    return widget.isLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            appBar: AppBar(
              title: Text("Detect your Trash!"),
            ),
            body: Padding(
              padding: const EdgeInsets.only(
                  left: 10.0, right: 10.0, top: 50, bottom: 50),
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

                        print(extension);
                        setState(() {
                          widget.file = image;
                        });
                      },
                      child: Container(
                        //height: 150,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(20)),

                        child: widget.file != null
                            ? Image.file(
                                File(widget.file!.path),
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
                                    result,
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
                      String resText = "";
                      try {
                        print("fetching");
                        widget.isLoading = true;
                        setState(() {});
                        Map<String, dynamic> results =
                            await processPicture(File(widget.file!.path));
                        print(results.toString());
                        resultController.text = results.toString();
                        result = results.toString();
                        results.forEach((key, value) {
                          resText += "$key: $value\n";
                        });
                        widget.isLoading = false;
                        setState(() {});
                        showDialog(
                            useSafeArea: true,
                            context: context,
                            builder: (context) {
                              return Padding(
                                padding: EdgeInsets.only(
                                    top: 250.sp,
                                    bottom: 250.sp,
                                    left: 50.sp,
                                    right: 50.sp),
                                child: Scaffold(
                                  appBar: AppBar(
                                    title: Text("Results"),
                                  ),
                                  body: Container(
                                    color: Colors.green,
                                    child: Center(
                                      child: Text(
                                        resText,
                                        style: GoogleFonts.autourOne(
                                            fontSize: 30.sp,
                                            color: Colors.black),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            });
                        // ScaffoldMessenger.of(context).showSnackBar(
                        //     SnackBar(content: Text(results.toString())));
                      } catch (e) {
                        print(e);
                      }
                      setState(() {
                        widget.file = null;
                      });
                    },
                    child: Text("Check"),
                  ),
                  // Text(
                  //   result,
                  //   style: GoogleFonts.autourOne(),
                  // ),
                ],
              ),
            ),
          );
  }
}
