import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/employer/employer.dart';
import '../../providers/employer_provider.dart';
import '../../providers/user_provider.dart';
import '../../utils/photo_view.dart';
import '../user-profile/active_jobs_view.dart';
import '../user-profile/finished_job_view.dart';
import '../user-profile/user_ratings_view.dart';

class EmployerDetailsPage extends StatefulWidget {
  final int id;

  const EmployerDetailsPage({super.key, required this.id});

  @override
  State<EmployerDetailsPage> createState() => _EmployerDetailsPageState();
}

class _EmployerDetailsPageState extends State<EmployerDetailsPage> {
  late EmployerProvider _employerProvider;
  late UserProvider _userProvider;
  late Employer employer;
  bool isLoading = true;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _employerProvider = context.read<EmployerProvider>();
    _userProvider = context.read<UserProvider>();
    fetchUser();
  }

  Future<void> fetchUser() async {
    try {
      final fetchedEmployer = await _employerProvider.get(widget.id);
      setState(() {
        employer = fetchedEmployer;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> blockUser() async {
    await _userProvider.delete(employer.id!);
    setState(() {
      employer.deleted = true;
    });
  }

  Future<void> activateUser() async {
    await _userProvider.activate(employer.id!);
    setState(() {
      employer.deleted = false;
    });
  }

  void _showConfirmationDialog({
    required BuildContext context,
    required String title,
    required String content,
    required VoidCallback onConfirm,
  }) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            child: const Text('Odustani'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          TextButton(
            child: const Text('Potvrdi'),
            onPressed: () {
              onConfirm();
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalji poslodavca'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : LayoutBuilder(
        builder: (context, constraints) {
          final isSmallScreen = constraints.maxWidth < 800;
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: isSmallScreen
                ? ListView(
              children: [
                _buildEmployerDetailsCard(context),
                const SizedBox(height: 16),
                _buildAdditionalDetailsCard(),
              ],
            )
                : Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 1,
                  child: LayoutBuilder(
                    builder: (context, leftConstraints) {
                      final leftHeight = leftConstraints.maxHeight;
                      return SizedBox(
                        height: leftHeight > 0 ? leftHeight : null,
                        child: _buildEmployerDetailsCard(context),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 2,
                  child: LayoutBuilder(
                    builder: (context, rightConstraints) {
                      final rightHeight = rightConstraints.maxHeight;
                      return SizedBox(
                        height: rightHeight > 0 ? rightHeight : null,
                        child: _buildAdditionalDetailsCard(),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmployerDetailsCard(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 300), // Minimum height
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: CircleAvatar(
                      radius: 50,
                      child: ClipOval(
                        child: PhotoView(
                          photo: employer.photo,
                          editable: false,
                          userId: employer.id!,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (employer.name != null) ...[
                    _detailRow('Naziv firme:', employer.name!),
                    _detailRow('Adresa:', employer.streetAddressAndNumber ?? '-'),
                    _detailRow('ID broj:', employer.idNumber ?? '-'),
                    _detailRow('Kontakt telefon:', employer.companyPhoneNumber ?? '-'),
                    const Divider(height: 24),
                    _detailRow('Zadužena osoba:', '${employer.firstName} ${employer.lastName}'),
                    _detailRow('Email:', employer.email ?? '-'),
                    _detailRow('Broj telefona:', employer.phoneNumber ?? '-'),
                  ] else ...[
                    _detailRow('Ime i prezime:', '${employer.firstName} ${employer.lastName}'),
                    _detailRow('Email:', employer.email ?? '-'),
                    _detailRow('Broj telefona:', employer.phoneNumber ?? '-'),
                  ],
                  const Divider(height: 24),
                  _detailRow('Grad:', employer.city?.name ?? '-'),
                  _detailRow('Račun potvrđen:', employer.accountConfirmed == true ? 'Da' : 'Ne'),
                  _detailRow('Prosječna ocjena:', employer.averageRating?.toString() ?? '-'),
                  const SizedBox(height: 24),
                  Center(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        if (employer.deleted!) {
                          _showConfirmationDialog(
                            context: context,
                            title: 'Aktiviraj',
                            content:
                            'Da li ste sigurni da želite aktivirati ${employer.name ?? employer.firstName}?',
                            onConfirm: activateUser,
                          );
                        } else {
                          _showConfirmationDialog(
                            context: context,
                            title: 'Blokiraj',
                            content:
                            'Da li ste sigurni da želite blokirati ${employer.name ?? employer.firstName}?',
                            onConfirm: blockUser,
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: employer.deleted!
                            ? Colors.greenAccent[700]
                            : Colors.redAccent[700],
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      ),
                      icon: Icon(
                        employer.deleted! ? Icons.refresh : Icons.block,
                        color: Colors.white,
                      ),
                      label: Text(
                        employer.deleted! ? 'Aktiviraj korisnika' : 'Blokiraj korisnika',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }


  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(color: Colors.grey),
              softWrap: true,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAdditionalDetailsCard() {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: DefaultTabController(
          length: 3, // 3 tabs
          child: Column(
            children: [
              const TabBar(
                tabs: [
                  Tab(text: 'Aktivni'),
                  Tab(text: 'Završeni'),
                  Tab(text: 'Utisci'),
                ],
              ),
              // SizedBox for responsiveness, adjusting the TabBarView's height
              SizedBox(
                height:600, // Adjust height based on screen size
                child: TabBarView(
                  children: [
                    // Aktivni poslovi tab
                    ActiveJobsView(userId: employer.id!),
                    // Završeni poslovi tab
                    FinishedJobsView(userId: employer.id!),
                    // Utisci tab
                    UserRatingsView(userId: employer.id!),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
