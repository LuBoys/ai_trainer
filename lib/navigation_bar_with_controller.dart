import 'package:flutter/material.dart';
import 'package:test/custom_bottom_nav_bar.dart';

class NavigationBarWithController extends StatefulWidget {
  final int selectedIndex;
  const NavigationBarWithController({Key? key, required this.selectedIndex}) : super(key: key);

  @override
  _NavigationBarWithControllerState createState() => _NavigationBarWithControllerState();
}

class _NavigationBarWithControllerState extends State<NavigationBarWithController> {
  void _onItemTapped(int index) {
    switch (index) {
      case 0:
        Navigator.of(context).pushNamed('/mesProgrammes');
        break;
      case 1:
        Navigator.of(context).pushNamed('/formulaire');
        break;
      case 2:
        Navigator.of(context).pushNamed('/profil');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomBottomNavBar(
      selectedIndex: widget.selectedIndex,
      onItemSelected: _onItemTapped,
    );
  }
}
