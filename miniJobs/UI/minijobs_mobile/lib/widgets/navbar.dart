import 'package:flutter/material.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:get_storage/get_storage.dart';
import 'package:minijobs_mobile/pages/home_page.dart';
import 'package:minijobs_mobile/pages/job_list.dart';
import 'package:minijobs_mobile/pages/job_step1.dart';
import 'package:minijobs_mobile/pages/job_step2.dart';
import 'package:minijobs_mobile/pages/job_step3.dart';
import 'package:minijobs_mobile/pages/profile.dart';

class Navbar extends StatefulWidget {
  @override
  _NavbarState createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  int _bottomNavIndex = 0;
  int _jobStep = 0;
  IconData _fabIcon = Icons.home; // Default FAB icon
  List<Widget> _pages = [];
  @override
  void initState() {
    super.initState();
    _initRole();
    _initPages();
  }

  _initRole() async {
    String role = GetStorage().read('role') ?? '';
    setState(() {
      _bottomNavIndex = 1;
    });
  }

  _initPages() {
    String role = GetStorage().read('role') ?? '';
    _pages = [
      HomePage(),
      JobStep1Page(onNextPressed: () {
        setState(() {
          _jobStep = 1; // Index of the next form page
        });
      }),
      JobList(),
      ProfilePage(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _bottomNavIndex,
        children: _buildPages(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(_fabIcon),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: AnimatedBottomNavigationBar(
        icons: _getIconsForRole(),
        activeIndex: _bottomNavIndex,
        gapLocation: GapLocation.center,
        backgroundColor: Colors.blue[100],
        inactiveColor: Colors.blue[400],
        activeColor: Colors.blue[400],
        notchSmoothness: NotchSmoothness.verySmoothEdge,
        leftCornerRadius: 32,
        rightCornerRadius: 32,
        onTap: (index) {
          setState(() {
            _bottomNavIndex = index;
            _fabIcon = _getFabIcon(index);
          });
        },
      ),
    );
  }

  // Method to get the FAB icon based on the selected index
  IconData _getFabIcon(int index) {
    switch (index) {
      case 0:
        return Icons.home;
      case 1:
        return Icons.add;
      case 2:
        return Icons.view_list;
      case 3:
        return Icons.person;
      default:
        return Icons.home;
    }
  }

  // Method to get the icons based on the role
  List<IconData> _getIconsForRole() {
    String role = '';
    if (role == 'Applicant') {
      return [
        Icons.home,
        Icons.bookmark,
        Icons.view_list,
        Icons.person,
      ];
    } else {
      return [
        Icons.home,
        Icons.add,
        Icons.view_list,
        Icons.person,
      ];
    }
  }

  // Method to dynamically build pages based on the role
  List<Widget> _buildPages() {
    String role = GetStorage().read('role') ?? '';
    List<Widget> pages = [];
    if (role == 'Applicant') {
      pages.add(HomePage());
      pages.add(_buildPage("Saved Jobs"));
      pages.add(_buildPage("View List Page"));
      pages.add(_buildPage("User Page"));
    } else {
      pages.add(HomePage());
      pages.add(JobStep1Page(
        onNextPressed: () {
          setState(() {
            _bottomNavIndex = 2;
          });
        },
      ));
      pages.add(JobStep2Page(
        onNextPressed: () {
          setState(() {
            _bottomNavIndex = 3;
          });
        },
      ));
      pages.add(JobStep3Page(
        // onNextPressed: () {
        //   setState(() {
        //     _bottomNavIndex = 4;
        //   });
        // },
      ));
      pages.add(JobList());
      pages.add(ProfilePage());
    }
    return pages;
  }

  Widget _buildPage(String title) {
    return Center(
      child: Text(title),
    );
  }
}
