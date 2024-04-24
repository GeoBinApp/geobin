import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geobin/collections.dart';
import 'package:geobin/editprofile.dart';
import 'package:geobin/landingpage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({super.key});
  Map<String, dynamic>? userData;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    User user = FirebaseAuth.instance.currentUser!;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      DocumentSnapshot userDoc = await FBCollections.users.doc(user.uid).get();
      var usrData = userDoc.data() as Map<String, dynamic>;
      setState(() {
        widget.userData = usrData;
      });
    });
  }

  User user = FirebaseAuth.instance.currentUser!;
  @override
  Widget build(BuildContext context) {
    Future<bool> signOutFromGoogle() async {
      try {
        await FirebaseAuth.instance.signOut();
        await GoogleSignIn().signOut();
        return true;
      } on Exception catch (_) {
        return false;
      }
    }

    return widget.userData == null
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            appBar: AppBar(
              title: Text("Profile Page"),
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 200,
                      decoration: BoxDecoration(
                        color: Colors.green[300],
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 8.0, right: 8.0, left: 8.0, bottom: 5.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  CachedNetworkImage(
                                    imageUrl: widget.userData?["pic_url"],
                                    placeholder: (context, url) =>
                                        SpinKitPumpingHeart(
                                      color: Colors.red,
                                      size: 50.0,
                                    ),
                                    imageBuilder: (context, imageProvider) =>
                                        Container(
                                      width: 110.0,
                                      height: 110.0,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        image: DecorationImage(
                                            image: imageProvider,
                                            fit: BoxFit.cover),
                                      ),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        Icon(Icons.error),
                                  ),
                                  SizedBox(
                                    width: 30,
                                  ),
                                  Flexible(
                                    child: Text(
                                      widget.userData!['name'],
                                      textAlign: TextAlign.left,
                                      style: GoogleFonts.autourOne(
                                          fontSize: 40, color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  //5555555555555555555555225602289682181238/1/85

                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => editProfilePage()));
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Icon(
                                Icons.edit_note_outlined,
                                size: 50,
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Text(
                                "Edit Profile",
                                style: GoogleFonts.autourOne(
                                    fontSize: 30, color: Colors.black),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 100,
                      decoration: BoxDecoration(
                        // color: Colors.green[300],
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Icon(
                              Icons.settings,
                              size: 50,
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Text(
                              "Settings",
                              style: GoogleFonts.autourOne(
                                  fontSize: 30, color: Colors.black),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 100,
                      decoration: BoxDecoration(
                        //color: Colors.green[300],
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Icon(
                              Icons.notes,
                              size: 50,
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Text(
                              "Terms and Conditions",
                              style: GoogleFonts.autourOne(
                                  fontSize: 23, color: Colors.black),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 100,
                      decoration: BoxDecoration(
                        // color: Colors.green[300],
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Icon(
                              Icons.help,
                              size: 50,
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Text(
                              "FAQs and Help",
                              style: GoogleFonts.autourOne(
                                  fontSize: 30, color: Colors.black),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 100,
                      decoration: BoxDecoration(
                        //color: Colors.green[300],
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Icon(
                              Icons.error,
                              size: 50,
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Text(
                              "Report",
                              style: GoogleFonts.autourOne(
                                  fontSize: 30, color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () async {
                      await signOutFromGoogle();
                      //await FirebaseAuth.instance.signOut();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LandingPage()));
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 100,
                        decoration: BoxDecoration(
                          // color: Colors.green[300],
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Icon(
                                Icons.logout,
                                size: 50,
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Text(
                                "Log Out",
                                style: GoogleFonts.autourOne(
                                    fontSize: 30, color: Colors.black),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
