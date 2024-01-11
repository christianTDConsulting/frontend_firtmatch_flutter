import 'package:fit_match/models/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fit_match/utils/colors.dart';
import 'package:fit_match/utils/utils.dart';

class mobileLayout extends StatefulWidget {
  final User user;
  final int initialPage;

  const mobileLayout({
    Key? key,
    required this.user,
    this.initialPage = 0,
  }) : super(key: key);

  @override
  _mobileLayout createState() => _mobileLayout();
}

class _mobileLayout extends State<mobileLayout> {
  int _page = 0;
  late PageController pageController; // for tabs animation

  @override
  void initState() {
    super.initState();
    _page = widget.initialPage;
    pageController = PageController(initialPage: _page);
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  void onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  }

  void navigationTapped(int page) {
    // Animating Page
    pageController.animateToPage(
      page,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  BottomNavigationBarItem buildTabBarItem(IconData icon, int pageNumber) {
    return BottomNavigationBarItem(
      icon: Icon(
        icon,
        color: (_page == pageNumber) ? blueColor : primaryColor,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: PageView(
          controller: pageController,
          onPageChanged: onPageChanged,
          children: buildHomeScreenItems(widget.user),
        ),
        bottomNavigationBar: CupertinoTabBar(
          backgroundColor: mobileBackgroundColor,
          items: <BottomNavigationBarItem>[
            buildTabBarItem(Icons.home, 0),
            buildTabBarItem(Icons.favorite, 1),
            buildTabBarItem(Icons.bookmark, 2),
            buildTabBarItem(Icons.fitness_center, 3),
            buildTabBarItem(Icons.person, 4),
          ],
          onTap: navigationTapped,
          currentIndex: _page,
        ));
  }
}
