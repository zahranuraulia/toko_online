import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:toko_online/models/response_data_map.dart';
import 'package:toko_online/models/user_login.dart';
import 'package:toko_online/services/url.dart' as url;

class Pesan {
  UserLogin userLogin = UserLogin();
  Future saveToDB(dataRequest) async {
    var uri = Uri.parse(url.BaseUrl + "/user/transaksi");
    var user = await userLogin.getUserLogin();
    if (user.status == false) {
      ResponseDataMap response = ResponseDataMap(
        status: false,
        message: 'anda belum login / token invalid',
      );
      return response;
    }
    Map<String, String> headers = {"Authorization": 'Bearer ${user.token}', "Content-Type": "application/json"};
    try {
      var simpanPesan = await http.post(
        uri,
        body: json.encode(dataRequest),
        headers: headers,
      );
      print(json.encode(dataRequest));
      var data = json.decode(simpanPesan.body);
      if (simpanPesan.statusCode == 200) {
        if (data["status"] == true) {
          ResponseDataMap response = ResponseDataMap(
            status: true,
            message: "Sukses menambah user",
          );
          return response;
        } else {
          ResponseDataMap response = ResponseDataMap(
            status: false,
            message: data["message"],
          );
          return response;
        }
      } else {
        print("${simpanPesan.statusCode}");
        ResponseDataMap response = ResponseDataMap(
          status: false,
          message:
              "gagal menambah user dengan code error ${simpanPesan.statusCode}",
        );
        return response;
      }
    } catch (e) {
      print(e);
      ResponseDataMap response = ResponseDataMap(
        status: false,
        message: "fatal error ${e}",
      );
      return response;
    }
  }
}
