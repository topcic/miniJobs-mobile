import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:minijobs_mobile/enumerations/job_statuses.dart';
import 'package:minijobs_mobile/models/applicant/applicant.dart';
import 'package:minijobs_mobile/models/job/job.dart';
import 'package:minijobs_mobile/providers/base_provider.dart';

import '../enumerations/sort_order.dart';
import '../models/job/job_step1_request.dart';
import '../models/job/job_step2.request.dart';
import '../models/job/job_step3_request.dart';
import '../models/search_result.dart';
import '../services/notification.service.dart';

class JobProvider extends BaseProvider<Job> {
  @override
  final notificationService = NotificationService();
  Job? _currentJob;

  JobProvider() : super("jobs");

  @override
  Job fromJson(data) {
    return Job.fromJson(data);
  }

  Future<void> setCurrentJob(Job? job) async {
    _currentJob = job;
    notifyListeners();
  }

  Job? getCurrentJob() {
    return _currentJob;
  }

  Future<Job?> apply(int id, bool apply) async {
    try {
      var url = "${baseUrl}jobs/$id/apply";
      dio.options.headers['Content-Type'] = 'application/json';

      // Send the request with the status serialized as JSON
      var response = await dio.post(url, data: apply);
      Job responseData = Job.fromJson(response.data);
      if (apply) {
        notificationService.success("Uspješno steaplicirali na posao");
      }
      return responseData;
    } catch (err) {
      handleError(err);
      handleError(err);
      return null;
    }
  }

  Future<Job?> updateStep1(int id, JobStep1Request request) async {
    try {
      var url = "${baseUrl}jobs/$id/step1";
      var jsonRequest = jsonEncode(request);

      var response = await dio.put(url, data: jsonRequest);
      Job responseData = Job.fromJson(response.data);
      notificationService.success("Uspješno ste spasili promjene.");
      return responseData;
    } catch (err) {
      handleError(err);
      return null;
    }
  }

  Future<Job?> updateStep2(int id, JobStep2Request request) async {
    try {
      var url = "${baseUrl}jobs/$id/step2";
      var jsonRequest = jsonEncode(request);

      var response = await dio.put(url, data: jsonRequest);
      Job responseData = Job.fromJson(response.data);
      notificationService.success("Uspješno ste spasili promjene.");
      return responseData;
    } catch (err) {
      handleError(err);
      return null;
    }
  }

  Future<Job?> updateStep3(int id, JobStep3Request request) async {
    try {
      var url = "${baseUrl}jobs/$id/step3";
      var jsonRequest = jsonEncode(request);

      var response = await dio.put(url, data: jsonRequest);
      Job responseData = Job.fromJson(response.data);
      notificationService.success("Uspješno ste spasili promjene.");
      return responseData;
    } catch (err) {
      handleError(err);
      return null;
    }
  }

  Future<Job?> activate(int id, JobStatus status) async {
    try {
      var url = "${baseUrl}jobs/$id/activate";
      dio.options.headers['Content-Type'] = 'application/json';

      // Send the request with the status serialized as JSON
      var response = await dio.put(url, data: status.index.toString());
      Job responseData = Job.fromJson(response.data);
      notificationService.success("Uspješno postavljen posao");
      return responseData;
    } catch (err) {
      handleError(err);
      return null;
    }
  }

  Future<Job?> finish(int id) async {
    try {
      var url = "${baseUrl}jobs/$id/finish";

      var response = await dio.put(url);
      Job responseData = Job.fromJson(response.data);
      notificationService.success("Uspješno završen posao");
      return responseData;
    } catch (err) {
      handleError(err);
      return null;
    }
  }

  Future<List<Applicant>> getApplicantsForJob(int jobId) async {
    try {
      var url = "${baseUrl}jobs/$jobId/applicants";
      var response = await dio.get(url);

      List<Applicant> responseData = List<Applicant>.from(
          response.data.map((item) => Applicant.fromJson(item)));
      return responseData;
    } catch (err) {
      throw Exception(err.toString());
    }
  }

  Future<SearchResult<Job>> search({
    String? searchText,
    int? cityId,
    required SortOrder sort,
    int limit = 10,
    int offset = 0,
  }) async {
    try {
      var url =
          "${baseUrl}jobs/search?SearchText=$searchText&Limit=$limit&Offset=$offset";

      if (cityId != null) {
        url += "&CityId=$cityId";
      }

      url += "&SortOrder=${sort.name}";

      var response = await dio.get(url);
      var data = response.data as Map<String, dynamic>;

      var result = (data['result'] as List<dynamic>)
          .map((item) => Job.fromJson(item as Map<String, dynamic>))
          .toList();
      var count = data['count'] as int;
      return SearchResult<Job>(count, result);
    } on DioException catch (err) {
      throw Exception(err.message);
    }
  }
}
