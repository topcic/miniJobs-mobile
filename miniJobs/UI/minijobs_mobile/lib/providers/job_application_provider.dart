
import '../models/job/job_application.dart';
import '../services/notification.service.dart';
import 'base_provider.dart';

class JobApplicationProvider extends BaseProvider<JobApplication> {
  final notificationService = NotificationService();

  JobApplicationProvider() : super("jobs");
  @override
  JobApplication fromJson(data) {
    return JobApplication.fromJson(data);
  }

  Future<JobApplication?> apply(int jobId) async {
    try {
      var url = "${baseUrl}jobs/$jobId/applications";
      var response = await dio.post(url);
      JobApplication responseData = JobApplication.fromJson(response.data);
      notificationService.success("Uspješno ste aplicirali.");
      return responseData;
    } catch (err) {
      handleError(err);
      return null;
    }
  }
  Future<JobApplication?> delete(int jobId) async {
    try {
      var url = "${baseUrl}jobs/$jobId/applications";

      var response = await dio.delete(url);
      JobApplication responseData = JobApplication.fromJson(response.data);
      notificationService.success("Uspješno ste poništili aplikaciju.");
      return responseData;
    } catch (err) {
      handleError(err);
      return null;
    }
  }
}