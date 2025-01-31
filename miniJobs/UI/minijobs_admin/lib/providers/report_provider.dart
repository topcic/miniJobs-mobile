import 'package:minijobs_admin/models/job/job.dart';
import 'package:minijobs_admin/models/rating.dart';

import '../models/job/job_application.dart';
import 'base_provider.dart';

class ReportProvider extends BaseProvider<Job> {
  ReportProvider() : super("reports");

  @override
  Job fromJson(data) {
    return Job.fromJson(data);
  }

  Future<List<Job>> getJobs() async {
    try {
      var url = "${baseUrl}reports/jobs";
      var response = await dio.get(url); // Use the dio getter here
      List<Job> responseData =
          List<Job>.from(response.data.map((item) => Job.fromJson(item)));
      return responseData;
    } catch (err) {
      throw Exception(err.toString());
    }
  }

  Future<List<JobApplication>> getJobApplications() async {
    try {
      var url = "${baseUrl}reports/job-applications";
      var response = await dio.get(url); // Use the dio getter here
      List<JobApplication> responseData = List<JobApplication>.from(
          response.data.map((item) => JobApplication.fromJson(item)));
      return responseData;
    } catch (err) {
      throw Exception(err.toString());
    }
  }

  Future<List<Rating>> getRatings() async {
    try {
      var url = "${baseUrl}reports/ratings";
      var response = await dio.get(url); // Use the dio getter here
      List<Rating> responseData =
          List<Rating>.from(response.data.map((item) => Rating.fromJson(item)));
      return responseData;
    } catch (err) {
      throw Exception(err.toString());
    }
  }
}
