import 'package:flutter/material.dart';
import 'package:minijobs_mobile/models/applicant/applicant.dart';
import 'package:minijobs_mobile/models/city.dart';
import 'package:minijobs_mobile/models/job_type.dart';
import 'package:minijobs_mobile/models/search_result.dart';
import 'package:minijobs_mobile/providers/applicant_provider.dart';
import 'package:minijobs_mobile/providers/city_provider.dart';
import 'package:minijobs_mobile/providers/job_type_provider.dart';
import 'package:provider/provider.dart';

import '../../enumerations/sort_order.dart';
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
  late JobTypeProvider _jobTypeProvider;
  late SearchResult<Applicant> applicants;
  List<City> cities = [];
  String? selectedCity;
  List<JobType> jobTypes = [];
  String? selectedJobType;
  bool isLoading = false;
  String sort = "Najnovije";

  @override
  void initState() {
    super.initState();
    applicants = SearchResult(0, []);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _applicantProvider = context.read<ApplicantProvider>();
    _cityProvider = context.read<CityProvider>();
    _jobTypeProvider = context.read<JobTypeProvider>();
    getCities();
    getJobTypes();
    searchApplicant();
  }
  Future<void> getCities() async {
    final result = await _cityProvider.getAll();
    if (mounted) {
      setState(() {
        cities = result;
      });
    }
  }

  Future<void> getJobTypes() async {
    final result = await _jobTypeProvider.getAll();
    if (mounted) {
      setState(() {
        jobTypes = result;
      });
    }
  }

  Future<void> searchApplicant() async {
    if (mounted) {
      setState(() {
        isLoading = true;
      });
    }

    String searchTerm = _searchController.text;
    City? city;
    if (selectedCity != null) {
      city = cities.firstWhere((city) => city.name == selectedCity);
    }

    JobType? jobType;
    if (selectedJobType != null) {
      jobType = jobTypes.firstWhere((jobType) => jobType.name == selectedJobType);
    }
    SortOrder sortOrder = sort == 'Najnovije' ? SortOrder.DESC : SortOrder.ASC;
    final result = await _applicantProvider.searchApplicants(
      searchText: searchTerm,
      cityId: city?.id,
      sort: sortOrder,
      jobTypeId: jobType?.id,
    );

    if (mounted) {
      setState(() {
        applicants = result;
        isLoading = false;
      });
    }
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
              searchApplicant();
            },
            onSearch: searchApplicant,
            sort: sort,
            onSortChanged: (String value) {
              setState(() {
                sort = value;
              });
              searchApplicant();
            },
            jobTypes: jobTypes,
            selectedJobType: selectedJobType,
            onJobTypeChanged: (String? value) {
              setState(() {
                selectedJobType = value;
              });
              searchApplicant();
            },
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
  final String sort;
  final ValueChanged<String> onSortChanged;
  final List<JobType> jobTypes;
  final String? selectedJobType;
  final ValueChanged<String?> onJobTypeChanged;

  const SearchBarWidget({
    super.key,
    required this.searchController,
    required this.cities,
    required this.selectedCity,
    required this.onCityChanged,
    required this.onSearch,
    required this.sort,
    required this.onSortChanged,
    required this.jobTypes,
    required this.selectedJobType,
    required this.onJobTypeChanged,
  });

  @override
  _SearchBarWidgetState createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  String? selectedSortOption;
  String? selectedFilterCity;
  String? selectedFilterJobType;

  @override
  void initState() {
    selectedSortOption = widget.sort;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 100,
      left: 0,
      right: 0,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20.0),
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 4.0,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: SearchBar(
                    controller: widget.searchController,
                    leading: IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: widget.onSearch,
                    ),
                    hintText: 'Pretraži...',
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.sort),
                  onPressed: () {
                    _showSortOptions();
                  },
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.filter_list),
                  onPressed: () {
                    _showFilterOptions();
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showSortOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'Poredaj po',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
              const Divider(),
              ListTile(
                leading: Icon(
                  Icons.arrow_downward,
                  color: selectedSortOption == 'Najnovije'
                      ? Colors.blue
                      : Colors.grey,
                ),
                title: const Text(
                  'Najnovije',
                  style: TextStyle(fontSize: 16.0),
                ),
                onTap: () {
                  setState(() {
                    selectedSortOption = 'Najnovije';
                  });
                  widget.onSortChanged('Najnovije');
                  widget.onSearch();
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.arrow_upward,
                  color: selectedSortOption == 'Najstarije'
                      ? Colors.blue
                      : Colors.grey,
                ),
                title: const Text(
                  'Najstarije',
                  style: TextStyle(fontSize: 16.0),
                ),
                onTap: () {
                  setState(() {
                    selectedSortOption = 'Najstarije';
                  });
                  widget.onSortChanged('Najstarije');
                  widget.onSearch();
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showFilterOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Izaberi grad',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const Divider(),
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: selectedFilterCity,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12.0,
                              vertical: 8.0,
                            ),
                            suffixIcon: selectedFilterCity != null
                                ? IconButton(
                                    icon: const Icon(Icons.clear,
                                        color: Colors.grey),
                                    onPressed: () {
                                      setModalState(() {
                                        selectedFilterCity = null;
                                      });
                                      widget.onCityChanged(null);
                                      widget.onSearch();
                                    },
                                  )
                                : null,
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
                                        child: Text(city.name!),
                                      ))
                                  .toList(),
                          onChanged: (value) {
                            setModalState(() {
                              selectedFilterCity = value;
                            });
                            widget.onCityChanged(value);
                            widget.onSearch();
                          },
                          isDense: true,
                          isExpanded: true,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Izaberi tip posla',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const Divider(),
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: selectedFilterJobType,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12.0,
                              vertical: 8.0,
                            ),
                            suffixIcon: selectedFilterJobType != null
                                ? IconButton(
                                    icon: const Icon(Icons.clear,
                                        color: Colors.grey),
                                    onPressed: () {
                                      setModalState(() {
                                        selectedFilterJobType = null;
                                      });
                                      widget.onJobTypeChanged(null);
                                      widget.onSearch();
                                    },
                                  )
                                : null,
                          ),
                          icon: const Icon(Icons.arrow_drop_down),
                          items: widget.jobTypes.isEmpty
                              ? [
                                  const DropdownMenuItem<String>(
                                    value: null,
                                    child: Text('Učitavanje tipova posla...'),
                                  ),
                                ]
                              : widget.jobTypes
                                  .map((jobType) => DropdownMenuItem<String>(
                                        value: jobType.name,
                                        child: Text(jobType.name!),
                                      ))
                                  .toList(),
                          onChanged: (value) {
                            setModalState(() {
                              selectedFilterJobType = value;
                            });
                            widget.onJobTypeChanged(value);
                            widget.onSearch();
                          },
                          isDense: true,
                          isExpanded: true,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
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
      top: 220,
      left: 0,
      right: 0,
      bottom: 0,
      child: isLoading
          ? const Center(child: CircularProgressIndicator())
          : workers,
    );
  }
}
