import 'package:flutter/material.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;

  CustomBottomNavBar({required this.selectedIndex, required this.onItemSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: BottomNavigationBar(
        backgroundColor: Colors.white,
        elevation: 0,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Mes programmes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.create),
            label: 'Créer son programme',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
        currentIndex: selectedIndex,
        selectedItemColor: Color(0xFF6A11CB), 
        unselectedItemColor: Color.fromARGB(255, 0, 0, 0), 
        onTap: onItemSelected,
      ),
    );
  }
}
