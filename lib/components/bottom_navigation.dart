import 'package:flutter/material.dart';

class MyBottomNavigation extends StatelessWidget {
  final void Function(int) onTabChange;
  final int selectedIndex;

  const MyBottomNavigation({
    super.key,
    required this.onTabChange,
    required this.selectedIndex,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: selectedIndex,
      onTap: onTabChange,
      type: BottomNavigationBarType.fixed, // good for 4+ items
      selectedItemColor: Colors.blueAccent, // or your primary color
      unselectedItemColor: Colors.grey,
      backgroundColor:
          Colors.white, // or theme.bottomNavigationBarTheme.backgroundColor
      elevation: 8,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: 'Home'),
        BottomNavigationBarItem(
          icon: Icon(Icons.grid_view_rounded),
          label: 'Categories',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_bag_rounded),
          label: 'Cart',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_rounded),
          label: 'Profile',
        ),
      ],
    );
  }
}
