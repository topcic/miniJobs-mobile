

import '../models/job/job.dart';
import '../models/job/job_card_dto.dart';
import '../models/recommendation_result.dart';
import 'base_provider.dart';

class RecommendationProvider extends BaseProvider<Job> {
  RecommendationProvider(): super("recommendations");
  @override
  Job fromJson(data) {
    return Job.fromJson(data);
  }

  Future<RecommendationResult> getRecommendatios() async {
    try {
      var url = "${baseUrl}recommendations/jobs";
      var response = await dio.get(url);

      RecommendationResult responseData = RecommendationResult.fromJson(response.data);
      return responseData;
    } catch (err) {
      throw Exception(err.toString());
    }
  }
}