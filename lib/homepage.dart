import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:geobin/collections.dart';
import 'package:geobin/landingpage.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});
  LatLng? userPos;

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

  Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      var doc = await FBCollections.users
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();
      Map<String, dynamic> userData = doc.data() as Map<String, dynamic>;
      if (userData['isBanned']) {
        await FirebaseAuth.instance.signOut();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              "You are banned from this application! If you think this is a mistake please contact the admin!"),
        ));
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => LandingPage()));
      }
      Position userLoc = await determinePosition();
      setState(() {
        widget.userPos = LatLng(userLoc.latitude, userLoc.longitude);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    const styleUrl =
        "https://tiles.stadiamaps.com/tiles/alidade_smooth_dark/{z}/{x}/{y}{r}.png";
    const apiKey = "a1e9793d-bed4-4986-949c-24f3abf9e654";
    return widget.userPos == null
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            appBar: AppBar(
              title: Text("Nearby Bins"),
            ),
            body: FlutterMap(
              options: MapOptions(
                  initialCenter: widget.userPos!,
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
                CurrentLocationLayer(
                    alignPositionOnUpdate: AlignOnUpdate.always,
                    alignDirectionOnUpdate: AlignOnUpdate.always,
                    style: LocationMarkerStyle(
                      marker: const DefaultLocationMarker(
                        child: Icon(
                          Icons.navigation,
                          color: Colors.white,
                        ),
                      ),
                      markerSize: const Size(30, 30),
                      markerDirection: MarkerDirection.heading,
                    )),
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
