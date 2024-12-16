import 'package:dio/dio.dart';
import 'package:minijobs_mobile/models/applicant/applicant.dart';
import 'package:minijobs_mobile/models/job/job.dart';
import 'package:minijobs_mobile/models/search_result.dart';
import 'package:minijobs_mobile/providers/base_provider.dart';

import '../enumerations/sort_order.dart';
import '../models/job/job_application.dart';
import '../services/notification.service.dart';

class ApplicantProvider extends BaseProvider<Applicant> {
  @override
  final notificationService = NotificationService();
  List<Job>? _savedJobs;
  List<JobApplication>? _appliedJobs;

  ApplicantProvider() : super("applicants");
  @override
  Applicant fromJson(data) {
    return Applicant.fromJson(data);
  }
  List<Job>? get savedJobs => _savedJobs;
  List<JobApplication>? get appliedJobs => _appliedJobs;


  Future<SearchResult<Applicant>> searchApplicants({
    String? searchText,
    int? cityId,
    required SortOrder sort,
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
      url += "&SortOrder=${sort.name}";
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
      var url = "${baseUrl}applicants/saved-jobs";
      var response = await dio.get(url); // Use the dio getter here
      List<Job> responseData =
          List<Job>.from(response.data.map((item) => Job.fromJson(item)));
      _savedJobs = responseData;
      notifyListeners();
      return responseData;
    } catch (err) {
      throw Exception(err.toString());
    }
  }

  Future<List<JobApplication>> getAppliedJobs() async {
    try {
      var url = "${baseUrl}applicants/applied-jobs";
      var response = await dio.get(url); // Use the dio getter here
      List<JobApplication> responseData =
          List<JobApplication>.from(response.data.map((item) => JobApplication.fromJson(item)));
      _appliedJobs = responseData;
      notifyListeners();
      return responseData;
    } catch (err) {
      throw Exception(err.toString());
    }
  }

  @override
  Future<Applicant> update(int id, [dynamic request]) async {
    var url = "${baseUrl}applicants/$id";
   List<int> jobTypesList = request.jobTypes ?? [];
Map<String, dynamic> formDataMap = {
  'firstName': request.firstName,
  'lastName': request.lastName,
  'phoneNumber': request.phoneNumber,
  'cityId': request.cityId,
  'description': request.description,
  'experience': request.experience,
  'wageProposal': request.wageProposal,
};

// Add each job type as a separate form data item
for (int i = 0; i < jobTypesList.length; i++) {
  formDataMap['jobTypes[$i]'] = jobTypesList[i].toString();
}

var formData = FormData.fromMap(formDataMap);

if (request.cvFile != null) {
  formData.files.add(MapEntry(
    'cvFile', 
    MultipartFile.fromBytes(request.cvFile!,
      filename: request.cvFileName),
  ));
}

    var response = await dio.put(url, data: formData);

    return fromJson(response.data);
  }

  Future<Job?> saveJob(int jobId) async {
    try {
      var url = "${baseUrl}applicants/saved-jobs/$jobId";
     // dio.options.headers['Content-Type'] = 'application/json';

      // Send the request with the status serialized as JSON
      var response = await dio.post(url);
    Job responseData = Job.fromJson(response.data);
      //   notificationService.success("Uspješno ste spremili posao");
      return responseData;
    } catch (err) {
      handleError(err);
      return null;
    }
  }
  Future<Job?> unsaveJob(int jobId) async {
    try {
      var url = "${baseUrl}applicants/saved-jobs/$jobId";

      var response = await dio.delete(url);
      Job responseData = Job.fromJson(response.data);
          notificationService.success("Uspješno ste uklonili posao");
      return responseData;
    } catch (err) {
      handleError(err);
return null;
    }
  }
}
