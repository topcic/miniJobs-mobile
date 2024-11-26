import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/city.dart';
import '../../models/job_type.dart';
import '../../providers/city_provider.dart';
import '../../providers/job_type_provider.dart';

class ApplicantRecommendations extends StatefulWidget {
  const ApplicantRecommendations({Key? key}) : super(key: key);

  @override
  _ApplicantRecommendationsState createState() => _ApplicantRecommendationsState();
}

class _ApplicantRecommendationsState extends State<ApplicantRecommendations> {
  late CityProvider _cityProvider;
  late JobTypeProvider _jobTypeProvider;
  late Future<List<City>> _citiesFuture;
  late Future<List<JobType>> _jobTypesFuture;

  List<int> selectedCityIds = [];
  List<int> selectedJobTypeIds = [];

  @override
  void initState() {
    super.initState();
    _cityProvider = context.read<CityProvider>();
    _jobTypeProvider = context.read<JobTypeProvider>();
    _citiesFuture = _cityProvider.getAll();
    _jobTypesFuture = _jobTypeProvider.getAll();
    _loadSavedPreferences();
  }

  Future<void> _loadSavedPreferences() async {
    // Mock: Load previously saved preferences (Replace with actual API call)
    // For example, fetch from shared preferences or user API
    setState(() {
      selectedCityIds = [1, 3]; // Replace with actual saved city IDs
      selectedJobTypeIds = [2]; // Replace with actual saved job type IDs
    });
  }

  void _toggleCitySelection(int cityId) {
    setState(() {
      if (selectedCityIds.contains(cityId)) {
        selectedCityIds.remove(cityId);
      } else {
        selectedCityIds.add(cityId);
      }
    });
  }

  void _toggleJobTypeSelection(int jobTypeId) {
    setState(() {
      if (selectedJobTypeIds.contains(jobTypeId)) {
        selectedJobTypeIds.remove(jobTypeId);
      } else {
        selectedJobTypeIds.add(jobTypeId);
      }
    });
  }

  Future<void> _savePreferences() async {
    // Mock: Save preferences (Replace with actual API call)
    // Example: Call API to save selectedCityIds and selectedJobTypeIds
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Preferences saved successfully!')),
    );
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
                        return Wrap(
                          spacing: 8.0,
                          runSpacing: 8.0,
                          children: cities.map((city) {
                            final isSelected = selectedCityIds.contains(city.id);
                            return FilterChip(
                              label: Text(city.name!),
                              selected: isSelected,
                              onSelected: (_) => _toggleCitySelection(city.id!),
                              selectedColor: Colors.blue.withOpacity(0.2),
                              checkmarkColor: Colors.blue,
                            );
                          }).toList(),
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
                        return Wrap(
                          spacing: 8.0,
                          runSpacing: 8.0,
                          children: jobTypes.map((jobType) {
                            final isSelected = selectedJobTypeIds.contains(jobType.id);
                            return FilterChip(
                              label: Text(jobType.name!),
                              selected: isSelected,
                              onSelected: (_) => _toggleJobTypeSelection(jobType.id!),
                              selectedColor: Colors.green.withOpacity(0.2),
                              checkmarkColor: Colors.green,
                            );
                          }).toList(),
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
                ElevatedButton(
                  onPressed: _savePreferences,
                  child: const Text('Dodaj Preporuke'),
                ),
                TextButton(
                  onPressed: _loadSavedPreferences,
                  child: const Text('Resetuj'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}