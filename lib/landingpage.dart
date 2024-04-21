import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geobin/collections.dart';
import 'package:geobin/homepage.dart';
import 'package:auth_buttons/auth_buttons.dart';
import 'package:geobin/nav.dart';
import 'package:geobin/profilepage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  Future<dynamic> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      return await FirebaseAuth.instance.signInWithCredential(credential);
    } on Exception catch (e) {
      // TODO
      print('exception->$e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Stack(children: [
      Container(
        color: Color(0xffd6f1cf),
        height: double.infinity,
        width: double.infinity,
      ),
      Image.asset(
        "assets/images/bg.jpg",
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        fit: BoxFit.cover,
      ),
      Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
              Column(
                children: [
                  SizedBox(
                    height: 100,
                  ),
                  Center(
                    child: Text(
                      "Welcome to",
                      style: GoogleFonts.averiaGruesaLibre(
                          fontSize: 45, color: Colors.white),
                    ),
                  ),
                  Center(
                    child: Text(
                      "GeoBin",
                      style:
                          GoogleFonts.cutive(fontSize: 60, color: Colors.white),
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => navBar()));
                    },
                    child: Image.asset(
                      "assets/images/login.png",
                      width: MediaQuery.of(context).size.width * 0.7,
                      fit: BoxFit.cover,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      print("Hello");
                    },
                    child: Image.asset(
                      "assets/images/signup.png",
                      width: MediaQuery.of(context).size.width * 0.7,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: Row(children: <Widget>[
                        Expanded(
                            child: Divider(
                          thickness: 2,
                          color: Color(0xffd6f1cf),
                        )),
                        Text(
                          "OR",
                          style: GoogleFonts.averiaGruesaLibre(
                              fontSize: 20, color: Colors.white),
                        ),
                        Expanded(
                            child: Divider(
                          thickness: 2,
                          color: Color(0xffd6f1cf),
                        )),
                      ])),
                  SizedBox(
                    height: 20,
                  ),
                  GoogleAuthButton(
                    onPressed: () async {
                      try {
                        await signInWithGoogle();
                        User user = FirebaseAuth.instance.currentUser!;
                        print(user.displayName);
                        var data = {
                          "name": user.displayName,
                          "email": user.email,
                          "pic": user.photoURL,
                          "uid": user.uid,
                          "posts": []
                        };
                        await FBCollections.users.doc(user.uid).set(data);
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) => navBar()));
                      } catch (e) {
                        print('exception->$e');
                      }
                    },
                    style: AuthButtonStyle(
                      buttonType: AuthButtonType.icon,
                    ),
                  ),
                ],
              )
            ])),
      ),
    ]));
  }
}
//206 bla 1:30 - 3:30