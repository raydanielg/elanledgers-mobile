// pages/sales_orders.dart
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:duka_app/l10n/locale_utils.dart';
import 'package:duka_app/services/sales_service.dart';

class SalesOrdersPage extends StatefulWidget {
  const SalesOrdersPage({super.key});

  @override
  State<SalesOrdersPage> createState() => _SalesOrdersPageState();
}

class _SalesOrdersPageState extends State<SalesOrdersPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  final SalesService _salesService = SalesService();
  bool _filterDialogOpen = false;

  // API Data
  List<dynamic> _salesData = [];
  List<dynamic> _ordersData = [];
  List<dynamic> _invoicesData = [];
  bool _isLoading = true;
  String? _errorMessage;

  bool _customerEnabled = true;
  bool _cashierEnabled = false;
  int _expandedSaleIndex = -1;
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

  late final List<_SaleEntry> _demoSales = [
    _SaleEntry(
      dateTime: 'Feb 17, 2026 00:00',
      paymentType: 'Cash',
      cashier: 'WILSON WINCHESLAUS',
      total: '60,000.00',
      paid: '60,000.00',
      saleType: 'Cash sale',
      items: [
        _SaleItem(
          name: 'POSTER DESIGNING',
          qty: '2.00',
          price: '20,000.00',
          total: '40,000.00',
        ),
        _SaleItem(
          name: 'POSTER DESIGNING',
          qty: '1.00',
          price: '20,000.00',
          total: '20,000.00',
        ),
      ],
      subtotal: '60,000.00',
      discount: '0.00',
    ),
    _SaleEntry(
      dateTime: 'Feb 16, 2026 00:00',
      paymentType: 'Cash',
      cashier: 'WILSON WINCHESLAUS',
      total: '60,000.00',
      paid: '60,000.00',
      saleType: 'Cash sale',
      items: [
        _SaleItem(
          name: 'POSTER DESIGNING',
          qty: '1.00',
          price: '40,000.00',
          total: '40,000.00',
        ),
        _SaleItem(
          name: 'POSTER DESIGNING',
          qty: '1.00',
          price: '20,000.00',
          total: '20,000.00',
        ),
      ],
      subtotal: '60,000.00',
      discount: '0.00',
    ),
    _SaleEntry(
      dateTime: 'Feb 15, 2026 11:45',
      paymentType: 'Mobile Money',
      cashier: 'WILSON WINCHESLAUS',
      total: '45,000.00',
      paid: '45,000.00',
      saleType: 'Mobile sale',
      items: [
        _SaleItem(
          name: 'LOGO DESIGN',
          qty: '1.00',
          price: '25,000.00',
          total: '25,000.00',
        ),
        _SaleItem(
          name: 'BUSINESS CARD DESIGN',
          qty: '2.00',
          price: '10,000.00',
          total: '20,000.00',
        ),
      ],
      subtotal: '45,000.00',
      discount: '0.00',
    ),
    _SaleEntry(
      dateTime: 'Feb 14, 2026 16:10',
      paymentType: 'Credit',
      cashier: 'WILSON WINCHESLAUS',
      total: '80,000.00',
      paid: '30,000.00',
      saleType: 'Credit sale',
      items: [
        _SaleItem(
          name: 'BANNER DESIGN',
          qty: '2.00',
          price: '25,000.00',
          total: '50,000.00',
        ),
        _SaleItem(
          name: 'FLYER DESIGN',
          qty: '3.00',
          price: '10,000.00',
          total: '30,000.00',
        ),
      ],
      subtotal: '80,000.00',
      discount: '0.00',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(_onTabChanged);
    _fetchSalesData();
  }

  // Fetch all sales data from API
  Future<void> _fetchSalesData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final results = await Future.wait([
        _salesService.getSales(),
        _salesService.getOrders(),
        _salesService.getInvoices(),
      ]);

      final salesResult = results[0];
      final ordersResult = results[1];
      final invoicesResult = results[2];

      setState(() {
        if (salesResult['success'] && salesResult['data'] != null) {
          final data = salesResult['data']['result'] ?? salesResult['data'];
          if (data is List) {
            _salesData = data;
          }
        }
        if (ordersResult['success'] && ordersResult['data'] != null) {
          final data = ordersResult['data']['result'] ?? ordersResult['data'];
          if (data is List) {
            _ordersData = data;
          }
        }
        if (invoicesResult['success'] && invoicesResult['data'] != null) {
          final data = invoicesResult['data']['result'] ?? invoicesResult['data'];
          if (data is List) {
            _invoicesData = data;
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
    if (_tabController.index == 3 &&
        !_tabController.indexIsChanging &&
        !_filterDialogOpen) {
      _filterDialogOpen = true;
      Future.microtask(() async {
        await _showFilterDialog();
        if (mounted) {
          setState(() {
            _filterDialogOpen = false;
          });
        } else {
          _filterDialogOpen = false;
        }
      });
    }
  }

  /// ============ SHARED TOP ACTIONS ============
  Widget _topActions() {
    final actions = [
      (
        _t('Make Sale', 'Fanya Mauzo'),
        Icons.point_of_sale_outlined,
        _TopAction.makeSale,
      ),
      (_t('Order', 'Oda'), Icons.shopping_cart_outlined, _TopAction.order),
      (
        _t('Invoice', 'Ankara'),
        Icons.receipt_long_outlined,
        _TopAction.invoice,
      ),
      (_t('Customer', 'Mteja'), Icons.people_outline, _TopAction.customer),
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: actions
          .map(
            (action) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: InkWell(
                borderRadius: BorderRadius.circular(8),
                onTap: () => _openTopAction(action.$3),
                child: SizedBox(
                  width: 72,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: Colors.lightBlue.shade50,
                          border: Border.all(color: Colors.lightBlue, width: 1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(action.$2, color: Colors.lightBlue),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        action.$1,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.lightBlue,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
          .toList(),
    );
  }

  void _openTopAction(_TopAction action) {
    switch (action) {
      case _TopAction.makeSale:
        Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) =>
                const _CreateTransactionPage(mode: _TransactionMode.makeSale),
          ),
        );
        return;
      case _TopAction.order:
        Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) =>
                const _CreateTransactionPage(mode: _TransactionMode.order),
          ),
        );
        return;
      case _TopAction.invoice:
        Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) =>
                const _CreateTransactionPage(mode: _TransactionMode.invoice),
          ),
        );
        return;
      case _TopAction.customer:
        Navigator.of(context).push(
          MaterialPageRoute<void>(builder: (_) => const _ManageCustomersPage()),
        );
        return;
    }
  }

  Widget _customerCashierRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Customer',
              style: TextStyle(
                color: Colors.lightBlue,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            Row(
              children: [
                CupertinoSwitch(
                  value: _customerEnabled,
                  onChanged: (value) =>
                      setState(() => _customerEnabled = value),
                  activeTrackColor: Colors.lightBlue,
                ),
              ],
            ),
          ],
        ),
        const Text(
          'All Time Report',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const Text(
              'Cashier',
              style: TextStyle(
                color: Colors.lightBlue,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            CupertinoSwitch(
              value: _cashierEnabled,
              onChanged: (value) => setState(() => _cashierEnabled = value),
              activeTrackColor: Colors.lightBlue,
            ),
          ],
        ),
      ],
    );
  }

  /// ============ SALES TAB ============
  Widget _salesTab() {
    final visibleSaleIndexes = <int>[];
    for (var i = 0; i < _demoSales.length; i++) {
      if (_hasVisibleSaleContent(_demoSales[i])) {
        visibleSaleIndexes.add(i);
      }
    }
    final visibleSales = visibleSaleIndexes.map((i) => _demoSales[i]).toList();

    final totalSales = visibleSales.fold<double>(
      0,
      (sum, sale) => sum + _toAmount(sale.total),
    );
    final unpaidSales = visibleSales.fold<double>(
      0,
      (sum, sale) => sum + (_toAmount(sale.total) - _toAmount(sale.paid)),
    );

    return Column(
      children: [
        const SizedBox(height: 10),
        _topActions(),
        const SizedBox(height: 10),
        _customerCashierRow(),
        const Divider(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text(
              'Credit: 0.00',
              style: TextStyle(
                color: Colors.red,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              'Cash: 120,000.00',
              style: TextStyle(
                color: Colors.green,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        TextField(
          decoration: InputDecoration(
            hintText: 'Search.......',
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
        const Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Date',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
          ),
        ),
        const Divider(),
        Expanded(
          child: ListView.builder(
            itemCount: visibleSaleIndexes.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'CASH SALE',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: Colors.grey.shade800,
                          ),
                        ),
                        Text(
                          'Unpaid: ${_amountString(unpaidSales)} | Total: ${_amountString(totalSales)}',
                          style: const TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.w700,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                  ],
                );
              }

              final saleIndex = visibleSaleIndexes[index - 1];

              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: _saleCard(index: saleIndex),
              );
            },
          ),
        ),
      ],
    );
  }

  bool _hasVisibleSaleContent(_SaleEntry sale) {
    bool hasText(String value) => value.trim().isNotEmpty;

    return hasText(sale.dateTime) ||
        hasText(sale.paymentType) ||
        hasText(sale.cashier) ||
        hasText(sale.total) ||
        hasText(sale.paid) ||
        hasText(sale.saleType) ||
        sale.items.isNotEmpty;
  }

  Widget _saleCard({required int index}) {
    final sale = _demoSales[index];
    final expanded = _expandedSaleIndex == index;
    final borderRadius = BorderRadius.circular(6);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.blue.shade200),
        borderRadius: borderRadius,
      ),
      child: ClipRRect(
        borderRadius: borderRadius,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(width: 6, color: Colors.green),
            Expanded(
              child: InkWell(
                onTap: () {
                  setState(() {
                    _expandedSaleIndex = expanded ? -1 : index;
                  });
                },
                child: Column(
                  children: [
                    Container(
                      color: expanded ? const Color(0xFFD8E7FB) : Colors.white,
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            sale.dateTime,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            sale.paymentType,
                            style: const TextStyle(
                              color: Colors.green,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            'By ${sale.cashier}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Total: ${sale.total}',
                                style: const TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                ),
                              ),
                              Row(
                                children: [
                                  Text(
                                    'Paid: ${sale.paid}',
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 13,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Icon(
                                    expanded
                                        ? Icons.keyboard_arrow_up
                                        : Icons.keyboard_arrow_down,
                                    size: 16,
                                    color: Colors.black,
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              'To ${sale.saleType}',
                              style: const TextStyle(
                                color: Colors.black,
                                fontStyle: FontStyle.italic,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (expanded) ...[
                      const Divider(height: 1),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 10,
                        ),
                        child: Column(
                          children: [
                            Table(
                              border: const TableBorder(
                                horizontalInside: BorderSide(
                                  color: Colors.black12,
                                ),
                              ),
                              columnWidths: const {
                                0: FlexColumnWidth(2.5),
                                1: FlexColumnWidth(1),
                                2: FlexColumnWidth(1.4),
                                3: FlexColumnWidth(1.4),
                              },
                              children: [
                                const TableRow(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                        vertical: 8,
                                      ),
                                      child: Text(
                                        'Item',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                        vertical: 8,
                                      ),
                                      child: Text(
                                        'Qty',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                        vertical: 8,
                                      ),
                                      child: Text(
                                        'Price',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                        vertical: 8,
                                      ),
                                      child: Text(
                                        'Total',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                ...sale.items.map(
                                  (item) => TableRow(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 8,
                                        ),
                                        child: Text(item.name),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 8,
                                        ),
                                        child: Text(item.qty),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 8,
                                        ),
                                        child: Text(item.price),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 8,
                                        ),
                                        child: Text(item.total),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                'Subtotal: ${sale.subtotal}',
                                style: const TextStyle(fontSize: 20),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                'Total: ${sale.total}',
                                style: const TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                'Discount: ${sale.discount}',
                                style: const TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                'Paid: ${sale.paid}',
                                style: const TextStyle(fontSize: 20),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                Expanded(child: _smallActionButton('Download')),
                                const SizedBox(width: 4),
                                Expanded(child: _smallActionButton('Print')),
                                const SizedBox(width: 4),
                                Expanded(child: _smallActionButton('Preview')),
                                const SizedBox(width: 4),
                                Expanded(child: _smallActionButton('Edit')),
                                const SizedBox(width: 4),
                                SizedBox(
                                  height: 32,
                                  child: ElevatedButton(
                                    onPressed: () {},
                                    style: ElevatedButton.styleFrom(
                                      minimumSize: const Size(30, 32),
                                      tapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                      backgroundColor: Colors.red.shade400,
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 6,
                                      ),
                                    ),
                                    child: const Icon(
                                      Icons.delete_outline,
                                      size: 16,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// ============ ORDER TAB ============
  Widget _ordersTab() {
    return Column(
      children: [
        const SizedBox(height: 10),
        _topActions(),
        const SizedBox(height: 10),
        _customerCashierRow(),
        const Divider(),
        const SizedBox(height: 18),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton(
              onPressed: _showOrderListDialog,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              child: const Text(
                'View List ->',
                style: TextStyle(color: Colors.white),
              ),
            ),
            const Text('Order Value: 0.00', style: TextStyle(fontSize: 20)),
          ],
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
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.lightBlue),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            _t('Date', 'Tarehe'),
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
          ),
        ),
        const Divider(),
      ],
    );
  }

  void _showOrderListDialog() {
    showDialog<void>(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 700),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _t('Order List', 'Orodha ya Oda'),
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.lightBlue,
                          foregroundColor: Colors.black,
                        ),
                        child: Text(_t('Close', 'Funga')),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Center(
                    child: Wrap(
                      spacing: 8,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.download,
                            size: 14,
                            color: Colors.lightBlue,
                          ),
                          label: const Text(
                            'Excel',
                            style: TextStyle(color: Colors.lightBlue),
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.download,
                            size: 14,
                            color: Colors.lightBlue,
                          ),
                          label: const Text(
                            'Pdf',
                            style: TextStyle(color: Colors.lightBlue),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Table(
                    border: TableBorder.all(color: Colors.black45),
                    columnWidths: const {
                      0: FlexColumnWidth(0.8),
                      1: FlexColumnWidth(2.2),
                      2: FlexColumnWidth(0.9),
                      3: FlexColumnWidth(1.4),
                      4: FlexColumnWidth(1.4),
                    },
                    children: const [
                      TableRow(
                        children: [
                          Padding(
                            padding: EdgeInsets.all(8),
                            child: Text(
                              'S/N',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8),
                            child: Text(
                              'Item Name',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8),
                            child: Text(
                              'QTY',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8),
                            child: Text(
                              'PRICE @',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8),
                            child: Text(
                              'TOTAL',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                      TableRow(
                        children: [
                          Padding(padding: EdgeInsets.all(8), child: Text('')),
                          Padding(
                            padding: EdgeInsets.all(8),
                            child: Text(
                              'GRAND TOTAL',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          Padding(padding: EdgeInsets.all(8), child: Text('')),
                          Padding(padding: EdgeInsets.all(8), child: Text('')),
                          Padding(
                            padding: EdgeInsets.all(8),
                            child: Text(
                              'TZS 0.00',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
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

  /// ============ INVOICE TAB ============
  Widget _invoiceTab() {
    return Column(
      children: [
        const SizedBox(height: 10),
        _topActions(),
        const SizedBox(height: 10),
        _customerCashierRow(),
        const Divider(),
        const SizedBox(height: 10),
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Unpaid: 0.00',
              style: TextStyle(
                color: Colors.red,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Paid: 0.00',
              style: TextStyle(
                color: Colors.green,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
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
        const Align(
          alignment: Alignment.centerLeft,
          child: Text('.', style: TextStyle(fontSize: 24)),
        ),
        const Divider(),
      ],
    );
  }

  /// ============ FILTER DIALOG ============
  Future<void> _showFilterDialog() async {
    String selectedFilter = 'Today';
    bool showCustomRange = false;

    await showDialog<void>(
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
                child: SingleChildScrollView(
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
                            _filterButtonRow(
                              labels: const ['Today'],
                              selectedFilter: selectedFilter,
                              onTap: (label) => setDialogState(() {
                                selectedFilter = label;
                                showCustomRange = false;
                              }),
                            ),
                            _filterButtonRow(
                              labels: const ['Yesterday', 'This Week'],
                              selectedFilter: selectedFilter,
                              onTap: (label) => setDialogState(() {
                                selectedFilter = label;
                                showCustomRange = false;
                              }),
                            ),
                            _filterButtonRow(
                              labels: const ['Last Week', 'This Month'],
                              selectedFilter: selectedFilter,
                              onTap: (label) => setDialogState(() {
                                selectedFilter = label;
                                showCustomRange = false;
                              }),
                            ),
                            _filterButtonRow(
                              labels: const ['Last Month', 'Last 3 Months'],
                              selectedFilter: selectedFilter,
                              onTap: (label) => setDialogState(() {
                                selectedFilter = label;
                                showCustomRange = false;
                              }),
                            ),
                            _filterButtonRow(
                              labels: const ['This Year'],
                              selectedFilter: selectedFilter,
                              onTap: (label) => setDialogState(() {
                                selectedFilter = label;
                                showCustomRange = false;
                              }),
                            ),
                            const SizedBox(height: 8),
                            SizedBox(
                              width: double.infinity,
                              child: OutlinedButton(
                                onPressed: () => setDialogState(() {
                                  selectedFilter = 'Custom';
                                  showCustomRange = true;
                                }),
                                style: OutlinedButton.styleFrom(
                                  side: BorderSide(
                                    color: selectedFilter == 'Custom'
                                        ? Colors.blue.shade700
                                        : Colors.blue,
                                  ),
                                  foregroundColor: Colors.blue.shade700,
                                ),
                                child: Text(_f('Custom')),
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (showCustomRange) ...[
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
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _filterButtonRow({
    required List<String> labels,
    required String selectedFilter,
    required ValueChanged<String> onTap,
  }) {
    if (labels.length == 1) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: () => onTap(labels.first),
            style: OutlinedButton.styleFrom(
              side: BorderSide(
                color: selectedFilter == labels.first
                    ? Colors.blue.shade700
                    : Colors.blue,
              ),
              foregroundColor: Colors.blue.shade700,
            ),
            child: Text(_f(labels.first)),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () => onTap(labels[0]),
              style: OutlinedButton.styleFrom(
                side: BorderSide(
                  color: selectedFilter == labels[0]
                      ? Colors.blue.shade700
                      : Colors.blue,
                ),
                foregroundColor: Colors.blue.shade700,
              ),
              child: Text(_f(labels[0])),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: OutlinedButton(
              onPressed: () => onTap(labels[1]),
              style: OutlinedButton.styleFrom(
                side: BorderSide(
                  color: selectedFilter == labels[1]
                      ? Colors.blue.shade700
                      : Colors.blue,
                ),
                foregroundColor: Colors.blue.shade700,
              ),
              child: Text(_f(labels[1])),
            ),
          ),
        ],
      ),
    );
  }

  Widget _filterTab() {
    return Center(
      child: OutlinedButton(
        onPressed: _showFilterDialog,
        child: Text(
          _t('Open Filter Dialog', 'Fungua Dirisha la Chujio'),
          style: TextStyle(
            color: Colors.lightBlue,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  Widget _smallActionButton(String label) {
    return SizedBox(
      height: 32,
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(0, 32),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 6),
          textStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
        ),
        child: FittedBox(fit: BoxFit.scaleDown, child: Text(label)),
      ),
    );
  }

  double _toAmount(String amount) {
    final cleaned = amount.replaceAll(',', '').trim();
    return double.tryParse(cleaned) ?? 0;
  }

  String _amountString(double amount) {
    return amount
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
          _t('Sales and Orders', 'Mauzo na Oda'),
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.lightBlue,
          labelColor: Colors.lightBlue,
          unselectedLabelColor: Colors.lightBlue,
          tabs: [
            Tab(
              icon: const Icon(Icons.shopping_cart_checkout),
              text: _t('Sales', 'Mauzo'),
            ),
            Tab(
              icon: const Icon(Icons.shopping_cart_outlined),
              text: _t('Order', 'Oda'),
            ),
            Tab(
              icon: const Icon(Icons.receipt_long_outlined),
              text: _t('Invoice', 'Ankara'),
            ),
            Tab(
              icon: const Icon(Icons.filter_alt_outlined),
              text: _t('Filter', 'Chuja'),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          Padding(padding: const EdgeInsets.all(10), child: _salesTab()),
          Padding(padding: const EdgeInsets.all(10), child: _ordersTab()),
          Padding(padding: const EdgeInsets.all(10), child: _invoiceTab()),
          Padding(padding: const EdgeInsets.all(10), child: _filterTab()),
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

class _SaleEntry {
  _SaleEntry({
    required this.dateTime,
    required this.paymentType,
    required this.cashier,
    required this.total,
    required this.paid,
    required this.saleType,
    required this.items,
    required this.subtotal,
    required this.discount,
  });

  final String dateTime;
  final String paymentType;
  final String cashier;
  final String total;
  final String paid;
  final String saleType;
  final List<_SaleItem> items;
  final String subtotal;
  final String discount;
}

class _SaleItem {
  _SaleItem({
    required this.name,
    required this.qty,
    required this.price,
    required this.total,
  });

  final String name;
  final String qty;
  final String price;
  final String total;
}

enum _TopAction { makeSale, order, invoice, customer }

enum _TransactionMode { makeSale, order, invoice }

class CreateCashSalePage extends StatelessWidget {
  const CreateCashSalePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _CreateTransactionPage(mode: _TransactionMode.makeSale);
  }
}

class CreateOrderPage extends StatelessWidget {
  const CreateOrderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _CreateTransactionPage(mode: _TransactionMode.order);
  }
}

class CreateQuotationPage extends StatelessWidget {
  const CreateQuotationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _CreateTransactionPage(mode: _TransactionMode.invoice);
  }
}

Future<void> _showCreateCustomerDialog(BuildContext context) async {
  String selectedCategory = 'Customers';
  String selectedGender = 'Select Gender';
  String selectedCountryCode = 'TZ +25';

  await showDialog<void>(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setDialogState) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 540),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(12),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Create Customer',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 28,
                        ),
                      ),
                    ),
                  ),
                  const Divider(height: 1),
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: _LabeledField(
                                label: 'Category',
                                child: _dialogDropdown(
                                  value: selectedCategory,
                                  items: const [
                                    'Customers',
                                    'Retail',
                                    'Wholesale',
                                    'VIP',
                                  ],
                                  onChanged: (value) {
                                    setDialogState(() {
                                      selectedCategory = value;
                                    });
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _LabeledField(
                                label: 'Name',
                                child: _dialogInput(''),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: _LabeledField(
                                label: 'Phone:',
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: 88,
                                      child: _dialogDropdown(
                                        value: selectedCountryCode,
                                        items: const [
                                          'TZ +25',
                                          'KE +254',
                                          'UG +256',
                                        ],
                                        onChanged: (value) {
                                          setDialogState(() {
                                            selectedCountryCode = value;
                                          });
                                        },
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(child: _dialogInput('065*****')),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _LabeledField(
                                label: 'Email',
                                child: _dialogInput('eg: username@example.com'),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: _LabeledField(
                                label: 'Gender',
                                child: _dialogDropdown(
                                  value: selectedGender,
                                  items: const [
                                    'Select Gender',
                                    'Male',
                                    'Female',
                                  ],
                                  onChanged: (value) {
                                    setDialogState(() {
                                      selectedGender = value;
                                    });
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _LabeledField(
                                label: 'Address',
                                child: _dialogInput('Dar es salaam'),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1),
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          onPressed: () => Navigator.pop(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey,
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('Close'),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () => Navigator.pop(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('Submit'),
                        ),
                      ],
                    ),
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

Widget _dialogInput(String hint) {
  return Container(
    height: 40,
    decoration: BoxDecoration(
      border: Border.all(color: Colors.lightBlue),
      borderRadius: BorderRadius.circular(6),
    ),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: TextField(
        textAlign: TextAlign.center,
        textAlignVertical: TextAlignVertical.top,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hint,
          contentPadding: const EdgeInsets.only(top: 8),
          isDense: true,
        ),
      ),
    ),
  );
}

Widget _dialogDropdown({
  required String value,
  required List<String> items,
  required ValueChanged<String> onChanged,
}) {
  return Container(
    height: 40,
    decoration: BoxDecoration(
      border: Border.all(color: Colors.lightBlue),
      borderRadius: BorderRadius.circular(6),
    ),
    padding: const EdgeInsets.symmetric(horizontal: 8),
    child: DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        value: value,
        isExpanded: true,
        isDense: true,
        onChanged: (selected) {
          if (selected != null) {
            onChanged(selected);
          }
        },
        items: items
            .map(
              (item) =>
                  DropdownMenuItem<String>(value: item, child: Text(item)),
            )
            .toList(),
      ),
    ),
  );
}

class _LabeledField extends StatelessWidget {
  const _LabeledField({required this.label, required this.child});

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

class _CatalogProduct {
  const _CatalogProduct({required this.name, required this.price});

  final String name;
  final double price;
}

class _CreateTransactionPage extends StatefulWidget {
  const _CreateTransactionPage({required this.mode});

  final _TransactionMode mode;

  @override
  State<_CreateTransactionPage> createState() => _CreateTransactionPageState();
}

class _CreateTransactionPageState extends State<_CreateTransactionPage> {
  bool _wholeSale = false;
  bool _printEnabled = false;
  String _selectedCustomer = 'Customer';
  String _paymentMode = 'Cash';
  String _searchText = '';
  final Map<String, int> _selectedProducts = {};
  final List<String> _customers = ['Customer', 'WILSON', 'MUSA', 'SALMA'];
  final List<_CatalogProduct> _products = const [
    _CatalogProduct(name: 'POSTER DESIGNING', price: 20000),
    _CatalogProduct(name: 'LOGO DESIGN', price: 25000),
    _CatalogProduct(name: 'BUSINESS CARD DESIGN', price: 10000),
    _CatalogProduct(name: 'FLYER DESIGN', price: 10000),
  ];
  String _tr(String en, String sw) => tr(context, en, sw);

  String get _title {
    switch (widget.mode) {
      case _TransactionMode.makeSale:
        return _tr('Create Cashsale', 'Unda Mauzo ya Cash');
      case _TransactionMode.order:
        return _tr('Create Order', 'Unda Oda');
      case _TransactionMode.invoice:
        return _tr('Create Quotation', 'Unda Nukuu');
    }
  }

  String get _saveLabel {
    switch (widget.mode) {
      case _TransactionMode.makeSale:
        return _tr('Save Record', 'Hifadhi Rekodi');
      case _TransactionMode.order:
        return _tr('Save order', 'Hifadhi oda');
      case _TransactionMode.invoice:
        return _tr('Save quotation', 'Hifadhi nukuu');
    }
  }

  double get _subtotal {
    double sum = 0;
    _selectedProducts.forEach((name, qty) {
      final product = _products.firstWhere((p) => p.name == name);
      sum += product.price * qty;
    });
    return sum;
  }

  double get _paidAmount {
    if (widget.mode == _TransactionMode.order) {
      return 0;
    }
    return _subtotal;
  }

  List<_CatalogProduct> get _filteredProducts {
    if (_searchText.trim().isEmpty) {
      return _products;
    }
    return _products
        .where(
          (p) =>
              p.name.toLowerCase().contains(_searchText.trim().toLowerCase()),
        )
        .toList();
  }

  void _addProduct(String name) {
    setState(() {
      _selectedProducts.update(name, (value) => value + 1, ifAbsent: () => 1);
    });
  }

  void _reduceProduct(String name) {
    setState(() {
      final qty = _selectedProducts[name] ?? 0;
      if (qty <= 1) {
        _selectedProducts.remove(name);
      } else {
        _selectedProducts[name] = qty - 1;
      }
    });
  }

  Future<void> _openCustomerDropdown() async {
    final picked = await showDialog<String>(
      context: context,
      builder: (context) {
        String search = '';
        return StatefulBuilder(
          builder: (context, setDialogState) {
            final matches = _customers
                .where(
                  (name) =>
                      name.toLowerCase().contains(search.trim().toLowerCase()),
                )
                .toList();

            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              insetPadding: const EdgeInsets.symmetric(horizontal: 60),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 360),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        onChanged: (value) {
                          setDialogState(() {
                            search = value;
                          });
                        },
                        decoration: InputDecoration(
                          hintText: 'Search customer...',
                          isDense: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      ...matches.map(
                        (name) => ListTile(
                          dense: true,
                          title: Text(name),
                          onTap: () => Navigator.pop(context, name),
                        ),
                      ),
                      const Divider(),
                      InkWell(
                        onTap: () async {
                          Navigator.pop(context);
                          if (!mounted) {
                            return;
                          }
                          await _showCreateCustomerDialog(this.context);
                        },
                        child: const Padding(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          child: Row(
                            children: [
                              Icon(Icons.add, color: Colors.blue),
                              SizedBox(width: 6),
                              Text(
                                'Add New Customer',
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.w700,
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
            );
          },
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedCustomer = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 6, 10, 6),
              child: Row(
                children: [
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    child: const Column(
                      children: [Icon(Icons.arrow_back, size: 28)],
                    ),
                  ),
                  Expanded(
                    child: Text(
                      _title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      const Text(
                        'Whole Sale',
                        style: TextStyle(
                          color: Colors.lightBlue,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      CupertinoSwitch(
                        value: _wholeSale,
                        onChanged: (value) =>
                            setState(() => _wholeSale = value),
                        activeTrackColor: Colors.lightBlue,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: _LabeledField(
                            label: 'Record Date',
                            child: _readonlyField('02/20/2026'),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _LabeledField(
                            label: 'Paid Amount',
                            child: _readonlyField(
                              _paidAmount.toStringAsFixed(2),
                              isBlueText: true,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton(
                        onPressed: _openCustomerDropdown,
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          side: BorderSide(color: Colors.blue.shade400),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        child: Text('$_selectedCustomer  \u25BE'),
                      ),
                    ),
                    const Divider(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _summaryCell('Discount', '0.00'),
                        _summaryCell('Subtotal', _subtotal.toStringAsFixed(2)),
                        _summaryCell(
                          'Total Amount',
                          _subtotal.toStringAsFixed(2),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    _scanButton(),
                    const SizedBox(height: 8),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Selected Products',
                        style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    _selectedProductTable(),
                    const SizedBox(height: 10),
                    TextField(
                      onChanged: (value) => setState(() => _searchText = value),
                      decoration: InputDecoration(
                        hintText: 'Search product name...',
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide: const BorderSide(color: Colors.lightBlue),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    _productsTable(),
                  ],
                ),
              ),
            ),
            _bottomActionBar(),
          ],
        ),
      ),
    );
  }

  Widget _summaryCell(String label, String amount) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 12)),
        Text(
          amount,
          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
        ),
      ],
    );
  }

  Widget _scanButton() {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: () {},
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Colors.lightBlue),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        ),
        child: const Text(
          'SCAN HERE...',
          style: TextStyle(fontWeight: FontWeight.w700, color: Colors.black87),
        ),
      ),
    );
  }

  Widget _selectedProductTable() {
    final selectedNames = _selectedProducts.keys.toList();
    if (selectedNames.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 12),
        child: Text(
          'No product selected yet',
          style: TextStyle(color: Colors.black54),
        ),
      );
    }

    return Column(
      children: selectedNames.map((name) {
        final qty = _selectedProducts[name] ?? 0;
        final price = _products.firstWhere((p) => p.name == name).price;
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 6),
          decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.black12)),
          ),
          child: Row(
            children: [
              Expanded(flex: 4, child: Text(name)),
              Expanded(
                flex: 3,
                child: Row(
                  children: [
                    _qtyButton('-', () => _reduceProduct(name)),
                    SizedBox(width: 42, child: Center(child: Text('$qty'))),
                    _qtyButton('+', () => _addProduct(name)),
                  ],
                ),
              ),
              Expanded(flex: 2, child: Text(price.toStringAsFixed(0))),
              Expanded(
                flex: 2,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text((price * qty).toStringAsFixed(2)),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _productsTable() {
    final rows = _filteredProducts;
    return Container(
      decoration: BoxDecoration(border: Border.all(color: Colors.black26)),
      child: Column(
        children: [
          Container(
            color: Colors.grey.shade300,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: const Row(
              children: [
                Expanded(flex: 4, child: Text('Item')),
                Expanded(flex: 3, child: Text('Qty')),
                Expanded(flex: 3, child: Text('S.P @')),
                Expanded(flex: 2, child: Text('Total')),
              ],
            ),
          ),
          ...rows.map((product) {
            final qty = _selectedProducts[product.name] ?? 0;
            return InkWell(
              onTap: () => _addProduct(product.name),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  border: Border(top: BorderSide(color: Colors.black12)),
                ),
                child: Row(
                  children: [
                    Expanded(
                      flex: 4,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(product.name),
                          Text(
                            'SP ${product.price.toStringAsFixed(0)}',
                            style: const TextStyle(color: Colors.blue),
                          ),
                          const Text(
                            'Service',
                            style: TextStyle(color: Colors.blue),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Row(
                        children: [
                          _qtyButton('-', () => _reduceProduct(product.name)),
                          SizedBox(
                            width: 44,
                            child: Center(child: Text('$qty')),
                          ),
                          _qtyButton('+', () => _addProduct(product.name)),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Container(
                        height: 28,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black54),
                        ),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: Text(product.price.toStringAsFixed(0)),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text((product.price * qty).toStringAsFixed(2)),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _qtyButton(String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 18,
        height: 22,
        decoration: BoxDecoration(
          color: Colors.lightBlue.shade100,
          border: Border.all(color: Colors.lightBlue),
        ),
        child: Center(
          child: Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
      ),
    );
  }

  Widget _bottomActionBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: DropdownButtonFormField<String>(
              initialValue: _paymentMode,
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _paymentMode = value;
                  });
                }
              },
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                isDense: true,
              ),
              items: const [
                DropdownMenuItem(value: 'Cash', child: Text('Cash')),
                DropdownMenuItem(value: 'Mobile', child: Text('Mobile')),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Column(
            children: [
              CupertinoSwitch(
                value: _printEnabled,
                onChanged: (value) => setState(() => _printEnabled = value),
                activeTrackColor: Colors.lightBlue,
              ),
              const Text(
                'Print',
                style: TextStyle(
                  color: Colors.black,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
          const SizedBox(width: 10),
          Expanded(
            flex: 2,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.lightBlue.shade700,
                foregroundColor: Colors.white,
                minimumSize: const Size(0, 40),
                padding: const EdgeInsets.symmetric(horizontal: 8),
              ),
              child: FittedBox(fit: BoxFit.scaleDown, child: Text(_saveLabel)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _readonlyField(String value, {bool isBlueText = false}) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.lightBlue),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            value,
            style: TextStyle(
              color: isBlueText ? Colors.blue : Colors.black,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}

class _ManageCustomersPage extends StatefulWidget {
  const _ManageCustomersPage();

  @override
  State<_ManageCustomersPage> createState() => _ManageCustomersPageState();
}

class _ManageCustomersPageState extends State<_ManageCustomersPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  bool _openingNewDialog = false;
  String _smsCategory = 'Cash';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(_onTabChanged);
  }

  @override
  void dispose() {
    _tabController.removeListener(_onTabChanged);
    _tabController.dispose();
    super.dispose();
  }

  // "New" launches a dialog and returns users to "All".
  void _onTabChanged() {
    if (_tabController.index == 1 &&
        !_tabController.indexIsChanging &&
        !_openingNewDialog) {
      _openingNewDialog = true;
      _showCreateCustomerDialog(context).then((_) {
        if (!mounted) {
          return;
        }
        _tabController.animateTo(0);
        _openingNewDialog = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        title: const Text(
          'Manage Customers',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          TabBar(
            controller: _tabController,
            indicatorColor: Colors.lightBlue,
            labelColor: Colors.lightBlue,
            tabs: const [
              Tab(icon: Icon(Icons.list), text: 'All'),
              Tab(icon: Icon(Icons.person_add_alt_1), text: 'New'),
              Tab(icon: Icon(Icons.chat_bubble_outline), text: 'Sms'),
              Tab(icon: Icon(Icons.credit_card), text: 'On-credit'),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _allCustomersTab(),
                const SizedBox.shrink(),
                _smsCustomersTab(),
                _onCreditCustomersTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _allCustomersTab() {
    return Column(
      children: const [
        SizedBox(height: 20),
        Text(
          'Manage Customers',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        Divider(),
      ],
    );
  }

  /// ============== SMS CUSTOMERS TAB ======================
  Widget _smsCustomersTab() {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          const SizedBox(height: 10),
          const Text(
            'SMS Customers',
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black12),
            ),
            child: Column(
              children: [
                DropdownButtonFormField<String>(
                  initialValue: _smsCategory,
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _smsCategory = value;
                      });
                    }
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    isDense: true,
                  ),
                  items: const [
                    DropdownMenuItem(value: 'Cash', child: Text('Cash')),
                    DropdownMenuItem(value: 'Credit', child: Text('Credit')),
                  ],
                ),
                const SizedBox(height: 10),
                TextField(
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: 'Write your Text',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.lightBlue.shade700,
              foregroundColor: Colors.white,
            ),
            child: const Text('Send SMS'),
          ),
          const Spacer(),
        ],
      ),
    );
  }

  Widget _onCreditCustomersTab() {
    return Column(
      children: [
        const SizedBox(height: 20),
        const Text(
          'Oncredit Customers',
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
        ),
        const Divider(),
        const Spacer(),
        Padding(
          padding: const EdgeInsets.only(right: 10, bottom: 10),
          child: Align(
            alignment: Alignment.bottomRight,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.lightBlue.shade700,
                foregroundColor: Colors.white,
              ),
              child: const Text('Save'),
            ),
          ),
        ),
      ],
    );
  }
}
