import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:toko_online/services/user.dart';
import 'package:toko_online/widgets/alert.dart';

class RegisterUserView extends StatefulWidget {
  const RegisterUserView({super.key});

  @override
  State<RegisterUserView> createState() => _RegisterUserViewState();
}

class _RegisterUserViewState extends State<RegisterUserView> {
  UserService user = UserService();
  final formKey = GlobalKey<FormState>();

  final TextEditingController name = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();

  bool isPasswordVisible = false;
  bool isLoading = false;
  String? role;
  List<String> roleChoice = ["admin", "kasir"];

  final Color primaryColor = const Color(0xFFF6A5C0);
  final Color backgroundColor = const Color(0xFFFDF0F2);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context), // Kembali ke Login
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: primaryColor),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: primaryColor.withOpacity(0.15),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    "Create Account",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                  const SizedBox(height: 30),

                  _buildInput(
                    "Nama Lengkap",
                    name,
                    Icons.person_outline_rounded,
                  ),
                  const SizedBox(height: 20),
                  _buildInput("Email Address", email, Icons.email_outlined),
                  const SizedBox(height: 20),

                  // ROLE DROPDOWN
                  DropdownButtonFormField<String>(
                    value: role,
                    decoration: _inputDecoration(
                      "Pilih Role",
                      Icons.badge_outlined,
                    ),
                    items: roleChoice
                        .map((r) => DropdownMenuItem(value: r, child: Text(r)))
                        .toList(),
                    onChanged: (value) => setState(() => role = value),
                    validator: (value) =>
                        value == null ? 'Role harus dipilih' : null,
                  ),
                  const SizedBox(height: 20),

                  // PASSWORD
                  TextFormField(
                    controller: password,
                    obscureText: !isPasswordVisible,
                    decoration: _inputDecoration(
                      "Password",
                      Icons.lock_outline_rounded,
                      suffix: IconButton(
                        icon: Icon(
                          isPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: primaryColor,
                        ),
                        onPressed: () => setState(
                          () => isPasswordVisible = !isPasswordVisible,
                        ),
                      ),
                    ),
                    validator: (value) =>
                        value!.isEmpty ? 'Password harus diisi' : null,
                  ),

                  const SizedBox(height: 40),

                  SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      onPressed: isLoading ? null : _handleRegister,
                      child: isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : Text(
                              "DAFTAR SEKARANG",
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),

                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Sudah punya akun? ", style: GoogleFonts.poppins()),
                      GestureDetector(
                        onTap: () => Navigator.pop(context), // Kembali ke Login
                        child: Text(
                          "Login disini",
                          style: GoogleFonts.poppins(
                            color: primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInput(String hint, TextEditingController ctr, IconData icon) {
    return TextFormField(
      controller: ctr,
      decoration: _inputDecoration(hint, icon),
      validator: (value) => value!.isEmpty ? '$hint harus diisi' : null,
    );
  }

  InputDecoration _inputDecoration(
    String hint,
    IconData icon, {
    Widget? suffix,
  }) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(icon, color: primaryColor),
      suffixIcon: suffix,
      filled: true,
      fillColor: const Color(0xFFFAFAFA),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(color: primaryColor),
      ),
    );
  }

void _handleRegister() async {
    if (formKey.currentState!.validate()) {
      setState(() => isLoading = true);
      
      var data = {
        "name": name.text, 
        "email": email.text, 
        "role": role, 
        "password": password.text
      };

      var result = await user.registerUser(data);
      
      setState(() => isLoading = false);

      if (result.status) {
        // Tampilkan pesan sukses
        AlertMessage().showAlert(context, "Registrasi Berhasil! Silahkan Login.", true);
        
        // --- PERUBAHAN DI SINI ---
        // Menuju ke halaman login setelah 2 detik
        Future.delayed(const Duration(seconds: 2), () {
          // Kita gunakan pushNamedAndRemoveUntil ke /login agar history register terhapus
          Navigator.pushNamedAndRemoveUntil(
            context,
            '/login',
            (route) => false
          );
        });
      } else {
        AlertMessage().showAlert(context, result.message, false);
      }
    }
  }
}
