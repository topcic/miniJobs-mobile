import 'package:flutter/material.dart';
import 'package:minijobs_mobile/models/applicant/applicant.dart';
import 'package:minijobs_mobile/providers/applicant_provider.dart';
import 'package:provider/provider.dart';
import 'applicant_additinal_info.dart';
import 'applicant_basic_info.dart';
import '../../utils/photo_view.dart'; // Make sure the PhotoView widget is available

class ApplicantInfo extends StatefulWidget {
  final int applicantId;
  final VoidCallback onBack;
  const ApplicantInfo({super.key, required this.applicantId, required this.onBack});

  @override
  State<ApplicantInfo> createState() => _ApplicantInfoState();
}

class _ApplicantInfoState extends State<ApplicantInfo> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  Applicant? applicant;
  late ApplicantProvider applicantProvider;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    applicantProvider = context.read<ApplicantProvider>();
    getApplicant();
  }

  Future<void> getApplicant() async {
    applicant = await applicantProvider.get(widget.applicantId);
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Korisničke informacije'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            widget.onBack(); // Call the callback when back button is pressed
            Navigator.pop(context, true); // Pass 'true' to indicate data should be fetched
          },
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          PhotoView(
            photo: applicant!.photo,
            editable: true,
            userId: applicant!.id!,
          ),
          TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: 'Osnovne Informacije'),
              Tab(text: 'Dodatne Informacije'),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                ApplicantBasicInfo(applicantId: widget.applicantId),
                ApplicantAdditionalInfo(applicantId: widget.applicantId),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
