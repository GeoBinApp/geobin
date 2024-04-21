import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geobin/addPost.dart';
import 'package:geobin/collections.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class communitiesPage extends StatefulWidget {
  communitiesPage({super.key});
  List? communities;

  @override
  State<communitiesPage> createState() => _communitiesPageState();
}

class _communitiesPageState extends State<communitiesPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      List comData =
          await FBCollections.community.get().then((value) => value.docs);
      setState(() {
        widget.communities = comData;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Communities"),
        ),
        body: widget.communities == null
            ? Center(
                child: CircularProgressIndicator(),
              )
            : ListView.builder(
                itemCount: widget.communities!.length,
                itemBuilder: (BuildContext context, int index) {
                  DocumentSnapshot post = widget.communities![index];
                  var data = post.data() as Map<String, dynamic>;
                  return postWidget(data: data);
                }),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => addPostPage()));
          },
          child: Icon(Icons.add),
          backgroundColor: Color(0xffd6f1cf),
        ));
  }
}

class postWidget extends StatelessWidget {
  postWidget({
    super.key,
    required this.data,
  });
  Map<String, dynamic> data;

  @override
  Widget build(BuildContext context) {
    User user = FirebaseAuth.instance.currentUser!;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
          //color: Colors.green[300],
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        height: 350,
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Container(
                height: 175,
                width: 375,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: CachedNetworkImage(
                    imageUrl: data["pic_url"],
                    placeholder: (context, url) => SpinKitWave(
                      color: Colors.red,
                      size: 50.0,
                    ),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.only(
                  right: 8.0,
                  left: 8.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          data["name"],
                          style: GoogleFonts.autourOne(
                              fontSize: 30, color: Colors.black),
                        ),
                        Text(
                          data["location"],
                          style: GoogleFonts.averageSans(
                              fontSize: 20,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        List members = data["joined"];
                        members.add(user.uid);
                        await FBCollections.community
                            .doc(data["id"])
                            .update({"joined": members});
                      },
                      child: Text("Join"),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 8.0, left: 8.0),
                child: Container(
                  height: 75,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Align(
                        alignment: Alignment.bottomLeft,
                        child: Text(
                          data["description"],
                          style: GoogleFonts.averageSans(
                              fontSize: 20, color: Colors.black),
                        )),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
