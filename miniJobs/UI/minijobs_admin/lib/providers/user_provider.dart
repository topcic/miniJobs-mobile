
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:minijobs_admin/models/job/job.dart';
import 'package:minijobs_admin/models/job_recommendation/job_recommendation.dart';
import 'package:minijobs_admin/models/rating.dart';
import 'package:minijobs_admin/models/user/user.dart';
import 'package:minijobs_admin/providers/base_provider.dart';

import '../models/search_result.dart';
import '../models/user/user_change_password_request.dart';

class UserProvider extends BaseProvider<User> {
  UserProvider() : super("users");

  @override
  User fromJson(data) {
    return User.fromJson(data);
  }

  Future<List<Rating>> getUserRatings(int userId) async {
    try {
      var url = "${baseUrl}users/$userId/ratings";
      var response = await dio.get(url);
      List<Rating> responseData =
          List<Rating>.from(response.data.map((item) => Rating.fromJson(item)));
      return responseData;
    } catch (err) {
      throw Exception(err.toString());
    }
  }

  Future<List<Job>> getUserFinishedJobs(int userId) async {
    try {
      var url = "${baseUrl}users/$userId/finishedjobs";
      var response = await dio.get(url);
      List<Job> responseData =
          List<Job>.from(response.data.map((item) => Job.fromJson(item)));
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

  Future<JobRecommendation?> findJobRecommendation(int userId) async {
    try {
      var url = "${baseUrl}users/$userId/job-recommendations";
      var response = await dio.get(url);
      JobRecommendation responseData = JobRecommendation.fromJson(
          response.data);
      return responseData;
    } catch (err) {
      handleError(err);
      return null;
    }
  }

  Future<bool?> forgotPassword(String email) async {
    try {
      var url = "${baseUrl}users/forgotpassword";
      dio.options.headers['Content-Type'] = 'application/json';
      var response = await dio.post(
        url,
        data: '"$email"', // Wrap the email in double quotes to send it as a plain JSON string
      );
      var responseData = response.data;
      return responseData;
    } catch (err) {
      handleError(err);
      return null;
    }
  }
  Future<bool?> changePassword(UserChangePasswordRequest request) async {
    try {
      var url = "${baseUrl}users/password";
      var jsonRequest = jsonEncode(request);

      var response = await dio.post(url, data: jsonRequest);
      if (response.data is bool) {
        bool responseData = response.data;
        if(responseData) {
          notificationService.success("Uspješno ste promjenili lozinku.");
        }
        return responseData;
      }
   else {
        return false;
      }
    } catch (err) {
      handleError(err);
      return null;
    }
  }
  Future<SearchResult<User>> search(Map<String, dynamic>? params) async {
    try {
      var url =
          "${baseUrl}users/search";
      final queryParameters = buildHttpParams(params ?? {});

      // Make GET request
      final response = await dio.get(url, queryParameters: queryParameters);
      var data = response.data as Map<String, dynamic>;

      var result = (data['result'] as List<dynamic>)
          .map((item) => User.fromJson(item as Map<String, dynamic>))
          .toList();
      var count = data['count'] as int;
      return SearchResult<User>(count, result);
    } on DioException catch (err) {
      throw Exception(err.message);
    }
  }
}
