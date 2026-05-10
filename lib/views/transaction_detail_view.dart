import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:toko_online/services/product_services.dart';
import 'package:toko_online/services/url.dart' as url;

class TransactionDetailView extends StatefulWidget {
  final int idTransaksi;
  final List<Map<String, dynamic>> detail;

  const TransactionDetailView({
    super.key,
    required this.idTransaksi,
    required this.detail,
  });

  @override
  State<TransactionDetailView> createState() => _TransactionDetailViewState();
}

class _TransactionDetailViewState extends State<TransactionDetailView>
    with SingleTickerProviderStateMixin {
  // ─── Color Palette ───
  final Color primaryPink = const Color(0xFFF6A5C0);
  final Color softPink = const Color(0xFFFCE4EC);
  final Color bgColor = const Color(0xFFFDF0F5);
  final Color darkPink = const Color(0xFFE91E63);
  final Color accentPink = const Color(0xFFF8BBD0);

  bool isLoading = true;
  List<Map<String, dynamic>> mergedItems = [];
  late AnimationController _animController;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnim = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeInOut,
    );
    _loadProductData();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _loadProductData() async {
    setState(() => isLoading = true);

    var result = await ProductServices().getMovieUser();

    if (result.status == true && result.data != null) {
      List allProducts = result.data!;

      List<Map<String, dynamic>> items = [];
      for (var detailItem in widget.detail) {
        // Debug: print actual keys to verify field names
        debugPrint("Detail item keys: ${detailItem.keys.toList()}");
        debugPrint("Detail item values: $detailItem");

        // The cart sends 'barang_id' when ordering, so history returns 'barang_id'
        int idProduct = int.tryParse(
          (detailItem['barang_id'] ?? detailItem['id_product'] ?? detailItem['id'] ?? 0).toString(),
        ) ?? 0;
        int qty = int.tryParse(detailItem['quantity'].toString()) ?? 0;

        // Find matching product from allProducts list
        int matchIndex = allProducts.indexWhere((p) => p.id == idProduct);
        var matchedProduct = matchIndex != -1 ? allProducts[matchIndex] : null;

        items.add({
          'id_product': idProduct,
          'qty': qty,
          'nama_barang': matchedProduct?.nama_barang ?? 'Produk #$idProduct',
          'harga': matchedProduct?.harga ?? 0.0,
          'image': matchedProduct?.image ?? '',
          'deskripsi': matchedProduct?.deskripsi ?? '',
        });
      }

      setState(() {
        mergedItems = items;
        isLoading = false;
      });
      _animController.forward();
    } else {
      setState(() => isLoading = false);
    }
  }

  double get _totalPrice {
    double total = 0;
    for (var item in mergedItems) {
      total += (item['harga'] as double) * (item['qty'] as int);
    }
    return total;
  }

  String _formatCurrency(double amount) {
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    return formatter.format(amount);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildSliverAppBar(),
          if (isLoading)
            SliverFillRemaining(child: _buildLoadingState())
          else if (mergedItems.isEmpty)
            SliverFillRemaining(child: _buildEmptyState())
          else ...[
            SliverToBoxAdapter(child: _buildTransactionHeader()),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 4),
                child: Text(
                  "Daftar Produk 🛍️",
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[700],
                  ),
                ),
              ),
            ),
            _buildProductList(),
            SliverToBoxAdapter(child: _buildTotalSection()),
            const SliverToBoxAdapter(child: SizedBox(height: 30)),
          ],
        ],
      ),
    );
  }

  // ─── Sliver AppBar ───
  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 120,
      floating: false,
      pinned: true,
      backgroundColor: primaryPink,
      leading: IconButton(
        icon: Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.25),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.arrow_back_rounded, color: Colors.white, size: 20),
        ),
        onPressed: () => Navigator.pop(context),
      ),
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          "Detail Transaksi 🎀",
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [primaryPink, accentPink, softPink],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Stack(
            children: [
              // Decorative circles
              Positioned(
                top: -20,
                right: -20,
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.1),
                  ),
                ),
              ),
              Positioned(
                bottom: 10,
                left: 30,
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.08),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─── Loading State ───
  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 50,
            height: 50,
            child: CircularProgressIndicator(
              color: primaryPink,
              strokeWidth: 3,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            "Memuat data produk... 🧸",
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  // ─── Empty State ───
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_bag_outlined, size: 80, color: accentPink),
          const SizedBox(height: 16),
          Text(
            "Tidak ada produk ditemukan 🥺",
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  // ─── Transaction Header Card ───
  Widget _buildTransactionHeader() {
    return FadeTransition(
      opacity: _fadeAnim,
      child: Container(
        margin: const EdgeInsets.fromLTRB(20, 16, 20, 8),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, softPink.withOpacity(0.3)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: primaryPink.withOpacity(0.15),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            // Cute icon container
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [primaryPink, darkPink.withOpacity(0.6)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(
                Icons.receipt_long_rounded,
                color: Colors.white,
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Transaksi #${widget.idTransaksi}",
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.grey[800],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.check_circle_rounded,
                          color: Colors.green[400], size: 16),
                      const SizedBox(width: 6),
                      Text(
                        "Selesai",
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.green[400],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: primaryPink.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          "${widget.detail.length} item",
                          style: GoogleFonts.poppins(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: primaryPink,
                          ),
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
  }

  // ─── Product List ───
  Widget _buildProductList() {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          return _buildProductCard(mergedItems[index], index);
        },
        childCount: mergedItems.length,
      ),
    );
  }

  Widget _buildProductCard(Map<String, dynamic> item, int index) {
    double subtotal = (item['harga'] as double) * (item['qty'] as int);

    return FadeTransition(
      opacity: _fadeAnim,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: primaryPink.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: Column(
            children: [
              // Pink accent top line
              Container(
                height: 3,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      primaryPink.withOpacity(0.3),
                      primaryPink,
                      primaryPink.withOpacity(0.3),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(14),
                child: Row(
                  children: [
                    // Product Image
                    _buildProductImage(item),
                    const SizedBox(width: 14),
                    // Product Info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item['nama_barang'],
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[800],
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 6),
                          // Price per item
                          Row(
                            children: [
                              Text(
                                _formatCurrency(item['harga'] as double),
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey[500],
                                ),
                              ),
                              Text(
                                "  ×  ",
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  color: Colors.grey[400],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: softPink,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  "${item['qty']}",
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: primaryPink,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          // Subtotal
                          Text(
                            _formatCurrency(subtotal),
                            style: GoogleFonts.poppins(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: darkPink,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Item number badge
                    Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: softPink,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          "${index + 1}",
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: primaryPink,
                          ),
                        ),
                      ),
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

  Widget _buildProductImage(Map<String, dynamic> item) {
    String imageUrl = item['image'] ?? '';
    bool hasImage = imageUrl.isNotEmpty;

    return Container(
      width: 70,
      height: 70,
      decoration: BoxDecoration(
        color: softPink.withOpacity(0.5),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: accentPink, width: 1.5),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.5),
        child: hasImage
            ? Image.network(
                "${url.BaseUrlTanpaAPi}/$imageUrl",
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return _buildImagePlaceholder();
                },
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        color: primaryPink,
                        strokeWidth: 2,
                      ),
                    ),
                  );
                },
              )
            : _buildImagePlaceholder(),
      ),
    );
  }

  Widget _buildImagePlaceholder() {
    return Container(
      color: softPink.withOpacity(0.3),
      child: Icon(
        Icons.cake_rounded,
        color: primaryPink.withOpacity(0.5),
        size: 30,
      ),
    );
  }

  // ─── Total Section ───
  Widget _buildTotalSection() {
    return FadeTransition(
      opacity: _fadeAnim,
      child: Container(
        margin: const EdgeInsets.fromLTRB(20, 16, 20, 0),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [primaryPink, darkPink.withOpacity(0.7)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: primaryPink.withOpacity(0.3),
              blurRadius: 15,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          children: [
            // Summary rows
            _buildSummaryRow(
              "Jumlah Item",
              "${mergedItems.fold<int>(0, (sum, item) => sum + (item['qty'] as int))} pcs",
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Divider(
                color: Colors.white.withOpacity(0.3),
                thickness: 1,
              ),
            ),
            // Total
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Total Pembayaran",
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
                Text(
                  _formatCurrency(_totalPrice),
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            // Status badge
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.verified_rounded,
                      color: Colors.white, size: 18),
                  const SizedBox(width: 8),
                  Text(
                    "Transaksi Berhasil ✨",
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 13,
            color: Colors.white.withOpacity(0.8),
          ),
        ),
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
