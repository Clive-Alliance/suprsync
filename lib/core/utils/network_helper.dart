import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class NetworkHelper {
  static final NetworkHelper _instance = NetworkHelper.internal();
  NetworkHelper.internal();
  factory NetworkHelper() => _instance;
  final JsonDecoder _decoder = const JsonDecoder();

  Future<dynamic> postLogin(String url,
      {Map<String, String>? headers, body, encoding}) async {
    try {
      headers?.addAll({'x-client-env' : 'mobile'});
      return http
          .post(Uri.parse(url),
              body: json.encode(body), headers: headers, encoding: encoding)
          .then((http.Response response) {
        final String res = response.body;
        final int statusCode = response.statusCode;
        var result = _decoder.convert(res);
        if (statusCode < 200 || statusCode > 400) {
          throw ("${result['message']}");
        }
        return result;
      });
    } catch (e) {
      rethrow;
    }
  }

  Future get(String url, {Map<String, String>? headers, body}) async {
    try {
      headers?.addAll({'x-client-env' : 'mobile'});
      return http
          .get(Uri.parse(url), headers: headers)
          .then((http.Response response) {
        final String res = response.body;
        var myResponse = {"code": response.statusCode, "body": response.body};
        final int statusCode = response.statusCode;
        if (statusCode < 200 || statusCode >= 400) {
          throw (myResponse);
        }
        return _decoder.convert(res);
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> post(String url,
      {Map<String, String>? headers, body, encoding}) {
    try {
      headers?.addAll({'x-client-env' : 'mobile'});
      return http
          .post(Uri.parse(url),
              body: json.encode(body), headers: headers, encoding: encoding)
          .then((http.Response response) {
        final String res = response.body;

        final int statusCode = response.statusCode;
        var result = _decoder.convert(res);
        if (statusCode < 200 || statusCode >= 400) {
          final Map<String, dynamic> errorBody = json.decode(res);
          if (errorBody.containsKey('message')) {
            throw errorBody['message'];
          } else {
            throw 'An unknown error occurred.';
          }
        }
        return result;
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> patch(String url,
      {Map<String, String>? headers, body, encoding}) {
    try {
      headers?.addAll({'x-client-env' : 'mobile'});
      return http
          .patch(Uri.parse(url),
              body: json.encode(body), headers: headers, encoding: encoding)
          .then((http.Response response) {
        final String res = response.body;
        final int statusCode = response.statusCode;
        var result = _decoder.convert(res);
        if (statusCode < 200 || statusCode > 400) {
          throw ("${result['msg']}");
        }
        return result;
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> postForm(Uri url, List<http.MultipartFile> files,
      {Map<String, String>? headers, body, encoding}) async {
    try {
      headers?.addAll({'x-client-env' : 'mobile'});
      var request = http.MultipartRequest('POST', url);
      request.headers.addAll(headers!);
      if (body != null) {
        request.fields.addAll(body);
      }
      request.files.addAll(files);
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      final dynamic res = json.decode(response.body);
      final int statusCode = response.statusCode;
      if (statusCode < 200 || statusCode > 400) {
        throw ("${res["msg"]}");
      }
      return res;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> put(String url,
      {Map<String, String>? headers, body, encoding}) {
    try {
      headers?.addAll({'x-client-env' : 'mobile'});
      return http
          .put(Uri.parse(url),
              body: json.encode(body), headers: headers, encoding: encoding)
          .then((http.Response response) {
        final String res = response.body;
        final int statusCode = response.statusCode;
        var result = _decoder.convert(res);
        if (statusCode < 200 || statusCode > 400) {
          throw ("${result['msg']}");
        }
        return result;
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> putForm(Uri url, List<http.MultipartFile> files,
      {Map<String, String>? headers, body, encoding}) async {
    try {
      headers?.addAll({'x-client-env' : 'mobile'});
      var request = http.MultipartRequest('PUT', url);
      request.headers.addAll(headers!);
      if (body != null) {
        request.fields.addAll(body);
      }
      request.files.addAll(files);
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      final dynamic res = json.decode(response.body);
      final int statusCode = response.statusCode;
      if (statusCode < 200 || statusCode > 400) {
        throw ("${res["msg"]}");
      }
      return res;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> delete(String url, {Map<String, String>? headers}) {
    try {
      headers?.addAll({'x-client-env' : 'mobile'});
      return http
          .delete(Uri.parse(url), headers: headers)
          .then((http.Response response) {
        final int statusCode = response.statusCode;
        if (statusCode < 200 || statusCode > 400) {
          throw ("no");
        }
        return "yes";
      });
    } catch (e) {
      rethrow;
    }
  }
}
