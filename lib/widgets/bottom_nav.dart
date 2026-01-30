import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class BottomNav extends StatefulWidget {
  final int activePage;

  const BottomNav(this.activePage, {super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  String role = 'kasir';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserRole();
  }

  Future<void> _loadUserRole() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      String? userData = prefs.getString('user') ??
          prefs.getString('userData') ??
          prefs.getString('user_login') ??
          prefs.getString('data');

      if (userData != null) {
        final Map<String, dynamic> data = jsonDecode(userData);

        role = (data['role'] ??
                data['user_role'] ??
                data['level'] ??
                'kasir')
            .toString()
            .trim()
            .toLowerCase();
      }

      // fallback jika role disimpan langsung
      final String? directRole = prefs.getString('role');
      if (directRole != null) {
        role = directRole.trim().toLowerCase();
      }
    } catch (e) {
      role = 'kasir';
    }

    setState(() {
      isLoading = false;
    });
  }

  String _getRoute(int index) {
    if (index == 0) return '/dashboard';

    if (index == 1) {
      return role == 'admin' ? '/produk' : '/transaksi';
    }

    return '/dashboard';
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const SizedBox(
        height: 70,
        child: Center(
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      );
    }

    return BottomNavigationBar(
      currentIndex: widget.activePage,
      selectedItemColor: const Color(0xFFF6A5C0),
      unselectedItemColor: Colors.grey,
      type: BottomNavigationBarType.fixed,
      onTap: (index) {
        if (index != widget.activePage) {
          Navigator.pushReplacementNamed(
            context,
            _getRoute(index),
          );
        }
      },
      items: [
        const BottomNavigationBarItem(
          icon: Icon(Icons.home_rounded),
          label: 'Home',
        ),
        role == 'admin'
            ? const BottomNavigationBarItem(
                icon: Icon(Icons.shopping_bag_rounded),
                label: 'Produk',
              )
            : const BottomNavigationBarItem(
                icon: Icon(Icons.receipt_long_rounded),
                label: 'Transaksi',
              ),
      ],
    );
  }
}
