import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/employer/employer.dart';
import '../../providers/employer_provider.dart';
import '../../providers/user_provider.dart';
import '../../utils/photo_view.dart';

class EmployerDetailsPage extends StatefulWidget {
  final Employer employer;

  const EmployerDetailsPage({Key? key, required this.employer}) : super(key: key);

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
    final employer = widget.employer;
    final displayName = employer.name ?? '${employer.firstName ?? ''} ${employer.lastName ?? ''}'.trim();
    return Scaffold(
      appBar: AppBar(
        title: Text(displayName),
        centerTitle: true,
      ),
      body: Padding(
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
                          content: 'Da li ste sigurni da želite aktivirati ${employer.name ?? employer.firstName}?',
                          onConfirm: activateUser,
                        );
                      } else {
                        _showConfirmationDialog(
                          context: context,
                          title: 'Blokiraj',
                          content: 'Da li ste sigurni da želite blokirati ${employer.name ?? employer.firstName}?',
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
}
