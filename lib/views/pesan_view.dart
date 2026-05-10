import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:toko_online/controllers/cartProvider.dart';
import 'package:toko_online/models/cart.dart';
import 'package:toko_online/models/product_model.dart';
import 'package:toko_online/services/DBHelper.dart';
import 'package:toko_online/services/product_services.dart';
import 'package:toko_online/widgets/bottom_nav.dart';
import 'package:badges/badges.dart' as badges;
import 'package:toko_online/services/url.dart' as url;

class PesanView extends StatefulWidget {
  const PesanView({super.key});
  @override
  State<PesanView> createState() => _PesanViewState();
}

class _PesanViewState extends State<PesanView> {
  final Color primaryColor = const Color(0xFFF6A5C0);
  final Color accentColor = const Color(0xFFF25C95); // Warna pink lebih tua untuk gradient
  
  final dBHelper = DBHelper();
  final cartProvider = CartProvider();
  List<ProductModel>? movie;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getMoview();
    updateCount();
  }

  String formatRupiah(double price) {
    return "Rp ${price.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}";
  }

  void getMoview() async {
    setState(() => isLoading = true);
    var result = await ProductServices().getMovieUser();
    if (result.status == true) {
      setState(() {
        movie = result.data as List<ProductModel>?;
        isLoading = false;
      });
    } else {
      setState(() => isLoading = false);
    }
  }

  void updateCount() async {
    await cartProvider.getData();
    if (mounted) setState(() {});
  }

  void saveData(int index) async {
    var item = movie![index];
    int productId = item.id ?? 0;
    var detail = await dBHelper.getCartListDetail(productId);
    int qty = (detail.isNotEmpty) ? (detail[0].quantity ?? 0) : 0;

    await dBHelper.insert(
      Cart(
        id: productId,
        nama_barang: item.nama_barang ?? "",
        deskripsi: item.deskripsi ?? "",
        stok: item.stok ?? 0,
        harga: item.harga ?? 0.0,
        quantity: qty + 1,
        image: item.image ?? "",
      ),
    );
    updateCount();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: accentColor,
        behavior: SnackBarBehavior.floating,
        content: Text('Item masuk keranjang! 🎀', style: GoogleFonts.poppins()),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF5F8), // Background pink sangat muda
      body: Column(
        children: [
          // CUSTOM HEADER DENGAN GRADIENT (Seperti referensi)
          Container(
            padding: const EdgeInsets.only(top: 60, left: 20, right: 20, bottom: 30),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [primaryColor.withOpacity(0.8), accentColor.withOpacity(0.6)],
              ),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Jelly Shop 🎀",
                      style: GoogleFonts.poppins(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      "Temukan Jelly impianmu",
                      style: GoogleFonts.poppins(color: Colors.white70, fontSize: 14),
                    ),
                  ],
                ),
                badges.Badge(
                  badgeStyle: badges.BadgeStyle(badgeColor: Colors.white),
                  badgeContent: ListenableBuilder(
                    listenable: cartProvider,
                    builder: (context, child) => Text(
                      '${cartProvider.counter}',
                      style: TextStyle(color: accentColor, fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.3),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.shopping_bag_outlined, color: Colors.white),
                      onPressed: () => Navigator.pushNamed(context, "/cartScreen"),
                    ),
                  ),
                )
              ],
            ),
          ),

          // LIST PRODUK
          Expanded(
            child: isLoading
                ? Center(child: CircularProgressIndicator(color: accentColor))
                : (movie == null || movie!.isEmpty)
                    ? Center(child: Text("Kosong nih.. 🛍️", style: GoogleFonts.poppins()))
                    : RefreshIndicator(
                        onRefresh: () async => getMoview(),
                        child: ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                          itemCount: movie!.length,
                          itemBuilder: (context, index) {
                            var item = movie![index];
                            String img = item.image ?? "";
                            String cleanBaseUrl = url.BaseUrl.replaceAll('/api', '');
                            String fullImgUrl = img.startsWith('http') ? img : "${cleanBaseUrl.endsWith('/') ? cleanBaseUrl : '$cleanBaseUrl/'}storage/$img";

                            return Container(
                              margin: const EdgeInsets.only(bottom: 20),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(25),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.03),
                                    blurRadius: 20,
                                    offset: const Offset(0, 10),
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(15),
                                child: Row(
                                  children: [
                                    // Image Box
                                    Container(
                                      width: 85,
                                      height: 85,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        image: DecorationImage(
                                          image: NetworkImage(fullImgUrl),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 15),
                                    // Info
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            item.nama_barang ?? "",
                                            style: GoogleFonts.poppins(
                                                fontWeight: FontWeight.bold, fontSize: 16),
                                          ),
                                          Text(
                                            formatRupiah(item.harga?.toDouble() ?? 0),
                                            style: GoogleFonts.poppins(
                                                color: accentColor,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ],
                                      ),
                                    ),
                                    // Add Button (Glow style)
                                    GestureDetector(
                                      onTap: () => saveData(index),
                                      child: Container(
                                        padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          color: primaryColor.withOpacity(0.2),
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(Icons.add, color: accentColor),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNav(1),
    );
  }
}