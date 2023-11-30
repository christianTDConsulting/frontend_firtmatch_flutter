import 'package:fit_match/models/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fit_match/utils/colors.dart';

class mobileLayout extends StatefulWidget {
  final User user;
  const mobileLayout({
    Key? key,
    required this.user,
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
    pageController = PageController();
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
    //Animating Page
    pageController.jumpToPage(page);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(),
      bottomNavigationBar: CupertinoTabBar(
        backgroundColor: mobileBackgroundColor,
        items: <BottomNavigationBarItem>[
          //HOME
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              color: (_page == 0) ? primaryColor : secondaryColor,
            ),
            label: '',
            backgroundColor: primaryColor,
          ),
          //SEARCH
          BottomNavigationBarItem(
              icon: Icon(
                Icons.search,
                color: (_page == 1) ? primaryColor : secondaryColor,
              ),
              label: '',
              backgroundColor: primaryColor),
          //MESSAGE
          BottomNavigationBarItem(
              icon: Icon(
                Icons.chat,
                color: (_page == 2) ? primaryColor : secondaryColor,
              ),
              label: '',
              backgroundColor: primaryColor),
          //NOTIFICATIONS
          BottomNavigationBarItem(
            icon: Icon(
              Icons.favorite,
              color: (_page == 3) ? primaryColor : secondaryColor,
            ),
            label: '',
            backgroundColor: primaryColor,
          ),

          //SAVED
          BottomNavigationBarItem(
            icon: Icon(
              Icons.bookmark,
              color: (_page == 4) ? primaryColor : secondaryColor,
            ),
            label: '',
            backgroundColor: primaryColor,
          ),
          //TRAININGS

          BottomNavigationBarItem(
            icon: Icon(
              Icons.fitness_center,
            ),
            label: '',
            backgroundColor: primaryColor,
          ),

          //PROFILE
          BottomNavigationBarItem(
            icon: Image.network(
                widget.user.profile_picture), // 'icon' is used for the image
            label: '',
            backgroundColor: primaryColor,
          ),
        ],
        onTap: navigationTapped,
        currentIndex: _page,
      ),
    );
  }
}
