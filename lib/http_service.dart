/**
 * Created by lejard_h on 23/12/15.
 */

library polymer_app.http_service;

import 'package:http/http.dart';
import "package:http/browser_client.dart";
import "dart:async";
import "dart:convert";

class HttpService {
  static HttpService _cache;

  factory HttpService() {
    if (_cache == null) {
      _cache = new HttpService._internal();
    }
    return _cache;
  }

  HttpService._internal();

  BrowserClient _http = new BrowserClient();

  Future<Response> delete(String url,
          {Map params, Map<String, String> headers, bool list: false}) =>
      _http.delete(_constructUrlParams(url, params), headers: headers);

  Future<Response> get(String url,
          {Map params, Map<String, String> headers, bool list: false}) =>
      _http.get(_constructUrlParams(url, params), headers: headers);

  Future<Response> head(String url,
          {Map params, Map<String, String> headers, bool list: false}) =>
      _http.head(_constructUrlParams(url, params), headers: headers);

  Future<Response> patch(String url,
          {body,
          Map params,
          Map<String, String> headers,
          Encoding encoding,
          bool list: false}) =>
      _http.patch(_constructUrlParams(url, params),
          body: body, headers: headers, encoding: encoding);

  Future<Response> post(String url,
          {body,
          Map params,
          Map<String, String> headers,
          Encoding encoding,
          bool list: false}) =>
      _http.post(_constructUrlParams(url, params),
          body: body, headers: headers, encoding: encoding);

  Future<Response> put(String url,
          {body,
          Map params,
          Map<String, String> headers,
          Encoding encoding,
          bool list: false}) =>
      _http.put(_constructUrlParams(url, params),
          body: body, headers: headers, encoding: encoding);

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
