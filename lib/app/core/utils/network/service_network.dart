import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

@injectable
class ServiceNetwork {
  ServiceNetwork() {
    dioInit();
  }

  String baseUrl = "https://gutendex.com";
  late Dio dio;

  void dioInit() {
    dio = Dio(BaseOptions(
      headers: {
        "Accept": "application/json",
      },
      baseUrl: baseUrl,
      followRedirects: true,
      validateStatus: (status) => status != null && status < 500,
    ));
  }

  Future<Response> get({
    required String url,
    Map<String, dynamic>? query,
    Map<String, dynamic>? headers,
  }) async {
    if (headers != null) {
      dio.options.headers.addAll(headers);
    }
    Response response = await dio.get(url, queryParameters: query);
    return response;
  }

  Future<Response> post({
    required String url,
    Map<String, dynamic>? query,
    Object? data,
  }) async {
    Response response = await dio.post(url, queryParameters: query, data: data);
    return response;
  }
}
