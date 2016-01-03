/**
 * Created by lejard_h on 23/12/15.
 */

library polymer_app.http_service;

import 'package:http/http.dart';
import "package:http/browser_client.dart";
import "dart:async";
import "dart:convert";
import 'serializer.dart';

String get json_format => "json";

class HttpResponse {
  Response response;
  dynamic convertedBody;

  num get statusCode => response?.statusCode;
}

class HttpService {
  static String data_format = json_format;

  static HttpService _cache;

  factory HttpService() {
    if (_cache == null) {
      _cache = new HttpService._internal();
    }
    return _cache;
  }

  HttpService._internal();

  BrowserClient _http = new BrowserClient();

  Future<HttpResponse> delete(String url,
      {Map params,
      Map<String, String> headers,
      Type decodeType}) async {

    HttpResponse res = new HttpResponse();
    res.response  = await _http.delete(_constructUrlParams(url, params), headers: headers);
    return _handleResponseBody(res, decodeType);
  }

  Future<HttpResponse> get(String url,
          {Map params,
          Map<String, String> headers,
          Type decodeType}) async {
    HttpResponse res = new HttpResponse();
    res.response = await _http.get(_constructUrlParams(url, params), headers: headers);
    return _handleResponseBody(res, decodeType);
  }

  Future<HttpResponse> head(String url,
          {Map params,
          Map<String, String> headers,
          Type decodeType}) async {
    HttpResponse res = new HttpResponse();
    res.response = await _http.head(_constructUrlParams(url, params), headers: headers);
    return _handleResponseBody(res, decodeType);
  }

  Future<HttpResponse> patch(String url,
          {body,
          Map params,
          Map<String, String> headers,
          Encoding encoding,
          Type decodeType}) async {
    HttpResponse res = new HttpResponse();
    res.response = await _http.patch(_constructUrlParams(url, params),
          body: body, headers: headers, encoding: encoding);
    return _handleResponseBody(res, decodeType);
  }

  Future<HttpResponse> post(String url,
          {body,
          Map params,
          Map<String, String> headers,
          Encoding encoding,
          Type decodeType}) async {
    HttpResponse res = new HttpResponse();
    res.response = await _http.post(_constructUrlParams(url, params),
          body: body, headers: headers, encoding: encoding);
    return _handleResponseBody(res, decodeType);
  }

  Future<HttpResponse> put(String url,
          {body,
          Map params,
          Map<String, String> headers,
          Encoding encoding,
          Type decodeType}) async {
    HttpResponse res = new HttpResponse();
    res.response = await _http.put(_constructUrlParams(url, params),
          body: body, headers: headers, encoding: encoding);
    return _handleResponseBody(res, decodeType);
  }

  HttpResponse _handleResponseBody(HttpResponse res, Type decodeType) {
    if (decodeType != null && res.response?.body != null && data_format == json_format) {
      res.convertedBody = Serializer.fromJson(res.response?.body, decodeType);
    }
    return res;
  }

  _constructUrlParams(String url, Map params) {
    if (params != null && params.length > 0) {
      url += "?";
      params.forEach((key, value) {
        url += "$key=$value&";
      });
    }
    return url;
  }

  insertParamsToUri(String uri, Map<String, dynamic> params) {
    params?.forEach((String key, value) {
      if (value != null && uri.contains(":$key")) {
        uri = uri.replaceFirst(":$key", Uri.encodeComponent(value));
      }
    });
    return uri;
  }
}
