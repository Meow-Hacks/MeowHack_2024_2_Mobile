import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../app/uikit/widgets/new_nav_bar/new_bottom_bar.dart';

class Test extends StatefulWidget {
  const Test({super.key});

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
  final List<Widget> pages = const [
    Center(child: Text('Home Page')),
    Center(child: Text('Search Page')),
    Center(child: Text('Profile Page')),
  ];

  @override
  Widget build(BuildContext context) {
    final currentPage = Provider.of<PageManager>(context).currentPage;
    final theme = Theme.of(context);

    return Scaffold(
      body: Stack(
        children: [
          pages[currentPage],
          Positioned(
            bottom: 10,
            left: 20,
            right: 20,
            child: NewBottomBar(
              backgroundColor: theme.colorScheme.surface,
              height: 70,
              icons: const [
                Icons.home,
                Icons.search,
                Icons.person,
              ],
              onPageSelected: (pageIndex) {
                print('Switched to page $pageIndex');
              },
            ),
          )
        ]
      )
    );
  }
}
