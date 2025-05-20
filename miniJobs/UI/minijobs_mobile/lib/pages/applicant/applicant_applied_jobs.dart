import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../enumerations/job_application_status.dart';
import '../../providers/applicant_provider.dart';
import '../../widgets/badges.dart';
import '../employer/job/job_application_card.dart';
import 'package:intl/intl.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:minijobs_mobile/models/job/job_application.dart';

class ApplicantAppliedJobsView extends StatefulWidget {
  const ApplicantAppliedJobsView({super.key});

  @override
  _ApplicantAppliedJobsViewState createState() =>
      _ApplicantAppliedJobsViewState();
}

class _ApplicantAppliedJobsViewState extends State<ApplicantAppliedJobsView> {
  Set<JobApplicationStatus> _selectedStatuses = {};
  DateTimeRange? _selectedDateRange;
  List<JobApplication>? _filteredJobs;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchAppliedJobs();
  }

  Future<void> _fetchAppliedJobs() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final applicantProvider = context.read<ApplicantProvider>();
      await applicantProvider.getAppliedJobs();
      setState(() {
        _filteredJobs = _filterJobs(applicantProvider.appliedJobs);
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  void _updateFilteredJobs(List<JobApplication>? jobs) {
    setState(() {
      _filteredJobs = _filterJobs(jobs);
    });
  }

  List<JobApplication> _filterJobs(List<JobApplication>? jobs) {
    if (jobs == null) return [];

    var filtered = List<JobApplication>.from(jobs);

    if (_selectedStatuses.isNotEmpty) {
      filtered = filtered
          .where((job) => _selectedStatuses.contains(job.status))
          .toList();
    }

    if (_selectedDateRange != null) {
      filtered = filtered.where((job) {
        final created = job.created;
        return created != null &&
            created.isAfter(_selectedDateRange!.start) &&
            created.isBefore(
                _selectedDateRange!.end.add(const Duration(days: 1)));
      }).toList();
    }

    return filtered;
  }

  Future<void> _selectDateRange(BuildContext context) async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      initialDateRange: _selectedDateRange,
      locale: const Locale('bs', 'BA'),
      helpText: 'Odaberi raspon datuma',
      cancelText: 'Otkaži',
      confirmText: 'Potvrdi',
      fieldStartLabelText: 'Početni datum',
      fieldEndLabelText: 'Krajnji datum',
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.blueAccent,
              onPrimary: Colors.white,
              surface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedDateRange = picked;
        _updateFilteredJobs(context.read<ApplicantProvider>().appliedJobs);
      });
    }
  }

  void _showStatusFilterDialog() {
    showDialog(
      context: context,
      builder: (context) {
        Set<JobApplicationStatus> tempSelectedStatuses =
        Set.from(_selectedStatuses);

        return StatefulBuilder(builder: (context, setDialogState) {
          return AlertDialog(
            title: const Text('Filtriraj po statusu'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: JobApplicationStatus.values.map((status) {
                  return CheckboxListTile(
                    title: JobApplicationBadge(status: status),
                    value: tempSelectedStatuses.contains(status),
                    onChanged: (bool? value) {
                      setDialogState(() {
                        if (value == true) {
                          tempSelectedStatuses.add(status);
                        } else {
                          tempSelectedStatuses.remove(status);
                        }
                      });
                    },
                  );
                }).toList(),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Otkaži'),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _selectedStatuses = tempSelectedStatuses;
                    _updateFilteredJobs(
                        context.read<ApplicantProvider>().appliedJobs);
                  });
                  Navigator.pop(context);
                },
                child: const Text('Potvrdi'),
              ),
            ],
          );
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Localizations.override(
      context: context,
      locale: const Locale('bs', 'BA'),
      delegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      child: Scaffold(
        appBar: AppBar(title: const Text('Aplicirani poslovi')),
        body: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.grey[100],
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _showStatusFilterDialog,
                      icon: const Icon(Icons.filter_list, size: 20),
                      label: Text(
                        _selectedStatuses.isEmpty
                            ? 'Status'
                            : _selectedStatuses.length == 1
                            ? '1 status odabran'
                            : '${_selectedStatuses.length} statusa odabrano',
                      ),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton.icon(
                    onPressed: () => _selectDateRange(context),
                    icon: const Icon(Icons.calendar_today, size: 20),
                    label: Text(
                      _selectedDateRange == null
                          ? 'Datum'
                          : '${DateFormat('dd.MM.yyyy').format(_selectedDateRange!.start)} - '
                          '${DateFormat('dd.MM.yyyy').format(_selectedDateRange!.end)}',
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Consumer<ApplicantProvider>(
                builder: (context, applicantProvider, child) {
                  // Update _filteredJobs when appliedJobs changes
                  _filteredJobs ??= _filterJobs(applicantProvider.appliedJobs);

                  if (_isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (_error != null) {
                    return Center(child: Text('Greška: $_error'));
                  }

                  if (_filteredJobs == null || _filteredJobs!.isEmpty) {
                    return const Center(
                      child: Text(
                        'Nema poslova koji odgovaraju filterima',
                        style: TextStyle(fontSize: 16),
                      ),
                    );
                  }

                  return ListView.builder(
                    key: ValueKey(_filteredJobs), // Ensure rebuild on list change
                    itemCount: _filteredJobs!.length,
                    itemBuilder: (context, index) {
                      final job = _filteredJobs![index];
                      return JobApplicationCard(
                        key: ValueKey(job.id), // Unique key for each job
                        jobApplication: job,
                        isInAppliedJobs: true,
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}