import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:todo_apps/data/repository/responses/todo_response.dart';

class ApiServices {
  final String baseUrl = "http://10.0.2.2:5000";
  final String apiKey = "";

  Dio _dio = Dio();
  ApiServices({Dio? dio}) {
    _dio = dio ?? Dio();
    if (kDebugMode) {
      _dio.interceptors.add(PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
      ));
    }
  }

  Future<TodoResponse?> getTodo() async {
    try {
      Response response = await _dio.get(baseUrl);
      if (response.statusCode == 200) {
        return TodoResponse.fromJson(response.data);
      }
      return null;
    } catch (e) {
      return TodoResponse.withError(e.toString());
    }
  }

  Future<String?> addPostTodo(Map data) async {
    try {
      Response response = await _dio.post(
        baseUrl,
        data: data,
      );
      return response.statusMessage;
    } catch (e) {
      return "Gagal : ${e.toString()}";
    }
  }

  Future<String?> updateTodoData(Map data) async {
    try {
      Response response = await _dio.put(
        baseUrl,
        data: data,
      );
      return response.statusMessage;
    } catch (e) {
      return "Gagal : ${e.toString()}";
    }
  }

  Future<String?> deleteTodoData(int id) async {
    try {
      Response response = await _dio.delete(
        '$baseUrl/$id',
      );
      return response.statusMessage;
    } catch (e) {
      return "Gagal : ${e.toString()}";
    }
  }
}
