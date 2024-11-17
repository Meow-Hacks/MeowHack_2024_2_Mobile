import 'package:flutter/material.dart';

class LekasBottomBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final List<LekasBottomBarItem> items;

  const LekasBottomBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
    required this.items,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final maxBarWidth = screenWidth - 20;
    final barWidth = (items.length * 80.0).clamp(0.0, maxBarWidth);

    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Container(
        width: screenWidth,
        height: 100,
        child: Center(
          child: Container(
            width: barWidth,
            padding: EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
              // border: Border.all(color: Colors.grey.withOpacity(0.5)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: items.asMap().entries.map((entry) {
                int index = entry.key;
                LekasBottomBarItem item = entry.value;
                return GestureDetector(
                  onTap: () => onTap(index),
                  child: AnimatedIconWithShadow(
                    icon: item.icon,
                    label: item.title,
                    isSelected: index == currentIndex,
                    selectedColor: item.selectedColor,
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}

class AnimatedIconWithShadow extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final Color selectedColor;

  const AnimatedIconWithShadow({
    Key? key,
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.selectedColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 30, // Constrain the size as needed
          height: 30, // Constrain the size as needed
          child: Stack(
            clipBehavior: Clip.none, // Allow overflow if needed
            children: [
              AnimatedPositioned(
                duration: Duration(milliseconds: 100),
                left: isSelected ? -2 : 0,
                top: isSelected ? 2 : 0,
                child: Icon(
                  icon,
                  color: Colors.grey.withOpacity(0.5),
                  size: 30, // Ensure consistent icon size
                ),
              ),
              AnimatedPositioned(
                duration: Duration(milliseconds: 100),
                left: isSelected ? 2 : 0,
                top: isSelected ? -2 : 0,
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 100),
                  child: Icon(
                    icon,
                    color: isSelected ? selectedColor : Colors.grey,
                    size: 30, // Ensure consistent icon size
                  ),
                ),
              ),
            ],
          ),
        ),
        // SizedBox(height: 4), // Space between icon and text
        // Text(
        //   label,
        //   style: TextStyle(
        //     color: isSelected ? selectedColor : Colors.grey,
        //     fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        //   ),
        // ),
      ],
    );
  }
}

class LekasBottomBarItem {
  final IconData icon;
  final String title;
  final Color selectedColor;

  LekasBottomBarItem({
    required this.icon,
    required this.title,
    required this.selectedColor,
  });
}
