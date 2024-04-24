import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:latlong2/latlong.dart';

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
        title: Text("Nearby Bins"),
      ),
      body: FlutterMap(
        options: MapOptions(
            initialCenter: LatLng(28.450645, 77.5841967),
            // center: LatLng(59.438484, 24.742595),
            initialZoom: 14,
            keepAlive: true),
        children: [
          TileLayer(
            urlTemplate: "$styleUrl?api_key={api_key}",
            additionalOptions: {"api_key": apiKey},
            maxZoom: 20,
            maxNativeZoom: 20,
          ),
          MarkerClusterLayerWidget(
            options: MarkerClusterLayerOptions(
              maxClusterRadius: 45,
              size: const Size(40, 40),
              alignment: Alignment.center,
              padding: const EdgeInsets.all(50),
              maxZoom: 15,
              markers: [
                Marker(
                    point: LatLng(28.450645, 77.5841967),
                    child: Icon(
                      Icons.location_on,
                      color: Colors.red,
                    )),
                Marker(
                    point: LatLng(28.450700, 77.5841967),
                    child: Icon(
                      Icons.location_on,
                      color: Colors.red,
                    )),
                Marker(
                    point: LatLng(28.450645, 77.5942000),
                    child: Icon(
                      Icons.location_on,
                      color: Colors.red,
                    )),
                Marker(
                    point: LatLng(28.46, 77.5841980),
                    child: Icon(
                      Icons.location_on,
                      color: Colors.red,
                    ))
              ],
              builder: (context, markers) {
                return Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.blue),
                  child: Center(
                    child: Text(
                      markers.length.toString(),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
