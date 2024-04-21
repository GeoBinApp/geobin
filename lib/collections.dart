import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FBCollections {
  static CollectionReference users =
      FirebaseFirestore.instance.collection("users");
  static CollectionReference community =
      FirebaseFirestore.instance.collection("community");
  static Reference photos = FirebaseStorage.instance.ref("community");
  static Reference pics = FirebaseStorage.instance.ref("pics");
  static CollectionReference geotags =
      FirebaseFirestore.instance.collection("geotags");
  static Reference geoPics = FirebaseStorage.instance.ref("geotags");
}
