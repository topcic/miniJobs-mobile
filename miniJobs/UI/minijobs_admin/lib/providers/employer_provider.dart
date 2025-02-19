import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:minijobs_admin/models/employer/employer.dart';
import 'package:minijobs_admin/models/job/job.dart';
import 'package:minijobs_admin/providers/base_provider.dart';
import '../models/employer/employer_save_request.dart';
import '../models/job/job_card_dto.dart';
import '../models/search_result.dart';

class EmployerProvider extends BaseProvider<Employer> {
  EmployerProvider() : super("employers");

  @override
  Employer fromJson(data) {
    return Employer.fromJson(data);
  }

  Future<List<JobCardDTO>> getActiveJobs(int userId) async {
    try {
      var url = "${baseUrl}employers/$userId/activejobs";
      var response = await dio.get(url); // Use the dio getter here
      List<JobCardDTO> responseData = List<JobCardDTO>.from(response.data.map((item) => JobCardDTO.fromJson(item)));
      return responseData;
    } catch (err) {
      throw Exception(err.toString());
    }
  }

  Future<List<Job>> getJobs(int userId) async {
    try {
      var url = "${baseUrl}employers/$userId/jobs";
      var response = await dio.get(url); // Use the dio getter here
      List<Job> responseData = List<Job>.from(response.data.map((item) => Job.fromJson(item)));
      return responseData;
    } catch (err) {
      throw Exception(err.toString());
    }
  }

  @override
  Future<Employer> update(int id, [dynamic request]) async {
    if (request is! EmployerSaveRequest) {
      throw ArgumentError('Request must be of type EmployerSaveRequest');
    }

    var url = "${baseUrl}employers/$id";
    var jsonRequest = request.toJson();
    var response = await dio.put(url, data: jsonEncode(jsonRequest)); // Make sure to encode JSON

    return fromJson(response.data);
  }

  Future<SearchResult<Employer>> searchPublic(Map<String, dynamic>? params) async {
    try {
      var url =
          "${baseUrl}employers/public-search";
      final queryParameters = buildHttpParams(params ?? {});

      // Make GET request
      final response = await dio.get(url, queryParameters: queryParameters);
      var data = response.data as Map<String, dynamic>;

      var result = (data['result'] as List<dynamic>)
          .map((item) => Employer.fromJson(item as Map<String, dynamic>))
          .toList();
      var count = data['count'] as int;
      return SearchResult<Employer>(count, result);
    } on DioException catch (err) {
      throw Exception(err.message);
    }
  }
}
