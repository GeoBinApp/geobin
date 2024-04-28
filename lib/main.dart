import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geobin/firebase_options.dart';
import 'package:geobin/landingpage.dart';
import 'package:geobin/nav.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    return ScreenUtilInit(
      designSize: const Size(411.4, 876.6),
      child: GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'GeoBin',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          home: user == null ? LandingPage() : navBar()),
    );
  }
}
