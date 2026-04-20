// pages/homepage.dart
import 'dart:async';
import 'package:duka_app/pages/renew.dart';
import 'package:duka_app/pages/sales_orders.dart';
import 'package:duka_app/pages/settings.dart';
import 'package:duka_app/pages/stock.dart';
import 'package:duka_app/pages/purchases_orders.dart';
import 'package:duka_app/pages/profits_expenses.dart';
import 'package:duka_app/pages/add_attendant.dart';
import 'package:duka_app/pages/warehouse.dart';
import 'package:duka_app/pages/reports.dart';
import 'package:duka_app/l10n/app_localizations.dart';
import 'package:duka_app/main.dart';
import 'package:duka_app/services/dashboard_service.dart';
import 'package:duka_app/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'login.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  String selectedValue = "English";
  final List<String> items = ["English", "Swahili"];
  final TextEditingController _shopSearchController = TextEditingController();
  bool _showShopSearch = false;
  bool _languageInitialized = false;
  bool _isLoading = true;

  final PageController _pageController = PageController();
  Timer? _timer;
  int _currentPage = 0;

  // Services
  final DashboardService _dashboardService = DashboardService();
  final AuthService _authService = AuthService();

  // API Data
  Map<String, dynamic> _userData = {};
  Map<String, dynamic> _shopData = {};
  List<dynamic> _shopsList = [];
  
  // Drawer counts
  int _shopsCount = 0;
  int _membersCount = 0;
  int _customersCount = 0;
  int _suppliersCount = 0;
  int _productsCount = 0;

  // Summary data from API
  List<Map<String, dynamic>> summary = [
    {"title": "toReceive", "amount": "0.00", "color": Colors.blue.shade500},
    {"title": "toPay", "amount": "0.00", "color": Colors.blue.shade800},
    {"title": "totalSales", "amount": "0.00", "color": Colors.blue.shade200},
  ];

  String _localizedSummaryTitle(String key, AppLocalizations l10n) {
    switch (key) {
      case 'toReceive':
        return l10n.toReceive;
      case 'toPay':
        return l10n.toPay;
      case 'totalSales':
        return l10n.totalSales;
      default:
        return key;
    }
  }

  // ============== SHOPS LOGIC ==============

  // ============= ADD NEW SHOP DIALOG ================
  void _addNewShopDialog() {
    final _formKey = GlobalKey<FormState>();
    String shopType = 'Both Product and Service';
    String shopCategory = 'Uncategorized';
    final TextEditingController _shopNameController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 360),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Add New Shop',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        Future.microtask(() => _showShopsDialog());
                      },
                      icon: const Icon(Icons.store, color: Colors.lightBlue),
                      label: const Text(
                        'Manage Shop',
                        style: TextStyle(color: Colors.lightBlue),
                      ),
                    ),
                  ),
                  const Divider(),
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 6),
                        const Text(
                          'Shop Type',
                          style: TextStyle(fontSize: 13, color: Colors.black54),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.lightBlue),
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.white,
                          ),
                          child: DropdownButton<String>(
                            value: shopType,
                            isExpanded: true,
                            underline: const SizedBox(),
                            items:
                                const [
                                      'Both Product and Service',
                                      'Product Only',
                                      'Service Only',
                                    ]
                                    .map(
                                      (e) => DropdownMenuItem(
                                        value: e,
                                        child: Text(e),
                                      ),
                                    )
                                    .toList(),
                            onChanged: (v) => shopType = v ?? shopType,
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Shop name',
                          style: TextStyle(fontSize: 13, color: Colors.black54),
                        ),
                        const SizedBox(height: 6),
                        TextFormField(
                          controller: _shopNameController,
                          decoration: InputDecoration(
                            hintText: 'Shop Name',
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 12,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: Colors.lightBlue),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                          validator: (v) => (v == null || v.trim().isEmpty)
                              ? 'Required'
                              : null,
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Shop Category',
                          style: TextStyle(fontSize: 13, color: Colors.black54),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.lightBlue),
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.white,
                          ),
                          child: DropdownButton<String>(
                            value: shopCategory,
                            isExpanded: true,
                            underline: const SizedBox(),
                            items:
                                const [
                                      'Uncategorized',
                                      'Clothing',
                                      'Electronics',
                                      'Food & Beverages',
                                    ]
                                    .map(
                                      (e) => DropdownMenuItem(
                                        value: e,
                                        child: Text(e),
                                      ),
                                    )
                                    .toList(),
                            onChanged: (v) => shopCategory = v ?? shopCategory,
                          ),
                        ),
                        const SizedBox(height: 18),
                        Align(
                          alignment: Alignment.centerRight,
                          child: ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                final newShop =
                                    '${_shopNameController.text.trim()} - ID: S${(shops.length + 31).toString().padLeft(4, '0')}';
                                setState(() {
                                  shops.add(newShop);
                                  activeShop = newShop;
                                });
                                Navigator.pop(context);
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.lightBlue,
                            ),
                            child: const Text(
                              'Create',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // ===============SHOW AVAILABLE SHOPS DIALOG ==================
  void _showShopsDialog() {
    // Convert API shops data to string list
    final List<String> apiShops = _shopsList.map((shop) {
      if (shop is Map) {
        final name = shop['shop_name']?.toString() ?? 'Unknown Shop';
        final id = shop['shop_id']?.toString() ?? '';
        return '$name - ID: $id';
      }
      return shop.toString();
    }).toList();
    
    // Fallback to local shops if API data is empty
    final displayShops = apiShops.isNotEmpty ? apiShops : shops;
    
    final query = _shopSearchController.text.trim().toLowerCase();
    final visibleShops = query.isEmpty
        ? displayShops
        : displayShops.where((shop) => shop.toLowerCase().contains(query)).toList();

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420, maxHeight: 380),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Switch Shop',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: visibleShops.isEmpty
                        ? const Center(
                            child: Text(
                              'No shops found',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                          )
                        : ListView.separated(
                            itemCount: visibleShops.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 10),
                            itemBuilder: (context, index) {
                              final s = visibleShops[index];
                              final isActive = (s == activeShop);
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    activeShop = s;
                                  });
                                  Navigator.pop(context);
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 10,
                                  ),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: isActive
                                          ? Colors.red
                                          : Colors.grey.shade300,
                                      width: isActive ? 2 : 1,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                    color: Colors.white,
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              s,
                                              style: TextStyle(
                                                fontWeight: isActive
                                                    ? FontWeight.w800
                                                    : FontWeight.w600,
                                                color: isActive
                                                    ? Colors.black
                                                    : Colors.black87,
                                              ),
                                            ),
                                            const SizedBox(height: 6),
                                            Row(
                                              children: [
                                                if (isActive)
                                                  Container(
                                                    padding:
                                                        const EdgeInsets.symmetric(
                                                          horizontal: 6,
                                                          vertical: 2,
                                                        ),
                                                    decoration: BoxDecoration(
                                                      color: Colors.green[100],
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            12,
                                                          ),
                                                    ),
                                                    child: const Text(
                                                      'Active',
                                                      style: TextStyle(
                                                        color: Colors.green,
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                      ),
                                                    ),
                                                  ),
                                                const SizedBox(width: 8),
                                                Text(
                                                  s.contains('ID:')
                                                      ? s
                                                            .split('ID:')
                                                            .last
                                                            .trim()
                                                      : '',
                                                  style: TextStyle(
                                                    color: Colors.grey[600],
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      if (isActive)
                                        const Icon(
                                          Icons.check_circle,
                                          color: Colors.green,
                                        ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                  const SizedBox(height: 8),
                  // Center plus button
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        _addNewShopDialog();
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.green, width: 2),
                        ),
                        child: const Icon(Icons.add, color: Colors.green),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // =============== SHOPS LIST =================
  // Default fallback shops (used when API fails)
  String activeShop = "TRAVELLER CREATIVE DESIGN - ID: S0031";

  List<String> shops = [
    "TRAVELLER CREATIVE DESIGN - ID: S0031",
    "CITY ELECTRONICS - ID: S0022",
    "SMART FASHION - ID: S0045",
  ];

  @override
  void initState() {
    super.initState();
    startAutoSlide();
    _fetchDashboardData();
  }

  // Fetch all dashboard data from API
  Future<void> _fetchDashboardData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Fetch all data in parallel
      final results = await Future.wait([
        _dashboardService.getSessionUser(),
        _dashboardService.getSessionShop(),
        _dashboardService.getMyShops(),
        _dashboardService.getDashboardSummary(),
        _dashboardService.getShops(),
        _dashboardService.getTeam(),
        _dashboardService.getCustomers(),
        _dashboardService.getSuppliers(),
        _dashboardService.getProducts(),
      ]);

      final userResult = results[0];
      final shopResult = results[1];
      final shopsListResult = results[2];
      final summaryResult = results[3];
      final shopsCountResult = results[4];
      final teamResult = results[5];
      final customersResult = results[6];
      final suppliersResult = results[7];
      final productsResult = results[8];

      setState(() {
        // User data
        if (userResult['success'] && userResult['data'] != null) {
          _userData = userResult['data']['result'] ?? userResult['data'];
        }

        // Shop data
        if (shopResult['success'] && shopResult['data'] != null) {
          _shopData = shopResult['data']['result'] ?? shopResult['data'];
        }

        // Shops list
        if (shopsListResult['success'] && shopsListResult['data'] != null) {
          final shopsData = shopsListResult['data']['result'] ?? shopsListResult['data'];
          if (shopsData is List) {
            _shopsList = shopsData;
          }
        }

        // Summary data
        if (summaryResult['success'] && summaryResult['data'] != null) {
          final summaryData = summaryResult['data']['result'] ?? summaryResult['data'];
          if (summaryData is Map) {
            summary = [
              {
                "title": "toReceive",
                "amount": _formatAmount(summaryData['to_receive'] ?? summaryData['toReceive'] ?? 0),
                "color": Colors.blue.shade500
              },
              {
                "title": "toPay",
                "amount": _formatAmount(summaryData['to_pay'] ?? summaryData['toPay'] ?? 0),
                "color": Colors.blue.shade800
              },
              {
                "title": "totalSales",
                "amount": _formatAmount(summaryData['total_sales'] ?? summaryData['totalSales'] ?? 0),
                "color": Colors.blue.shade200
              },
            ];
          }
        }

        // Drawer counts
        _shopsCount = _extractCount(shopsCountResult);
        _membersCount = _extractCount(teamResult);
        _customersCount = _extractCount(customersResult);
        _suppliersCount = _extractCount(suppliersResult);
        _productsCount = _extractCount(productsResult);
      });
    } catch (e) {
      print('Error fetching dashboard data: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Helper to format amount
  String _formatAmount(dynamic amount) {
    if (amount == null) return "0.00";
    if (amount is num) {
      return amount.toStringAsFixed(2);
    }
    if (amount is String) {
      final parsed = double.tryParse(amount);
      return parsed?.toStringAsFixed(2) ?? "0.00";
    }
    return "0.00";
  }

  // Helper to extract count from API response
  int _extractCount(Map<String, dynamic> result) {
    if (!result['success']) return 0;
    final data = result['data'];
    if (data == null) return 0;
    
    final resultData = data['result'] ?? data;
    if (resultData is List) {
      return resultData.length;
    }
    if (resultData is Map) {
      return resultData['count'] ?? resultData['total'] ?? 0;
    }
    return 0;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_languageInitialized) {
      final code = AppLocale.of(context).languageCode;
      selectedValue = code == 'sw' ? 'Swahili' : 'English';
      _languageInitialized = true;
    }
  }

  // ================ ANIMATE CARDS LOGIC ===================
  void startAutoSlide() {
    _timer = Timer.periodic(const Duration(seconds: 2), (timer) {
      _currentPage++;
      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeInOut,
      );
    });
  }

  Future<void> _reloadWithIndicator() async {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(
        child: CircularProgressIndicator(color: Colors.lightBlue),
      ),
    );

    // Fetch fresh data from API
    await _fetchDashboardData();
    
    if (!mounted) return;
    Navigator.of(context, rootNavigator: true).pop();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    _shopSearchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isNarrowPhone = MediaQuery.of(context).size.width < 390;
    return Scaffold(
      backgroundColor: Colors.grey[200],

      /// ================= APP BAR =================
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.lightBlue,
        elevation: 0,
        title: Container(
          width: isNarrowPhone ? 120 : 145,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: const Color.fromARGB(255, 213, 212, 212),
          ),
          child: DropdownButton<String>(
            value: selectedValue,
            underline: const SizedBox(),
            isExpanded: true,
            dropdownColor: Colors.white,
            icon: const Icon(Icons.arrow_drop_down, size: 20),
            items: items.map((String item) {
              return DropdownMenuItem<String>(
                value: item,
                child: Text(
                  item == 'Swahili'
                      ? l10n.languageSwahili
                      : l10n.languageEnglish,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 13),
                ),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                selectedValue = newValue!;
              });
              final locale = newValue == 'Swahili'
                  ? const Locale('sw')
                  : const Locale('en');
              AppLocale.setLocale(context, locale);
            },
          ),
        ),
        actions: [
          /// ========== ACTION BUTTONS ==================
          buildIcon(Icons.replay, () {
            _reloadWithIndicator();
          }),
          buildIcon(Icons.settings, () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SettingsPage()),
            );
          }),
          buildIcon(Icons.search, () {
            setState(() {
              _showShopSearch = !_showShopSearch;
              if (!_showShopSearch) {
                _shopSearchController.clear();
              }
            });
          }),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: IconButton(
              style: const ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(Colors.white),
              ),
              constraints: const BoxConstraints.tightFor(width: 38, height: 38),
              padding: const EdgeInsets.all(6),
              visualDensity: VisualDensity.compact,
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text(
                      l10n.logout,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    content: Text(
                      l10n.logoutConfirm,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                          l10n.cancel,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      TextButton(
                        onPressed: () async {
                          Navigator.pop(context);
                          // Clear auth token
                          await _authService.logout();
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginPage(),
                            ),
                          );
                        },
                        child: Text(
                          l10n.logout,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
              icon: const Icon(
                Icons.logout_outlined,
                color: Colors.lightBlue,
                size: 20,
              ),
            ),
          ),
          const SizedBox(width: 2),
        ],
      ),
      // ============== DRAWER =========================
      drawer: Drawer(
        child: Container(
          color: const Color(0xFFF3EDEE),
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
          child: Column(
            children: [
              // ==================== PROFILE AREA ====================
              CircleAvatar(
                radius: 36.0,
                backgroundColor: Colors.white,
                backgroundImage: _userData['photo'] != null
                    ? NetworkImage(_userData['photo'])
                    : const AssetImage('lib/images/dukaapplogo.png') as ImageProvider,
              ),
              const SizedBox(height: 10.0),
              Text(
                _userData['fullname']?.toString() ?? 'WILSON ISHEKANYORO',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13.0,
                  fontWeight: FontWeight.w800,
                  color: Colors.grey[800],
                ),
              ),
              const SizedBox(height: 4.0),
              Text(
                'User ID: ${_userData['user_id']?.toString() ?? 'U0029'}',
                style: TextStyle(
                  fontSize: 12.0,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 12.0),
              Divider(color: Colors.grey[400]),

              // ================ MENU ITEMS ==================
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    ListTile(
                      leading: Icon(Icons.dashboard, color: Colors.lightBlue),
                      title: Text(
                        l10n.dashboard,
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                      onTap: () => Navigator.pop(context),
                    ),
                    const SizedBox(height: 6.0),
                    _buildCountTile(l10n.shops, _shopsCount),
                    _buildCountTile(l10n.members, _membersCount),
                    _buildCountTile(l10n.customers, _customersCount),
                    _buildCountTile(l10n.suppliers, _suppliersCount),
                    _buildCountTile(l10n.products, _productsCount),
                    const SizedBox(height: 12.0),
                    Divider(color: Colors.grey[400]),
                  ],
                ),
              ),

              // ============= BOTTOM ACTIONS =======================
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0, top: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(l10n.shareTapped)),
                        );
                      },
                      icon: const Icon(Icons.share, color: Colors.lightBlue),
                      label: Text(
                        l10n.share,
                        style: TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text(
                              l10n.logout,
                              style: TextStyle(fontWeight: FontWeight.w700),
                            ),
                            content: Text(
                              l10n.logoutConfirm,
                              style: TextStyle(fontWeight: FontWeight.w700),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text(
                                  l10n.cancel,
                                  style: TextStyle(fontWeight: FontWeight.w700),
                                ),
                              ),
                              TextButton(
                                onPressed: () async {
                                  Navigator.pop(context);
                                  // Clear auth token
                                  await _authService.logout();
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const LoginPage(),
                                    ),
                                  );
                                },
                                child: Text(
                                  l10n.logout,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      icon: const Icon(Icons.logout, color: Colors.red),
                      label: Text(
                        l10n.logout,
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.w700,
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

      /// ================= BODY =================
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Loading indicator
            if (_isLoading)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: const Center(
                  child: SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.lightBlue,
                    ),
                  ),
                ),
              ),
            if (_showShopSearch) ...[
              TextField(
                controller: _shopSearchController,
                onChanged: (_) => setState(() {}),
                decoration: InputDecoration(
                  hintText: l10n.searchHere,
                  prefixIcon: const Icon(Icons.search),
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 10,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 10),
            ],

            /// =================== ACTIVE SHOP CONTAINER ================
            GestureDetector(
              onTap: () => _showShopsDialog(),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.lightBlue),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        "${l10n.active}: ${_shopData['shop_name']?.toString() ?? activeShop}",
                        style: const TextStyle(
                          fontWeight: FontWeight.w900,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                    const Icon(Icons.arrow_drop_down, color: Colors.blue),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            /// ================= MOVING SUMMARY =================
            SizedBox(
              height: 120,
              child: PageView.builder(
                controller: _pageController,
                itemBuilder: (context, index) {
                  final item = summary[index % summary.length];

                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      color: item["color"],
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _localizedSummaryTitle(item["title"] as String, l10n),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          item["amount"],
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 20),

            /// ================= QUICK ACTIONS =================
            Container(
              padding: const EdgeInsets.symmetric(vertical: 15),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  QuickButton(
                    title: l10n.sale,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CreateCashSalePage(),
                        ),
                      );
                    },
                  ),
                  QuickButton(
                    title: l10n.order,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CreateOrderPage(),
                        ),
                      );
                    },
                  ),
                  QuickButton(
                    title: l10n.product,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const StockPage(openProductDialogOnStart: true),
                        ),
                      );
                    },
                  ),
                  QuickButton(
                    title: l10n.purchase,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PurchasesOrdersPage(
                            openNewPurchaseDialogOnStart: true,
                          ),
                        ),
                      );
                    },
                  ),
                  QuickButton(
                    title: l10n.invoice,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CreateQuotationPage(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            /// ================= GRID SECTION =================
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
              childAspectRatio: 1.1,
              children: [
                MenuCard(
                  icon: Icons.inventory,
                  title: l10n.stock,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const StockPage(),
                      ),
                    );
                  },
                ),
                MenuCard(
                  icon: Icons.bar_chart,
                  title: l10n.salesOrders,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SalesOrdersPage(),
                      ),
                    );
                  },
                ),
                MenuCard(
                  icon: Icons.shopping_cart,
                  title: l10n.purchasesOrders,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PurchasesOrdersPage(),
                      ),
                    );
                  },
                ),
                MenuCard(
                  icon: Icons.show_chart,
                  title: l10n.profitsExpenses,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ProfitsExpensesPage(),
                      ),
                    );
                  },
                ),
                MenuCard(
                  icon: Icons.person_add,
                  title: l10n.addAttendant,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AddAttendantPage(),
                      ),
                    );
                  },
                ),
                MenuCard(
                  icon: Icons.house_rounded,
                  title: l10n.warehouse,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const WarehousePage(),
                      ),
                    );
                  },
                ),
                MenuCard(
                  icon: Icons.description,
                  title: l10n.reports,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ReportsPage(),
                      ),
                    );
                  },
                ),
                MenuCard(
                  icon: Icons.add,
                  title: l10n.addShop,
                  onTap: () {
                    _addNewShopDialog();
                  },
                ),
                MenuCard(
                  icon: Icons.autorenew,
                  title: l10n.renew,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const RenewPage(),
                      ),
                    );
                  },
                ),
                MenuCard(
                  icon: Icons.settings,
                  title: l10n.settings,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SettingsPage(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// =============== APPBAR ICON =================
  Widget buildIcon(IconData icon, [VoidCallback? onPressed]) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: IconButton(
        style: const ButtonStyle(
          backgroundColor: WidgetStatePropertyAll(Colors.white),
        ),
        constraints: const BoxConstraints.tightFor(width: 38, height: 38),
        padding: const EdgeInsets.all(6),
        visualDensity: VisualDensity.compact,
        onPressed: onPressed ?? () {},
        icon: Icon(icon, color: Colors.lightBlue, size: 20),
      ),
    );
  }
}

// Helper used by the drawer to build a tile with a count and arrow
Widget _buildCountTile(String title, int count) {
  return ListTile(
    title: Text(
      title,
      style: const TextStyle(fontSize: 14.0, fontWeight: FontWeight.w700),
    ),
    trailing: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '$count',
          style: TextStyle(
            color: Colors.lightBlue[700],
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(width: 6.0),
        const Icon(
          Icons.arrow_forward_ios,
          size: 16.0,
          color: Colors.lightBlue,
        ),
      ],
    ),
    onTap: () {},
  );
}

/// ============= QUICK BUTTONS ======================
class QuickButton extends StatelessWidget {
  final String title;
  final VoidCallback? onTap;
  const QuickButton({super.key, required this.title, this.onTap});

  @override
  Widget build(BuildContext context) {
    final content = Column(
      children: [
        Container(
          height: 45,
          width: 45,
          decoration: BoxDecoration(
            color: Colors.lightBlue,
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(Icons.add, color: Colors.white),
        ),
        const SizedBox(height: 5),
        Text(title, style: const TextStyle(fontSize: 12)),
      ],
    );

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: content,
      );
    }
    return content;
  }
}

/// ================ MENU CARDS =======================
class MenuCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback? onTap;

  const MenuCard({
    super.key,
    required this.icon,
    required this.title,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final child = Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          // ignore: deprecated_member_use
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 6),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 28,
            // ignore: deprecated_member_use
            backgroundColor: Colors.lightBlue.withOpacity(0.1),
            child: Icon(icon, color: Colors.lightBlue, size: 28),
          ),
          const SizedBox(height: 15),
          Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );

    if (onTap != null) {
      return InkWell(onTap: onTap, child: child);
    }
    return child;
  }
}
