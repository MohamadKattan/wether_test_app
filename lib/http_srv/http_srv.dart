import 'package:dio/dio.dart';

import '../config.dart';
import '../models/result_model.dart';

class HttpSrv {
  final dio = Dio(
    BaseOptions(
      sendTimeout: const Duration(milliseconds: 5000),
      receiveTimeout: const Duration(milliseconds: 5000),
      validateStatus: (status) => status! < 500,
      headers: {'Content-Type': 'application/json'},
    ),
  );

  Future<ResultController> getData({String? city}) async {
    try {
      String path = 'current.json?key=$apiKey&q=${city ?? 'omsk'}';
      dio.options.baseUrl = baseUrl;
      final response = await dio.get(path);
      if (response.statusCode != null &&
          (response.statusCode! < 200 || response.statusCode! >= 300)) {
        return ResultController(
            data: response.data, status: ResultsLevel.fail, error: 'error');
      }
      return ResultController(
          data: response.data, status: ResultsLevel.success);
    } catch (e) {
      return ResultController(error: e.toString(), status: ResultsLevel.fail);
    }
  }
}
