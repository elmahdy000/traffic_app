import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:google_fonts/google_fonts.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool isLogin = true;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  bool _isPasswordVisible = false;

  void _toggleMode() {
    setState(() {
      isLogin = !isLogin;
    });
  }

  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordVisible = !_isPasswordVisible;
    });
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      final phone = phoneController.text.trim();
      final password = passwordController.text.trim();
      print(isLogin ? 'تسجيل الدخول بـ: $phone' : 'إنشاء حساب بـ: $phone');
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFFE3F2FD),
                Color(0xFFFFFFFF),
              ],
            ),
          ),
          child: Stack(
            children: [
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                child: Container(
                  color: Colors.white.withOpacity(0.2),
                ),
              ),
              SafeArea(
                child: Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: ZoomIn(
                      duration: const Duration(milliseconds: 800),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.asset(
                              'traffice.jpg',
                              fit: BoxFit.cover,
                              height: 180,
                            ),
                          ),
                          const SizedBox(height: 16),
                          ElasticIn(
                            duration: const Duration(milliseconds: 1000),
                            child: Text(
                              'تطبيق المرور',
                              style: GoogleFonts.cairo(
                                fontSize: 36,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue.shade700,
                                shadows: [
                                  Shadow(
                                    blurRadius: 10.0,
                                    color: Colors.black.withOpacity(0.3),
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          Container(
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.95),
                              borderRadius: BorderRadius.circular(24),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 20,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                  FadeInUp(
                                    duration: const Duration(milliseconds: 600),
                                    child: TextFormField(
                                      controller: phoneController,
                                      style: GoogleFonts.cairo(),
                                      textDirection: TextDirection.rtl,
                                      keyboardType: TextInputType.phone,
                                      decoration: InputDecoration(
                                        prefixIcon:
                                            const Icon(Icons.phone_android),
                                        labelText: 'رقم الهاتف',
                                        labelStyle: GoogleFonts.cairo(),
                                        filled: true,
                                        fillColor: Colors.grey.shade100,
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          borderSide: BorderSide.none,
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          borderSide: const BorderSide(
                                            color: Colors.blue,
                                            width: 2,
                                          ),
                                        ),
                                      ),
                                      validator: (value) => value != null &&
                                              value.length == 11
                                          ? null
                                          : 'برجاء إدخال رقم هاتف صحيح مكون من 11 رقمًا',
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  FadeInUp(
                                    duration: const Duration(milliseconds: 700),
                                    child: TextFormField(
                                      controller: passwordController,
                                      style: GoogleFonts.cairo(),
                                      textDirection: TextDirection.rtl,
                                      decoration: InputDecoration(
                                        prefixIcon:
                                            const Icon(Icons.lock_outline),
                                        suffixIcon: IconButton(
                                          icon: Icon(
                                            _isPasswordVisible
                                                ? Icons.visibility
                                                : Icons.visibility_off,
                                          ),
                                          onPressed: _togglePasswordVisibility,
                                        ),
                                        labelText: 'كلمة المرور',
                                        labelStyle: GoogleFonts.cairo(),
                                        filled: true,
                                        fillColor: Colors.grey.shade100,
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          borderSide: BorderSide.none,
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          borderSide: const BorderSide(
                                            color: Colors.blue,
                                            width: 2,
                                          ),
                                        ),
                                      ),
                                      obscureText: !_isPasswordVisible,
                                      validator: (value) => value != null &&
                                              value.length >= 6
                                          ? null
                                          : 'كلمة المرور يجب أن تكون 6 أحرف على الأقل',
                                    ),
                                  ),
                                  if (!isLogin) ...[
                                    const SizedBox(height: 16),
                                    FadeInUp(
                                      duration:
                                          const Duration(milliseconds: 800),
                                      child: TextFormField(
                                        controller: confirmPasswordController,
                                        style: GoogleFonts.cairo(),
                                        textDirection: TextDirection.rtl,
                                        decoration: InputDecoration(
                                          prefixIcon:
                                              const Icon(Icons.lock_outline),
                                          suffixIcon: IconButton(
                                            icon: Icon(
                                              _isPasswordVisible
                                                  ? Icons.visibility
                                                  : Icons.visibility_off,
                                            ),
                                            onPressed:
                                                _togglePasswordVisibility,
                                          ),
                                          labelText: 'تأكيد كلمة المرور',
                                          labelStyle: GoogleFonts.cairo(),
                                          filled: true,
                                          fillColor: Colors.grey.shade100,
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            borderSide: BorderSide.none,
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            borderSide: const BorderSide(
                                              color: Colors.blue,
                                              width: 2,
                                            ),
                                          ),
                                        ),
                                        obscureText: !_isPasswordVisible,
                                        validator: (value) =>
                                            value == passwordController.text
                                                ? null
                                                : 'كلمتا المرور غير متطابقتين',
                                      ),
                                    ),
                                  ],
                                  const SizedBox(height: 24),
                                  FadeInUp(
                                    duration: const Duration(milliseconds: 900),
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.blue.shade600,
                                        foregroundColor: Colors.white,
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 16,
                                          horizontal: 32,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        elevation: 5,
                                      ),
                                      onPressed: _submit,
                                      child: Text(
                                        isLogin ? 'تسجيل الدخول' : 'إنشاء حساب',
                                        style: GoogleFonts.cairo(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  FadeInUp(
                                    duration:
                                        const Duration(milliseconds: 1000),
                                    child: TextButton(
                                      onPressed: _toggleMode,
                                      child: Text(
                                        isLogin
                                            ? 'ليس لديك حساب؟ إنشاء حساب'
                                            : 'لديك حساب؟ تسجيل الدخول',
                                        style: GoogleFonts.cairo(
                                          color: Colors.blue.shade700,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
