import 'dart:convert';

import '../models/job_recommendation/job_recommendation.dart';
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
}
