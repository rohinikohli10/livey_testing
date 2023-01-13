import 'package:flutter/material.dart';
import 'package:livey_testing/screens/create/create_screen.dart';
import 'package:livey_testing/screens/hangout/hangout_screen.dart';
import 'package:livey_testing/screens/home/home_screen.dart';
import 'package:livey_testing/screens/profile/profile_screen.dart';
import 'package:livey_testing/utils/colors.dart';

class BottomNavScreen extends StatefulWidget {
  const BottomNavScreen({super.key});

  @override
  State<BottomNavScreen> createState() => _BottomNavScreenState();
}

class _BottomNavScreenState extends State<BottomNavScreen> {
  final _pageController = PageController();
  int _selectedIndex = 0;

  void _onSelected(int index) {
    setState(() {
      _selectedIndex = index;
      _pageController.jumpToPage(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
          extendBody: true,
          body: PageView(
            controller: _pageController,
            onPageChanged: onPageChange,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              HomeScreen(),
              CreateScreen(),
              HangoutScreen(),
              ProfileScreen(),
            ],
          ),
          bottomNavigationBar: BottomNavigationBar(
            backgroundColor: ProjectColors.black,
            onTap: _onSelected,
            type: BottomNavigationBarType.fixed,
            selectedFontSize: 0,
            unselectedFontSize: 0,
            elevation: 8,
            selectedItemColor: Theme.of(context).primaryColor,
            items: [
              _bottomItem(
                'Home',
                'assets/images/home.png',
                'assets/images/home.png',
              ),
              _bottomItem(
                'Search',
                'assets/images/create.png',
                'assets/images/create.png',
              ),
              _bottomItem(
                'Plan',
                'assets/images/hangout.png',
                'assets/images/hangout.png',
              ),
              _bottomItem(
                'Account',
                'assets/images/profile.png',
                'assets/images/profile.png',
              ),
            ],
            currentIndex: _selectedIndex,
          )),
    );
  }

  _bottomItem(String title, String icon, String activeIcon) {
    return BottomNavigationBarItem(
      activeIcon: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 3,
            width: 30,
            color: ProjectColors.yellow,
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(activeIcon),
                      fit: BoxFit.fill,
                      colorFilter: ColorFilter.mode(
                          ProjectColors.yellow, BlendMode.color),
                    ),
                  ),
                ),
                Text(title,
                    style: TextStyle(
                        color: ProjectColors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w400)),
              ],
            ),
          ),
        ],
      ),
      icon: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(icon),
                  fit: BoxFit.fill,
                  colorFilter: ColorFilter.mode(Colors.grey, BlendMode.color),
                ),
              ),
            ),
            Text(title,
                style: TextStyle(
                    color: ProjectColors.grey,
                    fontSize: 12,
                    fontWeight: FontWeight.w400)),
          ],
        ),
      ),
      label: '',
    );
  }

  void onPageChange(int index) {}
}
