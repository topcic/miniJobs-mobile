
import '../models/job/job.dart';
import 'base_provider.dart';

class RecommendationProvider extends BaseProvider<Job> {
  RecommendationProvider(): super("recommendations");
  @override
  Job fromJson(data) {
    return Job.fromJson(data);
  }

  Future<List<Job>> getRecommendatios() async {
    try {
      var url = "${baseUrl}recommendations/jobs";
      var response = await dio.get(url);

      List<Job> responseData = List<Job>.from(
          response.data.map((item) => Job.fromJson(item)));
      return responseData;
    } catch (err) {
      throw Exception(err.toString());
    }
  }
}