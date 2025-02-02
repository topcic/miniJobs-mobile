import 'dart:convert';

import 'package:dio/dio.dart';

import '../models/job_recommendation/job_recommendation.dart';
import '../models/job_recommendation/job_recommendation_dto.dart';
import '../models/search_result.dart';
import '../services/notification.service.dart';
import 'base_provider.dart';

class JobRecommendationProvider extends BaseProvider<JobRecommendation> {
  @override
  final notificationService = NotificationService();

  JobRecommendationProvider() : super("job-recommendations");

  @override
  JobRecommendation fromJson(data) {
    return JobRecommendation.fromJson(data);
  }

  @override
  Future<JobRecommendation?> insert(dynamic request) async {
    try {
      var jsonRequest = jsonEncode(request.toJson());
      var url = "${baseUrl}job-recommendations";

      var response = await dio.post(url, data: jsonRequest);

      notificationService.success("Uspješno ste dodali preporuke");
      return fromJson(response.data);
    } catch (err) {
      handleError(err);
      return null;
    }
  }

  Future<SearchResult<JobRecommendationDto>> search(Map<String, dynamic>? params) async {
    try {
      var url =
          "${baseUrl}job-recommendations/search";
      final queryParameters = buildHttpParams(params ?? {});

      // Make GET request
      final response = await dio.get(url, queryParameters: queryParameters);
      var data = response.data as Map<String, dynamic>;

      var result = (data['result'] as List<dynamic>)
          .map((item) => JobRecommendationDto.fromJson(item as Map<String, dynamic>))
          .toList();
      var count = data['count'] as int;
      return SearchResult<JobRecommendationDto>(count, result);
    } on DioException catch (err) {
      throw Exception(err.message);
    }
  }
}
