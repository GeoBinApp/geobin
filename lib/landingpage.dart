import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geobin/homepage.dart';
import 'package:auth_buttons/auth_buttons.dart';
import 'package:geobin/profilepage.dart';
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
        child: Scaffold(
      appBar: AppBar(
        title: Center(child: Text("Login Page")),
        backgroundColor: Colors.green,
      ),
      body: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
            Column(
              children: [
                Center(
                  child: Text(
                    "Welcome to Geobin",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                  ),
                ),
                // Text(
                //   "           Geobin!",
                //   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                // ),
              ],
            ),
            Column(
              children: [
                ElevatedButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => HomePage()));
                    },
                    child: Text("Login")),
                GoogleAuthButton(
                  onPressed: () async {
                    try {
                      await signInWithGoogle();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ProfilePage()));
                    } catch (e) {
                      print('exception->$e');
                    }
                  },
                  style: AuthButtonStyle(
                    buttonType: AuthButtonType.icon,
                  ),
                ),
                ElevatedButton(onPressed: () {}, child: Text("Sign Up")),
              ],
            )
          ])),
    ));
  }
}
//206 bla 1:30 - 3:30