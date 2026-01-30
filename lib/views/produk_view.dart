import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:toko_online/widgets/bottom_nav.dart';

class ProdukView extends StatefulWidget {
  const ProdukView({super.key});
  @override
  State<ProdukView> createState() => _ProdukViewState();
}

class _ProdukViewState extends State<ProdukView> {
  List<Map<String, dynamic>> produkList = [
    {
      'nama': 'Jelly Strawberry',
      'kategori': 'Jelly Buah',
      'harga': 25000,
      'harga_asli': 30000,
      'diskon': 17,
      'stok': 45,
      'gambar': 'assets/jelly_strawberry.png', // Ganti dengan path gambar Anda
      'rating': 4.8,
      'terjual': 156,
      'lokasi': 'KAB. TANGERANG',
      'gratis_ongkir': true,
      'cicilan': 'Cicilan 0%',
    },
    {
      'nama': 'Jelly Blueberry',
      'kategori': 'Jelly Buah',
      'harga': 28000,
      'harga_asli': 35000,
      'diskon': 20,
      'stok': 32,
      'gambar': 'assets/jelly_blueberry.png',
      'rating': 4.9,
      'terjual': 89,
      'lokasi': 'KOTA JAKARTA SELATAN',
      'gratis_ongkir': true,
      'cicilan': '',
    },
    {
      'nama': 'Jelly Mix Berry',
      'kategori': 'Jelly Mix',
      'harga': 35000,
      'harga_asli': 42000,
      'diskon': 17,
      'stok': 54,
      'gambar': 'assets/jelly_mix.png',
      'rating': 4.9,
      'terjual': 145,
      'lokasi': 'KOTA SURABAYA',
      'gratis_ongkir': false,
      'cicilan': 'Cicilan 0%',
    },
    {
      'nama': 'Jelly Mangga',
      'kategori': 'Jelly Buah',
      'harga': 22000,
      'harga_asli': 28000,
      'diskon': 21,
      'stok': 67,
      'gambar': 'assets/jelly_mango.png',
      'rating': 4.7,
      'terjual': 123,
      'lokasi': 'KAB. BEKASI',
      'gratis_ongkir': true,
      'cicilan': '',
    },
    {
      'nama': 'Jelly lotus biscoff',
      'kategori': 'Jelly Biscuit',
      'harga': 30000,
      'harga_asli': 38000,
      'diskon': 21,
      'stok': 28,
      'gambar': 'assets/jelly_lotus.png',
      'rating': 4.6,
      'terjual': 76,
      'lokasi': 'KOTA BANDUNG',
      'gratis_ongkir': true,
      'cicilan': 'Cicilan Rp 5RBx6',
    },
    {
      'nama': 'Jelly oreo',
      'kategori': 'Jelly Biscuit',
      'harga': 24000,
      'harga_asli': 30000,
      'diskon': 20,
      'stok': 39,
      'gambar': 'assets/jelly_oreo.png',
      'rating': 4.5,
      'terjual': 98,
      'lokasi': 'KOTA YOGYAKARTA',
      'gratis_ongkir': false,
      'cicilan': '',
    },
    {
      'nama': 'Jelly Marie regal',
      'kategori': 'Jelly Biscuit',
      'harga': 27000,
      'harga_asli': 33000,
      'diskon': 18,
      'stok': 42,
      'gambar': 'assets/jelly_regal.png',
      'rating': 4.7,
      'terjual': 67,
      'lokasi': 'KAB. SEMARANG',
      'gratis_ongkir': true,
      'cicilan': 'Cicilan 0%',
    },
    {
      'nama': 'Jelly Mixed Pack',
      'kategori': 'Jelly Mix',
      'harga': 85000,
      'harga_asli': 100000,
      'diskon': 15,
      'stok': 25,
      'gambar': 'assets/jelly_pack.png',
      'rating': 4.9,
      'terjual': 189,
      'lokasi': 'KOTA JAKARTA PUSAT',
      'gratis_ongkir': true,
      'cicilan': 'Cicilan Rp 14RBx6',
    },
  ];

  final Color primaryColor = const Color(0xFFF6A5C0);
  final Color backgroundColor = const Color(0xFFFDF0F2);
  final Color secondaryColor = const Color(0xFF4CAF50); // Hijau untuk diskon

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text(
          "Data Produk Jelly",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w700,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: primaryColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            onPressed: () => _showFilterDialog(context),
            icon: const Icon(Icons.filter_list_rounded, color: Colors.white),
            tooltip: 'Filter',
          ),
          IconButton(
            onPressed: () => _showAddProductDialog(context),
            icon: const Icon(Icons.add_circle_outline, color: Colors.white),
            tooltip: 'Tambah Produk',
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar & Filter
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 45,
                    decoration: BoxDecoration(
                      color: backgroundColor,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: primaryColor.withOpacity(0.2)),
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "Cari produk jelly...",
                        hintStyle: GoogleFonts.poppins(color: Colors.grey[500]),
                        prefixIcon: Icon(Icons.search_rounded, color: primaryColor),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 15),
                      ),
                      style: GoogleFonts.poppins(fontSize: 14),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  width: 45,
                  height: 45,
                  decoration: BoxDecoration(
                    color: primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: primaryColor.withOpacity(0.3)),
                  ),
                  child: IconButton(
                    icon: Icon(Icons.tune_rounded, color: primaryColor),
                    onPressed: () => _showSortDialog(context),
                    padding: EdgeInsets.zero,
                  ),
                ),
              ],
            ),
          ),

          // Stats Info
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${produkList.length} produk ditemukan",
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                Row(
                  children: [
                    Icon(Icons.local_fire_department_rounded, color: Colors.orange, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      "Terlaris",
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.orange,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Product Grid (Marketplace Style)
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(12),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.75, // Lebih tinggi untuk gambar
              ),
              itemCount: produkList.length,
              itemBuilder: (context, index) {
                return _buildProductCard(produkList[index]);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddProductDialog(context),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.add_rounded, size: 28),
      ),
      bottomNavigationBar: const BottomNav(1),
    );
  }

  Widget _buildProductCard(Map<String, dynamic> produk) {
    return GestureDetector(
      onTap: () => _showProductDetail(produk),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            Stack(
              children: [
                Container(
                  height: 120,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                    ),
                    image: DecorationImage(
                      // Ganti dengan Image.asset jika punya gambar
                      image: NetworkImage(
                        'https://source.unsplash.com/random/300x200?jelly,dessert&${produk['nama']}',
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                
                // Discount Badge
                if (produk['diskon'] > 0)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                      decoration: BoxDecoration(
                        color: secondaryColor,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        "${produk['diskon']}%",
                        style: GoogleFonts.poppins(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                
                // Free Shipping Badge
                if (produk['gratis_ongkir'] == true)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        "Gratis\nOngkir",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: 8,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          height: 1.1,
                        ),
                      ),
                    ),
                  ),
              ],
            ),

            // Product Info
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Product Name
                    Text(
                      produk['nama'],
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[800],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    // Rating & Sold
                    Row(
                      children: [
                        Row(
                          children: [
                            Icon(Icons.star_rounded, color: Colors.amber, size: 12),
                            const SizedBox(width: 2),
                            Text(
                              "${produk['rating']}",
                              style: GoogleFonts.poppins(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey[700],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 8),
                        Container(
                          width: 1,
                          height: 10,
                          color: Colors.grey[300],
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "${produk['terjual']} terjual",
                          style: GoogleFonts.poppins(
                            fontSize: 10,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),

                    // Price Section
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Discounted Price
                        Text(
                          "Rp ${_formatPrice(produk['harga'])}",
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: primaryColor,
                          ),
                        ),

                        // Original Price & Installment
                        Row(
                          children: [
                            if (produk['harga_asli'] > produk['harga'])
                              Text(
                                "Rp ${_formatPrice(produk['harga_asli'])}",
                                style: GoogleFonts.poppins(
                                  fontSize: 10,
                                  color: Colors.grey[500],
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                            if (produk['cicilan'].isNotEmpty)
                              Expanded(
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: primaryColor.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      produk['cicilan'],
                                      style: GoogleFonts.poppins(
                                        fontSize: 8,
                                        fontWeight: FontWeight.w600,
                                        color: primaryColor,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),

                    // Location & Stock
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            produk['lokasi'],
                            style: GoogleFonts.poppins(
                              fontSize: 9,
                              color: Colors.grey[500],
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: produk['stok'] > 10 
                                ? Colors.green.withOpacity(0.1) 
                                : Colors.orange.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(
                              color: produk['stok'] > 10 
                                  ? Colors.green.withOpacity(0.3) 
                                  : Colors.orange.withOpacity(0.3),
                            ),
                          ),
                          child: Text(
                            produk['stok'] > 10 ? "Tersedia" : "Hampir Habis",
                            style: GoogleFonts.poppins(
                              fontSize: 8,
                              fontWeight: FontWeight.w600,
                              color: produk['stok'] > 10 ? Colors.green : Colors.orange,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatPrice(int price) {
    return price.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    );
  }

  void _showFilterDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "Filter Produk",
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 15),
            
            // Filter Categories
            Text(
              "Kategori",
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _filterChip("Semua", true),
                _filterChip("Jelly Buah", false),
                _filterChip("Jelly Mix", false),
                _filterChip("Paket", false),
              ],
            ),
            
            const SizedBox(height: 20),
            
            // Sort Options
            Text(
              "Urutkan",
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 10),
            Column(
              children: [
                _sortOption("Terlaris", true),
                _sortOption("Harga Terendah", false),
                _sortOption("Harga Tertinggi", false),
                _sortOption("Rating Tertinggi", false),
                _sortOption("Diskon Terbesar", false),
              ],
            ),
            
            const SizedBox(height: 30),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.grey[600],
                      side: BorderSide(color: Colors.grey[300]!),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      "Reset",
                      style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      "Terapkan",
                      style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _filterChip(String label, bool selected) {
    return FilterChip(
      label: Text(label),
      labelStyle: GoogleFonts.poppins(
        fontSize: 12,
        fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
        color: selected ? Colors.white : Colors.grey[700],
      ),
      selected: selected,
      onSelected: (value) {},
      selectedColor: primaryColor,
      backgroundColor: Colors.grey[100],
      checkmarkColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }

  Widget _sortOption(String label, bool selected) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: selected ? primaryColor : Colors.grey[400]!,
                width: 2,
              ),
            ),
            child: selected
                ? Center(
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: primaryColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                  )
                : null,
          ),
          const SizedBox(width: 12),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.grey[700],
              fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  void _showSortDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "Urutkan Berdasarkan",
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 20),
            ...['Terlaris', 'Harga Terendah', 'Harga Tertinggi', 'Rating Tertinggi', 'Diskon Terbesar']
                .map((option) => _sortOptionItem(option))
                .toList(),
          ],
        ),
      ),
    );
  }

  Widget _sortOptionItem(String label) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 10),
      child: TextButton(
        onPressed: () => Navigator.pop(context),
        style: TextButton.styleFrom(
          foregroundColor: Colors.grey[800],
          padding: const EdgeInsets.symmetric(vertical: 15),
          alignment: Alignment.centerLeft,
        ),
        child: Text(
          label,
          style: GoogleFonts.poppins(fontSize: 16),
        ),
      ),
    );
  }

  void _showAddProductDialog(BuildContext context) {
    // Implementasi dialog tambah produk
  }

  void _showProductDetail(Map<String, dynamic> produk) {
    // Implementasi detail produk
  }
}