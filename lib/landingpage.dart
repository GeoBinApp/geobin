import 'package:flutter/material.dart';
import 'package:geobin/homepage.dart';
import 'package:auth_buttons/auth_buttons.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
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
                Text(
                  "Welcome to                      ",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                ),
                Text(
                  "           Geobin!",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                ),
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
                ElevatedButton(onPressed: () {}, child: Text("Sign Up")),
              ],
            )
          ])),
    ));
  }
}
//206 bla 1:30 - 3:30