// lib/screens/employer_home_page.dart
import 'package:flutter/material.dart';
import 'package:minijobs_mobile/models/applicant/applicant.dart';
import 'package:minijobs_mobile/models/city.dart';
import 'package:minijobs_mobile/models/search_result.dart';
import 'package:minijobs_mobile/providers/applicant_provider.dart';
import 'package:minijobs_mobile/providers/city_provider.dart';
import 'package:provider/provider.dart';

import '../applicant/applicant_card.dart';

class EmployerHomePage extends StatefulWidget {
  const EmployerHomePage({super.key});

  @override
  _EmployerHomePageState createState() => _EmployerHomePageState();
}

class _EmployerHomePageState extends State<EmployerHomePage> {
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();

  late ApplicantProvider _applicantProvider;
  late CityProvider _cityProvider;
  late SearchResult<Applicant> applicants;
  List<City> cities = [];
  String? selectedCity;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    applicants = SearchResult( 0, []);
  }


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _applicantProvider = context.read<ApplicantProvider>();
    _cityProvider = context.read<CityProvider>();
    getCities();
    searchApplicant();
  }

  Future<void> getCities() async {
    cities = await _cityProvider.getAll();
    setState(() {});
  }

  Future<void> searchApplicant() async {
    setState(() {
      isLoading = true;
    });

    String searchTerm = _searchController.text;
    City? city;
    if (selectedCity != null) {
      city = cities.firstWhere(
        (city) =>
            city.name ==
            selectedCity, // Provide a default value or handle the case where no city is found
      );
    }
    applicants = await _applicantProvider.searchApplicants(
      searchText: searchTerm,
      cityId: city?.id,
    );

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mini Jobs - Poslodavac'),
      ),
      body: Stack(
        children: [
          const HeaderWidget(),
          // Search bar container
          SearchBarWidget(
            searchController: _searchController,
            cities: cities,
            selectedCity: selectedCity,
            onCityChanged: (String? value) {
              setState(() {
                selectedCity = value;
              });
            },
            onSearch: searchApplicant,
          ),
          WorkerProfilesWidget(
            isLoading: isLoading,
            workers: _buildWorkers(),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _locationController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Widget _buildWorkers() {
    if (applicants.result == null || applicants.result!.isEmpty) {
      return const Center(child: Text('Nema pronađenih radnika'));
    }
    return ListView.builder(
      itemCount: applicants.result!.length,
      itemBuilder: (context, index) {
        final applicant = applicants.result![index];
        return ApplicantCard(applicant: applicant);
      },
    );
  }
}

class HeaderWidget extends StatelessWidget {
  const HeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        height: 130,
        color: Colors.blue,
        padding: const EdgeInsets.all(20.0),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Pronađite idealnog radnika za vaš posao!',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "Pretražujte i pronađite radnike brzo i jednostavno!",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SearchBarWidget extends StatefulWidget {
  final TextEditingController searchController;
  final List<City> cities;
  final String? selectedCity;
  final ValueChanged<String?> onCityChanged;
  final VoidCallback onSearch;

  const SearchBarWidget({
    super.key,
    required this.searchController,
    required this.cities,
    required this.selectedCity,
    required this.onCityChanged,
    required this.onSearch,
  });

  @override
  _SearchBarWidgetState createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 100,
      left: 0,
      right: 0,
      child: Container(
        height: 240,
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(10.0),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 20.0),
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Row(
              children: [
                const Icon(Icons.search),
                const SizedBox(width: 10.0),
                Expanded(
                  child: TextFormField(
                    controller: widget.searchController,
                    decoration: const InputDecoration(
                      hintText: 'Koju uslugu ili kojeg radnika tražite?',
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ],
            ),
            const Divider(height: 20.0),
            Row(
              children: [
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      double parentWidth = constraints.maxWidth;
                      double desiredWidth = parentWidth * 0.8;

                      return Container(
                        width: desiredWidth,
                        height: 60.0,
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        child: DropdownButtonFormField<String>(
                          value: widget.selectedCity,
                          decoration: const InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            labelText: 'Izaberi grad',
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 12.0,
                              vertical: 8.0,
                            ),
                          ),
                          icon: const Icon(Icons.arrow_drop_down),
                          items: widget.cities.isEmpty
                              ? [
                                  const DropdownMenuItem<String>(
                                    value: null,
                                    child: Text('Učitavanje gradova...'),
                                  ),
                                ]
                              : widget.cities
                                  .map((city) => DropdownMenuItem<String>(
                                        value: city.name,
                                        child: Row(
                                          children: [
                                            Text(city.name!),
                                          ],
                                        ),
                                      ))
                                  .toList(),
                          onChanged: widget.onCityChanged,
                          isDense: true,
                          isExpanded: true,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20.0),
            Align(
              alignment: Alignment.bottomCenter,
              child: ElevatedButton(
                onPressed: widget.onSearch,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(
                      vertical: 15.0, horizontal: 30.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: const Text(
                  'Pretraži',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class WorkerProfilesWidget extends StatelessWidget {
  final bool isLoading;
  final Widget workers;

  const WorkerProfilesWidget({
    super.key,
    required this.isLoading,
    required this.workers,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 340,
      left: 0,
      right: 0,
      bottom: 0,
      child: isLoading
          ? const Center(child: CircularProgressIndicator())
          : workers,
    );
  }
}
