class Cart {
  late final int? id;
  final String? nama_barang;
  final String? deskripsi;
  final int? stok;
  final double? harga;
  int? quantity = 0;
  final String? image;
  Cart({
    required this.id,
    required this.nama_barang,
    required this.deskripsi,
    required this.stok,
    required this.harga,
    required this.quantity,
    required this.image,
  });
  factory Cart.fromMap(Map<dynamic, dynamic> data) {
    return Cart(
      id: data['id'],
      nama_barang: data['nama_barang'],
      deskripsi: data['deskripsi'],
      stok: data['stok'],
      harga: data['harga'],
      quantity: data['quantity'],
      image: data['image'],
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nama_barang': nama_barang,
      'deskripsi': deskripsi,
      'stok': stok,
      'harga': harga,
      'quantity': quantity,
      'image': image,
    };
  }
}
