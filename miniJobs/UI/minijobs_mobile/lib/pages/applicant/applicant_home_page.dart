import 'package:flutter/material.dart';
import 'package:minijobs_mobile/enumerations/sort_order.dart';
import 'package:minijobs_mobile/models/city.dart';
import 'package:minijobs_mobile/models/job_type.dart';
import 'package:minijobs_mobile/models/search_result.dart';
import 'package:minijobs_mobile/providers/city_provider.dart';
import 'package:minijobs_mobile/providers/job_provider.dart';
import 'package:minijobs_mobile/providers/job_type_provider.dart';
import 'package:minijobs_mobile/providers/recommendation_provider.dart';
import 'package:provider/provider.dart';
import '../../models/job/job_card_dto.dart';
import '../employer/job/job_card.dart';

class ApplicantHomePage extends StatefulWidget {
  const ApplicantHomePage({super.key});

  @override
  _ApplicantHomePageState createState() => _ApplicantHomePageState();
}

class _ApplicantHomePageState extends State<ApplicantHomePage> {
  final TextEditingController _searchController = TextEditingController();

  late JobProvider _jobProvider;
  late RecommendationProvider _recommendationProvider;
  late CityProvider _cityProvider;
  late JobTypeProvider _jobTypeProvider;
  SearchResult<JobCardDTO> jobs = SearchResult(0, []);
  List<JobCardDTO> recommendedJobs = [];
  String? recommendedJobsReason;
  List<City> cities = [];
  List<JobType> jobTypes = [];
  String? selectedCity;
  String? selectedJobType;
  String sort = "Najnovije";
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _jobProvider = context.read<JobProvider>();
    _cityProvider = context.read<CityProvider>();
    _jobTypeProvider = context.read<JobTypeProvider>();
    _recommendationProvider = context.read<RecommendationProvider>();

    // Load cities, job types, and recommended jobs sequentially, then search jobs
    getCities().then((_) {
      getJobTypes().then((_) {
        getRecommendedJobs().then((_) {
          searchJobs();
        });
      });
    });
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

  Future<void> getRecommendedJobs() async {
    var result = await _recommendationProvider.getRecommendatios();
    if (result != null) {
      recommendedJobs = result.jobs ?? [];
      recommendedJobsReason = result.reason;
    } else {
      recommendedJobs = [];
      recommendedJobsReason = null;
    }
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> searchJobs() async {
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
      jobType = jobTypes.firstWhere((type) => type.name == selectedJobType);
    }
    SortOrder sortOrder = sort == 'Najnovije' ? SortOrder.DESC : SortOrder.ASC;
    jobs = await _jobProvider.search(
      searchText: searchTerm,
      cityId: city?.id,
      jobTypeId: jobType?.id,
      sort: sortOrder,
    );

    // Clear recommended jobs if any search filters are applied
    bool isFilterApplied = searchTerm.isNotEmpty || city != null || jobType != null;
    if (isFilterApplied) {
      recommendedJobs = [];
    } else {
      // Reload recommended jobs if no filters are applied
      await getRecommendedJobs();
    }

    // Filter out recommended jobs only if there are 4 or more
    if (recommendedJobs.length >= 4) {
      final recommendedJobIds = recommendedJobs.map((job) => job.id).toSet();
      jobs.result!.removeWhere((job) => recommendedJobIds.contains(job.id));
    }

    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mini Jobs - Poslovi'),
        automaticallyImplyLeading: false,
      ),
      body: Stack(
        children: [
          const HeaderWidget(),
          SearchBarWidget(
            searchController: _searchController,
            cities: cities,
            jobTypes: jobTypes,
            selectedCity: selectedCity,
            selectedJobType: selectedJobType,
            onCityChanged: (String? value) {
              setState(() {
                selectedCity = value;
              });
              searchJobs();
            },
            onJobTypeChanged: (String? value) {
              setState(() {
                selectedJobType = value;
              });
              searchJobs();
            },
            onSearch: searchJobs,
            onClearFilters: () {
              setState(() {
                _searchController.clear();
                selectedCity = null;
                selectedJobType = null;
              });
              searchJobs();
            },
            sort: sort,
            onSortChanged: (String value) {
              setState(() {
                sort = value;
              });
              searchJobs();
            },
          ),
          JobListWidget(
            isLoading: isLoading,
            jobs: _buildJobs(),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Widget _buildJobs() {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Display recommended jobs if >=4
          if (recommendedJobs.length >= 4) ..._buildRecommendedJobs(),
          // Main job list
          jobs.result == null || jobs.result!.isEmpty
              ? const Padding(
            padding: EdgeInsets.all(16.0),
            child: Center(child: Text('Nema pronađenih poslova')),
          )
              : Column(
            children: jobs.result!.asMap().entries.map((entry) {
              final index = entry.key;
              final job = entry.value;
              return JobCard(job: job);
            }).toList(),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildRecommendedJobs() {
    return [
      Container(
        margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Preporučeni poslovi',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
            Text(
              recommendedJobsReason ?? 'Preporučeno na osnovu vaših interesa',
              style: const TextStyle(
                fontSize: 14.0,
                color: Colors.black54,
              ),
              softWrap: true,
            ),
            const SizedBox(height: 8.0),
          ],
        ),
      ),
      ...recommendedJobs.asMap().entries.map((entry) {
        final index = entry.key;
        final job = entry.value;
        return JobCard(job: job, isRecommended: true);
      }).toList(),
    ];
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
              'Pronađite posao na brz i jednostavan način!',
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
  final List<JobType> jobTypes;
  final String? selectedCity;
  final String? selectedJobType;
  final ValueChanged<String?> onCityChanged;
  final ValueChanged<String?> onJobTypeChanged;
  final VoidCallback onSearch;
  final VoidCallback onClearFilters;
  final String sort;
  final ValueChanged<String> onSortChanged;

  const SearchBarWidget({
    super.key,
    required this.searchController,
    required this.cities,
    required this.jobTypes,
    required this.selectedCity,
    required this.selectedJobType,
    required this.onCityChanged,
    required this.onJobTypeChanged,
    required this.onSearch,
    required this.onClearFilters,
    required this.sort,
    required this.onSortChanged,
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
    selectedFilterCity = widget.selectedCity;
    selectedFilterJobType = widget.selectedJobType;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Check if any filters are applied
    bool hasFilters = widget.searchController.text.isNotEmpty ||
        widget.selectedCity != null ||
        widget.selectedJobType != null;

    return Positioned(
      top: 82,
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
            const SizedBox(height: 8), // Add some spacing between Row and Clear Filters button
            // Clear Filters button below the Row, always visible but disabled when no filters
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0, top: 4.0), // Align with search bar padding
                child: ElevatedButton.icon(
                  onPressed: hasFilters
                      ? () {
                    widget.onClearFilters();
                  }
                      : null, // Disabled when no filters are applied
                  icon: const Icon(
                    Icons.clear,
                    size: 18, // Slightly smaller icon for better proportion
                  ),
                  label: const Text(
                    'Obriši filtere',
                    style: TextStyle(fontSize: 14), // Slightly smaller font for compactness
                  ),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: hasFilters ? Colors.blue : Colors.grey, // Text/icon color
                    backgroundColor: hasFilters ? Colors.blue.withOpacity(0.1) : Colors.grey.withOpacity(0.1), // Subtle background
                    elevation: 0, // Flat design to match the search bar style
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8), // Compact padding
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20), // Rounded corners for a modern look
                      side: BorderSide(
                        color: hasFilters ? Colors.blue.withOpacity(0.3) : Colors.grey.withOpacity(0.3),
                        width: 1,
                      ), // Subtle border
                    ),
                  ),
                ),
              ),
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
                  color: selectedSortOption == 'Najnovije' ? Colors.blue : Colors.grey,
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
                  color: selectedSortOption == 'Najstarije' ? Colors.blue : Colors.grey,
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
                    'Filteri',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const Divider(),
                  const Text(
                    'Izaberi grad',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
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
                              icon: const Icon(Icons.clear, color: Colors.grey),
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
                            child: Text(city.name ?? ''),
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
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
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
                              icon: const Icon(Icons.clear, color: Colors.grey),
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
                            child: Text(jobType.name ?? ''),
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

class JobListWidget extends StatelessWidget {
  final bool isLoading;
  final Widget jobs;

  const JobListWidget({
    super.key,
    required this.isLoading,
    required this.jobs,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 230,
      left: 0,
      right: 0,
      bottom: 0,
      child: isLoading
          ? const Center(child: CircularProgressIndicator())
          : jobs,
    );
  }
}