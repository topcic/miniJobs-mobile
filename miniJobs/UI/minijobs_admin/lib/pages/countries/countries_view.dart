import 'dart:async';
import 'package:another_flushbar/flushbar_route.dart';
import 'package:flutter/material.dart';
import 'package:horizontal_data_table/horizontal_data_table.dart';
import 'package:minijobs_admin/models/country.dart';
import 'package:minijobs_admin/pages/main/constants.dart';
import 'package:provider/provider.dart';
import 'package:another_flushbar/flushbar.dart';
import '../../providers/country_provider.dart';
import '../../widgets/badges.dart';
import 'country_form.dart';

class CountriesView extends StatefulWidget {
  const CountriesView({super.key});

  @override
  _CountriesViewState createState() => _CountriesViewState();
}

class _CountriesViewState extends State<CountriesView> {
  late CountryProvider _countryProvider;
  List<Country> data = [];
  bool isLoading = true;
  bool _showForm = false; // Controls visibility of CountryForm
  Country? _countryToEdit; // Tracks which country to edit (null for new)
  int totalCount = 0; // To track total number of items from the server

  Map<String, dynamic> filter = {
    'limit': 10,
    'offset': 0,
    'sortBy': 'name',
    'sortOrder': 'asc',
    'searchText': '',
  };

  Timer? _debounce;
  late ScrollController _verticalScrollController;
  late ScrollController _horizontalScrollController;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _countryProvider = context.read<CountryProvider>();
    fetchCountries();
  }

  Future<void> fetchCountries() async {
    setState(() {
      isLoading = true;
    });

    final result = await _countryProvider.searchPublic(filter);

    setState(() {
      data = result.result ?? []; // Use ?? to handle null result
      totalCount = result.count ?? 0; // Assuming searchPublic returns a count
      isLoading = false;
    });
  }

  void _debouncedSearch(String keyword) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      setState(() {
        filter['searchText'] = keyword;
        filter['offset'] = 0; // Reset to first page on search
      });
      fetchCountries();
    });
  }

  void _sort(String sortBy, bool ascending) {
    setState(() {
      filter['sortBy'] = sortBy;
      filter['sortOrder'] = ascending ? 'asc' : 'desc';
      filter['offset'] = 0;
    });
    fetchCountries();
  }

  void _changePage(int newPage) {
    setState(() {
      filter['offset'] = newPage * filter['limit'];
    });
    fetchCountries();
  }

  void showFlushbarWithRootNavigator(Flushbar flushbar, BuildContext context) {
    Navigator.of(context, rootNavigator: true).push(
      FlushbarRoute(
        flushbar: flushbar,
      ),
    );
  }

  void openCountryForm(Country? country) {
    setState(() {
      _showForm = true;
      _countryToEdit = country;
    });
  }

  void _closeCountryForm({bool success = false}) {
    setState(() {
      _showForm = false;
      _countryToEdit = null;
    });
    if (success) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        fetchCountries();
      });
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Države'),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  decoration: const InputDecoration(
                    hintText: 'Pretraži',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                  ),
                  onChanged: _debouncedSearch, // Directly use debounced search
                ),
              ),
              Expanded(
                child: isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : HorizontalDataTable(
                  leftHandSideColumnWidth: 150,
                  rightHandSideColumnWidth: 450,
                  isFixedHeader: true,
                  headerWidgets: _buildHeaders(),
                  leftSideItemBuilder: (context, index) =>
                      _buildLeftColumn(context, data[index]),
                  rightSideItemBuilder: (context, index) =>
                      _buildRightColumn(context, data[index]),
                  itemCount: data.length,
                  rowSeparatorWidget:
                  Divider(color: Colors.grey[300], height: 1.0),
                  onScrollControllerReady: (vertical, horizontal) {
                    _verticalScrollController = vertical;
                    _horizontalScrollController = horizontal;
                  },
                  leftHandSideColBackgroundColor: secondaryColor,
                  rightHandSideColBackgroundColor: secondaryColor,
                  itemExtent: 56,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: filter['offset'] > 0
                          ? () => _changePage(
                          (filter['offset'] / filter['limit']).floor() - 1)
                          : null,
                      child: const Text('Prethodna'),
                    ),
                    Text(
                        'Stranica ${(filter['offset'] / filter['limit']).floor() + 1} od ${(totalCount / filter['limit']).ceil()}'),
                    ElevatedButton(
                      onPressed: (filter['offset'] + filter['limit']) < totalCount
                          ? () => _changePage(
                          (filter['offset'] / filter['limit']).floor() + 1)
                          : null,
                      child: const Text('Sljedeća'),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (_showForm)
            GestureDetector(
              onTap: () => _closeCountryForm(),
              child: Container(
                color: Colors.black54,
                child: Center(
                  child: GestureDetector(
                    onTap: () {},
                    child: CountryForm(
                      country: _countryToEdit,
                      onClose: _closeCountryForm,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  List<Widget> _buildHeaders() {
    return [
      _buildHeaderItem('Akcije', 150),
      _buildHeaderItem('Naziv', 250, sortable: true, sortField: 'name'),
      _buildHeaderItem('Status', 100, sortable: true, sortField: 'isDeleted'),
      Container(
        width: 100,
        height: 56,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 8),
        child: ElevatedButton.icon(
          onPressed: () {
            openCountryForm(null); // Open form for adding
          },
          icon: const Icon(Icons.add, size: 16),
          label: const Text('Dodaj'),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
            minimumSize: const Size(0, 32),
            textStyle: const TextStyle(fontSize: 12),
          ),
        ),
      ),
    ];
  }

  Widget _buildHeaderItem(String label, double width,
      {bool sortable = false, String? sortField}) {
    return GestureDetector(
      onTap: sortable
          ? () => _sort(sortField!,
          filter['sortBy'] != sortField || filter['sortOrder'] == 'desc')
          : null,
      child: Container(
        width: width,
        height: 56,
        alignment: Alignment.centerLeft,
        child: Row(
          children: [
            Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
            if (sortable)
              Icon(
                filter['sortBy'] == sortField
                    ? (filter['sortOrder'] == 'asc'
                    ? Icons.arrow_upward
                    : Icons.arrow_downward)
                    : Icons.unfold_more,
                size: 16,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildLeftColumn(BuildContext context, Country country) {
    return Container(
      width: 150,
      height: 52,
      alignment: Alignment.center,
      child: Row(
        children: [
          Tooltip(
            message: 'Uredi državu',
            child: IconButton(
              icon: const Icon(Icons.edit, color: Colors.blue),
              onPressed: () {
                openCountryForm(country); // Open form for editing
              },
            ),
          ),
          Tooltip(
            message: country.isDeleted! ? 'Aktiviraj' : 'Deaktiviraj',
            child: IconButton(
              icon: Icon(
                country.isDeleted! ? Icons.refresh : Icons.delete,
                color: country.isDeleted! ? Colors.green : Colors.red,
              ),
              onPressed: () async {
                if (country.isDeleted!) {
                  await _countryProvider.activate(country.id!);
                } else {
                  await _countryProvider.delete(country.id!);
                }
                fetchCountries();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRightColumn(BuildContext context, Country country) {
    return Row(
      children: [
        _buildCell(Text(country.name ?? '-'), 250),
        _buildCell(
          RatingBadge(isActive: country.isDeleted!), // Inverted for display logic
          100,
        ),
      ],
    );
  }

  Widget _buildCell(Widget content, double width) {
    return Container(
      width: width,
      height: 52,
      alignment: Alignment.centerLeft,
      child: content,
    );
  }
}