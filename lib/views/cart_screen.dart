import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; // Tambahkan google_fonts
import 'package:badges/badges.dart' as badges;
import 'package:toko_online/controllers/cartProvider.dart';
import 'package:toko_online/services/DBHelper.dart';
import 'package:toko_online/services/pesan.dart';
import 'package:toko_online/widgets/alert.dart';
import 'package:toko_online/widgets/tombol_plus_minus.dart';
import 'package:toko_online/services/url.dart' as url;

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});
  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  // Palet Warna senada PesanView
  final Color primaryColor = const Color(0xFFF6A5C0);
  final Color accentColor = const Color(0xFFF25C95);
  final Color bgColor = const Color(0xFFFFF5F8);

  var dBHelper = DBHelper();
  final cartProvider = CartProvider();

  void updateCount() async {
    await cartProvider.getData();
    if (mounted) {
      setState(() {
        cartProvider.counter = cartProvider.cart.length;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    updateCount();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: Column(
        children: [
          // CUSTOM HEADER GRADIENT (Senada dengan PesanView)
          Container(
            padding: const EdgeInsets.only(top: 60, left: 10, right: 20, bottom: 30),
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
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
                  onPressed: () => Navigator.pop(context),
                ),
                const SizedBox(width: 5),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "My Cart 🛒",
                        style: GoogleFonts.poppins(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      ListenableBuilder(
                        listenable: cartProvider,
                        builder: (context, child) => Text(
                          "${cartProvider.cart.length} Items in your bag",
                          style: GoogleFonts.poppins(color: Colors.white70, fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                ),
                // Badge di pojok kanan header
                badges.Badge(
                  badgeStyle: const badges.BadgeStyle(badgeColor: Colors.white),
                  badgeContent: ListenableBuilder(
                    listenable: cartProvider,
                    builder: (context, child) => Text(
                      '${cartProvider.counter}',
                      style: TextStyle(color: accentColor, fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ),
                  child: const Icon(Icons.shopping_cart, color: Colors.white, size: 28),
                ),
              ],
            ),
          ),

          // LIST ITEM KERANJANG
          Expanded(
            child: ListenableBuilder(
              listenable: cartProvider,
              builder: (context, child) {
                if (cartProvider.cart.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.shopping_basket_outlined, size: 80, color: primaryColor.withOpacity(0.5)),
                        const SizedBox(height: 10),
                        Text(
                          'Your Cart is Empty 🌸',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0,
                            color: accentColor,
                          ),
                        ),
                      ],
                    ),
                  );
                } else {
                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    itemCount: cartProvider.cart.length,
                    itemBuilder: (context, index) {
                      var item = cartProvider.cart[index];

                      // --- LOGIC PERBAIKAN GAMBAR ---
                      String img = item.image ?? "";
                      String cleanBaseUrl = url.BaseUrl.replaceAll('/api', '');
                      if (cleanBaseUrl.endsWith('/')) {
                        cleanBaseUrl = cleanBaseUrl.substring(0, cleanBaseUrl.length - 1);
                      }
                      String fullImgUrl = img.startsWith('http') ? img : "$cleanBaseUrl/storage/$img";

                      return Container(
                        margin: const EdgeInsets.only(bottom: 18),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(22),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.03),
                              blurRadius: 15,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            children: [
                              // Widget Gambar
                              ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: Image.network(
                                  fullImgUrl,
                                  height: 85,
                                  width: 85,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Image.network(
                                      "$cleanBaseUrl/$img",
                                      height: 85,
                                      width: 85,
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, __, ___) => 
                                          Container(
                                            height: 85, width: 85, 
                                            color: bgColor,
                                            child: Icon(Icons.broken_image, color: primaryColor)
                                          ),
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(width: 15),
                              // Info Detail
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.nama_barang ?? "No Name",
                                      style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.bold, fontSize: 15),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      "Rp ${item.harga}",
                                      style: GoogleFonts.poppins(
                                          color: accentColor, 
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14),
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        PlusMinusButtons(
                                          addQuantity: () => cartProvider.addQuantity(item.id!),
                                          deleteQuantity: () => cartProvider.deleteQuantity(item.id!),
                                          text: item.quantity.toString(),
                                        ),
                                        GestureDetector(
                                          onTap: () async {
                                            await dBHelper.deleteCartItem(item.id!);
                                            cartProvider.removeItem(item.id!);
                                            cartProvider.removeCounter();
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.all(5),
                                            decoration: BoxDecoration(
                                              color: Colors.red.shade50,
                                              shape: BoxShape.circle,
                                            ),
                                            child: Icon(Icons.delete_outline_rounded, color: Colors.red.shade400, size: 22),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
      // Tombol Checkout (Sesuai Referensi)
      floatingActionButton: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: accentColor.withOpacity(0.4),
              blurRadius: 12,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: FloatingActionButton.extended(
          backgroundColor: accentColor,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          onPressed: () async {
            if (cartProvider.cart.isEmpty) return;

            List dataList = cartProvider.cart.map((i) {
              return {"barang_id": i.id, "qty": i.quantity};
            }).toList();
            
            var data = {"pesan": dataList};
            var result = await Pesan().saveToDB(data);
            
            if (result.status == true) {
              await dBHelper.clearCart(); 
              cartProvider.getData(); 
              
              if (mounted) {
                AlertMessage().showAlert(context, "Berhasil Melakukan Pembelian!", true);
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/history',
                  (Route<dynamic> route) => false,
                );
              }
            } else {
              debugPrint(result.message);
              if (mounted) {
                AlertMessage().showAlert(context, result.message ?? "Gagal Membeli", false);
              }
            }
          },
          icon: const Icon(Icons.shopping_cart_checkout_rounded, color: Colors.white),
          label: Text("Checkout Now ✨", style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }
}