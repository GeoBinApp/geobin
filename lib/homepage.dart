import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<bool> signOutFromGoogle() async {
    try {
      await FirebaseAuth.instance.signOut();
      return true;
    } on Exception catch (_) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    const styleUrl =
        "https://tiles.stadiamaps.com/tiles/alidade_smooth_dark/{z}/{x}/{y}{r}.png";
    const apiKey = "a1e9793d-bed4-4986-949c-24f3abf9e654";
    return Scaffold(
      appBar: AppBar(
        title: Text("Home Page"),
      ),
      body: Expanded(
          child: Container(
        width: double.infinity,
        child: // TODO: Replace this with your own API key. Sign up for free at https://client.stadiamaps.com/signup/
            FlutterMap(
          options: MapOptions(
              // center: LatLng(59.438484, 24.742595),
              zoom: 14,
              keepAlive: true),
          children: [
            TileLayer(
              urlTemplate: "$styleUrl?api_key={api_key}",
              additionalOptions: {"api_key": apiKey},
              maxZoom: 20,
              maxNativeZoom: 20,
            )
          ],
        ),
      )),
    );
  }
}
