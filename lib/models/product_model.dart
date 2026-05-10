class ProductModel {
  int? id;
  String? nama_barang;
  String? deskripsi;
  int? stok;
  double? harga;
  String? image;

  ProductModel({this.id, this.nama_barang, this.deskripsi, this.stok, this.harga, this.image});

  ProductModel.fromJson(Map<String, dynamic> json) {
    id = json['id'] != null ? int.tryParse(json['id'].toString()) : null;
    nama_barang = json['nama_barang']?.toString() ?? "No Name";
    deskripsi = json['deskripsi']?.toString() ?? "";
    
    // Menggunakan num.tryParse agar aman membaca angka bulat maupun desimal
    stok = num.tryParse(json['stok']?.toString() ?? "0")?.toInt() ?? 0;
    harga = num.tryParse(json['harga']?.toString() ?? "0")?.toDouble() ?? 0.0;
    
    image = json['image']?.toString() ?? "";
  }
}