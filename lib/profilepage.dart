import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                            CircleAvatar(
                              radius: 60,
                              child: Image.network(
                                  "https://cdn-icons-png.flaticon.com/512/924/924915.png"),
                            ),
                            SizedBox(
                              width: 30,
                            ),
                            Text(
                              "Ria",
                              style: GoogleFonts.autourOne(
                                  fontSize: 40, color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                      Divider(
                        thickness: 2,
                      ),
                      Text(
                        "Score: 100",
                        style: GoogleFonts.autourOne(
                            fontSize: 20, color: Colors.black),
                      )
                    ],
                  ),
                ),
              ),
            ),
            //5555555555555555555555225602289682181238/1/85
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              child: Container(
                height: 150,
                decoration: BoxDecoration(
                  // color: Colors.green[300],
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            children: [
                              Icon(
                                Icons.star,
                                color: Colors.amber,
                                size: 70,
                              ),
                              Text(
                                "Points",
                                style: GoogleFonts.autourOne(
                                    fontSize: 20, color: Colors.black),
                              )
                            ],
                          ),
                          Column(
                            children: [
                              Icon(
                                Icons.edit_note_outlined,
                                color: Colors.black,
                                size: 70,
                              ),
                              Text(
                                "Edit Profile",
                                style: GoogleFonts.autourOne(
                                    fontSize: 20, color: Colors.black),
                              )
                            ],
                          ),
                          Column(
                            children: [
                              Icon(
                                Icons.verified,
                                color: Colors.blue,
                                size: 70,
                              ),
                              Text(
                                "Status",
                                style: GoogleFonts.autourOne(
                                    fontSize: 20, color: Colors.black),
                              )
                            ],
                          ),
                        ],
                      ),
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
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
