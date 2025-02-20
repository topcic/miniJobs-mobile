import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:minijobs_admin/pages/applicants/applicants_view.dart';
import 'package:minijobs_admin/pages/home_page.dart';
import 'package:minijobs_admin/pages/users.dart';

import '../pages/employers/employers_view.dart';
import '../pages/jobs/jobs_view.dart';

class MasterScreenWidget extends StatefulWidget {
  final String title;

  const MasterScreenWidget({required this.title, super.key});

  @override
  State<MasterScreenWidget> createState() => _MasterScreenWidgetState();
}

class _MasterScreenWidgetState extends State<MasterScreenWidget> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const HomePage(),
    const UsersPage(),
    const ApplicantsView(), // Replace with Applicants Stranica
    const EmployersView(), // Replace with Employers Stranica
    const JobsView(), // Replace with Jobs Stranica
  ];

  final List<String> _titles = [
    'Kontrolna ploča',
    'Korisnici',
    'Aplikanti',
    'Poslodavci',
    'Poslovi',
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_selectedIndex]),
      ),
      body: Row(
        children: [
          // Sidebar
          NavigationRail(
            selectedIndex: _selectedIndex,
            onDestinationSelected: _onItemTapped,
            labelType: NavigationRailLabelType.all,
            destinations: const [
              NavigationRailDestination(
                icon: FaIcon(FontAwesomeIcons.home),
                label: Text('Kontrolna ploča'),
              ),
              NavigationRailDestination(
                icon: FaIcon(FontAwesomeIcons.users),
                label: Text('Korisnici'),
              ),
              NavigationRailDestination(
                icon: FaIcon(FontAwesomeIcons.usersCog),
                label: Text('Aplikanti'),
              ),
              NavigationRailDestination(
                icon: FaIcon(FontAwesomeIcons.building),
                label: Text('Poslodavci'),
              ),
              NavigationRailDestination(
                icon: FaIcon(FontAwesomeIcons.suitcase),
                label: Text('Poslovi'),
              ),
            ],
          ),
          // Main Content
          Expanded(
            child: _pages[_selectedIndex],
          ),
        ],
      ),
    );
  }
}
