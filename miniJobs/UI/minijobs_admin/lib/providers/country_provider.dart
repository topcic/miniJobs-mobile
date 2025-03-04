import 'package:dio/dio.dart';
import 'package:minijobs_admin/providers/base_provider.dart';
import '../models/country.dart';
import '../models/search_result.dart';

class CountryProvider extends BaseProvider<Country> {
  CountryProvider(): super("countries");
  @override
  Country fromJson(data) {
    return Country.fromJson(data);
  }

  Future<SearchResult<Country>> searchPublic(Map<String, dynamic>? params) async {
    try {
      var url =
          "${baseUrl}countries/search";
      final queryParameters = buildHttpParams(params ?? {});

      // Make GET request
      final response = await dio.get(url, queryParameters: queryParameters);
      var data = response.data as Map<String, dynamic>;

      var result = (data['result'] as List<dynamic>)
          .map((item) => Country.fromJson(item as Map<String, dynamic>))
          .toList();
      var count = data['count'] as int;
      return SearchResult<Country>(count, result);
    } on DioException catch (err) {
      throw Exception(err.message);
    }
  }
  Future<Country?> activate(int id) async {
    try {
      var url = "${baseUrl}countries/$id/activate";

      var response = await dio.put(url);
      Country responseData = Country.fromJson(response.data);
      notificationService.success("Uspješno aktivirano");
      return responseData;
    } catch (err) {
      handleError(err);
      return null;
    }
  }
}