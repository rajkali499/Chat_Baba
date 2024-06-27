import 'dart:convert';
import 'dart:io';

import 'package:chat_baba/helper/dialog_helper.dart';
import 'package:chat_baba/helper/storage_helper.dart';
import 'package:chat_baba/main.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';

enum Method { POST, GET, PUT, PATCH, DELETE }

//var baseUrl = "https://resumemaker-d0s8.onrender.com/";
var baseUrlAuth = environment.hostUrlAuth;
var baseUrlChat = environment.hostUrlChat;
var socketUrl = environment.socketUrl;
//var baseUrl = "https://pro.fluidfruits.com:8000/";
//var baseUrl = "https://pro.fluidfruits.com:8001/";

class ApiHelper {
  getAccessToken() async {
    String refreshToken = await StorageHelper().getRefreshTokenToken();
    if (refreshToken.isEmpty) {
      refreshToken =
          // "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJlbWFpbCI6ImthbGlAZ21haWwuY29tIiwiaWQiOiIyYjEyMGY3NS0xYWRlLTQ3MDItOGNlMC0xNDczYzc2MTY5YzciLCJleHAiOjE3MTk2MDQxNTYsInRva2VuX3R5cGUiOiJyZWZyZXNoX3Rva2VuIn0.tkSPcpO9FxFFMF_pq-UO9bf1IfdvbFtUnVUV1QCjauE"; // refreshToken =
      "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJlbWFpbCI6ImhhcmlwcmFzYXRoQGdtYWlsLmNvbSIsImlkIjoiZTI1YmZlOTYtYTQzNi00Mjg0LWE1YTgtOTJlMWEwZDNiYWI5IiwiZXhwIjoxNzE5NDQwODE2LCJ0b2tlbl90eXBlIjoiYWNjZXNzX3Rva2VuIn0.Ea9rf983WeKaJNycESaWf9hUkKz3anRgNaLrGwdIapA";
    }
    var body = {"refresh_token": refreshToken};
    var res =
        await makeReq("${baseUrlAuth}refresh_token/", body, method: Method.GET);
    if (res != null && res is Map) {
      await StorageHelper().setAccessToken(res["access_token"]);
      await StorageHelper().setRefreshToken(res["refresh_token"]);
      return true;
    }
    return false;
  }

  Future makeReqWithoutSSLSchecking(String URL, dynamic body,
      {Method method = Method.POST, bool retrying = false}) async {
    final ioc = HttpClient();
    ioc.badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;
    final https = IOClient(ioc);
    try {
      // final result = await InternetAddress.lookup('example.com');
      // if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      //   print('connected');
      //
      // }
      Uri url = Uri.parse(URL);
      http.Response response;
      var token =  await StorageHelper().getAccessToken();
      if (token.isEmpty) {
        token =
            // "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJlbWFpbCI6ImthbGlAZ21haWwuY29tIiwiaWQiOiIyYjEyMGY3NS0xYWRlLTQ3MDItOGNlMC0xNDczYzc2MTY5YzciLCJleHAiOjE3MTg4MzY1MzIsInRva2VuX3R5cGUiOiJhY2Nlc3NfdG9rZW4ifQ.gXZPtRIb2KJJGPPyKYjOtz2kiFEaW1ROXOvxOK7aEjs";
            "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJlbWFpbCI6ImhhcmlwcmFzYXRoQGdtYWlsLmNvbSIsImlkIjoiZTI1YmZlOTYtYTQzNi00Mjg0LWE1YTgtOTJlMWEwZDNiYWI5IiwiZXhwIjoxNzE5NDQwODE2LCJ0b2tlbl90eXBlIjoiYWNjZXNzX3Rva2VuIn0.Ea9rf983WeKaJNycESaWf9hUkKz3anRgNaLrGwdIapA";
      }
      var headers = {
        'Content-Type': 'application/json',
        'authorization': "Bearer $token"
      };
      try {
        print(
            "API : ${method.toString()} url : $url \nrequest : ${body.toString()} \nJsonView ${jsonEncode(body)}");
        switch (method) {
          case Method.POST:
            response = await https.post(url,
                headers: headers,
                body: jsonEncode(body),
                encoding: Encoding.getByName("utf-8"));
            break;
          case Method.GET:
            if (body != null &&
                body is Map &&
                body.isNotEmpty &&
                body is Map<String, dynamic>) {
              String queryString = Uri(queryParameters: body).query;
              url = Uri.parse("$URL?$queryString");
            }
            response = await https.get(url, headers: headers);
            break;
          case Method.PUT:
            response = await https.put(url,
                headers: headers,
                body: jsonEncode(body),
                encoding: Encoding.getByName("utf-8"));
            break;
          case Method.PATCH:
            response = await https.patch(url,
                headers: headers,
                body: jsonEncode(body),
                encoding: Encoding.getByName("utf-8"));
            break;
          case Method.DELETE:
            response = await https.delete(url,
                headers: headers,
                body: jsonEncode(body),
                encoding: Encoding.getByName("utf-8"));
            break;

          default:
            response = await https.post(url,
                headers: headers,
                body: jsonEncode(body),
                encoding: Encoding.getByName("utf-8"));
        }
      } catch (e) {
        print(e.toString());
        throw ApiFailure(400, e.toString());
      }
      print("Response: ${response.body} statusCode: ${response.statusCode}");
      var statusCode = response.statusCode;
      if (statusCode == 200 || statusCode == 201) {
        return json.decode(response.body);
      } else if (statusCode == 204) {
        return "$method completed Successfully";
      } else if (statusCode == 400) {
        var body = json.decode(response.body);
        throw ApiFailure(statusCode, (body?["error"] ?? "").toString());
      } else if (statusCode == 401) {
        if (await getAccessToken()) {
          makeReqWithoutSSLSchecking(URL, body,
              method: method, retrying: retrying);
        } else {
          throw ApiFailure(statusCode, (body?["error"] ?? "").toString());
        }
      } else {
        debugPrint((body?["error"] ?? "").toString());
        throw ApiFailure(statusCode, "Something went wrong");
      }
    } on SocketException catch (_) {
      throw ApiFailure(404, "No Internet Connection");
    }
  }

  Future makeReq(String URL, dynamic body,
      {Method method = Method.POST,
      bool retrying = false,
      bool isToken = false,
      bool showError = true}) async {
    // final ioc = new HttpClient();
    // ioc.badCertificateCallback =
    //     (X509Certificate cert, String host, int port) => true;
    // final https = new IOClient(ioc);
    if (!kIsWeb && Platform.isAndroid) {
      return await makeReqWithoutSSLSchecking(URL, body, method: method);
    }
    try {
      // final result = await InternetAddress.lookup('example.com');
      // if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      //   print('connected');
      //
      // }
      //var accessToken = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNzExNjI2MjIxLCJpYXQiOjE3MDI5ODYyMjEsImp0aSI6ImIwNjA5OTY5YWEwYTRlOWViMWI0NDMyODIxMTQ1ZTg4IiwidXNlcl9pZCI6IjJiZGE1OWE5LTcyOTUtNGQ4OS05MGMwLTYzN2I2ZjRjYzZlYyJ9.mgfbrc566HC1ID3cNhhH0c8jyK34iXu8txbvi9OkTGE";
      Uri url = Uri.parse(URL);
      http.Response response;
      var token = await StorageHelper().getAccessToken();
      if (token.isEmpty) {
        token =
            // "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJlbWFpbCI6ImthbGlAZ21haWwuY29tIiwiaWQiOiIyYjEyMGY3NS0xYWRlLTQ3MDItOGNlMC0xNDczYzc2MTY5YzciLCJleHAiOjE3MTg4MzY1MzIsInRva2VuX3R5cGUiOiJhY2Nlc3NfdG9rZW4ifQ.gXZPtRIb2KJJGPPyKYjOtz2kiFEaW1ROXOvxOK7aEjs";
            "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJlbWFpbCI6ImthbGlAZ21haWwuY29tIiwiaWQiOiIyYjEyMGY3NS0xYWRlLTQ3MDItOGNlMC0xNDczYzc2MTY5YzciLCJleHAiOjE3MTg4MzY1MzIsInRva2VuX3R5cGUiOiJhY2Nlc3NfdG9rZW4ifQ.gXZPtRIb2KJJGPPyKYjOtz2kiFEaW1ROXOvxOK7aEjs";
      }
      var headers = token.isNotEmpty
          ? {
              'Content-Type': 'application/json',
              'authorization': "Bearer $token"
            }
          : {
              'Content-Type': 'application/json'
              //'authorization': "Bearer $accessToken"
            };
      try {
        print(
            "API : ${method.toString()} url : $url \nrequest : ${body.toString()} \nheader: $headers");
        switch (method) {
          case Method.POST:
            response = await http.post(url,
                headers: headers,
                body: jsonEncode(body),
                encoding: Encoding.getByName("utf-8"));
            break;
          case Method.GET:
            if (body != null &&
                body is Map &&
                body.isNotEmpty &&
                body is Map<String, dynamic>) {
              String queryString = Uri(queryParameters: body).query;
              url = Uri.parse("$URL?$queryString");
            }
            response = await http.get(url, headers: headers);
            break;
          case Method.PUT:
            response = await http.put(url,
                headers: headers,
                body: jsonEncode(body),
                encoding: Encoding.getByName("utf-8"));
            break;
          case Method.PATCH:
            response = await http.patch(url,
                headers: headers,
                body: jsonEncode(body),
                encoding: Encoding.getByName("utf-8"));
            break;
          // case Method.IMAGE:
          //   {
          //     var request = new http.MultipartRequest("POST", url);
          //     request.files.add(body);
          //     response = await request.send();
          //     break;
          //   }
          case Method.DELETE:
            response = await http.delete(url,
                headers: headers,
                body: jsonEncode(body),
                encoding: Encoding.getByName("utf-8"));
            break;

          default:
            response = await http.post(url,
                headers: headers,
                body: jsonEncode(body),
                encoding: Encoding.getByName("utf-8"));
        }
      } catch (e) {
        print(e.toString());
        throw ApiFailure(400, e.toString());
      }
      print("Response: ${response.body} statusCode: ${response.statusCode}");
      var statusCode = response.statusCode;
      if (statusCode == 200 || statusCode == 201) {
        return json.decode(response.body);
      } else if (statusCode == 204) {
        return "$method completed Successfully";
      } else if (statusCode == 400) {
        //showMessage(response.body ?? "", MessageType.Fail);
        var body = json.decode(response.body);
        if (showError) {
          Future.delayed(const Duration(milliseconds: 100), () {
            showMessage(
                body?["error"] ?? "Something Went Wrong", MessageType.Fail);
          });
        }
        throw ApiFailure(statusCode, (body?["error"] ?? "").toString());
      } else if (statusCode == 401) {
        if (await getAccessToken()) {
          makeReqWithoutSSLSchecking(URL, body,
              method: method, retrying: retrying);
        } else {
          throw ApiFailure(statusCode, (body?["error"] ?? "").toString());
        }
      } else {
        //showMessage(response.body ?? "", MessageType.Fail);
        throw ApiFailure(statusCode, "Something went wrong");
      }
    } on SocketException catch (_) {
      throw ApiFailure(404, "No Internet Connection");
    }
  }
}

class ApiFailure implements Exception {
  String message = "";
  int code = 400;

  ApiFailure(this.code, this.message);
}
