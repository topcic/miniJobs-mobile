import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:minijobs_mobile/pages/signup.page.dart';
import 'package:minijobs_mobile/pages/company_employer_signup.page.dart';
import 'package:minijobs_mobile/pages/login_page.dart';

import '../enumerations/role.dart';

class LoginSignupPage extends StatefulWidget {
  const LoginSignupPage({Key? key}) : super(key: key);

  @override
  _LoginSignupPageState createState() => _LoginSignupPageState();
}

class _LoginSignupPageState extends State<LoginSignupPage> {
  int _selectedIndex = -1;
  void switchTabView(String option) {
    if (option == 'Applicant') {
      setState(() {
        _selectedIndex = 0; // Switch to the first tab
      });
    } else if (option == 'Individual') {
      setState(() {
        _selectedIndex = 1; // Switch to the second tab
      });
    }
    else{
      setState(() {
        _selectedIndex = 2;
      });
    }
  }
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Text('Prijava i registracija'),
            bottom: TabBar(
              tabs: [
                Tab(text: 'Prijava'),
                Tab(text: 'Registracija'),
              ],
              onTap: (index) {
                setState(() {
                  _selectedIndex = -1; // Reset the selected index when Registracija tab is clicked
                });
              },
            ),
          ),
          body: TabBarView(
            children: [
              LoginPage(),
              _selectedIndex==-1? SignupMenu(onOptionSelected: switchTabView)
                  :_selectedIndex==0?SignupPage(role:Role.Applicant)
                  :_selectedIndex==1?SignupPage(role:Role.Employer):CompanyEmployerSignupPage(),
            ],
          ),
        ),
      ),
    );
  }
}
class SignupMenu extends StatefulWidget {
  final Function(String) onOptionSelected; // Define callback function

  const SignupMenu({Key? key, required this.onOptionSelected}) : super(key: key);

  @override
  _SignupMenuState createState() => _SignupMenuState();
}

class _SignupMenuState extends State<SignupMenu> {
  String _selectedType = ''; // Default selected type

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Želite se registrovati kao?',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Column(
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _selectedType = 'Applicant';
                    });
                    widget.onOptionSelected('Applicant'); // Trigger callback
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 40),
                  ),
                  child: const Text(
                    'Aplikant',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _selectedType = 'Employer';
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 40),
                  ),
                  child: const Text(
                    'Poslodavac',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
            if (_selectedType == 'Employer') ...[
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        widget.onOptionSelected('Individual');
                      },
                      style: ElevatedButton.styleFrom(
                        padding:
                        EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                      ),
                      child: const Text(
                        'Kao fizičko lice',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        widget.onOptionSelected('Company');
                      },
                      style: ElevatedButton.styleFrom(
                        padding:
                        EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                      ),
                      child: const Text(
                        'Kao kompanija',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

}