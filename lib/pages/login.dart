// pages/login.dart
import 'package:flutter/material.dart';
import 'package:duka_app/l10n/app_localizations.dart';
import 'package:duka_app/main.dart';
import 'register.dart';
import 'reset.dart';
import 'homepage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _userIdController = TextEditingController();
  final _passwordController = TextEditingController();
  String _selectedLanguage = 'English';
  bool _obscurePassword = true;
  bool _languageInitialized = false;

  @override
  void dispose() {
    _userIdController.dispose();
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
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          // Background (optional - you can customize this)
          Container(color: Colors.grey[100]),
          // Main content
          SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height,
              ),
              child: IntrinsicHeight(
                child: Column(
                  children: [
                    // Language Dropdown at the top
                    Padding(
                      padding: const EdgeInsets.only(top: 24.0, right: 16.0),
                      child: Align(
                        alignment: Alignment.topRight,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10.0,
                            vertical: 2.0,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey[400]!),
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                          child: DropdownButton<String>(
                            value: _selectedLanguage,
                            isDense: true,
                            iconSize: 18,
                            underline: const SizedBox(),
                            items: ['English', 'Swahili']
                                .map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(
                                      value == 'Swahili'
                                          ? l10n.languageSwahili
                                          : l10n.languageEnglish,
                                      style: const TextStyle(
                                        fontSize: 12.0,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  );
                                })
                                .toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                _selectedLanguage = newValue ?? 'English';
                              });
                              final locale = _selectedLanguage == 'Swahili'
                                  ? const Locale('sw')
                                  : const Locale('en');
                              AppLocale.setLocale(context, locale);
                            },
                          ),
                        ),
                      ),
                    ),
                    // Spacer to push login form to center
                    Expanded(
                      child: SizedBox(
                        width: double.infinity,
                        child: SingleChildScrollView(
                          physics: const NeverScrollableScrollPhysics(),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24.0,
                              vertical: 20.0,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                // Logo
                                Padding(
                                  padding: const EdgeInsets.only(
                                    bottom: 30.0,
                                    top: 40.0,
                                  ),
                                  child: Center(
                                    child: Image.asset(
                                      'lib/images/dukaapplogo.png',
                                      height: 100.0,
                                      width: 100.0,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                      Center(
                        child: Text(
                          l10n.welcomeBackMissed,
                          style: const TextStyle(
                            fontSize: 18,
                            fontStyle: FontStyle.italic,
                            color: Colors.black54,
                          ),
                        ),
                      ),
                                const SizedBox(height: 16),
                                // Form
                                Form(
                                  key: _formKey,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      // UserId/Email/Phone Label
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          bottom: 12.0,
                                        ),
                                        child: Text(
                                          _selectedLanguage == 'English'
                                              ? 'UserId | Email | Phone'
                                              : 'Kitambulisho | Barua | Simu',
                                          style: TextStyle(
                                            fontSize: 14.0,
                                            color: Colors.grey[700],
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      // UserId/Email/Phone TextField
                                      TextFormField(
                                        controller: _userIdController,
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        textInputAction: TextInputAction.next,
                                        decoration: InputDecoration(
                                          prefixIcon: Icon(
                                            Icons.mail,
                                            color: Colors.lightBlue,
                                          ),
                                          hintText:
                                              _selectedLanguage == 'English'
                                              ? 'Enter UserId, Email or Phone'
                                              : 'Ingiza Kitambulisho, Barua au Simu',
                                          hintStyle: TextStyle(
                                            color: Colors.grey[400],
                                          ),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                              6.0,
                                            ),
                                            borderSide: BorderSide(
                                              color: Colors.blue[300]!,
                                            ),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                              6.0,
                                            ),
                                            borderSide: BorderSide(
                                              color: Colors.blue[300]!,
                                              width: 1.5,
                                            ),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                              6.0,
                                            ),
                                            borderSide: BorderSide(
                                              color: Colors.blue[500]!,
                                              width: 2.0,
                                            ),
                                          ),
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                horizontal: 16.0,
                                                vertical: 14.0,
                                              ),
                                          filled: true,
                                          fillColor: Colors.white,
                                        ),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return _selectedLanguage ==
                                                    'English'
                                                ? 'This field is required'
                                                : 'Hili sehemu ni lazima';
                                          }
                                          if (!value.contains('@') &&
                                              !value.isEmpty) {
                                            // Basic validation for email or phone
                                            if (value.length < 3) {
                                              return _selectedLanguage ==
                                                      'English'
                                                  ? 'Please enter valid UserId, Email or Phone'
                                                  : 'Tafadhali ingiza kitambulisho, barua au simu halali';
                                            }
                                          }
                                          return null;
                                        },
                                      ),
                                      // Password Label
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          top: 20.0,
                                          bottom: 12.0,
                                        ),
                                        child: Text(
                                          _selectedLanguage == 'English'
                                              ? 'Password'
                                              : 'Neno la Siri',
                                          style: TextStyle(
                                            fontSize: 14.0,
                                            color: Colors.grey[700],
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      // Password TextField
                                      TextFormField(
                                        controller: _passwordController,
                                        obscureText: _obscurePassword,
                                        textInputAction: TextInputAction.done,
                                        decoration: InputDecoration(
                                          prefixIcon: Icon(
                                            Icons.lock,
                                            color: Colors.lightBlue,
                                          ),
                                          hintText:
                                              _selectedLanguage == 'English'
                                              ? 'Enter Password'
                                              : 'Ingiza Neno la Siri',
                                          hintStyle: TextStyle(
                                            color: Colors.grey[400],
                                          ),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                              6.0,
                                            ),
                                            borderSide: BorderSide(
                                              color: Colors.blue[300]!,
                                            ),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                              6.0,
                                            ),
                                            borderSide: BorderSide(
                                              color: Colors.blue[300]!,
                                              width: 1.5,
                                            ),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                              6.0,
                                            ),
                                            borderSide: BorderSide(
                                              color: Colors.blue[500]!,
                                              width: 2.0,
                                            ),
                                          ),
                                          suffixIcon: IconButton(
                                            icon: Icon(
                                              _obscurePassword
                                                  ? Icons.visibility_off
                                                  : Icons.visibility,
                                              color: Colors.grey[600],
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                _obscurePassword =
                                                    !_obscurePassword;
                                              });
                                            },
                                          ),
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                horizontal: 16.0,
                                                vertical: 14.0,
                                              ),
                                          filled: true,
                                          fillColor: Colors.white,
                                        ),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return _selectedLanguage ==
                                                    'English'
                                                ? 'Password is required'
                                                : 'Neno la siri ni lazima';
                                          }
                                          if (value.length < 6) {
                                            return _selectedLanguage ==
                                                    'English'
                                                ? 'Password must be at least 6 characters'
                                                : 'Neno la siri lazima liwe na angalau herufi 6';
                                          }
                                          return null;
                                        },
                                      ),
                                      // Login Button
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          top: 28.0,
                                          bottom: 24.0,
                                        ),
                                        child: ElevatedButton(
                                          onPressed: () {
                                            if (_formKey.currentState!
                                                .validate()) {
                                              Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      const Homepage(),
                                                ),
                                              );
                                            }
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.lightBlue,
                                            foregroundColor: Colors.white,
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 14.0,
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(6.0),
                                            ),
                                            elevation: 2.0,
                                          ),
                                          child: Text(
                                            _selectedLanguage == 'English'
                                                ? 'Login'
                                                : 'Ingia',
                                            style: const TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.w600,
                                              letterSpacing: 0.5,
                                            ),
                                          ),
                                        ),
                                      ),
                                      // Reset Password and Register Buttons Row
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          bottom: 20.0,
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            // Reset Password Button
                                            Expanded(
                                              child: SizedBox(
                                                height: 44.0,
                                                child: TextButton(
                                                  onPressed: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            const ResetPasswordPage(),
                                                      ),
                                                    );
                                                  },
                                                  style: TextButton.styleFrom(
                                                    backgroundColor:
                                                        Colors.grey[600],
                                                    foregroundColor:
                                                        Colors.white,
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            6.0,
                                                          ),
                                                    ),
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        _selectedLanguage ==
                                                                'English'
                                                            ? 'Reset Password'
                                                            : 'Sezesha Neno',
                                                        style: const TextStyle(
                                                          fontSize: 13.0,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        width: 6.0,
                                                      ),
                                                      const Icon(
                                                        Icons.arrow_forward_ios,
                                                        size: 14.0,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 12.0),
                                            // Register Button
                                            Expanded(
                                              child: SizedBox(
                                                height: 44.0,
                                                child: TextButton(
                                                  onPressed: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            const RegisterPage(),
                                                      ),
                                                    );
                                                  },
                                                  style: TextButton.styleFrom(
                                                    backgroundColor:
                                                        Colors.grey[600],
                                                    foregroundColor:
                                                        Colors.white,
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            6.0,
                                                          ),
                                                    ),
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        _selectedLanguage ==
                                                                'English'
                                                            ? 'Register'
                                                            : 'Jisajili',
                                                        style: const TextStyle(
                                                          fontSize: 13.0,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        width: 6.0,
                                                      ),
                                                      const Icon(
                                                        Icons.arrow_forward_ios,
                                                        size: 14.0,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
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
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
