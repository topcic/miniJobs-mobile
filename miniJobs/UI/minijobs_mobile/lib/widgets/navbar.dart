// File path: lib/navbar.dart

import 'package:flutter/material.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:get_storage/get_storage.dart';
import 'package:minijobs_mobile/pages/employeer/employeer_home_page.dart';
import 'package:minijobs_mobile/pages/employeer/employer_profile_page.dart';
import 'package:minijobs_mobile/pages/employeer/job/job_details.dart';
import 'package:minijobs_mobile/pages/home_page.dart';
import 'package:minijobs_mobile/pages/employeer/job_list.dart';
import 'package:minijobs_mobile/pages/profile.dart';

class Navbar extends StatefulWidget {
  const Navbar({super.key});

  @override
  _NavbarState createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  int _bottomNavIndex = 0;
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    _initRole();
  }

  _initRole() async {
    String role = GetStorage().read('role') ?? '';
    setState(() {
      _bottomNavIndex = 0;
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _bottomNavIndex = index;
          });
        },
        children: _buildPages(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(_getFabIcon(_bottomNavIndex)),
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
          });
          _pageController.jumpToPage(index);
        },
      ),
    );
  }

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

  List<IconData> _getIconsForRole() {
    String role = GetStorage().read('role') ?? '';
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

  List<Widget> _buildPages() {
    String role = GetStorage().read('role') ?? '';
    if (role == 'Applicant') {
      return [
        const HomePage(),
        _buildPage("Saved Jobs"),
        _buildPage("View List Page"),
        _buildPage("User Page"),
      ];
    } else {
      return [
        const EmployerHomePage(),
        const JobDetails(jobId: 0),
        const JobList(),
        const EmployerProfilePage(),
      ];
    }
  }

  Widget _buildPage(String title) {
    return Center(
      child: Text(title),
    );
  }
}
