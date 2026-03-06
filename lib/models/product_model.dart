import 'package:toko_online/services/url.dart' as url;
class ProductModel {
int? id;
String? nama_barang;
String? deskripsi;
int? stok;
int? harga;
String? image;
ProductModel({
required this.id,
required this.nama_barang,
this.deskripsi,
this.stok,
this.harga,
this.image,
});
ProductModel.fromJson(Map<String, dynamic> parsedJson) {
id = parsedJson["id"];
nama_barang = parsedJson["nama_barang"];
deskripsi = parsedJson["deskripsi"];
stok = parsedJson["stok"];
harga = parsedJson["harga"];
image = parsedJson["image"];
}
}
