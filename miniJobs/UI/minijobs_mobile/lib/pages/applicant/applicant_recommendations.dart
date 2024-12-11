import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:minijobs_mobile/providers/job_recommendation_provider.dart';
import 'package:minijobs_mobile/providers/user_provider.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:provider/provider.dart';

import '../../models/city.dart';
import '../../models/job_recommendation/job_recommendation.dart';
import '../../models/job_recommendation/job_recommendation_request.dart';
import '../../models/job_type.dart';
import '../../providers/city_provider.dart';
import '../../providers/job_type_provider.dart';

class ApplicantRecommendations extends StatefulWidget {
  const ApplicantRecommendations({Key? key}) : super(key: key);

  @override
  _ApplicantRecommendationsState createState() =>
      _ApplicantRecommendationsState();
}

class _ApplicantRecommendationsState extends State<ApplicantRecommendations> {
  late CityProvider _cityProvider;
  late JobRecommendationProvider _jobRecommendationProvider;
  late UserProvider _userProvider;
  late JobTypeProvider _jobTypeProvider;

  late Future<List<City>> _citiesFuture;
  late Future<List<JobType>> _jobTypesFuture;

  JobRecommendation? jobRecommendation;
  List<int> selectedCityIds = [];
  List<int> selectedJobTypeIds = [];

  @override
  void initState() {
    super.initState();
    _cityProvider = context.read<CityProvider>();
    _jobTypeProvider = context.read<JobTypeProvider>();
    _jobRecommendationProvider = context.read<JobRecommendationProvider>();
    _userProvider = context.read<UserProvider>();

    _citiesFuture = _cityProvider.getAll();
    _jobTypesFuture = _jobTypeProvider.getAll();

    _loadJobRecommendation();
  }

  Future<void> _loadJobRecommendation() async {
    final userId = int.parse( GetStorage().read('userId'));
    final recommendation = await _userProvider.findJobRecommendation(userId);
    if (recommendation != null) {
      setState(() {
        jobRecommendation = recommendation;
        selectedCityIds = recommendation.cities ?? [];
        selectedJobTypeIds = recommendation.jobTypes ?? [];
      });
    }
  }

  Future<void> _saveRecommendation() async {
    final request = JobRecommendationRequest(
      cities: selectedCityIds,
      jobTypes: selectedJobTypeIds,
    );

    if (jobRecommendation == null) {
      // Insert new recommendation
      final newRecommendation =
      await _jobRecommendationProvider.insert(request);
      setState(() {
        jobRecommendation = newRecommendation;
      });

    } else {
      // Update existing recommendation
      final updatedRecommendation =
      await _jobRecommendationProvider.update(
        jobRecommendation!.id!,
        request,
      );
      setState(() {
        jobRecommendation = updatedRecommendation;
      });
    }
  }

  Future<void> _resetRecommendation() async {
    if (jobRecommendation != null) {
      await _jobRecommendationProvider.delete(jobRecommendation!.id!);
      setState(() {
        jobRecommendation = null;
        selectedCityIds = [];
        selectedJobTypeIds = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Preporuke'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Dobit ćete preporuke za posao na osnovu Vaših preferencija za posao putem e-pošte.',
              style: TextStyle(fontSize: 16, height: 1.5),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Odaberite Gradove',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    FutureBuilder<List<City>>(
                      future: _citiesFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError || !snapshot.hasData) {
                          return const Center(child: Text('Failed to load cities.'));
                        }

                        final cities = snapshot.data!;
                        return MultiSelectDialogField<int>(
                          items: cities
                              .map((city) => MultiSelectItem<int>(city.id!, city.name!))
                              .toList(),
                          title: const Text("Gradovi"),
                          initialValue: selectedCityIds,
                          buttonText: const Text(
                            "Izaberite gradove",
                            style: TextStyle(color: Colors.grey),
                          ),
                          onConfirm: (values) {
                            setState(() {
                              selectedCityIds = values.cast<int>();
                            });
                          },
                        );
                      },
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Odaberite Tipove Poslova',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    FutureBuilder<List<JobType>>(
                      future: _jobTypesFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError || !snapshot.hasData) {
                          return const Center(child: Text('Failed to load job types.'));
                        }

                        final jobTypes = snapshot.data!;
                        return MultiSelectDialogField<int>(
                          items: jobTypes
                              .map((jobType) => MultiSelectItem<int>(jobType.id!, jobType.name!))
                              .toList(),
                          title: const Text("Tipovi posla"),
                          initialValue: selectedJobTypeIds,
                          buttonText: const Text(
                            "Izaberite tip posla kojim se bavite",
                            style: TextStyle(color: Colors.grey),
                          ),
                          onConfirm: (values) {
                            setState(() {
                              selectedJobTypeIds = values.cast<int>();
                            });
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (jobRecommendation != null)
                  TextButton(
                    onPressed: _resetRecommendation,
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.red,
                    ),
                    child: const Text('Resetuj'),
                  ),
                ElevatedButton(
                  onPressed: (selectedCityIds.isNotEmpty || selectedJobTypeIds.isNotEmpty)
                      ? _saveRecommendation
                      : null, // Disable the button when no cities or job types are selected
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green, // The button's background color when enabled
                    disabledBackgroundColor: Colors.grey, // The button's background color when disabled
                  ),
                  child: const Text('Dodaj preporuke'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
