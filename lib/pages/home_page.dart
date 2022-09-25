import 'package:flutter/material.dart';
import 'package:jnb_mobile/drawer.dart';
import 'package:jnb_mobile/global_variables.dart';
import 'package:jnb_mobile/pages/deliveries_page.dart';
import 'package:jnb_mobile/pages/login_page.dart';
import 'package:jnb_mobile/pages/map_page.dart';
import 'package:jnb_mobile/utilities/color_utility.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 1;
  bool _isLoading = false;

  final _pageController = PageController(initialPage: 1);

  void onTabTapped(int index) {
    setState(() {
      switch (index) {
        case 0:
          globalAppBarTitle.value = 'Map';
          break;
        case 1:
          globalAppBarTitle.value = 'Deliveries';
          break;
        default:
      }
      _currentIndex = index;
      _pageController.animateToPage(index,
          duration: const Duration(milliseconds: 1000), curve: Curves.easeInOut);
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          title: Text(globalAppBarTitle.value),
          centerTitle: true,
          backgroundColor: AppColors.primary,
        ),
        drawer: const DrawerComponent(),
        body: PageView(
          scrollDirection: Axis.horizontal,
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            MapPage(),
            DeliveriesPage(),
          ],
        ), // new
        bottomNavigationBar: BottomNavigationBar(
          iconSize: 15,
          selectedFontSize: 12,
          unselectedFontSize: 11,
          type: BottomNavigationBarType.fixed,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Map'),
            BottomNavigationBarItem(icon: Icon(Icons.motorcycle), label: 'Deliveries'),
          ],
          currentIndex: _currentIndex,
          fixedColor: Colors.deepPurple,
          onTap: onTabTapped,
        ),
      ),
    );
  }
}
