import 'package:dio/dio.dart';
import 'package:minijobs_mobile/models/applicant.dart';
import 'package:minijobs_mobile/models/job/job.dart';
import 'package:minijobs_mobile/models/search_result.dart';
import 'package:minijobs_mobile/providers/base_provider.dart';

class ApplicantProvider extends BaseProvider<Applicant> {
  ApplicantProvider() : super("applicants");
  @override
  Applicant fromJson(data) {
    return Applicant.fromJson(data);
  }
 Future<SearchResult<Applicant>> searchApplicants({
    String? searchText,
    int? cityId,
    int? jobTypeId,
    int limit = 10,
    int offset = 0,
  }) async {
    try {
      var url = "${baseUrl}applicants/search?SearchText=$searchText&Limit=$limit&Offset=$offset";
      
      if (cityId != null) {
        url += "&CityId=$cityId";
      }

      if (jobTypeId != null) {
        url += "&JobTypeId=$jobTypeId";
      }

      var dio = Dio();
      var response = await dio.get(url);
  var data = response.data;

      // Use the custom SearchResult.fromJson method
      var result = SearchResult<Applicant>.fromJson(
        data,
        (json) => Applicant.fromJson(json as Map<String, dynamic>),
      );

      return result;
    } on DioException catch (err) {
      throw Exception(err.message);
    }
  }

  Future<List<Job>> getSavedJobs() async {
    try {
      var url = "${baseUrl}applicants/savedjobs";
      var response = await dio.get(url); // Use the dio getter here
      List<Job> responseData = List<Job>.from(response.data.map((item) => Job.fromJson(item)));
      return responseData;
    } catch (err) {
      throw Exception(err.toString());
    }
  }

  Future<List<Job>> getAppliedJobs(int userId) async {
    try {
      var url = "${baseUrl}applicants/appliedjobs";
      var response = await dio.get(url); // Use the dio getter here
      List<Job> responseData = List<Job>.from(response.data.map((item) => Job.fromJson(item)));
      return responseData;
    } catch (err) {
      throw Exception(err.toString());
    }
  }
}
