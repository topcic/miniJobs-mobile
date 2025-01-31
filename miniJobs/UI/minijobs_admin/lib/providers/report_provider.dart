import 'package:minijobs_admin/models/job/job.dart';

import 'base_provider.dart';

class ReportProvider extends BaseProvider<Job> {
  ReportProvider(): super("reports");
  @override
  Job fromJson(data) {
    return Job.fromJson(data);
  }

  Future<List<Job>> getJobs() async {
    try {
      var url = "${baseUrl}reports/jobs";
      var response = await dio.get(url); // Use the dio getter here
      List<Job> responseData = List<Job>.from(
          response.data.map((item) => Job.fromJson(item)));
      return responseData;
    } catch (err) {
      throw Exception(err.toString());
    }
  }
}