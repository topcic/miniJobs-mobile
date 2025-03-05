import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:minijobs_admin/pages/countries/countries_view.dart';
import 'package:minijobs_admin/pages/job-applications/job_applications_view.dart';
import 'package:minijobs_admin/pages/jobtypes/job_types_view.dart';
import 'package:minijobs_admin/pages/ratings/rating_view.dart';
import 'package:minijobs_admin/pages/saved_jobs/saved_jobs_view.dart';

import '../../../applicants/applicants_view.dart';
import '../../../cites/cities_view.dart';
import '../../../employers/employers_view.dart';
import '../../../job-recommendations/job-recommendations_view.dart';
import '../../../jobs/jobs_view.dart';
import '../../../reports/job_application_reports_page.dart';
import '../../../reports/job_reports_page.dart';
import '../../../reports/rating_reports_page.dart';
import '../../constants.dart';
import '../dashboard/dashboard_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  Widget _selectedScreen = const DashboardScreen(); // Default screen
  final GlobalKey<ScaffoldState> _scaffoldKey =
      GlobalKey<ScaffoldState>(); // Key to control drawer

  void _setSelectedScreen(Widget screen) {
    setState(() {
      _selectedScreen = screen;
    });

    // Close the drawer if on mobile after selecting a menu item
    if (MediaQuery.of(context).size.width < 850) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isMobile =
        MediaQuery.of(context).size.width < 850; // Define breakpoint for mobile

    return Scaffold(
      key: _scaffoldKey,
      drawer: isMobile ? _buildSideMenu() : null, // Use drawer on mobile
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!isMobile) _buildSideMenu(), // Show Side Menu on larger screens
            Expanded(
              flex: 5,
              child: Column(
                children: [
                  _buildHeader(isMobile),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(defaultPadding),
                      child: _selectedScreen,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Header with menu button for mobile
  Widget _buildHeader(bool isMobile) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
      color: secondaryColor,
      child: Row(
        children: [
          if (isMobile)
            IconButton(
              icon: const Icon(Icons.menu, color: Colors.white),
              onPressed: () {
                _scaffoldKey.currentState
                    ?.openDrawer(); // Open drawer on mobile
              },
            ),
        ],
      ),
    );
  }

  // Sidebar menu (Drawer for mobile, Expanded container for desktop)
  Widget _buildSideMenu() {
    return Container(
      width: 250,
      decoration: const BoxDecoration(color: secondaryColor),
      child: ListView(
        children: [
          DrawerHeader(
            child: Image.asset("assets/images/logo.png"),
          ),
          _buildMenuItem("Dashboard", FontAwesomeIcons.tachometerAlt,
              const DashboardScreen()),
          ExpansionTile(
            leading:
                const Icon(FontAwesomeIcons.cogs , color: Colors.white54),
            title: const Text("Generalne postavke",
                style: TextStyle(color: Colors.white54)),
            children: [
              _buildMenuItem("Države", FontAwesomeIcons.globe,
                  const CountriesView()),
              _buildMenuItem("Gradovi", FontAwesomeIcons.city  ,
                  const CitiesView()),
              _buildMenuItem("Tipovi posla", FontAwesomeIcons.briefcase ,
                  const JobTypesView()),

            ],
          ),
          _buildMenuItem(
              "Poslodavci", FontAwesomeIcons.building, const EmployersView()),
          _buildMenuItem(
              "Aplikanti", FontAwesomeIcons.users, const ApplicantsView()),
          _buildMenuItem(
              "Poslovi", FontAwesomeIcons.briefcase, const JobsView()),
          _buildMenuItem("Aplikacije", FontAwesomeIcons.fileAlt,
              const JobApplicationsView()),
          _buildMenuItem("Ocjene", FontAwesomeIcons.star, const RatingsView()),
          _buildMenuItem("Preporuke", FontAwesomeIcons.thumbsUp,
              const JobRecommendationsView()),
          _buildMenuItem("Spašeni poslovi", FontAwesomeIcons.bookmark,
              const SavedJobsView()),
          ExpansionTile(
            leading:
                const Icon(FontAwesomeIcons.chartBar, color: Colors.white54),
            title: const Text("Izvještaji",
                style: TextStyle(color: Colors.white54)),
            children: [
              _buildMenuItem("Izvještaj o ocjenama", FontAwesomeIcons.star,
                  const RatingReportsPage()),
              _buildMenuItem("Izvještaj o aplikacijama",
                  FontAwesomeIcons.fileAlt, const JobApplicationReportsPage()),
              _buildMenuItem("Izvještaj o poslovima", FontAwesomeIcons.suitcase,
                  const JobReportsPage()),
            ],
          ),
        ],
      ),
    );
  }

  // Helper method to build menu items
  Widget _buildMenuItem(String title, IconData icon, Widget screen) {
    return ListTile(
      onTap: () => _setSelectedScreen(screen),
      leading: FaIcon(icon, color: Colors.white54, size: 16),
      title: Text(title, style: const TextStyle(color: Colors.white54)),
    );
  }
}
