import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geobin/collections.dart';
import 'package:geobin/constants.dart';
import 'package:geobin/editprofile.dart';
import 'package:geobin/landingpage.dart';
import 'package:get/get.dart';
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
                      height: Sizes.h200,
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
                                    imageUrl: widget.userData?["pic"],
                                    placeholder: (context, url) =>
                                        SpinKitPumpingHeart(
                                      color: Colors.red,
                                      size: 50.0,
                                    ),
                                    imageBuilder: (context, imageProvider) =>
                                        Container(
                                      width: Sizes.w110,
                                      height: Sizes.h110,
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
                                    width: Sizes.w20,
                                  ),
                                  Flexible(
                                    child: Text(
                                      widget.userData!['name'],
                                      textAlign: TextAlign.left,
                                      style: GoogleFonts.autourOne(
                                          fontSize: 32.sp, color: Colors.white),
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

                  profileMenuButton(
                    onClick: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => editProfilePage()));
                    },
                    icon: Icons.edit_note_outlined,
                    title: "Edit Profile",
                  ),
                  profileMenuButton(
                      onClick: () {}, icon: Icons.settings, title: "Settings"),
                  profileMenuButton(
                    onClick: () {},
                    icon: Icons.notes,
                    title: "Terms and Conditions",
                    isLong: true,
                  ),
                  profileMenuButton(
                      onClick: () {}, icon: Icons.help, title: "FAQs and Help"),
                  profileMenuButton(
                      onClick: () {}, icon: Icons.error, title: "Report"),
                  profileMenuButton(
                      onClick: () async {
                        await signOutFromGoogle();
                        //await FirebaseAuth.instance.signOut();
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LandingPage()));
                      },
                      icon: Icons.logout,
                      title: "Log Out"),
                ],
              ),
            ),
          );
  }
}

class profileMenuButton extends StatelessWidget {
  profileMenuButton({
    super.key,
    required this.onClick,
    required this.icon,
    required this.title,
    this.isLong = false,
  });
  void Function() onClick;
  IconData icon;
  String title;
  bool isLong;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onClick,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          height: Sizes.h100,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: 50.sp,
                ),
                SizedBox(
                  width: Sizes.w20,
                ),
                Text(
                  title,
                  style: GoogleFonts.autourOne(
                      fontSize: isLong ? 20.sp : 25.sp, color: Colors.black),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
