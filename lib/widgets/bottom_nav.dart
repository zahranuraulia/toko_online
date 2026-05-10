import 'package:flutter/material.dart';
import 'package:toko_online/models/user_login.dart';

class BottomNav extends StatefulWidget {
  final int activePage;
  BottomNav(this.activePage, {super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  UserLogin userLogin = UserLogin();
  String? role;

  getDataLogin() async {
    var user = await userLogin.getUserLogin();
    if (user.status != false) {
      if (mounted) {
        setState(() {
          role = user.role;
        });
      }
    } else {
      if (mounted) Navigator.popAndPushNamed(context, '/login');
    }
  }

  @override
  void initState() {
    super.initState();
    getDataLogin();
  }

  void getLink(index) {
    if (role == "admin") {
      if (index == 0) Navigator.pushReplacementNamed(context, '/dashboard');
      if (index == 1) Navigator.pushReplacementNamed(context, '/produk');
    } else if (role == "user") {
      if (index == 0) Navigator.pushReplacementNamed(context, '/dashboard');
      if (index == 1) Navigator.pushReplacementNamed(context, '/pesan');
      if (index == 2) Navigator.pushReplacementNamed(context, '/history');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (role == null) return const SizedBox();

    return role == "admin"
        ? BottomNavigationBar(
            selectedItemColor: Colors.black,
            unselectedItemColor: Colors.grey,
            currentIndex: widget.activePage,
            onTap: (index) => getLink(index),
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
              BottomNavigationBarItem(icon: Icon(Icons.file_copy), label: 'Movie'),
            ],
          )
        : BottomNavigationBar(
            selectedItemColor: Colors.black,
            unselectedItemColor: Colors.grey,
            currentIndex: widget.activePage,
            onTap: (index) => getLink(index),
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
              BottomNavigationBarItem(icon: Icon(Icons.card_giftcard), label: 'Pesan'),
              BottomNavigationBarItem(icon: Icon(Icons.history), label: 'History'),
            ],
          );
  }
}