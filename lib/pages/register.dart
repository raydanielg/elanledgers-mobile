// pages/register.dart
import 'package:flutter/material.dart';
import 'package:duka_app/l10n/app_localizations.dart';
import 'package:duka_app/main.dart';
import 'login.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _shopNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  String _selectedLanguage = 'English';
  bool _obscurePassword = true;
  bool _agreeToTerms = false;
  bool _languageInitialized = false;

  @override
  void dispose() {
    _fullNameController.dispose();
    _shopNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
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
      body: SafeArea(
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
                      style: TextStyle(
                        color: Colors.green.shade600,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // Create Account title
                Text(
                  _selectedLanguage == 'English' ? 'Create Account 🎉' : 'Tengeneza Akaunti 🎉',
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                // Subtitle
                Text(
                  _selectedLanguage == 'English'
                      ? 'Fill in your details to get started'
                      : 'Jaza maelezo yako kuanza',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 30),
                // Form
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Full Name
                      _buildLabel(_selectedLanguage == 'English' ? 'Full Name' : 'Jina Kamili'),
                      _buildTextField(
                        controller: _fullNameController,
                        hint: _selectedLanguage == 'English' ? 'Enter full name' : 'Weka jina kamili',
                        icon: Icons.person_outline,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return _selectedLanguage == 'English' ? 'Full name is required' : 'Jina kamili linahitajika';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      // Shop Name
                      _buildLabel(_selectedLanguage == 'English' ? 'Shop Name' : 'Jina la Duka'),
                      _buildTextField(
                        controller: _shopNameController,
                        hint: _selectedLanguage == 'English' ? 'Enter shop name' : 'Weka jina la duka',
                        icon: Icons.store_outlined,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return _selectedLanguage == 'English' ? 'Shop name is required' : 'Jina la duka linahitajika';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      // Phone Number
                      _buildLabel(_selectedLanguage == 'English' ? 'Phone Number' : 'Namba ya Simu'),
                      _buildTextField(
                        controller: _phoneController,
                        hint: _selectedLanguage == 'English' ? 'Enter phone number' : 'Weka namba ya simu',
                        icon: Icons.phone_outlined,
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return _selectedLanguage == 'English' ? 'Phone number is required' : 'Namba ya simu inahitajika';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      // Email
                      _buildLabel(_selectedLanguage == 'English' ? 'Email' : 'Barua Pepe'),
                      _buildTextField(
                        controller: _emailController,
                        hint: _selectedLanguage == 'English' ? 'Enter email' : 'Weka barua pepe',
                        icon: Icons.email_outlined,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return _selectedLanguage == 'English' ? 'Email is required' : 'Barua pepe inahitajika';
                          }
                          if (!value.contains('@')) {
                            return _selectedLanguage == 'English' ? 'Please enter a valid email' : 'Weka barua pepe halali';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      // Password
                      _buildLabel(_selectedLanguage == 'English' ? 'Password' : 'Neno la Siri'),
                      _buildPasswordField(),
                      const SizedBox(height: 16),
                      // Terms checkbox
                      Row(
                        children: [
                          Checkbox(
                            value: _agreeToTerms,
                            onChanged: (value) {
                              setState(() {
                                _agreeToTerms = value ?? false;
                              });
                            },
                            activeColor: const Color(0xFF4CAF50),
                          ),
                          Expanded(
                            child: Text(
                              _selectedLanguage == 'English'
                                  ? 'I agree to Terms of Service & Privacy Policy'
                                  : 'Nakubali Masharti ya Huduma na Sera ya Faragha',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      // Register Button
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              if (!_agreeToTerms) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      _selectedLanguage == 'English'
                                          ? 'Please agree to Terms of Service'
                                          : 'Tafadhali kubali Masharti ya Huduma',
                                    ),
                                  ),
                                );
                                return;
                              }
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    _selectedLanguage == 'English'
                                        ? 'Registration successful!'
                                        : 'Usajili umefanikiwa!',
                                  ),
                                ),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF4CAF50),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            _selectedLanguage == 'English' ? 'Register' : 'Jisajili',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      // Login link
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              _selectedLanguage == 'English'
                                  ? "Already have an account? "
                                  : "Unayo akaunti tayari? ",
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 14,
                              ),
                            ),
                            GestureDetector(
                              onTap: () => Navigator.pop(context),
                              child: Text(
                                _selectedLanguage == 'English' ? 'Sign In' : 'Ingia',
                                style: TextStyle(
                                  color: Colors.green.shade600,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
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
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 14,
          color: Colors.grey.shade700,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    required String? Function(String?) validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.green.shade400, size: 20),
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
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
          borderSide: BorderSide(color: Colors.green.shade400, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        filled: true,
        fillColor: Colors.grey.shade50,
      ),
      validator: validator,
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
      obscureText: _obscurePassword,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.lock_outline, color: Colors.green.shade400, size: 20),
        hintText: _selectedLanguage == 'English' ? 'Enter password' : 'Weka neno la siri',
        hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
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
          borderSide: BorderSide(color: Colors.green.shade400, width: 1.5),
        ),
        suffixIcon: IconButton(
          icon: Icon(
            _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
            color: Colors.grey.shade500,
            size: 20,
          ),
          onPressed: () {
            setState(() {
              _obscurePassword = !_obscurePassword;
            });
          },
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        filled: true,
        fillColor: Colors.grey.shade50,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return _selectedLanguage == 'English' ? 'Password is required' : 'Neno la siri linahitajika';
        }
        if (value.length < 6) {
          return _selectedLanguage == 'English'
              ? 'Password must be at least 6 characters'
              : 'Neno la siri lazima liwe na angalau herufi 6';
        }
        return null;
      },
    );
  }
}
