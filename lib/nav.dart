import 'package:flutter/material.dart';
import 'package:geobin/communities.dart';
import 'package:geobin/geotag.dart';
import 'package:geobin/homepage.dart';
import 'package:geobin/modelPage.dart';
import 'package:geobin/profilepage.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class navBar extends StatefulWidget {
  int selectedIndex;
  navBar({this.selectedIndex = 0});
  @override
  _navBarState createState() => _navBarState();
}

class _navBarState extends State<navBar> {
  late int _selectedIndex;
  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.selectedIndex;
  }

  static const TextStyle optionStyle =
      TextStyle(fontSize: 25, fontWeight: FontWeight.w600);
  static List<Widget> _widgetOptions = <Widget>[
    HomePage(),
    geoTagScreen(
      imgPath: null,
    ),
    ModelPage(),
    communitiesPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 20,
              color: Colors.black.withOpacity(.1),
            )
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
            child: GNav(
              rippleColor: Colors.grey[300]!,
              hoverColor: Colors.grey[100]!,
              gap: 1,
              activeColor: Colors.black,
              iconSize: 20,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              duration: Duration(milliseconds: 400),
              tabBackgroundColor: Colors.grey[100]!,
              color: Colors.black,
              tabs: [
                GButton(
                  icon: Icons.delete,
                  text: 'Bins',
                ),
                GButton(
                  icon: Icons.location_on,
                  text: 'GeoTag',
                ),
                GButton(
                  icon: Icons.model_training,
                  text: 'Detect',
                ),
                GButton(
                  icon: Icons.people,
                  text: 'Posts',
                ),
                GButton(
                  icon: Icons.person,
                  text: 'Profile',
                ),
              ],
              selectedIndex: _selectedIndex,
              onTabChange: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
            ),
          ),
        ),
      ),
    );
  }
}
