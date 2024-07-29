import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:minijobs_mobile/models/job/job.dart';
import 'package:minijobs_mobile/models/rating.dart';
import 'package:minijobs_mobile/models/user.dart';
import 'package:minijobs_mobile/providers/base_provider.dart';

class UserProvider extends BaseProvider<User> {
  UserProvider(): super("users");
    @override
  User fromJson(data) {
    return User.fromJson(data);
  }
    Future<List<Rating>> getUserRatings(int userId) async {
    try {
        var url = "${baseUrl}users/$userId/ratings";
      var response = await dio.get(url);
     List<Rating> responseData = List<Rating>.from(response.data.map((item) => Rating.fromJson(item)));
    return responseData;

    } catch (err) {
      throw Exception(err.toString());
    }
  }
   Future<List<Job>> getUserFinishedJobs(int userId) async {
    try {
        var url = "${baseUrl}users/$userId/finishedjobs";
      var response = await dio.get(url);
     List<Job> responseData = List<Job>.from(response.data.map((item) => Job.fromJson(item)));
    return responseData;

    } catch (err) {
      throw Exception(err.toString());
    }
  }
  Future<User> uploadUserPhoto(int userId, MultipartFile photo) async {
    try {
      var url = "${baseUrl}users/$userId/photo";
      var formData = FormData.fromMap({
        'photo': photo,
      });
      var response = await dio.patch(url, data: formData);
      return User.fromJson(response.data);
    } catch (err) {
      throw Exception(err.toString());
    }
  }
}