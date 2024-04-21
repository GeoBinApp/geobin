import 'package:cloud_firestore/cloud_firestore.dart';

class FBCollections {
  static CollectionReference users =
      FirebaseFirestore.instance.collection("users");
  static CollectionReference community =
      FirebaseFirestore.instance.collection("community");
}
