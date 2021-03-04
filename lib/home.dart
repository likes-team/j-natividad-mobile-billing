import 'package:flutter/material.dart';
import 'package:jnb_mobile/modules/offline_manager/services/failed_deliveries.dart';
import 'utilities/colors.dart' show MyColors;
import 'modules/home/components/app_bar.dart' show AppBarComponent;
import 'modules/home/components/drawer.dart' show DrawerComponent;
import 'modules/deliveries/pages/deliveries_page.dart' show DeliveriesPage;
import 'modules/location_updater/pages/location_updater.dart'
    show LocationUpdaterPage;
import 'modules/dashboard/pages/dashboard.dart' show DashboardPage;
// import 'modules/profile/pages/profile.dart' show ProfilePage;

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _HomeState();
  }
}

class _HomeState extends State<Home> {
  String _title;
  int _currentPage = 1;

  final failedDeliveriesService = FailedDeliveryService();

  final List<Widget> _pages = [
    DashboardPage(),
    DeliveriesPage(),
    LocationUpdaterPage(),
    // ProfilePage(),
  ];

  @override
  initState() {
    super.initState();

    _title = 'Deliveries';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarComponent(
        title: _title,
      ),
      body: _pages[_currentPage],
      drawer: DrawerComponent(),
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped,
        currentIndex: _currentPage,
        selectedItemColor: MyColors.home,
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
            icon: Icon(Icons.motorcycle),
            label: 'Deliveries',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.edit_location),
            label: 'Location Updater',
          ),
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.person),
          //   label: 'Profile',
          // ),
        ],
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
            _title = "Deliveries";
          }
          break;
        case 2:
          {
            _title = "Location Updater";
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
