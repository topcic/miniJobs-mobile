import 'package:minijobs_admin/models/city.dart';
import 'package:minijobs_admin/providers/base_provider.dart';

class CityProvider extends BaseProvider<City> {
  CityProvider(): super("cities");
    @override
  City fromJson(data) {
    return City.fromJson(data);
  }
}