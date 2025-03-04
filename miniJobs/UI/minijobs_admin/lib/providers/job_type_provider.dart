import 'package:dio/dio.dart';
import 'package:minijobs_admin/models/job_type.dart';
import 'package:minijobs_admin/providers/base_provider.dart';

import '../models/search_result.dart';

class JobTypeProvider extends BaseProvider<JobType> {
  JobTypeProvider(): super("jobtypes");
    @override
  JobType fromJson(data) {
    return JobType.fromJson(data);
  }
  Future<SearchResult<JobType>> searchPublic(Map<String, dynamic>? params) async {
    try {
      var url =
          "${baseUrl}jobtypes/search";
      final queryParameters = buildHttpParams(params ?? {});

      // Make GET request
      final response = await dio.get(url, queryParameters: queryParameters);
      var data = response.data as Map<String, dynamic>;

      var result = (data['result'] as List<dynamic>)
          .map((item) => JobType.fromJson(item as Map<String, dynamic>))
          .toList();
      var count = data['count'] as int;
      return SearchResult<JobType>(count, result);
    } on DioException catch (err) {
      throw Exception(err.message);
    }
  }
  Future<JobType?> activate(int id) async {
    try {
      var url = "${baseUrl}jobtypes/$id/activate";

      var response = await dio.put(url);
      JobType responseData = JobType.fromJson(response.data);
      notificationService.success("Uspješno aktivirano");
      return responseData;
    } catch (err) {
      handleError(err);
      return null;
    }
  }
}