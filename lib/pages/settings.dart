// pages/settings.dart
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:duka_app/l10n/locale_utils.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _shopNameController = TextEditingController(
    text: 'TRAVELLER CREATIVE DESIGN',
  );
  final TextEditingController _tradingNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  String _selectedCurrency = 'USD';
  final List<String> _currencies = ['USD', 'TZS', 'KES', 'UGX', 'EUR'];
  // sample toggles
  bool showLogoOnReceipt = true;
  bool enableHomepageSummary = true;
  bool showCashInHand = true;
  bool showToPay = true;
  bool showToReceive = true;
  bool showTodaysSales = false;
  bool enableVAT = false;
  bool addProductByImage = false;
  bool enableBarcodeScanner = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _shopNameController.dispose();
    _tradingNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _stateController.dispose();
    super.dispose();
  }

  Widget _buildToggle(String label, bool value, ValueChanged<bool> onChanged) {
    return ListTile(
      title: Text(label, style: const TextStyle(fontSize: 14)),
      trailing: CupertinoSwitch(
        value: value,
        onChanged: onChanged,
        // ignore: deprecated_member_use
        activeColor: Colors.lightBlue,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.lightBlue),
        elevation: 0,
        centerTitle: true,
        title: Text(
          tr(context, 'Shop Settings', 'Mipangilio ya Duka'),
          style: const TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.lightBlue,
          unselectedLabelColor: Colors.grey,
          indicatorColor: Colors.lightBlue,
          tabs: [
            Tab(
              icon: const Icon(Icons.store, color: Colors.lightBlue),
              text: tr(context, 'Shop', 'Duka'),
            ),
            Tab(
              icon: const Icon(Icons.storage, color: Colors.lightBlue),
              text: tr(context, 'Storage', 'Hifadhi'),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Shop tab - editable settings form
          SingleChildScrollView(
            padding: const EdgeInsets.all(12),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  Text(
                    tr(
                      context,
                      'Shop category: Computing',
                      'Kategoria ya duka: Kompyuta',
                    ),
                    style: const TextStyle(
                      color: Colors.lightBlue,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    tr(context, 'Details', 'Maelezo'),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),

                  // Shop Name
                  Text(tr(context, 'Shop Name', 'Jina la Duka')),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: _shopNameController,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 12,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                        borderSide: const BorderSide(color: Colors.lightBlue),
                      ),
                      hintText: tr(
                        context,
                        'Enter shop name',
                        'Ingiza jina la duka',
                      ),
                    ),
                    validator: (v) => (v == null || v.trim().isEmpty)
                        ? tr(
                            context,
                            'Shop name required',
                            'Jina la duka linahitajika',
                          )
                        : null,
                  ),
                  const SizedBox(height: 12),

                  // Trading Name
                  Text(tr(context, 'Trading Name', 'Jina la Biashara')),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: _tradingNameController,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 12,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      hintText: tr(context, 'Trading name', 'Jina la biashara'),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Business Email
                  Text(tr(context, 'Business Email', 'Barua Pepe ya Biashara')),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 12,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      hintText: tr(
                        context,
                        'email@domain.com',
                        'barua@domain.com',
                      ),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) return null;
                      final emailRegex = RegExp(
                        r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}",
                      );
                      return emailRegex.hasMatch(v)
                          ? null
                          : tr(
                              context,
                              'Enter a valid email',
                              'Ingiza barua pepe sahihi',
                            );
                    },
                  ),
                  const SizedBox(height: 12),

                  // Phone number
                  Text(tr(context, 'Phone Number', 'Namba ya Simu')),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: _phoneController,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 12,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      hintText: tr(
                        context,
                        '+255 7xx xxx xxx',
                        '+255 7xx xxx xxx',
                      ),
                    ),
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 12),

                  // Address
                  Text(tr(context, 'Address', 'Anwani')),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: _addressController,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 12,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      hintText: tr(
                        context,
                        'Street, area, building',
                        'Mtaa, eneo, jengo',
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // State / City
                  Text(tr(context, 'State/City', 'Mkoa/Jiji')),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: _stateController,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 12,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      hintText: tr(context, 'State or city', 'Mkoa au jiji'),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Currency dropdown
                  Text(tr(context, 'Shop Currency', 'Sarafu ya Duka')),
                  const SizedBox(height: 6),
                  DropdownButtonFormField<String>(
                    value: _selectedCurrency,
                    items: _currencies
                        .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                        .toList(),
                    onChanged: (v) => setState(
                      () => _selectedCurrency = v ?? _selectedCurrency,
                    ),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                  ),

                  const SizedBox(height: 18),
                  Text(
                    tr(context, 'Branding', 'Muonekano'),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  _buildToggle(
                    tr(
                      context,
                      'Show Logo on Receipt',
                      'Onyesha Nembo kwenye Risiti',
                    ),
                    showLogoOnReceipt,
                    (v) => setState(() => showLogoOnReceipt = v),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    tr(context, 'Dashboard', 'Dashibodi'),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  _buildToggle(
                    tr(
                      context,
                      'Enable Homepage Live Summary',
                      'Washa muhtasari wa moja kwa moja',
                    ),
                    enableHomepageSummary,
                    (v) => setState(() => enableHomepageSummary = v),
                  ),
                  _buildToggle(
                    tr(context, 'Show Cash in Hand', 'Onyesha Fedha Mkononi'),
                    showCashInHand,
                    (v) => setState(() => showCashInHand = v),
                  ),
                  _buildToggle(
                    tr(context, 'Show To Pay', 'Onyesha ya Kulipa'),
                    showToPay,
                    (v) => setState(() => showToPay = v),
                  ),
                  _buildToggle(
                    tr(context, 'Show To Receive', 'Onyesha ya Kupokea'),
                    showToReceive,
                    (v) => setState(() => showToReceive = v),
                  ),
                  _buildToggle(
                    tr(context, 'Show Today\'s Sales', 'Onyesha Mauzo ya Leo'),
                    showTodaysSales,
                    (v) => setState(() => showTodaysSales = v),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    tr(context, 'Tax', 'Kodi'),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  _buildToggle(
                    tr(context, 'Enable VAT', 'Washa VAT'),
                    enableVAT,
                    (v) => setState(() => enableVAT = v),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    tr(context, 'Product', 'Bidhaa'),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  _buildToggle(
                    tr(
                      context,
                      'Add Product by Image',
                      'Ongeza Bidhaa kwa Picha',
                    ),
                    addProductByImage,
                    (v) => setState(() => addProductByImage = v),
                  ),
                  _buildToggle(
                    tr(
                      context,
                      'Enable Barcode Scanner',
                      'Washa Kisoma Barcode',
                    ),
                    enableBarcodeScanner,
                    (v) => setState(() => enableBarcodeScanner = v),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    tr(context, 'Sales & Receipt', 'Mauzo na Risiti'),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  _buildToggle(
                    tr(
                      context,
                      'Enable Receipt Printer',
                      'Washa Kichapishi cha Risiti',
                    ),
                    false,
                    (v) {},
                  ),
                  _buildToggle(
                    tr(
                      context,
                      'Print Receipt as Invoice',
                      'Chapisha Risiti kama Ankara',
                    ),
                    false,
                    (v) {},
                  ),
                  const SizedBox(height: 12),
                  Text(
                    tr(context, 'Finance', 'Fedha'),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  _buildToggle(
                    tr(
                      context,
                      'Enable Tax Calculation',
                      'Washa Hesabu ya Kodi',
                    ),
                    false,
                    (v) {},
                  ),
                  const SizedBox(height: 12),
                  Text(
                    tr(context, 'Security', 'Usalama'),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  _buildToggle(
                    tr(
                      context,
                      'Enable Inactivity Lock',
                      'Washa Kufunga Kiotomatiki',
                    ),
                    false,
                    (v) {},
                  ),
                  const SizedBox(height: 12),
                  Text(
                    tr(context, 'Pricing', 'Bei'),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  _buildToggle(
                    tr(
                      context,
                      'Auto-Calculate Selling Price',
                      'Hesabu Bei ya Uuzaji Kiotomatiki',
                    ),
                    false,
                    (v) {},
                  ),
                  const SizedBox(height: 12),
                  Text(
                    tr(context, 'Miscellaneous', 'Nyinginezo'),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  _buildToggle(
                    tr(
                      context,
                      'Make "Today" the default data filter',
                      'Fanya "Leo" kuwa chujio msingi',
                    ),
                    false,
                    (v) {},
                  ),

                  const SizedBox(height: 18),
                  // Update button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(
                          Colors.lightBlue,
                        ),
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          setState(() {});
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                tr(
                                  context,
                                  'Settings updated',
                                  'Mipangilio imesasishwa',
                                ),
                              ),
                            ),
                          );
                        }
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        child: Text(
                          tr(context, 'Update', 'Sasisha'),
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Storage tab
          SingleChildScrollView(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 8),
                Text(
                  tr(context, 'Storage Settings', 'Mipangilio ya Hifadhi'),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber[200],
                        foregroundColor: Colors.black,
                      ),
                      child: Text(
                        tr(context, 'Clear Shop Data', 'Futa Data za Duka'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red[100],
                        foregroundColor: Colors.red,
                      ),
                      child: Text(tr(context, 'Delete Shop', 'Futa Duka')),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                // Placeholder chart
                Container(
                  height: 220,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.blue[200],
                  ),
                  child: const Center(
                    child: Text(
                      'Chart Placeholder',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ignore: unused_element
  Widget _buildFieldRow(String label, String value) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: Text(label)),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.lightBlue),
                borderRadius: BorderRadius.circular(6),
                color: Colors.white,
              ),
              child: Text(value, style: const TextStyle(color: Colors.black87)),
            ),
          ],
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}
