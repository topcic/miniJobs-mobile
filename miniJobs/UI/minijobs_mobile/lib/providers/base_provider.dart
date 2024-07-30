import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

abstract class BaseProvider<T> with ChangeNotifier {
  static String? _baseUrl;
  String _endpoint = "";
  final GetStorage _getStorage = GetStorage();
  late final Dio _dio; // Declare _dio as late

  BaseProvider(String endpoint) {
    _endpoint = endpoint;
    _baseUrl = const String.fromEnvironment("baseUrl",//http://localhost:5020/api/
        defaultValue: "http://localhost:5020/api/");// "http://10.0.2.2:5020/api/
    _dio = Dio(BaseOptions(
      baseUrl: _baseUrl!,
      responseType: ResponseType.json,
      contentType: "application/json",
    ));

    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
  options.headers["Accept"] = "application/json";
  String? token = _getStorage.read('accessToken');
  if (token != null) {
    options.headers["Authorization"] = "Bearer $token";
  }
  return handler.next(options);
},
      onError: (error, handler) async {
        if (error.response?.statusCode == 401) {
          final newAccessToken = await refreshToken();
          if (newAccessToken != null) {
            _dio.options.headers["Authorization"] = "Bearer $newAccessToken";
            return handler.resolve(await _dio.fetch(error.requestOptions));
          }
        }
        return handler.next(error);
      },
    ));
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
      GetStorage().write('accessToken', newAccessToken);
      return newAccessToken;
    } catch (err) {
      _getStorage.erase();
// Get.offAllNamed(Route.login);
    }
    return null;
  }

  // Future<SearchResult<T>> search({dynamic filter}) async {
  //   //var url = "https://localhost:44343/api/users/search?SearchText=&Limit=10&Offset=0&SortBy=&SortOrder=0";
  //   try {
  //     _endpoint =
  //         "users/search?SearchText=&Limit=10&Offset=0&SortBy=&SortOrder=0";
  //     var url = _endpoint;
  //     if (filter != null) {
  //       var queryString = getQueryString(filter);
  //       url = "$url?$queryString";
  //     }

  //     var response = await _dio.get(url);

  //     var data = jsonDecode(response.data);

  //     var result = SearchResult<T>();

  //     result.count = data['count'];

  //     for (var item in data['result']) {
  //       result.result?.add(fromJson(item));
  //     }

  //     return result;
  //   } on DioException catch (err) {
  //     throw new Exception(err.message);
  //   }
  // }

  Future<List<T>> getAll() async {
    try {
      var response = await _dio.get(_endpoint);

      List<dynamic> responseData = response.data;
      List<T> dataList = responseData.map((item) => fromJson(item)).toList();

      return dataList;
    } catch (err) {
      throw Exception(err.toString());
    }
  }
Future<T> get(int id) async {
    try {
       var url = "$_endpoint/$id";
      var response = await _dio.get(url);
         return fromJson(response.data);
    } catch (err) {
      throw Exception(err.toString());
    }
  }
  Future<T> insert(dynamic request) async {
    var jsonRequest = jsonEncode(request);
    var response = await _dio.post(_endpoint, data: jsonRequest);
    return fromJson(response.data);
  }

  Future<T> update(int id, [dynamic request]) async {
    var url = "$_endpoint/$id";
    var jsonRequest = jsonEncode(request);
    var response = await _dio.put(url, data: jsonRequest);
    return fromJson(response.data);
  }

  T fromJson(data) {
    throw Exception("Method not implemented");
  }

  Map<String, String> createHeaders() {
    var token = _getStorage.read('accessToken');
    String bearerAuth = "Bearer $token";
    var headers = {
      "Content-Type": "application/json",
      "Authorization": bearerAuth
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
}
