import 'package:flutter/material.dart';
import 'package:minijobs_admin/enumerations/sort_order.dart';
import 'package:minijobs_admin/models/city.dart';
import 'package:minijobs_admin/models/search_result.dart';
import 'package:minijobs_admin/providers/city_provider.dart';
import 'package:minijobs_admin/providers/job_provider.dart';
import 'package:provider/provider.dart';
import '../../providers/recommendation_provider.dart';
import '../employer/job/job_card.dart';
import '../../models/job/job.dart';

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
  SearchResult<Job> jobs = SearchResult(0, []); // Initialize jobs directly here
  List<Job> recommendedJobs=[];
  List<City> cities = [];
  String? selectedCity;
  String sort="Najnovije";
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
    _recommendationProvider = context.read<RecommendationProvider>();

    getCities();
    searchJobs();
    getRecommendedJobs();
  }

  Future<void> getCities() async {
    cities = await _cityProvider.getAll();
    setState(() {});
  }

  Future<void> getRecommendedJobs() async {
    recommendedJobs = await _recommendationProvider.getRecommendatios();
    setState(() {});
  }
  Future<void> searchJobs() async {
    setState(() {
      isLoading = true;
    });

    String searchTerm = _searchController.text;
    City? city;
    if (selectedCity != null) {
      city = cities.firstWhere(
              (city) => city.name == selectedCity
      );
    }
    SortOrder sortOrder= sort=='Najnovije'?SortOrder.DESC:SortOrder.ASC;
    jobs = await _jobProvider.search(
      searchText: searchTerm,
      cityId: city?.id,
        sort: sortOrder
    );
    if (recommendedJobs.length >= 4) {
      final recommendedJobIds = recommendedJobs.map((job) => job.id).toSet();
      jobs.result!.removeWhere((job) => recommendedJobIds.contains(job.id));
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mini Jobs - Poslovi'),
      ),
      body: Stack(
        children: [
          const HeaderWidget(),
          SearchBarWidget(
            searchController: _searchController,
            cities: cities,
            selectedCity: selectedCity,
            onCityChanged: (String? value) {
              setState(() {
                selectedCity = value;
              });
              searchJobs();
            },
            onSearch: searchJobs,
            sort: sort,
            onSortChanged:(String value){
             setState(() {
               sort=value;
             });
             searchJobs();
            }
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
    return Column(
      children: [
        // Display recommended jobs if >=4
        if (recommendedJobs.length >= 4) _buildRecommendedJobs(),
        Expanded(
          child: jobs.result == null || jobs.result!.isEmpty
              ? const Center(child: Text('Nema pronađenih poslova'))
              : ListView.builder(
            itemCount: jobs.result!.length,
            itemBuilder: (context, index) {
              final job = jobs.result![index];
              return JobCard(job: job);
            },
          ),
        ),
      ],
    );
  }


  Widget _buildRecommendedJobs() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16.0),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.blue.shade100,
        borderRadius: BorderRadius.circular(8.0),
      ),
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
          const SizedBox(height: 8.0),
          SizedBox(
            height: 200,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: recommendedJobs.length,
              itemBuilder: (context, index) {
                final job = recommendedJobs[index];
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: SizedBox(
                    width: 250,
                    child: JobCard(job: job),
                  ),
                );
              },
            ),
          ),
        ],
      ),
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
  final String? selectedCity;
  final ValueChanged<String?> onCityChanged;
  final VoidCallback onSearch;
  final String sort;
  final ValueChanged<String> onSortChanged;

  const SearchBarWidget({
    super.key,
    required this.searchController,
    required this.cities,
    required this.selectedCity,
    required this.onCityChanged,
    required this.onSearch,
    required this.sort,
    required this.onSortChanged
  });

  @override
  _SearchBarWidgetState createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  String? selectedSortOption;
  String? selectedFilterCity;

  @override
  void initState() {
    selectedSortOption=widget.sort;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
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
      top: 180,
      left: 0,
      right: 0,
      bottom: 0,
      child: isLoading
          ? const Center(child: CircularProgressIndicator())
          : jobs,
    );
  }


}
