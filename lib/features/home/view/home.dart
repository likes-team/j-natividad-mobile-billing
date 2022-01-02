import 'package:flutter/material.dart';
import 'package:jnb_mobile/features/delivery_map/view/map.dart';
import 'package:jnb_mobile/features/profile/view/profile.dart';
import '../../../utilities/colors.dart' show AppColors;
import 'components/app_bar.dart' show AppBarComponent;
import 'components/drawer.dart' show DrawerComponent;
import '../../delivery/view/deliveries_page.dart' show DeliveriesPage;

import '../../dashboard/view/dashboard.dart' show DashboardPage;
// import 'modules/profile/pages/profile.dart' show ProfilePage;

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<Home> {
  String _title;
  int _currentPage = 2;


  final List<Widget> _pages = [
    DashboardPage(),
    MapPage(),
    DeliveriesPage(),
    ProfilePage(),
  ];

  @override
  initState() {
    super.initState();

    _title = 'Deliveries';
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBarComponent(
          title: _title,
        ),
        body: _pages[_currentPage],
        drawer: DrawerComponent(),
        bottomNavigationBar: BottomNavigationBar(
          onTap: onTabTapped,
          currentIndex: _currentPage,
          selectedItemColor: AppColors.home,
          unselectedItemColor: Colors.grey[500],
          showUnselectedLabels: true,
          items: [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.dashboard,
              ),
              label: 'Dashboard',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.map),
              label: 'Map',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.motorcycle),
              label: 'Deliveries',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }

  void onTabTapped(int index) {
    setState(() {
      _currentPage = index;
      switch (index) {
        case 0:
          {
            _title = "Dashboard";
          }
          break;
        case 1:
          {
            _title = "Map";
          }
          break;
        case 2:
          {
            _title = "Deliveries";
          }
          break;
        case 3:
          {
            _title = "Profile";
          }
          break;
      }
    });
  }
}
