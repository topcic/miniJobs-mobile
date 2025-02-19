
import '../models/job/job.dart';
import '../models/job/job_card_dto.dart';
import 'base_provider.dart';

class RecommendationProvider extends BaseProvider<Job> {
  RecommendationProvider(): super("recommendations");
  @override
  Job fromJson(data) {
    return Job.fromJson(data);
  }

  Future<List<JobCardDTO>> getRecommendatios() async {
    try {
      var url = "${baseUrl}recommendations/jobs";
      var response = await dio.get(url);

      List<JobCardDTO> responseData = List<JobCardDTO>.from(
          response.data.map((item) => JobCardDTO.fromJson(item)));
      return responseData;
    } catch (err) {
      throw Exception(err.toString());
    }
  }
}