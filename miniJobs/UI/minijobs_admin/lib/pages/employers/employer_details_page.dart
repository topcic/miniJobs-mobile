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
  final Employer employer;

  const EmployerDetailsPage({super.key, required this.employer});

  @override
  State<EmployerDetailsPage> createState() => _EmployerDetailsPageState();
}

class _EmployerDetailsPageState extends State<EmployerDetailsPage> {
  late EmployerProvider _employerProvider;
  late UserProvider _userProvider;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _employerProvider = context.read<EmployerProvider>();
    _userProvider = context.read<UserProvider>();
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    // Add logic to fetch user-specific data if required
  }

  Future<void> blockUser() async {
    await _userProvider.delete(widget.employer.id!);
    setState(() {
      widget.employer.deleted = true;
    });
  }

  Future<void> activateUser() async {
    await _userProvider.activate(widget.employer.id!);
    setState(() {
      widget.employer.deleted = false;
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
        title: const Text('Employer Details'),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isSmallScreen = constraints.maxWidth < 800; // Small screen check
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
                Expanded(flex: 1, child: _buildEmployerDetailsCard(context)),
                const SizedBox(width: 16),
                Expanded(flex: 2, child: _buildAdditionalDetailsCard()),
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
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: CircleAvatar(
                  radius: 50,
                  child: ClipOval(
                    child: PhotoView(
                      photo: widget.employer.photo,
                      editable: false,
                      userId: widget.employer.id!,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              if (widget.employer.name != null) ...[
                _detailRow('Naziv firme:', widget.employer.name!),
                _detailRow('Adresa:', widget.employer.streetAddressAndNumber ?? '-'),
                _detailRow('ID broj:', widget.employer.idNumber ?? '-'),
                _detailRow('Kontakt telefon:', widget.employer.companyPhoneNumber ?? '-'),
                const Divider(height: 24),
                _detailRow('Zadužena osoba:', '${widget.employer.firstName} ${widget.employer.lastName}'),
                _detailRow('Email:', widget.employer.email ?? '-'),
                _detailRow('Broj telefona:', widget.employer.phoneNumber ?? '-'),
              ] else ...[
                _detailRow('Ime i prezime:', '${widget.employer.firstName} ${widget.employer.lastName}'),
                _detailRow('Email:', widget.employer.email ?? '-'),
                _detailRow('Broj telefona:', widget.employer.phoneNumber ?? '-'),
              ],
              const Divider(height: 24),
              _detailRow('Grad:', widget.employer.city?.name ?? '-'),
              _detailRow('Račun potvrđen:', widget.employer.accountConfirmed == true ? 'Da' : 'Ne'),
              _detailRow('Prosječna ocjena:', widget.employer.averageRating?.toString() ?? '-'),
              const SizedBox(height: 24),
              Center(
                child: ElevatedButton.icon(
                  onPressed: () {
                    if (widget.employer.deleted!) {
                      _showConfirmationDialog(
                        context: context,
                        title: 'Aktiviraj',
                        content: 'Da li ste sigurni da želite aktivirati ${widget.employer.name ?? widget.employer.firstName}?',
                        onConfirm: activateUser,
                      );
                    } else {
                      _showConfirmationDialog(
                        context: context,
                        title: 'Blokiraj',
                        content: 'Da li ste sigurni da želite blokirati ${widget.employer.name ?? widget.employer.firstName}?',
                        onConfirm: blockUser,
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: widget.employer.deleted!
                        ? Colors.greenAccent[700]
                        : Colors.redAccent[700],
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                  icon: Icon(
                    widget.employer.deleted! ? Icons.refresh : Icons.block,
                    color: Colors.white,
                  ),
                  label: Text(
                    widget.employer.deleted! ? 'Aktiviraj korisnika' : 'Blokiraj korisnika',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
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
                height: MediaQuery.of(context).size.height * 0.4, // Adjust height based on screen size
                child: TabBarView(
                  children: [
                    // Aktivni poslovi tab
                    ActiveJobsView(userId: widget.employer.id!),
                    // Završeni poslovi tab
                    FinishedJobsView(userId: widget.employer.id!),
                    // Utisci tab
                    UserRatingsView(userId: widget.employer.id!),
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

