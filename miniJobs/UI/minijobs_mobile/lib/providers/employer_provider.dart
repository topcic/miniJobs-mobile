import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:minijobs_mobile/models/employer.dart';
import 'package:minijobs_mobile/models/job/job.dart';
import 'package:minijobs_mobile/providers/base_provider.dart';

class EmployerProvider extends BaseProvider<Employer> {
  EmployerProvider(): super("employers");
    @override
  Employer fromJson(data) {
    return Employer.fromJson(data);
  }

  Future<List<Job>> getActiveJobs(int userId) async {
    try {
      var url = "${baseUrl}employers/$userId/activejobs";
      var response = await dio.get(url); // Use the dio getter here
      List<Job> responseData = List<Job>.from(response.data.map((item) => Job.fromJson(item)));
      return responseData;
    } catch (err) {
      throw Exception(err.toString());
    }
  }

}