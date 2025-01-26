import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:minijobs_admin/pages/applicants/applicants_view.dart';
import 'package:minijobs_admin/pages/home_page.dart';
import 'package:minijobs_admin/pages/users.dart';

import '../pages/employers/employers_view.dart';

class MasterScreenWidget extends StatefulWidget {
  final String title;

  const MasterScreenWidget({required this.title, Key? key}) : super(key: key);

  @override
  State<MasterScreenWidget> createState() => _MasterScreenWidgetState();
}

class _MasterScreenWidgetState extends State<MasterScreenWidget> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const HomePage(),
    const UsersPage(),
    const ApplicantsView(), // Replace with Applicants Page
    const EmployersView(), // Replace with Employers Page
    const UsersPage(), // Replace with Jobs Page
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
            destinations: [
              NavigationRailDestination(
                icon: const FaIcon(FontAwesomeIcons.home),
                label: const Text('Kontrolna ploča'),
              ),
              NavigationRailDestination(
                icon: const FaIcon(FontAwesomeIcons.users),
                label: const Text('Korisnici'),
              ),
              NavigationRailDestination(
                icon: const FaIcon(FontAwesomeIcons.usersCog),
                label: const Text('Aplikanti'),
              ),
              NavigationRailDestination(
                icon: const FaIcon(FontAwesomeIcons.building),
                label: const Text('Poslodavci'),
              ),
              NavigationRailDestination(
                icon: const FaIcon(FontAwesomeIcons.suitcase),
                label: const Text('Poslovi'),
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
