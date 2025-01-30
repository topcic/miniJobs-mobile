import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


import '../../../applicants/applicants_view.dart';
import '../../../employers/employers_view.dart';
import '../../../jobs/jobs_view.dart';
import '../../constants.dart';
import '../dashboard/dashboard_screen.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  Widget _selectedScreen = DashboardScreen(); // Default screen

  void _setSelectedScreen(Widget screen) {
    setState(() {
      _selectedScreen = screen; // Update selected screen
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SideMenu(onMenuItemSelected: _setSelectedScreen),
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: SideMenu(onMenuItemSelected: _setSelectedScreen)),
            Expanded(
              flex: 5,
              child: Padding(
                padding: const EdgeInsets.all(defaultPadding), // Apply default padding
                child: _selectedScreen,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SideMenu extends StatelessWidget {
  final Function(Widget) onMenuItemSelected; // Function callback to update screen

  const SideMenu({Key? key, required this.onMenuItemSelected}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            child: Image.asset("assets/images/logo.png"),
          ),
          DrawerListTile(
            title: "Dashboard",
            icon: FontAwesomeIcons.tachometerAlt,
            press: () => onMenuItemSelected(DashboardScreen()),
          ),
          DrawerListTile(
            title: "Poslodavci",
            icon: FontAwesomeIcons.building,
            press: () => onMenuItemSelected(const EmployersView()),
          ),
          DrawerListTile(
            title: "Aplikanti",
            icon: FontAwesomeIcons.users,
            press: () => onMenuItemSelected(const ApplicantsView()),
          ),
          DrawerListTile(
            title: "Poslovi",
            icon: FontAwesomeIcons.briefcase,
            press: () => onMenuItemSelected(JobsView()),
          ),
        ],
      ),
    );
  }
}

class DrawerListTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback press;

  const DrawerListTile({
    Key? key,
    required this.title,
    required this.icon,
    required this.press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: press,
      horizontalTitleGap: 0.0,
      leading: FaIcon(icon, color: Colors.white54, size: 16),
      title: Text(title, style: TextStyle(color: Colors.white54)),
    );
  }
}
