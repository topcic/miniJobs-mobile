import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import '../services/config_service.dart';
import '../services/notification.service.dart';

abstract class BaseProvider<T> with ChangeNotifier {
  static String? _baseUrl;
  String _endpoint = "";
  final GetStorage _getStorage = GetStorage();
  final NotificationService notificationService = NotificationService();
  late final Dio _dio;

  BaseProvider(String endpoint) {
    _endpoint = endpoint;
    // Check if _baseUrl is null and throw an exception if it is
    if (_baseUrl == null) {
       throw Exception(
          'Base URL is not initialized. Ensure BaseProvider.initializeBaseUrl() is called in main.dart.');
    }
    _dio = Dio(BaseOptions(
      baseUrl: _baseUrl!,
      responseType: ResponseType.json,
      contentType: "application/json",
    ));
    _dio.options.headers["Accept-Language"] = "bs";

    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        options.headers["Accept"] = "application/json";
        options.headers["Accept-Language"] = "bs";
        String? token = _getStorage.read('accessToken');
        print("Access Token in onRequest: $token"); // Debug statement
        if (token != null) {
          options.headers["Authorization"] = "Bearer $token";
        }
        handler.next(options); // Ensure the request continues
      },
      onError: (error, handler) async {
        if (error.response?.statusCode == 401) {
          final newAccessToken = await refreshToken();
          if (newAccessToken != null) {
            // Retry the failed request with new access token
            final opts = error.requestOptions;
            opts.headers["Authorization"] = "Bearer $newAccessToken";
            final cloneReq = await _dio.request(
              opts.path,
              options: Options(
                method: opts.method,
                headers: opts.headers,
              ),
              data: opts.data,
              queryParameters: opts.queryParameters,
            );
            return handler.resolve(cloneReq);
          }
        }
        handler.next(error);
      },
    ));
  }

  // Static method to initialize _baseUrl globally
  static Future<void> initializeBaseUrl() async {
    if (_baseUrl == null) {
      final config = ConfigService();
      await config.init();
      _baseUrl = config.getBaseUrl();
    }
  }

  Dio get dio => _dio;

  Future<String?> refreshToken() async {
    try {
      String? refreshToken = _getStorage.read('refreshToken');
      var refreshTokenRequest = {
        'GrantType': 'refresh',
        'RefreshToken': refreshToken
      };
      var response = await _dio.post('tokens', data: refreshTokenRequest);
      final newAccessToken = response.data['accessToken'];
      _getStorage.write('accessToken', newAccessToken);
      return newAccessToken;
    } catch (err) {
      _getStorage.erase();
      // Get.offAllNamed(Route.login); // Uncomment if using GetX navigation
    }
    return null;
  }

  Future<List<T>> getAll() async {
    try {
      var response = await _dio.get(_endpoint);
      List<dynamic> responseData = response.data;
      List<T> dataList = responseData.map((item) => fromJson(item)).toList();
      return dataList;
    } catch (err) {
      handleError(err);
      throw Exception(err.toString());
    }
  }

  Future<T> get(int id) async {
    try {
      var url = "$_endpoint/$id";
      var response = await _dio.get(url);
      return fromJson(response.data);
    } catch (err) {
      handleError(err);
      throw Exception(err.toString());
    }
  }

  Future<T?> insert(dynamic request) async {
    var jsonRequest = jsonEncode(request);
    try {
      var response = await _dio.post(_endpoint, data: jsonRequest);
      notificationService.success("Uspješno ste dodali.");
      return fromJson(response.data);
    } catch (err) {
        handleError(err);
    }
  }

  void handleError2(Object err) {
    if (err is DioException) {
      if (err.response != null) {
        if (err.response!.data != null)
          throw err.response!.data;
        else
          notificationService.error(err.response!.toString());
      }
    }
  }

  Future<T> update(int id, [dynamic request]) async {
    var url = "$_endpoint/$id";
    var jsonRequest = jsonEncode(request);
    try {
      var response = await _dio.put(url, data: jsonRequest);
      notificationService.success("Uspješno ste spasili promjene.");
      return fromJson(response.data);
    } catch (err) {
      handleError(err);
      throw Exception(err.toString());
    }
  }

  Future<void> delete(int id) async {
    try {
      var url = "$_endpoint/$id";
      await _dio.delete(url);
      notificationService.success("Uspješno ste izbrisali.");
    } catch (err) {
      handleError(err);
      throw Exception(err.toString());
    }
  }

  T fromJson(data) {
    throw Exception("Method not implemented");
  }

  Map<String, String> createHeaders() {
    var token = _getStorage.read('accessToken');
    String bearerAuth = "Bearer $token";
    var headers = {
      "Content-Type": "application/json",
      "Authorization": token != null ? bearerAuth : ""
    };
    return headers;
  }

  String getQueryString(Map params,
      {String prefix = '&', bool inRecursion = false}) {
    String query = '';
    params.forEach((key, value) {
      if (inRecursion) {
        if (key is int) {
          key = '[$key]';
        } else if (value is List || value is Map) {
          key = '.$key';
        } else {
          key = '.$key';
        }
      }
      if (value is String || value is int || value is double || value is bool) {
        var encoded = value;
        if (value is String) {
          encoded = Uri.encodeComponent(value);
        }
        query += '$prefix$key=$encoded';
      } else if (value is DateTime) {
        query += '$prefix$key=${(value).toIso8601String()}';
      } else if (value is List || value is Map) {
        if (value is List) value = value.asMap();
        value.forEach((k, v) {
          query +=
              getQueryString({k: v}, prefix: '$prefix$key', inRecursion: true);
        });
      }
    });
    return query;
  }

  String get baseUrl => _baseUrl!;

  void handleError(Object err) {
    if (err is DioException) {
      if (err.response != null) {
        if (err.response!.data != null) if (err.response!.data
            is Map<String, dynamic>)
          throw err.response!.data;
        else
          notificationService.error(err.response!.data);
        else
          notificationService.error(err.response!.toString());
      }
    }
  }

  Map<String, dynamic> buildHttpParams(Map<String, dynamic> data) {
    final Map<String, dynamic> queryParams = {};

    data.forEach((key, value) {
      if (value is DateTime) {
        queryParams[key] = value.toIso8601String();
      } else if (value is List) {
        queryParams[key] = value.join(',');
      } else {
        queryParams[key] = value;
      }
    });

    return queryParams;
  }
}
