// pages/purchases_orders.dart
import 'package:flutter/material.dart';
import 'package:duka_app/l10n/locale_utils.dart';

class PurchasesOrdersPage extends StatefulWidget {
  const PurchasesOrdersPage({
    super.key,
    this.openNewPurchaseDialogOnStart = false,
  });

  final bool openNewPurchaseDialogOnStart;

  @override
  State<PurchasesOrdersPage> createState() => _PurchasesOrdersPageState();
}

class _PurchasesOrdersPageState extends State<PurchasesOrdersPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  final List<_StockProduct> _products = const [
    _StockProduct(name: 'POSTER DESIGNING', price: '20,000.00'),
    _StockProduct(name: 'LOGO DESIGN', price: '25,000.00'),
    _StockProduct(name: 'FLYER DESIGN', price: '10,000.00'),
  ];

  final List<_PurchaseEntry> _purchaseHistory = const [
    _PurchaseEntry(
      supplier: 'Smart Print Supplies',
      dateTime: 'Feb 19, 2026 14:32',
      amount: '120,000.00',
      paid: '120,000.00',
      items: [
        _PurchaseItem(name: 'POSTER DESIGNING', qty: '2', price: '20,000.00'),
        _PurchaseItem(name: 'LOGO DESIGN', qty: '2', price: '40,000.00'),
      ],
    ),
    _PurchaseEntry(
      supplier: 'Alpha Stationery',
      dateTime: 'Feb 15, 2026 09:15',
      amount: '80,000.00',
      paid: '50,000.00',
      items: [
        _PurchaseItem(name: 'FLYER DESIGN', qty: '3', price: '10,000.00'),
        _PurchaseItem(name: 'POSTER DESIGNING', qty: '1', price: '50,000.00'),
      ],
    ),
  ];

  final List<String> _accounts = ['Cash', 'Bank', 'Mobile Money', '+ New'];
  String _selectedAccount = 'Cash';
  String _selectedFilter = 'Today';
  bool _showCustomRange = false;
  bool _dialogInProgress = false;
  String _t(String en, String sw) => tr(context, en, sw);
  String _f(String label) {
    switch (label) {
      case 'Select filter to proceed':
        return _t(label, 'Chagua chujio kuendelea');
      case 'Today':
        return _t(label, 'Leo');
      case 'Yesterday':
        return _t(label, 'Jana');
      case 'This Week':
        return _t(label, 'Wiki hii');
      case 'Last Week':
        return _t(label, 'Wiki iliyopita');
      case 'This Month':
        return _t(label, 'Mwezi huu');
      case 'Last Month':
        return _t(label, 'Mwezi uliopita');
      case 'Last 3 Months':
        return _t(label, 'Miezi 3 iliyopita');
      case 'This Year':
        return _t(label, 'Mwaka huu');
      case 'Custom':
        return _t(label, 'Maalum');
      case 'Select Custom Range':
        return _t(label, 'Chagua Muda Maalum');
      case 'from:':
        return _t(label, 'kutoka:');
      case 'to:':
        return _t(label, 'hadi:');
      default:
        return label;
    }
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_onTabChanged);
    if (widget.openNewPurchaseDialogOnStart) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        _dialogInProgress = true;
        _showRestockDialog().then((_) {
          if (!mounted) return;
          _tabController.animateTo(0);
          _dialogInProgress = false;
        });
      });
    }
  }

  @override
  void dispose() {
    _tabController.removeListener(_onTabChanged);
    _tabController.dispose();
    super.dispose();
  }

  // Tab actions mimic the design flow: open dialog when tapping New Purchase / Filter.
  void _onTabChanged() {
    if (_tabController.indexIsChanging || _dialogInProgress) {
      return;
    }

    if (_tabController.index == 1) {
      _dialogInProgress = true;
      _showRestockDialog().then((_) {
        if (!mounted) return;
        _tabController.animateTo(0);
        _dialogInProgress = false;
      });
      return;
    }

    if (_tabController.index == 2) {
      _dialogInProgress = true;
      _showFilterDialog().then((_) {
        if (!mounted) return;
        _tabController.animateTo(0);
        _dialogInProgress = false;
      });
    }
  }

  Future<void> _showRestockDialog() async {
    await showDialog<void>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _t('Add Stocks', 'Ongeza Hisa'),
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Text(
                          _t('Search', 'Tafuta'),
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: _t(
                                'Product name...',
                                'Jina la bidhaa...',
                              ),
                              suffixIcon: const Icon(Icons.search),
                              isDense: true,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 12,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                  color: Colors.lightBlue,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Text(
                          _t('From Account', 'Kutoka Akaunti'),
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            initialValue: _selectedAccount,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              isDense: true,
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 8,
                              ),
                            ),
                            items: _accounts
                                .map(
                                  (item) => DropdownMenuItem<String>(
                                    value: item,
                                    child: Text(item),
                                  ),
                                )
                                .toList(),
                            onChanged: (value) {
                              if (value == null) return;
                              setState(() => _selectedAccount = value);
                              setDialogState(() => _selectedAccount = value);
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    ..._products.map(_restockListItem),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          onPressed: () => Navigator.pop(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black,
                          ),
                          child: Text(_t('Close', 'Funga')),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () => Navigator.pop(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.lightBlue,
                            foregroundColor: Colors.black,
                          ),
                          child: Text(_t('Save', 'Hifadhi')),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _restockListItem(_StockProduct product) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.blue, width: 1)),
      ),
      child: Row(
        children: [
          const Icon(Icons.settings, color: Colors.lightBlue, size: 16),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(product.name, style: const TextStyle(fontSize: 20)),
              Text(
                'S.P ${product.price}',
                style: const TextStyle(color: Colors.blue),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _showFilterDialog() async {
    _showCustomRange = false;

    await showDialog<void>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            _f('Select filter to proceed'),
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.close, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: [
                        _filterButtonRow(setDialogState, const ['Today']),
                        _filterButtonRow(setDialogState, const [
                          'Yesterday',
                          'This Week',
                        ]),
                        _filterButtonRow(setDialogState, const [
                          'Last Week',
                          'This Month',
                        ]),
                        _filterButtonRow(setDialogState, const [
                          'Last Month',
                          'Last 3 Months',
                        ]),
                        _filterButtonRow(setDialogState, const ['This Year']),
                        const SizedBox(height: 8),
                        _outlinedFilterButton(
                          label: _f('Custom'),
                          selected: _selectedFilter == 'Custom',
                          fullWidth: true,
                          onTap: () {
                            setDialogState(() {
                              _selectedFilter = 'Custom';
                              _showCustomRange = true;
                            });
                            setState(() {
                              _selectedFilter = 'Custom';
                              _showCustomRange = true;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  if (_showCustomRange) ...[
                    const Divider(height: 1),
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _f('Select Custom Range'),
                            style: TextStyle(
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(height: 10),
                          Row(
                            children: [
                              Expanded(child: _DateField(label: 'from:')),
                              SizedBox(width: 14),
                              Expanded(child: _DateField(label: 'to:')),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _filterButtonRow(StateSetter setDialogState, List<String> labels) {
    if (labels.length == 1) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: _outlinedFilterButton(
          label: _f(labels.first),
          selected: _selectedFilter == labels.first,
          onTap: () {
            setDialogState(() {
              _selectedFilter = labels.first;
              _showCustomRange = false;
            });
            setState(() {
              _selectedFilter = labels.first;
              _showCustomRange = false;
            });
          },
          fullWidth: true,
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Expanded(
            child: _outlinedFilterButton(
              label: _f(labels[0]),
              selected: _selectedFilter == labels[0],
              onTap: () {
                setDialogState(() {
                  _selectedFilter = labels[0];
                  _showCustomRange = false;
                });
                setState(() {
                  _selectedFilter = labels[0];
                  _showCustomRange = false;
                });
              },
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: _outlinedFilterButton(
              label: _f(labels[1]),
              selected: _selectedFilter == labels[1],
              onTap: () {
                setDialogState(() {
                  _selectedFilter = labels[1];
                  _showCustomRange = false;
                });
                setState(() {
                  _selectedFilter = labels[1];
                  _showCustomRange = false;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _outlinedFilterButton({
    required String label,
    required bool selected,
    required VoidCallback onTap,
    bool fullWidth = false,
  }) {
    return SizedBox(
      width: fullWidth ? double.infinity : null,
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          side: BorderSide(
            color: selected ? Colors.blue.shade700 : Colors.blue,
          ),
          foregroundColor: Colors.blue.shade700,
        ),
        child: Text(label),
      ),
    );
  }

  Widget _historyTab() {
    return Column(
      children: [
        const SizedBox(height: 8),
        Center(
          child: InkWell(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => const _ManageSuppliersPage(),
                ),
              );
            },
            borderRadius: BorderRadius.circular(28),
            child: Container(
              width: 56,
              height: 56,
              decoration: const BoxDecoration(
                color: Colors.lightBlue,
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Text(
                  '+\nSupplier',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        TextField(
          decoration: InputDecoration(
            hintText: 'Search product name...',
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 10,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.lightBlue),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Expanded(
          child: ListView.builder(
            itemCount: _purchaseHistory.length,
            itemBuilder: (context, index) {
              final entry = _purchaseHistory[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 10),
                child: ExpansionTile(
                  title: Text(
                    entry.supplier,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  subtitle: Text(
                    '${entry.dateTime}  |  Amount ${entry.amount}',
                  ),
                  childrenPadding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                  children: [
                    ...entry.items.map(
                      (item) => Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: Row(
                          children: [
                            Expanded(child: Text(item.name)),
                            Text('Qty ${item.qty}'),
                            const SizedBox(width: 12),
                            Text(item.price),
                          ],
                        ),
                      ),
                    ),
                    const Divider(),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text('Paid: ${entry.paid}'),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: Text(
            'Grand Total Amount: ${_grandTotal()}',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
          ),
        ),
      ],
    );
  }

  String _grandTotal() {
    double total = 0;
    for (final entry in _purchaseHistory) {
      total += double.tryParse(entry.amount.replaceAll(',', '')) ?? 0;
    }
    return total
        .toStringAsFixed(2)
        .replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (match) => ',');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          _t('Purchases and Orders', 'Ununuzi na Oda'),
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      body: Column(
        children: [
          TabBar(
            controller: _tabController,
            indicatorColor: Colors.lightBlue,
            labelColor: Colors.lightBlue,
            unselectedLabelColor: Colors.lightBlue,
            tabs: [
              Tab(
                icon: const Icon(Icons.inventory_2_outlined),
                text: _t('Purchase History', 'Historia ya Ununuzi'),
              ),
              Tab(
                icon: const Icon(Icons.playlist_add_circle_outlined),
                text: _t('New Purchase', 'Ununuzi Mpya'),
              ),
              Tab(
                icon: const Icon(Icons.filter_alt_outlined),
                text: _t('Filter', 'Chuja'),
              ),
            ],
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: _historyTab(),
            ),
          ),
        ],
      ),
    );
  }
}

class _DateField extends StatelessWidget {
  const _DateField({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w700)),
        const SizedBox(height: 4),
        TextField(
          readOnly: true,
          decoration: InputDecoration(
            hintText: 'mm/dd/yyyy',
            suffixIcon: const Icon(Icons.calendar_month, size: 16),
            isDense: true,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(7)),
          ),
        ),
      ],
    );
  }
}

class _StockProduct {
  const _StockProduct({required this.name, required this.price});

  final String name;
  final String price;
}

class _PurchaseEntry {
  const _PurchaseEntry({
    required this.supplier,
    required this.dateTime,
    required this.amount,
    required this.paid,
    required this.items,
  });

  final String supplier;
  final String dateTime;
  final String amount;
  final String paid;
  final List<_PurchaseItem> items;
}

class _PurchaseItem {
  const _PurchaseItem({
    required this.name,
    required this.qty,
    required this.price,
  });

  final String name;
  final String qty;
  final String price;
}

class _ManageSuppliersPage extends StatefulWidget {
  const _ManageSuppliersPage();

  @override
  State<_ManageSuppliersPage> createState() => _ManageSuppliersPageState();
}

class _ManageSuppliersPageState extends State<_ManageSuppliersPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  String _supplierCountryCode = 'TZ +255';
  String _t(String en, String sw) => tr(context, en, sw);

  final List<_SupplierEntry> _suppliers = const [
    _SupplierEntry(
      supplierName: 'Smart Print Supplies',
      phone: '0658 111 222',
      email: 'smart@supplies.co.tz',
      company: 'Smart Supplies Ltd',
    ),
    _SupplierEntry(
      supplierName: 'Alpha Stationery',
      phone: '0756 333 444',
      email: 'alpha@stationery.co.tz',
      company: 'Alpha Group',
    ),
    _SupplierEntry(
      supplierName: 'Mlimani Traders',
      phone: '0712 987 123',
      email: 'mlimani@traders.co.tz',
      company: 'Mlimani Traders',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Manage Suppliers',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.lightBlue,
          labelColor: Colors.lightBlue,
          unselectedLabelColor: Colors.lightBlue,
          tabs: const [
            Tab(icon: Icon(Icons.list), text: 'All'),
            Tab(icon: Icon(Icons.person_add_alt_1), text: 'New'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [_allSuppliersTab(), _newSupplierTab()],
      ),
    );
  }

  Widget _allSuppliersTab() {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          const SizedBox(height: 6),
          const Text(
            'Manage suppliers',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          const Divider(height: 1),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black12),
              color: Colors.white,
            ),
            child: Table(
              border: TableBorder.all(color: Colors.black12),
              columnWidths: const {
                0: FlexColumnWidth(0.7),
                1: FlexColumnWidth(2.2),
                2: FlexColumnWidth(1.5),
                3: FlexColumnWidth(2.0),
                4: FlexColumnWidth(2.0),
              },
              children: [
                const TableRow(
                  decoration: BoxDecoration(color: Color(0xFFF4F4F4)),
                  children: [
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: Text(
                        'SN',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: Text(
                        'Supplier Name',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: Text(
                        'Phone',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: Text(
                        'Email',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: Text(
                        'Company name',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                  ],
                ),
                ..._suppliers.asMap().entries.map((entry) {
                  final index = entry.key + 1;
                  final supplier = entry.value;
                  return TableRow(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Text('$index'),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Text(supplier.supplierName),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Text(supplier.phone),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Text(supplier.email),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Text(supplier.company),
                      ),
                    ],
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _newSupplierTab() {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 6),
          Center(
            child: Text(
              _t('Create supplier', 'Unda msambazaji'),
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700),
            ),
          ),
          const SizedBox(height: 8),
          const Divider(height: 1),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _SupplierField(
                  label: _t('supplier Name', 'Jina la msambazaji'),
                  child: _inputField(hint: ''),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _SupplierField(
                  label: _t('Phone:', 'Simu:'),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 110,
                        child: DropdownButtonFormField<String>(
                          initialValue: _supplierCountryCode,
                          isDense: true,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                color: Colors.lightBlue,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                color: Colors.lightBlue,
                              ),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 13,
                            ),
                          ),
                          items: const [
                            DropdownMenuItem(
                              value: 'TZ +255',
                              child: Text('TZ +255'),
                            ),
                            DropdownMenuItem(
                              value: 'KE +254',
                              child: Text('KE +254'),
                            ),
                            DropdownMenuItem(
                              value: 'UG +256',
                              child: Text('UG +256'),
                            ),
                          ],
                          onChanged: (value) {
                            if (value != null) {
                              setState(() => _supplierCountryCode = value);
                            }
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(child: _inputField(hint: '065* *** ***')),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _SupplierField(
                  label: _t('Email', 'Barua Pepe'),
                  child: _inputField(hint: ''),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _SupplierField(
                  label: _t(
                    'Business/Company Name',
                    'Jina la Biashara/Kampuni',
                  ),
                  child: _inputField(hint: ''),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _SupplierField(
                  label: _t(
                    'Taxpayer Number (TIN)',
                    'Namba ya Mlipa Kodi (TIN)',
                  ),
                  child: _inputField(hint: ''),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _SupplierField(
                  label: _t('Address', 'Anwani'),
                  child: _inputField(hint: ''),
                ),
              ),
            ],
          ),
          const Spacer(),
          Align(
            alignment: Alignment.bottomRight,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.lightBlue,
                foregroundColor: Colors.white,
              ),
              child: Text(_t('Create', 'Unda')),
            ),
          ),
        ],
      ),
    );
  }

  Widget _inputField({required String hint}) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.lightBlue),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
        child: TextField(
          textAlignVertical: TextAlignVertical.center,
          decoration: InputDecoration(
            hintText: hint,
            border: InputBorder.none,
            isCollapsed: true,
          ),
        ),
      ),
    );
  }
}

class _SupplierField extends StatelessWidget {
  const _SupplierField({required this.label, required this.child});

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w700)),
        const SizedBox(height: 4),
        child,
      ],
    );
  }
}

class _SupplierEntry {
  const _SupplierEntry({
    required this.supplierName,
    required this.phone,
    required this.email,
    required this.company,
  });

  final String supplierName;
  final String phone;
  final String email;
  final String company;
}
