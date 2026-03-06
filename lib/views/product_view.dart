import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:toko_online/models/response_data_list.dart';
import 'package:toko_online/services/product_services.dart';
import 'package:toko_online/widgets/bottom_nav.dart';
import 'package:toko_online/services/url.dart' as url;

class ProductView extends StatefulWidget {
  const ProductView({super.key});

  @override
  State<ProductView> createState() => _ProductViewState();
}

class _ProductViewState extends State<ProductView> {
  ProductServices product = ProductServices();
  List? products;

  final Color primaryColor = const Color(0xFFF6A5C0);
  final Color bgColor = const Color(0xFFF8F9FA);

  getProducts() async {
    ResponseDataList getProducts = await product.getProducts();
    setState(() {
      products = getProducts.data;
    });
  }

  @override
  void initState() {
    super.initState();
    getProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Text(
          "Sweet Jelly Store",
          style: GoogleFonts.poppins(fontWeight: FontWeight.w800, fontSize: 22, color: Colors.black87),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none_rounded, color: Colors.black87),
            onPressed: () {},
          ),
        ],
      ),
      body: products != null
          ? RefreshIndicator(
              onRefresh: () async => getProducts(),
              color: primaryColor,
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildModernBanner(),
                    const SizedBox(height: 30),
                    Text(
                      "Koleksi Populer",
                      style: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 18),
                    ),
                    const SizedBox(height: 20),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 15,
                        mainAxisSpacing: 15,
                        childAspectRatio: 0.7,
                      ),
                      itemCount: products!.length,
                      itemBuilder: (context, index) => ProductCardItem(item: products![index]),
                    ),
                  ],
                ),
              ),
            )
          : const Center(child: CircularProgressIndicator()),
      bottomNavigationBar: const BottomNav(1),
    );
  }

  Widget _buildModernBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [primaryColor, const Color(0xFFFFC1D6)]),
        borderRadius: BorderRadius.circular(32),
        boxShadow: [BoxShadow(color: primaryColor.withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 10))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Promo Hari Ini", style: TextStyle(color: Colors.white70, fontWeight: FontWeight.w600)),
          const Text("Diskon 40%", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 28)),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: primaryColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              elevation: 0,
            ),
            child: const Text("Ambil Sekarang", style: TextStyle(fontWeight: FontWeight.bold)),
          )
        ],
      ),
    );
  }
}

// INI ADALAH WIDGET KARTU DENGAN ANIMASI TERBAIK
class ProductCardItem extends StatefulWidget {
  final dynamic item;
  const ProductCardItem({super.key, required this.item});

  @override
  State<ProductCardItem> createState() => _ProductCardItemState();
}

class _ProductCardItemState extends State<ProductCardItem> {
  double _scale = 1.0; // State untuk mengontrol ukuran

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (_) => setState(() => _scale = 0.94), // Mengecil saat disentuh
      onPointerUp: (_) => setState(() => _scale = 1.0),   // Kembali saat dilepas
      onPointerCancel: (_) => setState(() => _scale = 1.0),
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeInOutCubic, // Efek memantul halus
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 15, offset: const Offset(0, 8))
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  width: double.infinity,
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF0F5),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(18),
                    child: Image.network(
                      Uri.encodeFull("${url.BaseUrlTanpaAPi}/${widget.item.image}"),
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.item.nama_barang ?? "",
                      style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 14),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Rp 25.000",
                      style: GoogleFonts.poppins(fontWeight: FontWeight.w800, color: const Color(0xFFF6A5C0), fontSize: 15),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}