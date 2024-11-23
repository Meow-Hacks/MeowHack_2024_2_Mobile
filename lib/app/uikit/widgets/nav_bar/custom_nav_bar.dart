import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
// import 'package:lekas_bottom_bar/lekas_bottom_bar.dart';
import 'lekas_bottom_bar.dart';
import 'package:meow_hack_app/app/routes/navigator.dart';


class CustomBottomNavigationBar extends StatelessWidget {
  const CustomBottomNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    final tabManager = Provider.of<TabManager>(context);
    final theme = Theme.of(context);

    return LekasBottomBar(
      backgroundColor: theme.colorScheme.surface,
      currentIndex: tabManager.currentIndex,
      onTap: (index) => tabManager.setCurrentIndex(index),
      items: [
        LekasBottomBarItem(
          icon: Icons.home,
          title: "Home",
          selectedColor: Colors.purple,
        ),
        LekasBottomBarItem(
          icon: Icons.search,
          title: "Search",
          selectedColor: Colors.orange,
        ),
        LekasBottomBarItem(
          icon: Icons.favorite_border,
          title: "Likes",
          selectedColor: Colors.pink,
        ),
        LekasBottomBarItem(
          icon: Icons.person,
          title: "Profile",
          selectedColor: Colors.teal,
        ),
      ],
    );
  }
}