// pages/reset.dart
import 'package:flutter/material.dart';
import 'package:duka_app/l10n/app_localizations.dart';
import 'package:duka_app/main.dart';
import 'package:duka_app/services/auth_service.dart';
import 'package:duka_app/widgets/image_background.dart';
import 'login.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({Key? key}) : super(key: key);

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final AuthService _authService = AuthService();
  String _selectedLanguage = 'English';
  bool _languageInitialized = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_languageInitialized) {
      final code = AppLocale.of(context).languageCode;
      _selectedLanguage = code == 'sw' ? 'Swahili' : 'English';
      _languageInitialized = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: ImageBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                const SizedBox(height: 20),
                // Back button
                Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back_ios, color: Colors.black87),
                      padding: EdgeInsets.zero,
                    ),
                    Text(
                      _selectedLanguage == 'English' ? 'Back' : 'Rudi',
                      style: const TextStyle(
                        color: Color(0xFF800000),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                // Title
                Text(
                  _selectedLanguage == 'English' ? 'Reset Password 🔐' : 'Rekebisha Neno la Siri 🔐',
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 12),
                // Subtitle
                Text(
                  _selectedLanguage == 'English'
                      ? 'Enter your email and we will send you a link to reset your password'
                      : 'Weka barua pepe yako na tutakutumia kiungo cha kurekebisha neno la siri',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 40),
                // Form
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Email label
                      Text(
                        _selectedLanguage == 'English' ? 'Email' : 'Barua Pepe',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade700,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Email field
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.email_outlined,
                            color: Color(0xFF800000),
                            size: 20,
                          ),
                          hintText: _selectedLanguage == 'English'
                              ? 'Enter your email'
                              : 'Weka barua pepe yako',
                          hintStyle: TextStyle(
                            color: Colors.grey.shade400,
                            fontSize: 14,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide: BorderSide(
                              color: Color(0xFF800000),
                              width: 1.5,
                            ),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 16,
                          ),
                          filled: true,
                          fillColor: Colors.grey.shade50,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return _selectedLanguage == 'English'
                                ? 'Email is required'
                                : 'Barua pepe inahitajika';
                          }
                          if (!value.contains('@')) {
                            return _selectedLanguage == 'English'
                                ? 'Please enter a valid email'
                                : 'Weka barua pepe halali';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 32),
                      // Landing Style Send Reset Link Button
                      GestureDetector(
                        onTap: _isLoading
                            ? null
                            : () async {
                                if (_formKey.currentState!.validate()) {
                                  setState(() {
                                    _isLoading = true;
                                  });
                                  
                                  final result = await _authService.sendResetLink(
                                    username: _emailController.text.trim(),
                                  );
                                  
                                  setState(() {
                                    _isLoading = false;
                                  });
                                  
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(result['message']),
                                      backgroundColor: result['success'] ? Color(0xFF800000) : Colors.red,
                                    ),
                                  );
                                }
                              },
                        child: Container(
                          width: double.infinity,
                          height: 56,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Color(0xFF800000),
                                Color(0xFFA52A2A),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(22),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF800000).withOpacity(0.35),
                                blurRadius: 20,
                                offset: const Offset(0, 8),
                                spreadRadius: 2,
                              ),
                              BoxShadow(
                                color: const Color(0xFF800000).withOpacity(0.15),
                                blurRadius: 40,
                                offset: const Offset(0, 12),
                                spreadRadius: 8,
                              ),
                            ],
                          ),
                          child: Center(
                            child: _isLoading
                                ? const SizedBox(
                                    height: 24,
                                    width: 24,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.5,
                                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                    ),
                                  )
                                : Text(
                                    _selectedLanguage == 'English'
                                        ? 'Send Reset Link'
                                        : 'Tuma Kiungo',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      // Back to login link
                      Center(
                        child: GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Text(
                            _selectedLanguage == 'English'
                                ? 'Back to Sign In'
                                : 'Rudi kwenye Kuingia',
                            style: TextStyle(
                              color: Color(0xFF800000),
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
      ),
    );
  }
}
