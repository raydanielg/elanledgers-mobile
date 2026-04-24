// pages/stock.dart
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:duka_app/l10n/locale_utils.dart';
import 'package:duka_app/services/stock_service.dart';
import 'package:duka_app/services/purchase_service.dart';

class StockPage extends StatefulWidget {
  const StockPage({
    super.key,
    this.openProductDialogOnStart = false,
    this.openRestockDialogOnStart = false,
    this.initialTabIndex = 0,
  });

  final bool openProductDialogOnStart;
  final bool openRestockDialogOnStart;
  final int initialTabIndex;

  @override
  State<StockPage> createState() => _StockPageState();
}

class _StockPageState extends State<StockPage> with TickerProviderStateMixin {
  late final TabController _tabController;
  final StockService _stockService = StockService();
  final PurchaseService _purchaseService = PurchaseService();

  // API Data
  List<dynamic> _productsData = [];
  List<dynamic> _stockData = [];
  List<dynamic> _categoriesData = [];
  List<dynamic> _suppliersData = [];
  bool _isLoading = true;
  String? _errorMessage;

  // UI-compatible products list (mapped from API data)
  List<_StockProduct> get _products => _productsData.isEmpty
      ? []
      : _productsData.map((p) => _StockProduct(
          name: p['product_name']?.toString() ?? 'Unknown',
          price: p['sp']?.toString() ?? p['selling_price']?.toString() ?? '0.00',
        )).toList();

  // UI State
  final List<String> _accounts = ['Cash', 'Bank', 'Mobile Money', '+ New'];
  String _selectedAccount = 'Cash';
  String _selectedFilter = 'Today';
  bool _showCustomRange = false;
  bool _categoryMode = false;
  bool _tabDialogInProgress = false;
  String _t(String en, String sw) => tr(context, en, sw);
  String _f(String label) {
    switch (label) {
      case 'Select filter to proceed':
        return _t(label, 'Chagua chujio kuendelea');
      case 'Select Custom Range':
        return _t(label, 'Chagua Muda Maalum');
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
    _tabController = TabController(
      length: 4,
      vsync: this,
      initialIndex: widget.initialTabIndex,
    );
    _tabController.addListener(_onTabChanged);
    _fetchStockData();
    if (widget.openProductDialogOnStart) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _showProductDialog();
        }
      });
    }
    if (widget.openRestockDialogOnStart) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _showRestockDialog();
        }
      });
    }
  }

  // Fetch all stock data from API
  Future<void> _fetchStockData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final results = await Future.wait([
        _stockService.getProducts(),
        _stockService.getStock(),
        _stockService.getStockCategories(),
        _purchaseService.getSuppliers(),
      ]);

      final productsResult = results[0];
      final stockResult = results[1];
      final categoriesResult = results[2];
      final suppliersResult = results[3];

      setState(() {
        if (productsResult['success'] && productsResult['data'] != null) {
          final data = productsResult['data']['result'] ?? productsResult['data'];
          if (data is List) {
            _productsData = data;
          }
        }
        if (stockResult['success'] && stockResult['data'] != null) {
          final data = stockResult['data']['result'] ?? stockResult['data'];
          if (data is List) {
            _stockData = data;
          }
        }
        if (categoriesResult['success'] && categoriesResult['data'] != null) {
          final data = categoriesResult['data']['result'] ?? categoriesResult['data'];
          if (data is List) {
            _categoriesData = data;
          }
        }
        if (suppliersResult['success'] && suppliersResult['data'] != null) {
          final data = suppliersResult['data']['result'] ?? suppliersResult['data'];
          if (data is List) {
            _suppliersData = data;
          }
        }
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load data: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _tabController.removeListener(_onTabChanged);
    _tabController.dispose();
    super.dispose();
  }

  void _onTabChanged() {
    if (_tabController.indexIsChanging || _tabDialogInProgress) {
      return;
    }

    if (_tabController.index == 3) {
      _tabDialogInProgress = true;
      _showFilterDialog().then((_) {
        if (!mounted) return;
        _tabController.animateTo(0);
        _tabDialogInProgress = false;
      });
    }
  }

  /// ============ RESTOCK DIALOG METHOD============

  void _showRestockDialog() {
    showDialog<void>(
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
                    const Text(
                      'Add Stocks',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Text(
                          'Search',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: 'Product name...',
                              suffixIcon: Icon(Icons.search),
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
                    Center(
                      child: SizedBox(
                        width: 320,
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 10,
                              ),

                              child: const Text(
                                'From Account',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            Expanded(
                              child: DropdownButtonFormField<String>(
                                initialValue: _selectedAccount,
                                icon: const Icon(Icons.arrow_drop_down),
                                decoration: const InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 2,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(8),
                                    ),
                                  ),
                                ),
                                items: _accounts
                                    .map(
                                      (item) => DropdownMenuItem<String>(
                                        value: item,
                                        child: Text(
                                          item,
                                          style: TextStyle(
                                            fontWeight: item == '+ New'
                                                ? FontWeight.w700
                                                : FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    )
                                    .toList(),
                                onChanged: (value) {
                                  if (value == null) {
                                    return;
                                  }
                                  setState(() => _selectedAccount = value);
                                  setDialogState(
                                    () => _selectedAccount = value,
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    ..._products.map((product) => _restockListItem(product)),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          onPressed: () => Navigator.pop(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black,
                          ),
                          child: const Text('Close'),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.lightBlue,
                            foregroundColor: Colors.black,
                          ),
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Save'),
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

  /// =========== RESTOCK LIST WIDGET===============

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
              Text(product.name, style: const TextStyle(fontSize: 18)),
              const Text(
                'Service',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// ============== FILTER DIALOG METHOD ==================

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
                        _filterButtonRow(context, setDialogState, ['Today']),
                        _filterButtonRow(context, setDialogState, [
                          'Yesterday',
                          'This Week',
                        ]),
                        _filterButtonRow(context, setDialogState, [
                          'Last Week',
                          'This Month',
                        ]),
                        _filterButtonRow(context, setDialogState, [
                          'Last Month',
                          'Last 3 Months',
                        ]),
                        _filterButtonRow(context, setDialogState, [
                          'This Year',
                        ]),
                        const SizedBox(height: 8),
                        _outlinedFilterButton(
                          label: _f('Custom'),
                          selected: _selectedFilter == 'Custom',
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
                          fullWidth: true,
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
                          const SizedBox(height: 10),
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

  Widget _filterButtonRow(
    BuildContext context,
    StateSetter setDialogState,
    List<String> labels,
  ) {
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

  /// ============ CATEGORY DIALOGS =====================

  void _showCategoriesDialog() {
    final categories = <_CategoryRow>[
      const _CategoryRow(name: 'GRAPHICS', products: 2, canDelete: false),
      const _CategoryRow(name: 'Uncategorized', products: 0, canDelete: true),
    ];

    showDialog<void>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 620),
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Product Categories',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 10),
                      const Divider(),
                      const SizedBox(height: 8),
                      Center(
                        child: OutlinedButton(
                          onPressed: _showCreateCategoryDialog,
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.blue.shade700,
                            side: BorderSide(color: Colors.blue.shade700),
                          ),
                          child: const Text('+ Create New category'),
                        ),
                      ),
                      const SizedBox(height: 10),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          headingRowColor: WidgetStateProperty.all(
                            const Color(0xFFD5E4F8),
                          ),
                          columns: const [
                            DataColumn(
                              label: Text(
                                'Name',
                                style: TextStyle(fontWeight: FontWeight.w700),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Products',
                                style: TextStyle(fontWeight: FontWeight.w700),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Delete',
                                style: TextStyle(fontWeight: FontWeight.w700),
                              ),
                            ),
                          ],
                          rows: categories
                              .map(
                                (row) => DataRow(
                                  cells: [
                                    DataCell(Text(row.name)),
                                    DataCell(Text(row.products.toString())),
                                    DataCell(
                                      row.canDelete
                                          ? IconButton(
                                              onPressed: () {
                                                setDialogState(
                                                  () => categories.remove(row),
                                                );
                                              },
                                              icon: const Icon(
                                                Icons.delete_outline,
                                                color: Colors.red,
                                                size: 18,
                                              ),
                                            )
                                          : const SizedBox.shrink(),
                                    ),
                                  ],
                                ),
                              )
                              .toList(),
                        ),
                      ),
                      const SizedBox(height: 14),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                            onPressed: () => Navigator.pop(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blueGrey,
                              foregroundColor: Colors.white,
                            ),
                            child: const Text('Close'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showCreateCategoryDialog() {
    showDialog<void>(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Add New Category',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 10),
                  const Divider(),
                  const SizedBox(height: 12),
                  const Text(
                    'Category name [separate with comma]',
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    maxLines: 2,
                    decoration: InputDecoration(
                      hintText: 'eg: category1, category2, category3 etc',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueGrey,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Close'),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Create'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  /// ============ PRODUCT DIALOG =====================

  void _showProductDialog() {
    String selectedType = 'Product';
    String selectedCategory = 'Uncategorised';
    String taxable = 'No';

    showDialog<void>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            final isNarrow = MediaQuery.of(context).size.width < 820;
            final isService = selectedType == 'Service';
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 980),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Register New Product',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 10),
                        const Divider(),
                        const SizedBox(height: 10),
                        isNarrow
                            ? Column(
                                children: [
                                  _formSelectField(
                                    label: 'Type',
                                    value: selectedType,
                                    items: const ['Product', 'Service'],
                                    onChanged: (value) => setDialogState(
                                      () =>
                                          selectedType = value ?? selectedType,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  _formSelectField(
                                    label: 'Category',
                                    value: selectedCategory,
                                    items: const [
                                      'Uncategorised',
                                      'Graphics',
                                      'General',
                                    ],
                                    onChanged: (value) => setDialogState(
                                      () => selectedCategory =
                                          value ?? selectedCategory,
                                    ),
                                  ),
                                ],
                              )
                            : Row(
                                children: [
                                  Expanded(
                                    child: _formSelectField(
                                      label: 'Type',
                                      value: selectedType,
                                      items: const ['Product', 'Service'],
                                      onChanged: (value) => setDialogState(
                                        () => selectedType =
                                            value ?? selectedType,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: _formSelectField(
                                      label: 'Category',
                                      value: selectedCategory,
                                      items: const [
                                        'Uncategorised',
                                        'Graphics',
                                        'General',
                                      ],
                                      onChanged: (value) => setDialogState(
                                        () => selectedCategory =
                                            value ?? selectedCategory,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                        const SizedBox(height: 10),
                        if (isService) ...[
                          isNarrow
                              ? Column(
                                  children: [
                                    _formTextField(label: 'Item Name'),
                                    const SizedBox(height: 10),
                                    _formTextField(label: 'Selling Price'),
                                    const SizedBox(height: 10),
                                    _formSelectField(
                                      label: 'Taxable',
                                      value: taxable,
                                      items: const ['No', 'Yes'],
                                      onChanged: (value) => setDialogState(
                                        () => taxable = value ?? taxable,
                                      ),
                                    ),
                                  ],
                                )
                              : Column(
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: _formTextField(
                                            label: 'Item Name',
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: _formTextField(
                                            label: 'Selling Price',
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: _formSelectField(
                                            label: 'Taxable',
                                            value: taxable,
                                            items: const ['No', 'Yes'],
                                            onChanged: (value) =>
                                                setDialogState(
                                                  () => taxable =
                                                      value ?? taxable,
                                                ),
                                          ),
                                        ),
                                        const Expanded(
                                          child: SizedBox.shrink(),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                          const SizedBox(height: 6),
                        ] else ...[
                          _formTextField(label: 'Item Name'),
                          const SizedBox(height: 10),
                          isNarrow
                              ? Column(
                                  children: const [
                                    _LabeledCompactField(label: 'Qty'),
                                    SizedBox(height: 10),
                                    _LabeledCompactField(label: 'Buying Price'),
                                    SizedBox(height: 10),
                                    _LabeledCompactField(
                                      label: 'Selling Price',
                                    ),
                                  ],
                                )
                              : const Row(
                                  children: [
                                    Expanded(
                                      child: _LabeledCompactField(label: 'Qty'),
                                    ),
                                    SizedBox(width: 10),
                                    Expanded(
                                      child: _LabeledCompactField(
                                        label: 'Buying Price',
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Expanded(
                                      child: _LabeledCompactField(
                                        label: 'Selling Price',
                                      ),
                                    ),
                                  ],
                                ),
                          const SizedBox(height: 10),
                          isNarrow
                              ? Column(
                                  children: [
                                    const _LabeledCompactField(
                                      label: 'Wholesale',
                                    ),
                                    const SizedBox(height: 10),
                                    const _LabeledCompactField(
                                      label: 'Discount',
                                    ),
                                    const SizedBox(height: 10),
                                    const _LabeledCompactField(
                                      label: 'Reorder-level',
                                    ),
                                    const SizedBox(height: 10),
                                    _formTextField(label: 'Barcode'),
                                  ],
                                )
                              : Row(
                                  children: [
                                    const Expanded(
                                      child: _LabeledCompactField(
                                        label: 'Wholesale',
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    const Expanded(
                                      child: _LabeledCompactField(
                                        label: 'Discount',
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    const Expanded(
                                      child: _LabeledCompactField(
                                        label: 'Reorder-level',
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: _formTextField(label: 'Barcode'),
                                    ),
                                  ],
                                ),
                          const SizedBox(height: 10),
                          isNarrow
                              ? Column(
                                  children: [
                                    _formSelectField(
                                      label: 'Taxable',
                                      value: taxable,
                                      items: const ['No', 'Yes'],
                                      onChanged: (value) => setDialogState(
                                        () => taxable = value ?? taxable,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    _photoPickerField(),
                                    const SizedBox(height: 10),
                                    _formTextField(
                                      label: 'Expiry Date',
                                      hint: 'mm/dd/yyyy',
                                    ),
                                    const SizedBox(height: 10),
                                    _formTextField(label: 'Size'),
                                    const SizedBox(height: 10),
                                    _formTextField(label: 'Color'),
                                  ],
                                )
                              : Row(
                                  children: [
                                    Expanded(
                                      child: _formSelectField(
                                        label: 'Taxable',
                                        value: taxable,
                                        items: const ['No', 'Yes'],
                                        onChanged: (value) => setDialogState(
                                          () => taxable = value ?? taxable,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(child: _photoPickerField()),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: _formTextField(
                                        label: 'Expiry Date',
                                        hint: 'mm/dd/yyyy',
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: _formTextField(label: 'Size'),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: _formTextField(label: 'Color'),
                                    ),
                                  ],
                                ),
                          const SizedBox(height: 10),
                          _formTextField(label: 'Description', maxLines: 2),
                        ],
                        const SizedBox(height: 10),
                        const Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton(
                              onPressed: () => Navigator.pop(context),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blueGrey,
                                foregroundColor: Colors.white,
                              ),
                              child: const Text('Close'),
                            ),
                            const SizedBox(width: 10),
                            ElevatedButton(
                              onPressed: () => Navigator.pop(context),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white,
                              ),
                              child: const Text('Save'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  /// ============ IMPORT DIALOGS =====================

  void _showImportActionsDialog() {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return SimpleDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          children: [
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(dialogContext);
                _showImportProductFileDialog();
              },
              child: const Text(
                'Import Product File',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(dialogContext);
                _showImportFromOtherShopDialog();
              },
              child: const Text(
                'Import From Other Shop',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showImportProductFileDialog() {
    String selectedCategory = 'Uncategorised';
    showDialog<void>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 600),
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Import Products',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      const Divider(),
                      Row(
                        children: [
                          const Expanded(
                            child: Text(
                              'Download Template here',
                              style: TextStyle(fontStyle: FontStyle.italic),
                            ),
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.download_for_offline_outlined,
                              color: Colors.blue,
                            ),
                          ),
                        ],
                      ),
                      const Divider(),
                      _formSelectField(
                        label: 'Category',
                        value: selectedCategory,
                        items: const ['Uncategorised', 'Graphics', 'General'],
                        onChanged: (value) => setDialogState(
                          () => selectedCategory = value ?? selectedCategory,
                        ),
                      ),
                      const SizedBox(height: 10),
                      _photoPickerField(label: 'File'),
                      const SizedBox(height: 14),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                            onPressed: () => Navigator.pop(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blueGrey,
                              foregroundColor: Colors.white,
                            ),
                            child: const Text('Close'),
                          ),
                          const SizedBox(width: 10),
                          ElevatedButton(
                            onPressed: () => Navigator.pop(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                            ),
                            child: const Text('Import'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showImportFromOtherShopDialog() {
    String selectedShop = 'Select';
    showDialog<void>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 680),
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Import Products from Other Shop',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(
                            width: 78,
                            child: Text('Import From.'),
                          ),
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              initialValue: selectedShop,
                              isExpanded: true,
                              decoration: InputDecoration(
                                isDense: true,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 10,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              items: const [
                                DropdownMenuItem(
                                  value: 'Select',
                                  child: Text('Select'),
                                ),
                                DropdownMenuItem(
                                  value: 'Kariakoo Branch',
                                  child: Text('Kariakoo Branch'),
                                ),
                                DropdownMenuItem(
                                  value: 'Mikocheni Branch',
                                  child: Text('Mikocheni Branch'),
                                ),
                                DropdownMenuItem(
                                  value: 'Masaki Branch',
                                  child: Text('Masaki Branch'),
                                ),
                              ],
                              onChanged: (value) => setDialogState(
                                () => selectedShop = value ?? selectedShop,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(width: 78, child: Text('Search')),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: 'Product name...',
                                isDense: true,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 10,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(6),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                            onPressed: () => Navigator.pop(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blueGrey,
                              foregroundColor: Colors.white,
                            ),
                            child: const Text('Close'),
                          ),
                          const SizedBox(width: 10),
                          ElevatedButton(
                            onPressed: () => Navigator.pop(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                            ),
                            child: const Text('Save'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showTransferStocksDialog() {
    String selectedShop = 'Select Shop';
    showDialog<void>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 700),
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Transfer Stocks',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 12),

                      Row(
                        children: [
                          const Text('Transfer To.'),
                          const SizedBox(width: 8),
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              initialValue: selectedShop,
                              decoration: InputDecoration(
                                isDense: true,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 10,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(6),
                                ),
                              ),
                              items: const [
                                DropdownMenuItem(
                                  value: 'Select Shop',
                                  child: Text('Select Shop'),
                                ),
                                DropdownMenuItem(
                                  value: 'Kariakoo Branch',
                                  child: Text('Kariakoo Branch'),
                                ),
                                DropdownMenuItem(
                                  value: 'Mikocheni Branch',
                                  child: Text('Mikocheni Branch'),
                                ),
                              ],
                              onChanged: (value) => setDialogState(
                                () => selectedShop = value ?? selectedShop,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),
                      Row(
                        children: [
                          const Text('Search'),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: 'Product name...',
                                isDense: true,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 10,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(6),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Table(
                        columnWidths: const {
                          0: FixedColumnWidth(44),
                          1: FlexColumnWidth(1.2),
                          2: FlexColumnWidth(2),
                          3: FlexColumnWidth(1.5),
                          4: FlexColumnWidth(1),
                        },
                        border: TableBorder.all(color: Colors.black12),
                        children: const [
                          TableRow(
                            decoration: BoxDecoration(color: Color(0xFFF1F1F1)),
                            children: [
                              Padding(
                                padding: EdgeInsets.all(8),
                                child: Center(
                                  child: Icon(
                                    Icons.check_box_outline_blank,
                                    size: 16,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(8),
                                child: Text(
                                  'Photo',
                                  style: TextStyle(fontWeight: FontWeight.w700),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(8),
                                child: Text(
                                  'Name',
                                  style: TextStyle(fontWeight: FontWeight.w700),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(8),
                                child: Text(
                                  'Balance',
                                  style: TextStyle(fontWeight: FontWeight.w700),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(8),
                                child: Text(
                                  'Qty',
                                  style: TextStyle(fontWeight: FontWeight.w700),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                            onPressed: () => Navigator.pop(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blueGrey,
                              foregroundColor: Colors.white,
                            ),
                            child: const Text('Close'),
                          ),
                          const SizedBox(width: 10),
                          ElevatedButton(
                            onPressed: () => Navigator.pop(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue.shade400,
                              foregroundColor: Colors.white,
                            ),
                            child: const Text('Save'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  /// ============ TOP ACTIONS =====================

  void _onTopActionTap(String label) {
    switch (label) {
      case 'Category':
      case 'Kategoria':
        _showCategoriesDialog();
        break;
      case 'Product':
      case 'Bidhaa':
        _showProductDialog();
        break;
      case 'Import':
      case 'Ingiza':
        _showImportActionsDialog();
        break;
      case 'Supplier':
      case 'Msambazaji':
        Navigator.of(context).push(
          MaterialPageRoute<void>(builder: (_) => const _ManageSuppliersPage()),
        );
        break;
      case 'Transfer':
      case 'Hamisha':
        _showTransferStocksDialog();
        break;
      default:
        break;
    }
  }

  Widget _topActions() {
    final labels = [
      _t('Category', 'Kategoria'),
      _t('Product', 'Bidhaa'),
      _t('Import', 'Ingiza'),
      _t('Supplier', 'Msambazaji'),
      _t('Transfer', 'Hamisha'),
    ];
    const spacing = 6.0;
    return LayoutBuilder(
      builder: (context, constraints) {
        final slotWidth =
            (constraints.maxWidth - (spacing * (labels.length - 1))) /
            labels.length;
        final fontSize = slotWidth < 60 ? 8.0 : 9.0;

        return Row(
          children: [
            for (int i = 0; i < labels.length; i++) ...[
              Expanded(
                child: GestureDetector(
                  onTap: () => _onTopActionTap(labels[i]),
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.lightBlue,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(4),
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              '+\n${labels[i]}',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: fontSize,
                                fontWeight: FontWeight.w700,
                                height: 1.1,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              if (i < labels.length - 1) const SizedBox(width: spacing),
            ],
          ],
        );
      },
    );
  }

  /// ============ FORM HELPERS =====================

  Widget _formTextField({
    required String label,
    String? hint,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 18)),
        const SizedBox(height: 6),
        TextField(
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 10,
            ),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
      ],
    );
  }

  Widget _formSelectField({
    required String label,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 18)),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          initialValue: value,
          icon: const Icon(Icons.arrow_drop_down),
          decoration: InputDecoration(
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 10,
            ),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
          items: items
              .map(
                (item) =>
                    DropdownMenuItem<String>(value: item, child: Text(item)),
              )
              .toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _photoPickerField({String label = 'Photo'}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 18)),
        const SizedBox(height: 6),
        Container(
          height: 44,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.blue),
          ),
          child: Row(
            children: [
              TextButton(
                onPressed: () {},
                child: const Text(
                  'Choose File',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const VerticalDivider(width: 1),
              const Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    'No file chosen',
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// =========== STOCK TAB ==============

  Widget _stockTab() {
    return Column(
      children: [
        const SizedBox(height: 10),
        _topActions(),
        const SizedBox(height: 8),
        Align(
          alignment: Alignment.centerRight,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Category Mode',
                style: TextStyle(
                  color: Colors.lightBlue,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(width: 8),
              CupertinoSwitch(
                value: _categoryMode,
                activeTrackColor: Colors.lightBlue,
                onChanged: (value) {
                  setState(() {
                    _categoryMode = value;
                  });
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 6),
        const Divider(color: Colors.black),
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Loss: 0.00', style: TextStyle(fontWeight: FontWeight.w700)),
            Text(
              'S.Value: 0.00',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
            Text(
              'P.Estimate: 0.00',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
          ],
        ),
        const SizedBox(height: 10),
        TextField(
          decoration: InputDecoration(
            hintText: 'Search product name...',
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 11,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: const BorderSide(color: Colors.lightBlue),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Expanded(
          child: ListView.builder(
            itemCount: _products.length,
            itemBuilder: (context, index) {
              final product = _products[index];
              return _StockCard(
                product: product,
                onToggle: () {
                  setState(() {
                    _products[index] = product.copyWith(
                      expanded: !product.expanded,
                    );
                  });
                },
              );
            },
          ),
        ),
      ],
    );
  }

  /// =========== RESTOCK TAB =========================
  Widget _restockTab() {
    return Column(
      children: [
        const SizedBox(height: 10),
        _topActions(),
        const SizedBox(height: 14),
        Align(
          alignment: Alignment.topCenter,
          child: ElevatedButton.icon(
            onPressed: _showRestockDialog,
            icon: const Icon(
              Icons.add,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
            label: const Text(
              'Add Stocks',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: ListView(
            children: _products
                .map(
                  (product) => ListTile(
                    leading: const CircleAvatar(
                      backgroundColor: Colors.lightBlue,
                      child: Text(
                        'PD',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    title: Text(
                      product.name,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    subtitle: Text('Sp: ${product.price}'),
                    trailing: const Icon(Icons.keyboard_arrow_down),
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }

  /// =========== BARCODES TAB =====================

  Widget _barcodesTab() {
    return Column(
      children: [
        const SizedBox(height: 10),
        _topActions(),
        const SizedBox(height: 10),
        const Text(
          'Barcodes',
          style: TextStyle(fontSize: 26, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 8),
        const Divider(),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  'Barcode',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
              Expanded(
                child: Text(
                  'Name',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
        ),
        const Divider(),
        Expanded(
          child: ListView.builder(
            itemCount: _products.length,
            itemBuilder: (context, index) {
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                decoration: const BoxDecoration(
                  border: Border(bottom: BorderSide(color: Colors.black12)),
                ),
                child: Row(
                  children: [
                    const Expanded(child: _FakeBarcode(code: '003783860030')),
                    Expanded(
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              _products[index].name,
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          const Text(
                            '0.00',
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  /// ============= FILTER TAB ===================
  Widget _filterTab() {
    return Column(
      children: [
        const SizedBox(height: 10),
        _topActions(),
        const SizedBox(height: 16),
        Center(
          child: OutlinedButton(
            onPressed: () {
              _showFilterDialog();
            },
            child: Text(
              _t('Open Filter Dialog', 'Fungua Dirisha la Chujio'),
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          _t('Stock', 'Hisa'),
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        backgroundColor: Colors.white,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(kTextTabBarHeight),
          child: Container(
            color: Colors.white,
            child: TabBar(
              controller: _tabController,
              indicatorColor: Colors.lightBlue,
              labelColor: Colors.lightBlue,
              unselectedLabelColor: Colors.lightBlue,
              tabs: [
                Tab(
                  icon: const Icon(Icons.inventory_2_outlined),
                  text: _t('Stock', 'Hisa'),
                ),
                Tab(
                  icon: const Icon(Icons.add_box_outlined),
                  text: _t('Restock', 'Ongeza Hisa'),
                ),
                Tab(
                  icon: const Icon(Icons.qr_code_2),
                  text: _t('Barcodes', 'Misimbo'),
                ),
                Tab(
                  icon: const Icon(Icons.filter_list),
                  text: _t('Filter', 'Chuja'),
                ),
              ],
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          Padding(padding: const EdgeInsets.all(12), child: _stockTab()),
          Padding(padding: const EdgeInsets.all(12), child: _restockTab()),
          Padding(padding: const EdgeInsets.all(12), child: _barcodesTab()),
          Padding(padding: const EdgeInsets.all(12), child: _filterTab()),
        ],
      ),
    );
  }
}

class _StockCard extends StatelessWidget {
  const _StockCard({required this.product, required this.onToggle});

  final _StockProduct product;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: product.expanded ? const Color(0xFFC2D8F6) : Colors.transparent,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Colors.blueGrey.shade100),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 18,
                  backgroundColor: Colors.lightBlue,
                  child: Text(
                    'PD',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text('Sp: ${product.price}'),
                    ],
                  ),
                ),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Sold: 0.00'),
                    Text('Exp: 0.00'),
                    Text('Bad: 0.00'),
                    Text('Lost: 0.00'),
                  ],
                ),
                IconButton(
                  onPressed: onToggle,
                  icon: Icon(
                    product.expanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                  ),
                ),
              ],
            ),
          ),
          if (product.expanded)
            Container(
              width: double.infinity,
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Stock History~',
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const Expanded(
                    child: Text(
                      'Sales History~',
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.edit, size: 14),
                    label: const Text('Edit'),
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 6),
                  OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.delete_outline, size: 14),
                    label: const Text('Delete'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _LabeledCompactField extends StatelessWidget {
  const _LabeledCompactField({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 18)),
        const SizedBox(height: 6),
        TextField(
          decoration: InputDecoration(
            hintText: '0',
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 10,
            ),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
      ],
    );
  }
}

class _ManageSuppliersPage extends StatefulWidget {
  const _ManageSuppliersPage();

  @override
  State<_ManageSuppliersPage> createState() => _ManageSuppliersPageState();
}

class _ManageSuppliersPageState extends State<_ManageSuppliersPage> {
  void _showCreateSupplierDialog() {
    showDialog<void>(
      context: context,
      builder: (context) {
        final isNarrow = MediaQuery.of(context).size.width < 760;
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 760),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Center(
                      child: Text(
                        'Create supplier',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Divider(),
                    const SizedBox(height: 8),
                    isNarrow
                        ? const Column(
                            children: [
                              _SupplierField(label: 'Supplier Name'),
                              SizedBox(height: 10),
                              _SupplierField(label: 'Phone'),
                              SizedBox(height: 10),
                              _SupplierField(label: 'Email (Optional)'),
                              SizedBox(height: 10),
                              _SupplierField(label: 'Business/Company Name'),
                              SizedBox(height: 10),
                              _SupplierField(
                                label: 'Taxpayer Number (TIN) (Optional)',
                              ),
                              SizedBox(height: 10),
                              _SupplierField(
                                label: 'Address (Optional)',
                                maxLines: 2,
                              ),
                            ],
                          )
                        : const Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: _SupplierField(
                                      label: 'Supplier Name',
                                    ),
                                  ),
                                  SizedBox(width: 12),
                                  Expanded(
                                    child: _SupplierField(label: 'Phone'),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                              Row(
                                children: [
                                  Expanded(
                                    child: _SupplierField(
                                      label: 'Email (Optional)',
                                    ),
                                  ),
                                  SizedBox(width: 12),
                                  Expanded(
                                    child: _SupplierField(
                                      label: 'Business/Company Name',
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                              Row(
                                children: [
                                  Expanded(
                                    child: _SupplierField(
                                      label: 'Taxpayer Number (TIN) (Optional)',
                                    ),
                                  ),
                                  SizedBox(width: 12),
                                  Expanded(
                                    child: _SupplierField(
                                      label: 'Address (Optional)',
                                      maxLines: 2,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                    const SizedBox(height: 14),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          onPressed: () => Navigator.pop(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueGrey,
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('Close'),
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: () => Navigator.pop(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.lightBlue,
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('Create'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: TextButton.icon(
              onPressed: _showCreateSupplierDialog,
              icon: const Icon(Icons.person_add_alt_1, color: Colors.blue),
              label: const Text(
                'Add New',
                style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            const Center(
              child: Text(
                'Manage suppliers',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.w700),
              ),
            ),
            const SizedBox(height: 8),
            const Divider(),
            Table(
              columnWidths: const {
                0: FlexColumnWidth(0.7),
                1: FlexColumnWidth(2.1),
                2: FlexColumnWidth(1.8),
                3: FlexColumnWidth(2.2),
                4: FlexColumnWidth(2.2),
              },
              border: TableBorder.all(color: Colors.black12),
              children: const [
                TableRow(
                  decoration: BoxDecoration(color: Color(0xFFF1F1F1)),
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
                        'Company Name',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    Padding(padding: EdgeInsets.all(8), child: Text('1')),
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: Text('Demo Supplier'),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: Text('+255 712 345 678'),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: Text('demo@supplier.com'),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: Text('Demo Company Ltd'),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SupplierField extends StatelessWidget {
  const _SupplierField({required this.label, this.maxLines = 1});

  final String label;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 6),
        TextField(
          maxLines: maxLines,
          decoration: InputDecoration(
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 10,
            ),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
      ],
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

class _FakeBarcode extends StatelessWidget {
  const _FakeBarcode({required this.code});

  final String code;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Row(
              children: List.generate(
                30,
                (index) => Container(
                  margin: const EdgeInsets.only(right: 1),
                  width: index % 3 == 0 ? 3 : 2,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          Text(code),
        ],
      ),
    );
  }
}

class _CategoryRow {
  const _CategoryRow({
    required this.name,
    required this.products,
    required this.canDelete,
  });

  final String name;
  final int products;
  final bool canDelete;
}

class _StockProduct {
  const _StockProduct({
    required this.name,
    required this.price,
    this.expanded = false,
  });

  final String name;
  final String price;
  final bool expanded;

  _StockProduct copyWith({String? name, String? price, bool? expanded}) {
    return _StockProduct(
      name: name ?? this.name,
      price: price ?? this.price,
      expanded: expanded ?? this.expanded,
    );
  }
}
