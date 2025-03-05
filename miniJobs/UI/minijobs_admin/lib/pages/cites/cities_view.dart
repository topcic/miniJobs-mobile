import 'dart:async';
import 'package:another_flushbar/flushbar_route.dart';
import 'package:flutter/material.dart';
import 'package:horizontal_data_table/horizontal_data_table.dart';
import 'package:minijobs_admin/models/city.dart';
import 'package:minijobs_admin/pages/main/constants.dart';
import 'package:provider/provider.dart';
import 'package:another_flushbar/flushbar.dart';
import '../../providers/city_provider.dart';
import 'city_form.dart';

class CitiesView extends StatefulWidget {
  const CitiesView({super.key});

  @override
  _CitiesViewState createState() => _CitiesViewState();
}

class _CitiesViewState extends State<CitiesView> {
  late CityProvider _cityProvider;
  List<City> data = [];
  bool isLoading = true;
  bool _showForm = false; // Controls visibility of CityForm
  City? _cityToEdit; // Tracks which city to edit (null for new)

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
    _cityProvider = context.read<CityProvider>();
    fetchCities();
  }

  Future<void> fetchCities() async {
    setState(() {
      isLoading = true;
    });

    final result = await _cityProvider.searchPublic(filter);

    setState(() {
      data = result.result ?? [];
      isLoading = false;
    });
  }

  void _debouncedSearch(String keyword) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      setState(() {
        filter['searchText'] = keyword;
        filter['offset'] = 0;
      });
      fetchCities();
    });
  }

  void _sort(String sortBy, bool ascending) {
    setState(() {
      filter['sortBy'] = sortBy;
      filter['sortOrder'] = ascending ? 'asc' : 'desc';
      filter['offset'] = 0;
    });
    fetchCities();
  }

  void _changePage(int newPage) {
    setState(() {
      filter['offset'] = newPage * filter['limit'];
    });
    fetchCities();
  }

  void showFlushbarWithRootNavigator(Flushbar flushbar, BuildContext context) {
    Navigator.of(context, rootNavigator: true).push(
      FlushbarRoute(
        flushbar: flushbar,
      ),
    );
  }

  void openCityForm(City? city) {
    setState(() {
      _showForm = true;
      _cityToEdit = city;
    });
  }

  void _closeCityForm({bool success = false}) {
    setState(() {
      _showForm = false;
      _cityToEdit = null;
    });
    if (success) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        fetchCities();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gradovi'),
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
                  controller: TextEditingController(
                    text: filter['searchText'],
                  ),
                  onChanged: _debouncedSearch,
                ),
              ),
              Expanded(
                child: isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : HorizontalDataTable(
                  leftHandSideColumnWidth: 150,
                  rightHandSideColumnWidth: 650,
                  isFixedHeader: true,
                  headerWidgets: _buildHeaders(),
                  leftSideItemBuilder: (context, index) =>
                      _buildLeftColumn(context, data[index]),
                  rightSideItemBuilder: (context, index) =>
                      _buildRightColumn(context, data[index]),
                  itemCount: data.length,
                  rowSeparatorWidget: Divider(color: Colors.grey[300], height: 1.0),
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
                          ? () => _changePage((filter['offset'] / filter['limit']).floor() - 1)
                          : null,
                      child: const Text('Prethodna'),
                    ),
                    Text('Stranica ${(filter['offset'] / filter['limit']).floor() + 1}'),
                    ElevatedButton(
                      onPressed: (filter['offset'] + filter['limit']) < data.length
                          ? () => _changePage((filter['offset'] / filter['limit']).floor() + 1)
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
              onTap: () => _closeCityForm(),
              child: Container(
                color: Colors.black54,
                child: Center(
                  child: GestureDetector(
                    onTap: () {},
                    child: CityForm(
                      city: _cityToEdit,
                      onClose: _closeCityForm,
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
      _buildHeaderItem('Država', 200, sortable: true, sortField: 'countryId'),
      _buildHeaderItem('Poštanski broj', 120, sortable: true, sortField: 'postcode'),
      Container(
        width: 100,
        height: 56,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 8),
        child: ElevatedButton.icon(
          onPressed: () {
            openCityForm(null); // Open form for adding
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

  Widget _buildHeaderItem(String label, double width, {bool sortable = false, String? sortField}) {
    return GestureDetector(
      onTap: sortable
          ? () => _sort(sortField!, filter['sortBy'] != sortField || filter['sortOrder'] == 'desc')
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
                    ? (filter['sortOrder'] == 'asc' ? Icons.arrow_upward : Icons.arrow_downward)
                    : Icons.unfold_more,
                size: 16,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildLeftColumn(BuildContext context, City city) {
    return Container(
      width: 150,
      height: 52,
      alignment: Alignment.center,
      child: Row(
        children: [
          Tooltip(
            message: 'Uredi grad',
            child: IconButton(
              icon: const Icon(Icons.edit, color: Colors.blue),
              onPressed: () {
                openCityForm(city); // Open form for editing
              },
            ),
          ),
          Tooltip(
            message: 'Obriši grad',
            child: IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () async {
                await _cityProvider.delete(city.id!);
                fetchCities();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRightColumn(BuildContext context, City city) {
    return Row(
      children: [
        _buildCell(Text(city.name ?? '-'), 250),
        _buildCell(Text(city.countryName ?? '-'), 200),
        _buildCell(Text(city.postcode ?? '-'), 100),
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