import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hrm/main/data/database_helper.dart';
import 'package:hrm/main/models/user.dart';
import 'package:hrm/main/utils/network_util.dart';
import 'package:hrm/theme1/utils/T1Images.dart';
import 'package:http/http.dart' as http;

class RestDatasource {
  NetworkUtil _netUtil = new NetworkUtil();
  static final BASE_URL = "http://hrm.ams.net.vn";
  static final LOGIN_URL = BASE_URL + "/api/method/login";

  //local
  // static final BASE_URL = "http://erpnext.com.vn:8001";
  // static final Authorization = "token 8c66a371debfc53:3860484db7dacf0";
  // service
  static final Authorization = "token 14c1ae1f6b6535a:4f44381d7b13dcf";
  static final LOGINED_URL =
      BASE_URL + "/api/method/frappe.auth.get_logged_user";
  final JsonDecoder _decoder = new JsonDecoder();

  Future<User> login(String username, String password) {
    return http
        .post(LOGIN_URL,
            headers: <String, String>{
              'Accept': 'application/json',
              'Content-Type': 'application/json',
            },
            body: jsonEncode({"usr": username.trim(), "pwd": password.trim()}))
        .then((http.Response response) {
      final String res = response.body;
      final Map<String, String> header = response.headers;
      final int statusCode = response.statusCode;

      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw new Exception("Error while fetching data : $statusCode");
      }else if(statusCode ==302){
        throw new Exception("Please connect Internet or check  : ${response.headers['location']}");
      }
      var sid = ((header['set-cookie']).split(";"))[0];
      Map infoUser = {
        "sid": sid,
        "username": username,
        "password": password,
      };
      return new User.map(infoUser);
    });
  }

  Future<dynamic> getleaveAvalible(String endpoint, String sid, String type, var data) {
    return http
        .post(BASE_URL + endpoint,
            headers: <String, String>{
              'Cookie': sid.trim(),
            },
            body: data)
        .then((http.Response response) {
      final int statusCode = response.statusCode;
      if (statusCode < 200 || statusCode > 400 || json == null) {
        return false;
      }
      try {
        var res =
            (json.decode(response.body)["message"]["leave_allocation"][type]);
        res["type"] = type;
        return res;
      } catch (e) {
        return null;
      }
    }).catchError((error) {
      throw Exception(error);
    });
  }

  Future<dynamic> getFormData(String endpoint, String sid, Map data) {
    return http
        .post(BASE_URL + endpoint,
            headers: <String, String>{
              'Cookie': sid.trim(),
            },
            body: data)
        .then((http.Response response) {
      final int statusCode = response.statusCode;
      if (statusCode < 200 || statusCode > 400 || json == null) {
        return false;
      }
      try {
        var res = (json.decode(response.body)["message"]);
        return res;
      } catch (e) {
        return null;
      }
    }).catchError((error) {
      throw Exception(error);
    });
  }

  Future<dynamic> postleaveDraft(String endpoint, String sid, var data) {
    return http
        .post(BASE_URL + endpoint,
            headers: <String, String>{
              'Accept': 'application/json',
              'Content-Type': 'application/json',
              'Cookie': sid.trim(),
            },
            body: jsonEncode(data))
        .then((http.Response response) {
      final int statusCode = response.statusCode;

      if (statusCode < 200 || statusCode > 400 || json == null) {
        return false;
      }
      return true;
    }).catchError((error) {
      throw Exception(error);
    });
  }

  Future<dynamic> postPrivateAll(String endpoint, String sid, var data) {
    print(data);
    return http
        .post(BASE_URL + endpoint,
            headers: <String, String>{
              'Accept': 'application/json',
              'Content-Type': 'application/json',
              'Cookie': sid.trim(),
            },
            body: jsonEncode(data))
        .then((http.Response response) {
      final int statusCode = response.statusCode;
      if (statusCode < 200 || statusCode > 400 || json == null) {
        return false;
      }
      return true;
    }).catchError((error) {
      throw Exception(error);
    });
  }

  Future<dynamic> updatePublicDetail(String endpoint,  var data) {
    print(data);
    return http
        .put(BASE_URL + endpoint,
            headers: <String, String>{
              'Accept': 'application/json',
              'Content-Type': 'application/json',
              'Authorization': Authorization,
            },
            body: jsonEncode(data))
        .then((http.Response response) {
      final int statusCode = response.statusCode;
      if (statusCode < 200 || statusCode > 400 || json == null) {
        return false;
      }
      return true;
    }).catchError((error) {
      throw Exception(error);
    });
  }



  //PROFILE_URL
  Future<dynamic> getData(String sid, String endpoint) {
    return http.get(BASE_URL + endpoint, headers: <String, String>{
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Cookie': sid.trim(),
    }).then((http.Response response) {
      final String res = response.body;
      final int statusCode = response.statusCode;
      if (statusCode < 200 || statusCode > 400 || json == null) {
        return false;
      }
      return res;
    }).catchError((error) {
      throw Exception(error);
    });
  }

  Future<String> getNameId(String sid, String endpoint) async {
    return http.get(BASE_URL + endpoint, headers: <String, String>{
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Cookie': sid.trim(),
    }).then((http.Response response) {
      final dynamic res = jsonDecode(response.body);
      final int statusCode = response.statusCode;
      if (statusCode < 200 || statusCode > 400 || json == null) {
        print("errors call api getNameId");
        return null;
      }
      return res["data"].first["name"];
    });
  }

  //PROFILE_URL
  Future<dynamic> getDataPublic(String endpoint) {
    return http.get(BASE_URL + endpoint, headers: <String, String>{
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': Authorization,
    }).then((http.Response response) {
      final int statusCode = response.statusCode;
      if (statusCode < 200 || statusCode > 400 || json == null) {
        return false;
      }
      return json.decode(response.body)["data"];
    }).catchError((error) {
      throw Exception(error);
    });
  }


  //PROFILE_URL
  Future<dynamic> getDataPrivate(String endpoint, String sid) {
    return http.get(BASE_URL + endpoint, headers: <String, String>{
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Cookie': sid.trim(),
    }).then((http.Response response) {
      final int statusCode = response.statusCode;
      if (statusCode < 200 || statusCode > 400 || json == null) {
        return false;
      }
      return json.decode(response.body)["data"];
    }).catchError((error) {
      throw Exception(error);
    });
  }
}
