import 'dart:convert';
import 'package:toko_online/models/product_model.dart';
import 'package:toko_online/models/response_data_list.dart';
import 'package:toko_online/models/response_data_map.dart';
import 'package:toko_online/models/user_login.dart';
import 'package:toko_online/services/url.dart' as url;
import 'package:http/http.dart' as http;

class ProductServices {
  List<ProductModel> _mapToProductList(dynamic data) {
    if (data is List) {
      return data.map((item) => ProductModel.fromJson(item)).toList();
    }
    return [];
  }

  Future<ResponseDataList> getHistory() async {
    var uri = Uri.parse("${url.BaseUrl}/user/history_trans");
    UserLogin userLogin = UserLogin();
    var user = await userLogin.getUserLogin();
    Map<String, String> headers = {"Authorization": 'Bearer ${user.token}'};
    try {
      var response = await http.get(uri, headers: headers);
      var data = json.decode(response.body);
      return ResponseDataList(
        status: true,
        message: 'Success',
        data: data["data"],
      );
    } catch (e) {
      print(e);
      return ResponseDataList(status: false, message: 'Error', data: null);
    }
  }

  Future<ResponseDataList> getProducts() async {
    var uri = Uri.parse("${url.BaseUrl}/admin/getmovie");
    UserLogin userLogin = UserLogin();
    var user = await userLogin.getUserLogin();
    Map<String, String> headers = {"Authorization": 'Bearer ${user.token}'};
    try {
      var response = await http.get(uri, headers: headers);
      var data = json.decode(response.body);
      return ResponseDataList(
        status: true,
        message: 'Success',
        data: _mapToProductList(data["data"]),
      );
    } catch (e) {
      return ResponseDataList(status: false, message: 'Error', data: null);
    }
  }

  Future<ResponseDataList> getMovieUser() async {
    var uri = Uri.parse("${url.BaseUrl}/user/getbarang");
    UserLogin userLogin = UserLogin();
    var user = await userLogin.getUserLogin();
    Map<String, String> headers = {"Authorization": 'Bearer ${user.token}'};
    try {
      var response = await http.get(uri, headers: headers);
      var data = json.decode(response.body);
      return ResponseDataList(
        status: true,
        message: 'Success',
        data: _mapToProductList(data["data"]),
      );
    } catch (e) {
      return ResponseDataList(status: false, message: 'Error', data: null);
    }
  }

  Future<ResponseDataMap> insertMovie(request, image, id) async {
    var requestUrl = id == null
        ? "${url.BaseUrl}/admin/insertmovie"
        : "${url.BaseUrl}/admin/updatemovie/$id";
    var multiPartReq = http.MultipartRequest('POST', Uri.parse(requestUrl));
    UserLogin userLogin = UserLogin();
    var user = await userLogin.getUserLogin();
    multiPartReq.headers["Authorization"] = 'Bearer ${user.token}';
    if (image != null)
      multiPartReq.files.add(
        await http.MultipartFile.fromPath('image', image.path),
      );
    multiPartReq.fields['nama_barang'] = request["nama_barang"] ?? "";
    multiPartReq.fields['harga'] = request["harga"].toString();
    multiPartReq.fields['deskripsi'] = request["deskripsi"] ?? "";
    try {
      var streamedRes = await multiPartReq.send();
      var res = await http.Response.fromStream(streamedRes);
      var data = json.decode(res.body);
      return ResponseDataMap(status: data["status"], message: data["message"]);
    } catch (e) {
      return ResponseDataMap(status: false, message: "Error");
    }
  }

  Future<ResponseDataList> hapusProduct(context, id) async {
    var uri = Uri.parse("${url.BaseUrl}/admin/hapusmovie/$id");
    UserLogin userLogin = UserLogin();
    var user = await userLogin.getUserLogin();
    Map<String, String> headers = {"Authorization": 'Bearer ${user.token}'};
    try {
      var response = await http.delete(uri, headers: headers);
      var result = json.decode(response.body);
      return ResponseDataList(
        status: result["status"],
        message: result["message"],
        data: null,
      );
    } catch (e) {
      return ResponseDataList(status: false, message: 'Error', data: null);
    }
  }
}
