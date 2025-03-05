import 'package:dio/dio.dart';
import 'package:minijobs_admin/models/city.dart';
import 'package:minijobs_admin/providers/base_provider.dart';

import '../models/search_result.dart';

class CityProvider extends BaseProvider<City> {
  CityProvider(): super("cities");
    @override
  City fromJson(data) {
    return City.fromJson(data);
  }
  Future<SearchResult<City>> searchPublic(Map<String, dynamic>? params) async {
    try {
      var url =
          "${baseUrl}cities/search";
      final queryParameters = buildHttpParams(params ?? {});

      // Make GET request
      final response = await dio.get(url, queryParameters: queryParameters);
      var data = response.data as Map<String, dynamic>;

      var result = (data['result'] as List<dynamic>)
          .map((item) => City.fromJson(item as Map<String, dynamic>))
          .toList();
      var count = data['count'] as int;
      return SearchResult<City>(count, result);
    } on DioException catch (err) {
      throw Exception(err.message);
    }
  }
  Future<City?> activate(int id) async {
    try {
      var url = "${baseUrl}cities/$id/activate";

      var response = await dio.put(url);
      City responseData = City.fromJson(response.data);
      notificationService.success("Uspješno aktivirano");
      return responseData;
    } catch (err) {
      handleError(err);
      return null;
    }
  }
}