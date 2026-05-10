import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:toko_online/services/product_services.dart';
import 'package:toko_online/views/transaction_detail_view.dart';
import 'package:toko_online/widgets/bottom_nav.dart';

class HistoryView extends StatefulWidget {
  const HistoryView({super.key});

  @override
  State<HistoryView> createState() => _HistoryViewState();
}

class _HistoryViewState extends State<HistoryView> {
  // ─── Color Palette ───
  final Color primaryPink = const Color(0xFFF6A5C0);
  final Color softPink = const Color(0xFFFCE4EC);
  final Color bgColor = const Color(0xFFFDF0F5);
  final Color darkPink = const Color(0xFFE91E63);
  final Color accentPink = const Color(0xFFF8BBD0);

  List? history;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getHistoryData();
  }

  void getHistoryData() async {
    setState(() => isLoading = true);
    var result = await ProductServices().getHistory();
    if (result.status == true) {
      setState(() {
        history = result.data; // Ini berisi list "pesan" dari API
        isLoading = false;
      });
    } else {
      print(result.message);
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Text(
          "Riwayat Transaksi 🎀",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w700,
            fontSize: 18,
            color: primaryPink,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: primaryPink),
      ),
      body: isLoading
          ? _buildLoadingState()
          : (history == null || history!.isEmpty)
              ? _buildEmptyState()
              : RefreshIndicator(
                  onRefresh: () async => getHistoryData(),
                  color: primaryPink,
                  child: ListView.builder(
                    physics: const BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics(),
                    ),
                    padding: const EdgeInsets.fromLTRB(16, 10, 16, 20),
                    itemCount: history!.length,
                    itemBuilder: (context, index) {
                      var item = history![index];
                      return _buildHistoryCard(item, index);
                    },
                  ),
                ),
      bottomNavigationBar: BottomNav(2),
    );
  }

  // ─── Loading State ───
  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 45,
            height: 45,
            child: CircularProgressIndicator(
              color: primaryPink,
              strokeWidth: 3,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            "Memuat riwayat... 🧸",
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
          Icon(
            Icons.receipt_long_outlined,
            size: 80,
            color: accentPink,
          ),
          const SizedBox(height: 16),
          Text(
            "Belum ada transaksi 🥺",
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey[500],
            ),
          ),
          const SizedBox(height: 6),
          Text(
            "Yuk mulai belanja sekarang!",
            style: GoogleFonts.poppins(
              fontSize: 13,
              color: Colors.grey[400],
            ),
          ),
        ],
      ),
    );
  }

  // ─── History Card ───
  Widget _buildHistoryCard(dynamic item, int index) {
    int itemCount = (item['detail'] as List).length;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TransactionDetailView(
              idTransaksi: item['id_transaksi'] is int
                  ? item['id_transaksi']
                  : int.tryParse(item['id_transaksi'].toString()) ?? 0,
              detail: List<Map<String, dynamic>>.from(
                (item['detail'] as List).map((e) => Map<String, dynamic>.from(e)),
              ),
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: primaryPink.withOpacity(0.1),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: Column(
            children: [
              // Top pink accent bar
              Container(
                height: 3,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      primaryPink.withOpacity(0.2),
                      primaryPink,
                      primaryPink.withOpacity(0.2),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    // Cute icon container
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            primaryPink.withOpacity(0.15),
                            softPink,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(
                        Icons.shopping_bag_rounded,
                        color: primaryPink,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 14),
                    // Info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Transaksi #${item['id_transaksi']}",
                            style: GoogleFonts.poppins(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[800],
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: softPink,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  "$itemCount barang",
                                  style: GoogleFonts.poppins(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: primaryPink,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Icon(Icons.check_circle,
                                  color: Colors.green[400], size: 14),
                              const SizedBox(width: 4),
                              Text(
                                "Selesai",
                                style: GoogleFonts.poppins(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.green[400],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Arrow + "Lihat" button
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: primaryPink.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Lihat",
                            style: GoogleFonts.poppins(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: primaryPink,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Icon(
                            Icons.arrow_forward_ios_rounded,
                            color: primaryPink,
                            size: 12,
                          ),
                        ],
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
}
