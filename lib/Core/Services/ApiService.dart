import 'package:dio/dio.dart';
import 'dart:convert';
import 'package:genopets/Core/Services/ResponseModel.dart';
import 'package:genopets/models.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  late String _url;

  // ignore: prefer_final_fields
  Map<String, String> _headers = {
    "Content-Type": "application/json",
    "Accept": "application/json",
    "Access-Control-Allow-Origin": "*",
    "Access-Control-Allow-Methods": "GET, POST, PATCH, PUT, DELETE, OPTIONS",
    "Access-Control-Allow-Headers": "Origin, Content-Type, X-Auth-Token",
  };

  String get url => _url;
  Map<String, String> get headers => _headers;

  set url(String url) {
    _url = url;
  }

  set token(String token) {
    _headers["Authorization"] = "Bearer $token";
  }

  set headers(Map<String, String> headers) {
    _headers.addAll(headers);
  }

  void setToken(String token) {
    this._headers["Authorization"] = "Bearer " + token;
  }

  static final ApiService _apiService = ApiService._internal();

  ApiService._internal();

  factory ApiService({String? url}) {
    if (url!.isNotEmpty) {
      _apiService._url = url;
    }
    return _apiService;
  }

  Future checkToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('access_token');
    if (accessToken == null || accessToken.isEmpty) {
      return false;
    }

    String expiration = prefs.getString("expires_in") ?? "";
    DateTime expirationDate = DateTime.parse(expiration);
    if (DateTime.now().isBefore(expirationDate)) {
      _headers["Authorization"] = "Bearer " + accessToken;
      return true;
    } else {
      return false;
    }
  }

  Stream<List<FirestoreDocument>> streamFetch(String metodo, String? url,
      {Map<dynamic, dynamic>? body}) async* {
    yield* Stream.periodic(
      const Duration(seconds: 1),
      (_) => fetchForStream(metodo, url, body: body),
    ).asyncMap((event) async => (await event) as List<FirestoreDocument>);
  }

  Future<List<FirestoreDocument>> fetchForStream(String metodo, String? url,
      {Map<dynamic, dynamic>? body}) async {
    try {
      List<FirestoreDocument> list;

      if (url!.contains("runQuery")) {
        list = ((await fetch(metodo, url, body: body)).content as List)
            .map((e) => FirestoreDocument.fromJson(e["document"]))
            .toList();
      } else {
        list = ((await fetch(metodo, url, body: body)).content["documents"]
                as List<dynamic>)
            .map((e) => FirestoreDocument.fromJson(e))
            .toList();
      }
      return list;
    } catch (e) {
      throw e;
    }
  }

  Future<ResponseModel> fetch(String metodo, String? url,
      {Map<dynamic, dynamic>? body,
      String? absoluteUrl,
      bool needsCheckToken = true}) async {
    if (needsCheckToken && !await checkToken()) {
      ResponseModel.codeContentConstructor(401, "Token expirado ou inválido");
    }
    if (absoluteUrl != null) {
      url = absoluteUrl;
    } else {
      url = "$_url$url";
    }

    Dio dio = Dio();
    var response;
    dio.options.headers = _headers;

    switch (metodo) {
      case 'get':
        response = await dio.get(url);
        break;
      case 'post':
        response = await dio.post(url, data: json.encode(body));
        break;
      case 'patch':
        response = await dio.patch(url, data: json.encode(body));
        break;
      case 'put':
        response = await dio.put(url, data: json.encode(body));
        break;
      case 'delete':
        response = await dio.delete(url);
        break;
    }

    return ResponseModel.codeContentConstructor(
        response.statusCode, response.data ?? json.decode(response.data));
  }
}
