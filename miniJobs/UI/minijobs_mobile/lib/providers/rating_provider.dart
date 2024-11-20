import 'dart:convert';

import 'package:minijobs_mobile/providers/base_provider.dart';

import '../models/rating.dart';
import '../services/notification.service.dart';

class RatingProvider extends BaseProvider<Rating> {
  final notificationService = NotificationService();
  RatingProvider(): super("ratings");
  @override
  Rating fromJson(data) {
    return Rating.fromJson(data);
  }
  @override
  Future<Rating?> insert(dynamic request) async {
    try {
    var jsonRequest = jsonEncode(request.toJson());
    var url = "${baseUrl}ratings";
    // Send the request to the API endpoint
    var response = await dio.post(url, data: jsonRequest);

    notificationService.success("Uspješno ste ocjenili");
    return fromJson(response.data);
    } catch (err) {
      handleError(err);
      return null;
    }
  }
}
