import 'package:flutter/material.dart';
import 'package:toko_online/models/response_data_list.dart';
import 'package:toko_online/views/tambah_product.dart';
import 'package:toko_online/widgets/bottom_nav.dart';
import 'package:toko_online/widgets/alert.dart';
import 'package:toko_online/services/product_services.dart';
import 'package:toko_online/services/url.dart' as url; // Tambahkan ini

class ProductView extends StatefulWidget {
  const ProductView({super.key});
  @override
  State<ProductView> createState() => _ProductViewState();
}

class _ProductViewState extends State<ProductView> {
  ProductServices movie = ProductServices();
  List? product;

  // List actions untuk PopupMenuButton
  List<String> actions = ["Update", "Delete"]; 

  getProduct() async {
    ResponseDataList getProducts = await movie.getProducts();
    if (mounted) {
      setState(() {
        product = getProducts.data;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getProduct();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Product"),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TambahProductView(
                    title: "Tambah Product", 
                    item: null
                  ),
                ),
              ).then((value) => getProduct()); // Refresh data setelah kembali
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: product != null
          ? ListView.builder(
              itemCount: product!.length,
              itemBuilder: (context, index) {
                // Ambil data item saat ini
                var item = product![index];

                return Card(
                  child: ListTile(
                    leading: Image(
                      width: 50,
                      // Sesuaikan dengan model: nama_barang & image
                      image: NetworkImage("${url.BaseUrl}/${item.image}"),
                      errorBuilder: (context, error, stackTrace) => 
                          const Icon(Icons.broken_image),
                    ),
                    title: Text(item.nama_barang ?? "No Name"),
                    subtitle: Text("Rp ${item.harga}"),
                    trailing: PopupMenuButton<String>(
                      onSelected: (String r) async {
                        if (r == "Update") {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TambahProductView(
                                title: "Update Product",
                                item: item,
                              ),
                            ),
                          ).then((value) => getProduct());
                        } else {
                          // Logika Delete
                          var results = await AlertMessage().showAlert(
                            context,
                            'Yakin ingin menghapus?',
                            false,
                          );
                          
                          if (results != null && results['status'] == true) {
                            var res = await movie.hapusProduct(
                              context,
                              item.id,
                            );
                            if (res.status == true) {
                              AlertMessage().showAlert(context, res.message, true);
                              getProduct();
                            } else {
                              AlertMessage().showAlert(context, res.message, false);
                            }
                          }
                        }
                      },
                      itemBuilder: (BuildContext context) {
                        return actions.map((String r) {
                          return PopupMenuItem<String>(
                            value: r,
                            child: Text(r),
                          );
                        }).toList();
                      },
                    ),
                  ),
                );
              },
            )
          : const Center(child: CircularProgressIndicator()),
      bottomNavigationBar: BottomNav(1),
    );
  }
}