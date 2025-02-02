import 'package:dio/dio.dart';
import 'package:minijobs_admin/models/saved_job.dart';
import '../models/search_result.dart';
import '../services/notification.service.dart';
import 'base_provider.dart';

class SavedJobProvider extends BaseProvider<SavedJob> {
  @override
  final notificationService = NotificationService();

  SavedJobProvider() : super("saved-jobs");

  @override
  SavedJob fromJson(data) {
    return SavedJob.fromJson(data);
  }

  Future<SearchResult<SavedJob>> search(Map<String, dynamic>? params) async {
    try {
      var url =
          "${baseUrl}saved-jobs/search";
      final queryParameters = buildHttpParams(params ?? {});

      // Make GET request
      final response = await dio.get(url, queryParameters: queryParameters);
      var data = response.data as Map<String, dynamic>;

      var result = (data['result'] as List<dynamic>)
          .map((item) => SavedJob.fromJson(item as Map<String, dynamic>))
          .toList();
      var count = data['count'] as int;
      return SearchResult<SavedJob>(count, result);
    } on DioException catch (err) {
      throw Exception(err.message);
    }
  }
}
