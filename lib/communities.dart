import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geobin/collections.dart';
import 'package:google_fonts/google_fonts.dart';

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

      print(widget.communities![0].data());
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
    );
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
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.green[300],
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
                  child: Image.network(
                    "https://pbs.twimg.com/media/FcV9NqLaAAIjDp2.jpg",
                    fit: BoxFit.cover,
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
                    Text(
                      "Post Name",
                      style: GoogleFonts.autourOne(
                          fontSize: 30, color: Colors.black),
                    ),
                    ElevatedButton(onPressed: () {}, child: Text("Join")),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 8.0, left: 8.0),
                child: Container(
                  height: 100,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Align(
                        alignment: Alignment.bottomLeft,
                        child: Text(
                          "Quisque felis ante, dapibus sed ligula vitae, efficitur sagittis metus. Proin fringilla cursus nisi et maximus. Aliquam vitae dui nunc. Mauris in egestas erat, sit amet aliquam ligula. Nunc nec finibus ante, et sagittis lacus. Curabitur lobortis, ex ut ornare sagittis, massa est accumsan elit, vel scelerisque nibh nulla sed lorem. Vestibulum feugiat cursus egestas. Donec pretium diam at lorem vestibulum sodales. Curabitur id efficitur nulla. Curabitur sollicitudin dapibus libero interdum feugiat. Sed dictum turpis et purus efficitur blandit. Etiam nisi dui, rhoncus non viverra eget, dignissim in nunc. Nulla quis viverra magna. Pellentesque rutrum, odio vitae dictum pretium, ex nisi pharetra nisl, sit amet laoreet justo sapien eget erat. Aliquam id sapien eget felis gravida lobortis sed sagittis ante. Morbi laoreet mauris eget cursus tincidunt.",
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
