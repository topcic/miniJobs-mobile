import 'package:minijobs_mobile/models/city.dart';
import 'package:minijobs_mobile/providers/base_provider.dart';

class CityProvider extends BaseProvider<City> {
  CityProvider(): super("cities");
    @override
  City fromJson(data) {
    return City.fromJson(data);
  }
}