import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:toko_online/widgets/bottom_nav.dart';

class TransaksiView extends StatefulWidget {
  const TransaksiView({super.key});
  @override
  State<TransaksiView> createState() => _TransaksiViewState();
}

class _TransaksiViewState extends State<TransaksiView> {
  final List<String> filterOptions = ['Semua', 'Dikemas', 'Dikirim', 'Selesai', 'Dibatalkan'];
  String selectedFilter = 'Semua';

  List<Map<String, dynamic>> transaksiList = [
    {
      'id': 'TRX-001',
      'status': 'Dikemas',
      'tanggal': '12 Jan 2024',
      'items': 3,
      'total': 85000,
      'customer': 'Budi Santoso',
      'itemsDetail': [
        {'nama': 'Jelly Strawberry', 'qty': 2, 'harga': 25000},
        {'nama': 'Jelly Blueberry', 'qty': 1, 'harga': 35000},
      ],
      'statusColor': Colors.orange,
    },
    {
      'id': 'TRX-002',
      'status': 'Dikirim',
      'tanggal': '11 Jan 2024',
      'items': 5,
      'total': 175000,
      'customer': 'Sari Dewi',
      'itemsDetail': [
        {'nama': 'Jelly Mix Berry', 'qty': 3, 'harga': 35000},
        {'nama': 'Jelly Mangga', 'qty': 2, 'harga': 22000},
      ],
      'statusColor': Colors.blue,
    },
    {
      'id': 'TRX-003',
      'status': 'Selesai',
      'tanggal': '10 Jan 2024',
      'items': 2,
      'total': 60000,
      'customer': 'Ahmad Fauzi',
      'itemsDetail': [
        {'nama': 'Jelly Lemon', 'qty': 2, 'harga': 30000},
      ],
      'statusColor': Colors.green,
    },
    {
      'id': 'TRX-004',
      'status': 'Selesai',
      'tanggal': '09 Jan 2024',
      'items': 4,
      'total': 132000,
      'customer': 'Maya Indah',
      'itemsDetail': [
        {'nama': 'Jelly Anggur', 'qty': 2, 'harga': 30000},
        {'nama': 'Jelly Strawberry', 'qty': 2, 'harga': 25000},
      ],
      'statusColor': Colors.green,
    },
    {
      'id': 'TRX-005',
      'status': 'Dibatalkan',
      'tanggal': '08 Jan 2024',
      'items': 1,
      'total': 28000,
      'customer': 'Rudi Hartono',
      'itemsDetail': [
        {'nama': 'Jelly Blueberry', 'qty': 1, 'harga': 28000},
      ],
      'statusColor': Colors.red,
    },
  ];

  final Color primaryColor = const Color(0xFFF6A5C0);
  final Color backgroundColor = const Color(0xFFFDF0F2);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text(
          "Transaksi & Pesanan",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w700,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: primaryColor,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () => _showNewTransactionDialog(context),
            icon: const Icon(Icons.add_circle_outline, color: Colors.white),
          ),
        ],
      ),
      body: Column(
        children: [
          // Stats Cards
          Container(
            padding: const EdgeInsets.all(20),
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildTransactionStat("Hari Ini", "Rp 850.000", Icons.today_rounded),
                _buildTransactionStat("Bulan Ini", "Rp 4.2 Jt", Icons.calendar_month_rounded),
                _buildTransactionStat("Total", "156", Icons.receipt_long_rounded),
              ],
            ),
          ),

          // Filter Chips
          Container(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
            color: Colors.white,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: filterOptions.map((filter) {
                  bool isSelected = filter == selectedFilter;
                  return Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: FilterChip(
                      label: Text(filter),
                      labelStyle: GoogleFonts.poppins(
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                        color: isSelected ? Colors.white : Colors.grey[700],
                      ),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() {
                          selectedFilter = filter;
                        });
                      },
                      selectedColor: primaryColor,
                      backgroundColor: backgroundColor,
                      checkmarkColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(
                          color: isSelected ? primaryColor : Colors.grey[300]!,
                          width: 1,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),

          // Transaction List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: transaksiList.length,
              itemBuilder: (context, index) {
                return _buildTransactionCard(transaksiList[index], index);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showNewTransactionDialog(context),
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

  Widget _buildTransactionStat(String label, String value, IconData icon) {
    return Column(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: primaryColor, size: 24),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: Colors.grey[800],
          ),
        ),
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 11,
            color: Colors.grey[500],
          ),
        ),
      ],
    );
  }

  Widget _buildTransactionCard(Map<String, dynamic> transaksi, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: (transaksi['statusColor'] as Color).withOpacity(0.05),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: transaksi['statusColor'],
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          transaksi['id'],
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.grey[800],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      transaksi['customer'],
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: transaksi['statusColor'].withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: transaksi['statusColor'].withOpacity(0.3)),
                  ),
                  child: Text(
                    transaksi['status'],
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: transaksi['statusColor'],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Items
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                for (var item in (transaksi['itemsDetail'] as List))
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: primaryColor.withOpacity(0.5),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            item['nama'],
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              color: Colors.grey[700],
                            ),
                          ),
                        ),
                        Text(
                          "${item['qty']}x",
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: Colors.grey[500],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          "Rp ${item['harga'].toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}",
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[800],
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),

          // Footer
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: Colors.grey[100]!, width: 1),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      transaksi['tanggal'],
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        color: Colors.grey[500],
                      ),
                    ),
                    Text(
                      "${transaksi['items']} item${transaksi['items'] > 1 ? 's' : ''}",
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "Total",
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        color: Colors.grey[500],
                      ),
                    ),
                    Text(
                      "Rp ${transaksi['total'].toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}",
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: primaryColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Action Buttons
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: Colors.grey[100]!, width: 1),
              ),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(15),
                bottomRight: Radius.circular(15),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (transaksi['status'] == 'Dikemas')
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _updateStatus(transaksi['id'], 'Dikirim'),
                      icon: const Icon(Icons.local_shipping_rounded, size: 16),
                      label: Text(
                        "Proses Pengiriman",
                        style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                if (transaksi['status'] == 'Dikirim')
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _updateStatus(transaksi['id'], 'Selesai'),
                      icon: const Icon(Icons.check_circle_rounded, size: 16),
                      label: Text(
                        "Tandai Selesai",
                        style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                const SizedBox(width: 10),
                IconButton(
                  onPressed: () => _viewDetails(transaksi),
                  icon: Icon(Icons.more_horiz_rounded, color: Colors.grey[600]),
                  tooltip: "Detail",
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showNewTransactionDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        height: MediaQuery.of(context).size.height * 0.85,
        child: Column(
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
              "Transaksi Baru",
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: [
                  // Add transaction form here
                ],
              ),
            ),
            SizedBox(
              width: double.infinity,
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
                  "Simpan Transaksi",
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _updateStatus(String transactionId, String newStatus) {
    setState(() {
      int index = transaksiList.indexWhere((t) => t['id'] == transactionId);
      if (index != -1) {
        transaksiList[index]['status'] = newStatus;
        transaksiList[index]['statusColor'] = _getStatusColor(newStatus);
      }
    });
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Dikemas':
        return Colors.orange;
      case 'Dikirim':
        return Colors.blue;
      case 'Selesai':
        return Colors.green;
      case 'Dibatalkan':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  void _viewDetails(Map<String, dynamic> transaksi) {
    // Implement view details
  }
}