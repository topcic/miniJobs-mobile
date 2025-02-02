import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:minijobs_admin/providers/base_provider.dart';
import '../models/rating.dart';
import '../models/search_result.dart';
import '../services/notification.service.dart';

class RatingProvider extends BaseProvider<Rating> {
  @override
  final notificationService = NotificationService();
  RatingProvider(): super("ratings");
  @override
  Rating fromJson(data) {
    return Rating.fromJson(data);
  }
  @override
  Future<Rating?> insert(dynamic request) async {
    try {
    var jsonRequest = jsonEncode(request.toJson());
    var url = "${baseUrl}ratings";
    // Send the request to the API endpoint
    var response = await dio.post(url, data: jsonRequest);

    notificationService.success("Uspješno ste ocjenili");
    return fromJson(response.data);
    } catch (err) {
      handleError(err);
      return null;
    }
  }
  Future<SearchResult<Rating>> search(Map<String, dynamic>? params) async {
    try {
      var url =
          "${baseUrl}ratings/search";
      final queryParameters = buildHttpParams(params ?? {});

      // Make GET request
      final response = await dio.get(url, queryParameters: queryParameters);
      var data = response.data as Map<String, dynamic>;

      var result = (data['result'] as List<dynamic>)
          .map((item) => Rating.fromJson(item as Map<String, dynamic>))
          .toList();
      var count = data['count'] as int;
      return SearchResult<Rating>(count, result);
    } on DioException catch (err) {
      throw Exception(err.message);
    }
  }
}
