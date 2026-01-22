import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:toko_online/services/user.dart';
import 'package:toko_online/views/register_user_views.dart';
import 'package:toko_online/widgets/alert.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  UserService user = UserService();
  final formKey = GlobalKey<FormState>();

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  bool isLoading = false;
  bool showPass = true;

  final Color primaryPink = const Color(0xFFF6A5C0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF0F2),
      appBar: AppBar(
        title: Text(
          "Login",
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: primaryPink,
        centerTitle: true,
        automaticallyImplyLeading: false, // <-- Menghilangkan tombol back
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Center(
              child: SizedBox(
                height: 120,
                child: Image.asset(
                  'assets/logoPinkJelly.png', 
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) => Icon(Icons.image_not_supported, size: 80, color: primaryPink),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: primaryPink.withValues(alpha: 0.15),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    Text("Welcome Back!", style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.w800, color: primaryPink)),
                    const SizedBox(height: 8),
                    Text("Silahkan masuk ke akun anda", style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[500])),
                    const SizedBox(height: 30),

                    // EMAIL
                    TextFormField(
                      controller: email,
                      decoration: _inputStyle("Email", Icons.email_outlined),
                      validator: (value) => value!.isEmpty ? 'Email harus diisi' : null,
                    ),
                    const SizedBox(height: 20),

                    // PASSWORD
                    TextFormField(
                      controller: password,
                      obscureText: showPass,
                      decoration: _inputStyle("Password", Icons.lock_outline, isPassword: true),
                      validator: (value) => value!.isEmpty ? 'Password harus diisi' : null,
                    ),
                    const SizedBox(height: 30),

                    // BUTTON LOGIN
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: MaterialButton(
                        onPressed: _handleLogin,
                        color: primaryPink,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        child: isLoading 
                          ? const CircularProgressIndicator(color: Colors.white) 
                          : Text("LOGIN", style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold)),
                      ),
                    ),
                    
                    const SizedBox(height: 24),

                    // --- TOMBOL MENUJU REGISTER ---
Row(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
    Text(
      "Belum punya akun? ",
      style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[600]),
    ),
    GestureDetector(
      onTap: () {
        // MENGGUNAKAN MATERIAL PAGE ROUTE AGAR PASTI BISA PINDAH HALAMAN
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const RegisterUserView()),
        );
      },
      child: Text(
        "Daftar Sekarang",
        style: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: primaryPink, // Warna pink sesuai tema
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

  InputDecoration _inputStyle(String label, IconData icon, {bool isPassword = false}) {
    return InputDecoration(
      labelText: label,
      labelStyle: GoogleFonts.poppins(color: Colors.grey[600]),
      filled: true,
      fillColor: const Color(0xFFFAFAFA),
      prefixIcon: Icon(icon, color: primaryPink),
      suffixIcon: isPassword ? IconButton(
        icon: Icon(showPass ? Icons.visibility_off : Icons.visibility, color: primaryPink),
        onPressed: () => setState(() => showPass = !showPass),
      ) : null,
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide(color: primaryPink, width: 1.5)),
    );
  }

  void _handleLogin() async {
    if (formKey.currentState!.validate()) {
      setState(() => isLoading = true);
      var result = await user.loginUser({"email": email.text, "password": password.text});
      setState(() => isLoading = false);

      if (result.status == true) {
        AlertMessage().showAlert(context, result.message, true);
        Future.delayed(const Duration(seconds: 2), () => Navigator.pushReplacementNamed(context, '/dashboard'));
      } else {
        AlertMessage().showAlert(context, result.message, false);
      }
    }
  }
}