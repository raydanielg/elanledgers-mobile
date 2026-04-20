// pages/register.dart
import 'package:flutter/material.dart';
import 'package:duka_app/l10n/app_localizations.dart';
import 'package:duka_app/main.dart';

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
  final _regionController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  String _selectedLanguage = 'English';
  String _selectedShopType = 'Both Product and Service';
  String _selectedShopCategory = 'Clothing';
  String _selectedCountryCode = 'TZ +255';
  bool _obscurePassword = true;
  bool _agreeToTerms = false;
  bool _languageInitialized = false;

  final List<String> _shopTypes = [
    'Both Product and Service',
    'Product Only',
    'Service Only',
  ];

  final List<String> _shopCategories = [
    'Clothing',
    'Electronics',
    'Food & Beverages',
    'Health & Beauty',
    'Home & Garden',
    'Sports & Outdoors',
    'Other',
  ];

  final List<String> _countryCodes = [
    'TZ +255',
    'KE +254',
    'UG +256',
    'RW +250',
  ];

  @override
  void dispose() {
    _fullNameController.dispose();
    _shopNameController.dispose();
    _phoneController.dispose();
    _regionController.dispose();
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
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          // Background
          Container(color: Colors.grey[100]),
          // Main content
          SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height,
              ),
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 24.0,
                  right: 24.0,
                  top: 16.0,
                  bottom: 24.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Language Dropdown and Back Button Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Back to Login Button
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: const Size(0, 0),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.arrow_back_ios,
                                size: 16.0,
                                color: Colors.blue[600],
                              ),
                              const SizedBox(width: 4.0),
                              Text(
                                _selectedLanguage == 'English'
                                    ? 'Back to Login'
                                    : 'Rudi kwenye Ingia',
                                style: TextStyle(
                                  fontSize: 14.0,
                                  color: Colors.blue[600],
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Language Dropdown
                        Container(
                          margin: const EdgeInsets.only(top: 6.0),
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
                      ],
                    ),
                    const SizedBox(height: 16.0),
                    // Logo
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0, bottom: 24.0),
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
                        l10n.createAccountForYou,
                        style: const TextStyle(
                          fontSize: 18,
                          fontStyle: FontStyle.italic,
                          color: Colors.black54,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Form
                    Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Full Name Field
                          _buildTextFormField(
                            controller: _fullNameController,
                            label: _selectedLanguage == 'English'
                                ? 'Full Name'
                                : 'Jina Kamili',
                            hint: _selectedLanguage == 'English'
                                ? 'Enter Full Name'
                                : 'Ingiza Jina Kamili',
                            icon: Icons.person,
                            keyboardType: TextInputType.name,
                            textInputAction: TextInputAction.next,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return _selectedLanguage == 'English'
                                    ? 'Full Name is required'
                                    : 'Jina Kamili ni lazima';
                              }
                              if (value.length < 3) {
                                return _selectedLanguage == 'English'
                                    ? 'Name must be at least 3 characters'
                                    : 'Jina lazima liwe na angalau herufi 3';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16.0),
                          // Shop Type Dropdown
                          _buildDropdownField(
                            label: _selectedLanguage == 'English'
                                ? 'Shop Type'
                                : 'Aina ya Duka',
                            value: _selectedShopType,
                            items: _shopTypes,
                            icon: Icons.store,
                            onChanged: (value) {
                              setState(() {
                                _selectedShopType = value!;
                              });
                            },
                          ),
                          const SizedBox(height: 16.0),
                          // Shop Name Field
                          _buildTextFormField(
                            controller: _shopNameController,
                            label: _selectedLanguage == 'English'
                                ? 'Shop Name'
                                : 'Jina la Duka',
                            hint: _selectedLanguage == 'English'
                                ? 'Enter Shop Name'
                                : 'Ingiza Jina la Duka',
                            icon: Icons.storefront,
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.next,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return _selectedLanguage == 'English'
                                    ? 'Shop Name is required'
                                    : 'Jina la Duka ni lazima';
                              }
                              if (value.length < 2) {
                                return _selectedLanguage == 'English'
                                    ? 'Shop Name must be at least 2 characters'
                                    : 'Jina la Duka lazima liwe na angalau herufi 2';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16.0),
                          // Shop Category Dropdown
                          _buildDropdownField(
                            label: _selectedLanguage == 'English'
                                ? 'Select Shop Category'
                                : 'Chagua Aina ya Duka',
                            value: _selectedShopCategory,
                            items: _shopCategories,
                            icon: Icons.category,
                            onChanged: (value) {
                              setState(() {
                                _selectedShopCategory = value!;
                              });
                            },
                          ),
                          const SizedBox(height: 16.0),
                          // Phone Number with Country Code
                          _buildPhoneField(),
                          const SizedBox(height: 16.0),
                          // Region Field
                          _buildTextFormField(
                            controller: _regionController,
                            label: _selectedLanguage == 'English'
                                ? 'Region'
                                : 'Mikoa',
                            hint: _selectedLanguage == 'English'
                                ? 'Enter Region'
                                : 'Ingiza Mkoa',
                            icon: Icons.location_on,
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.next,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return _selectedLanguage == 'English'
                                    ? 'Region is required'
                                    : 'Mkoa ni lazima';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16.0),
                          // Email Field
                          _buildTextFormField(
                            controller: _emailController,
                            label: _selectedLanguage == 'English'
                                ? 'Email'
                                : 'Barua Pepe',
                            hint: _selectedLanguage == 'English'
                                ? 'Enter Email'
                                : 'Ingiza Barua Pepe',
                            icon: Icons.email,
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return _selectedLanguage == 'English'
                                    ? 'Email is required'
                                    : 'Barua Pepe ni lazima';
                              }
                              if (!RegExp(
                                r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
                              ).hasMatch(value)) {
                                return _selectedLanguage == 'English'
                                    ? 'Please enter a valid email'
                                    : 'Tafadhali ingiza barua pepe halali';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16.0),
                          // Password Field
                          _buildPasswordField(),
                          const SizedBox(height: 16.0),
                          // Terms and Conditions Checkbox
                          Row(
                            children: [
                              Checkbox(
                                value: _agreeToTerms,
                                onChanged: (value) {
                                  setState(() {
                                    _agreeToTerms = value ?? false;
                                  });
                                },
                                activeColor: Colors.blue[600],
                              ),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute<void>(
                                        builder: (_) => _TermsPrivacyPage(
                                          language: _selectedLanguage,
                                        ),
                                      ),
                                    );
                                  },
                                  child: RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: _selectedLanguage == 'English'
                                              ? 'I agree to '
                                              : 'Nakubali ',
                                          style: TextStyle(
                                            fontSize: 12.0,
                                            color: Colors.grey[700],
                                          ),
                                        ),
                                        TextSpan(
                                          text: _selectedLanguage == 'English'
                                              ? 'Terms of Service & Privacy Policy'
                                              : 'Masharti ya Huduma & Sera ya Faragha',
                                          style: TextStyle(
                                            fontSize: 12.0,
                                            color: Colors.blue[600],
                                            fontWeight: FontWeight.w600,
                                            decoration:
                                                TextDecoration.underline,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24.0),
                          // Register Button
                          ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                if (!_agreeToTerms) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        _selectedLanguage == 'English'
                                            ? 'Please agree to Terms of Service & Privacy Policy'
                                            : 'Tafadhali kubali Masharti ya Huduma & Sera ya Faragha',
                                      ),
                                      duration: const Duration(seconds: 2),
                                    ),
                                  );
                                  return;
                                }
                                // TODO: Implement registration logic
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      _selectedLanguage == 'English'
                                          ? 'Registration successful'
                                          : 'Usajili umefanikiwa',
                                    ),
                                    duration: const Duration(seconds: 2),
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
                                borderRadius: BorderRadius.circular(6.0),
                              ),
                              elevation: 2.0,
                            ),
                            child: Text(
                              _selectedLanguage == 'English'
                                  ? 'Register'
                                  : 'Jisajili',
                              style: const TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.5,
                              ),
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
        ],
      ),
    );
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    required TextInputType keyboardType,
    required TextInputAction textInputAction,
    required String? Function(String?) validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13.0,
              color: Colors.grey[700],
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey[400]),
            prefixIcon: Icon(icon, color: Colors.blue[500], size: 20.0),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6.0),
              borderSide: BorderSide(color: Colors.blue[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6.0),
              borderSide: BorderSide(color: Colors.blue[300]!, width: 1.5),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6.0),
              borderSide: BorderSide(color: Colors.blue[500]!, width: 2.0),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6.0),
              borderSide: const BorderSide(color: Colors.red, width: 1.5),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14.0,
              vertical: 12.0,
            ),
            filled: true,
            fillColor: Colors.white,
          ),
          validator: validator,
        ),
      ],
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String value,
    required List<String> items,
    required IconData icon,
    required Function(String?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13.0,
              color: Colors.grey[700],
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.blue[300]!, width: 1.5),
            borderRadius: BorderRadius.circular(6.0),
            color: Colors.white,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Row(
            children: [
              Icon(icon, color: Colors.blue[500], size: 20.0),
              const SizedBox(width: 8.0),
              Expanded(
                child: DropdownButton<String>(
                  value: value,
                  isExpanded: true,
                  underline: const SizedBox(),
                  icon: Icon(Icons.arrow_drop_down, color: Colors.grey[600]),
                  items: items.map<DropdownMenuItem<String>>((String item) {
                    return DropdownMenuItem<String>(
                      value: item,
                      child: Text(
                        item,
                        style: const TextStyle(
                          fontSize: 14.0,
                          color: Colors.black87,
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: onChanged,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPhoneField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Text(
            _selectedLanguage == 'English' ? 'Phone Number' : 'Namba ya Simu',
            style: TextStyle(
              fontSize: 13.0,
              color: Colors.grey[700],
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Row(
          children: [
            // Country Code Dropdown
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blue[300]!, width: 1.5),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(6.0),
                  bottomLeft: Radius.circular(6.0),
                ),
                color: Colors.white,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: DropdownButton<String>(
                value: _selectedCountryCode,
                underline: const SizedBox(),
                icon: Icon(
                  Icons.arrow_drop_down,
                  color: Colors.grey[600],
                  size: 20.0,
                ),
                items: _countryCodes.map<DropdownMenuItem<String>>((
                  String code,
                ) {
                  return DropdownMenuItem<String>(
                    value: code,
                    child: Text(
                      code,
                      style: const TextStyle(
                        fontSize: 12.0,
                        color: Colors.black87,
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCountryCode = value!;
                  });
                },
              ),
            ),
            const SizedBox(width: 8.0),
            // Phone Number Field
            Expanded(
              child: TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  hintText: _selectedLanguage == 'English'
                      ? 'Phone Number'
                      : 'Namba ya Simu',
                  hintStyle: TextStyle(color: Colors.grey[400]),
                  prefixIcon: Icon(
                    Icons.phone,
                    color: Colors.blue[500],
                    size: 20.0,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(6.0),
                      bottomRight: Radius.circular(6.0),
                    ),
                    borderSide: BorderSide(color: Colors.blue[300]!),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(6.0),
                      bottomRight: Radius.circular(6.0),
                    ),
                    borderSide: BorderSide(
                      color: Colors.blue[300]!,
                      width: 1.5,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(6.0),
                      bottomRight: Radius.circular(6.0),
                    ),
                    borderSide: BorderSide(
                      color: Colors.blue[500]!,
                      width: 2.0,
                    ),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(6.0),
                      bottomRight: Radius.circular(6.0),
                    ),
                    borderSide: const BorderSide(color: Colors.red, width: 1.5),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12.0,
                    vertical: 12.0,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return _selectedLanguage == 'English'
                        ? 'Phone Number is required'
                        : 'Namba ya Simu ni lazima';
                  }
                  if (!RegExp(r'^\d{7,15}$').hasMatch(value)) {
                    return _selectedLanguage == 'English'
                        ? 'Please enter a valid phone number'
                        : 'Tafadhali ingiza namba ya simu halali';
                  }
                  return null;
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Text(
            _selectedLanguage == 'English' ? 'Password' : 'Neno la Siri',
            style: TextStyle(
              fontSize: 13.0,
              color: Colors.grey[700],
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        TextFormField(
          controller: _passwordController,
          obscureText: _obscurePassword,
          textInputAction: TextInputAction.done,
          decoration: InputDecoration(
            hintText: _selectedLanguage == 'English'
                ? 'Enter Password'
                : 'Ingiza Neno la Siri',
            hintStyle: TextStyle(color: Colors.grey[400]),
            prefixIcon: Icon(Icons.lock, color: Colors.blue[500], size: 20.0),
            suffixIcon: IconButton(
              icon: Icon(
                _obscurePassword ? Icons.visibility_off : Icons.visibility,
                color: Colors.grey[600],
                size: 20.0,
              ),
              onPressed: () {
                setState(() {
                  _obscurePassword = !_obscurePassword;
                });
              },
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6.0),
              borderSide: BorderSide(color: Colors.blue[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6.0),
              borderSide: BorderSide(color: Colors.blue[300]!, width: 1.5),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6.0),
              borderSide: BorderSide(color: Colors.blue[500]!, width: 2.0),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6.0),
              borderSide: const BorderSide(color: Colors.red, width: 1.5),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14.0,
              vertical: 12.0,
            ),
            filled: true,
            fillColor: Colors.white,
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return _selectedLanguage == 'English'
                  ? 'Password is required'
                  : 'Neno la Siri ni lazima';
            }
            if (value.length < 6) {
              return _selectedLanguage == 'English'
                  ? 'Password must be at least 6 characters'
                  : 'Neno la siri lazima liwe na angalau herufi 6';
            }
            return null;
          },
        ),
      ],
    );
  }
}

class _TermsPrivacyPage extends StatelessWidget {
  const _TermsPrivacyPage({required this.language});

  final String language;

  @override
  Widget build(BuildContext context) {
    final isEnglish = language == 'English';
    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEnglish
              ? 'Terms of Service & Privacy Policy'
              : 'Masharti ya Huduma & Sera ya Faragha',
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Text(
          isEnglish
              ? '''1. Acceptance
By creating an account, you agree to these terms and our privacy policy.

2. Account and Security
You are responsible for keeping your account credentials secure and for all activity under your account.

3. Acceptable Use
You agree to use the app lawfully and not attempt to abuse, disrupt, or reverse engineer the service.

4. Data and Privacy
We collect account and usage information to provide and improve the service. We do not sell your personal data.

5. Payments and Subscriptions
If paid features are used, charges, billing periods, and renewals apply based on your selected plan.

6. Limitation of Liability
The service is provided as available. We are not liable for indirect or consequential damages.

7. Updates
We may update these terms from time to time. Continued use after updates means you accept the revised terms.

8. Contact
For support or privacy questions, contact the app support team.'''
              : '''1. Kukubali Masharti
Kwa kufungua akaunti, unakubali masharti haya na sera yetu ya faragha.

2. Akaunti na Usalama
Unawajibika kulinda taarifa zako za kuingia na shughuli zote zinazofanyika kwenye akaunti yako.

3. Matumizi Yanayokubalika
Unakubali kutumia programu kwa kufuata sheria na kuepuka matumizi mabaya au kuvuruga huduma.

4. Data na Faragha
Tunakusanya taarifa za akaunti na matumizi ili kutoa na kuboresha huduma. Hatuuzi taarifa binafsi.

5. Malipo na Usajili
Ukichagua vipengele vya kulipia, ada, muda wa bili, na uhuishaji vitatumika kulingana na mpango wako.

6. Ukomo wa Dhima
Huduma hutolewa kama ilivyo. Hatuwajibiki kwa hasara zisizo za moja kwa moja.

7. Mabadiliko ya Masharti
Tunaweza kubadilisha masharti haya. Kuendelea kutumia baada ya mabadiliko ni kukubali masharti mapya.

8. Mawasiliano
Kwa msaada au maswali ya faragha, wasiliana na timu ya msaada ya programu.''',
          style: const TextStyle(height: 1.4),
        ),
      ),
    );
  }
}
