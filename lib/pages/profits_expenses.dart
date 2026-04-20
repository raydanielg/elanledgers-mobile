// pages/profits_expenses.dart
import 'package:flutter/material.dart';
import 'package:duka_app/l10n/locale_utils.dart';

class ProfitsExpensesPage extends StatefulWidget {
  const ProfitsExpensesPage({super.key});

  @override
  State<ProfitsExpensesPage> createState() => _ProfitsExpensesPageState();
}

class _ProfitsExpensesPageState extends State<ProfitsExpensesPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  String _selectedFilter = 'Today';
  bool _showCustomRange = false;
  bool _dialogInProgress = false;

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

  final List<_ExpenseSummary> _expenses = const [
    _ExpenseSummary(title: 'Purcheses', amount: '210,000.00'),
    _ExpenseSummary(title: 'Internet expese', amount: '10,000.00'),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_onTabChanged);
  }

  @override
  void dispose() {
    _tabController.removeListener(_onTabChanged);
    _tabController.dispose();
    super.dispose();
  }

  // Filter tab opens dialog directly.
  void _onTabChanged() {
    if (_tabController.indexIsChanging || _dialogInProgress) {
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

  Future<void> _showAddExpenseDialog() async {
    String selectedCategory = 'Purchase';
    String selectedAccount = 'Cash';

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
                constraints: const BoxConstraints(maxWidth: 520),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 12,
                      ),
                      child: Center(
                        child: Text(
                          _t('Create Expense', 'Unda Gharama'),
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 28,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    const Divider(height: 1),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: _FormField(
                                  label: _t('Categories', 'Kategoria'),
                                  child: DropdownButtonFormField<String>(
                                    initialValue: selectedCategory,
                                    isDense: true,
                                    decoration: _dropdownDecoration(),
                                    items: const [
                                      DropdownMenuItem(
                                        value: 'Purchase',
                                        child: Text('Purchase'),
                                      ),
                                      DropdownMenuItem(
                                        value: 'Internet',
                                        child: Text('Internet'),
                                      ),
                                      DropdownMenuItem(
                                        value: 'Transport',
                                        child: Text('Transport'),
                                      ),
                                    ],
                                    onChanged: (value) {
                                      if (value != null) {
                                        setDialogState(() {
                                          selectedCategory = value;
                                        });
                                      }
                                    },
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _FormField(
                                  label: _t('Title', 'Kichwa'),
                                  child: _outlinedInput(hint: 'Eg. Advance'),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Expanded(
                                child: _FormField(
                                  label: _t('Date', 'Tarehe'),
                                  child: _outlinedInput(
                                    hint: '02/20/2026',
                                    suffix: Icons.calendar_month,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _FormField(
                                  label: _t('Amount', 'Kiasi'),
                                  child: _outlinedInput(hint: ''),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          _FormField(
                            label: _t('Note', 'Maelezo'),
                            child: Container(
                              height: 72,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.lightBlue),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                child: TextField(
                                  maxLines: 3,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    isDense: true,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          _FormField(
                            label: _t('From Account', 'Kutoka Akaunti'),
                            child: DropdownButtonFormField<String>(
                              initialValue: selectedAccount,
                              isDense: true,
                              decoration: _dropdownDecoration(),
                              items: const [
                                DropdownMenuItem(
                                  value: 'Cash',
                                  child: Text('Cash'),
                                ),
                                DropdownMenuItem(
                                  value: 'Bank',
                                  child: Text('Bank'),
                                ),
                                DropdownMenuItem(
                                  value: 'Mobile Money',
                                  child: Text('Mobile Money'),
                                ),
                              ],
                              onChanged: (value) {
                                if (value != null) {
                                  setDialogState(() {
                                    selectedAccount = value;
                                  });
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Divider(height: 1),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                            onPressed: () => Navigator.pop(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blueGrey,
                              foregroundColor: Colors.white,
                            ),
                            child: Text(_t('Cancel', 'Ghairi')),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: () => Navigator.pop(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.lightBlue,
                              foregroundColor: Colors.white,
                            ),
                            child: Text(_t('Create', 'Unda')),
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

  InputDecoration _dropdownDecoration() {
    return InputDecoration(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.lightBlue),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.lightBlue),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
    );
  }

  Widget _outlinedInput({
    required String hint,
    IconData? suffix,
    bool centerText = false,
  }) {
    return Container(
      height: 44,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.lightBlue),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: TextField(
          maxLines: 1,
          textAlign: centerText ? TextAlign.center : TextAlign.start,
          textAlignVertical: TextAlignVertical.center,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(fontWeight: FontWeight.w700),
            border: InputBorder.none,
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(vertical: 10),
            suffixIcon: suffix == null ? null : Icon(suffix, size: 16),
          ),
        ),
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

  Widget _expensesTab() {
    return Column(
      children: [
        const SizedBox(height: 20),
        Container(
          width: 300,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: const Color(0xFFF0CDD3),
            border: Border.all(color: const Color(0xFFE59AA8)),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Center(
            child: Text(
              '↑ 220,000.00',
              style: TextStyle(
                color: Color(0xFF4A1520),
                fontSize: 24,
                fontWeight: FontWeight.w700,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        const Divider(),
        ElevatedButton(
          onPressed: _showAddExpenseDialog,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.lightBlue,
            foregroundColor: Colors.white,
            minimumSize: const Size(160, 40),
          ),
          child: Text(_t('Add Expense', 'Ongeza Gharama')),
        ),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black12),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Column(
            children: _expenses.map((item) {
              return InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => _ExpenseDetailPage(expense: item),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 14,
                  ),
                  decoration: const BoxDecoration(
                    border: Border(bottom: BorderSide(color: Colors.black12)),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          item.title,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      Text(
                        item.amount,
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const Text(
                        ' →',
                        style: TextStyle(color: Colors.red, fontSize: 20),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _profitTab() {
    return ListView(
      children: [
        const SizedBox(height: 20),
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            _t('Profit Growth', 'Ukuaji wa Faida'),
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
        ),
        const SizedBox(height: 8),
        const Divider(),
        Container(
          width: 420,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            color: const Color(0xFFC7DCD3),
            border: Border.all(color: const Color(0xFF97C4B3)),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Center(
            child: Text(
              '↑ null 0.00',
              style: TextStyle(
                color: Color(0xFF003B2C),
                fontSize: 20,
                fontWeight: FontWeight.w700,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        const Divider(),
        ElevatedButton(
          onPressed: _showFilterDialog,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue.shade700,
            foregroundColor: Colors.white,
            minimumSize: const Size(160, 40),
          ),
          child: Text(_t('Filter', 'Chuja')),
        ),
        const SizedBox(height: 10),
        _profitRow('Total sales', '120,000.00', Colors.green),
        _profitRow(_t('Gross Profit', 'Faida Ghafi'), '0.00', Colors.green),
        _profitRow('Bad stocks', '0.00', Colors.deepOrange),
        _profitRow('Lost stocks', '0.00', Colors.deepOrange),
        _profitRow('Expired stocks', '0.00', Colors.deepOrange),
        _profitRow('Total Loss', '0.00', Colors.red),
        _profitRow(_t('Expenses', 'Gharama'), '220,000.00', Colors.black87),
        _profitRow(
          _t('Net Profit', 'Faida Halisi'),
          '-220,000.00',
          Colors.green,
        ),
      ],
    );
  }

  Widget _profitRow(String title, String amount, Color amountColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.black12)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
          ),
          Text(
            amount,
            style: TextStyle(
              color: amountColor,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(' →', style: TextStyle(color: amountColor, fontSize: 16)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          _t('Profits & Expenses', 'Faida na Gharama'),
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
                icon: const Icon(Icons.arrow_upward),
                text: _t('Expenses', 'Gharama'),
              ),
              Tab(
                icon: const Icon(Icons.insights_outlined),
                text: _t('Profit', 'Faida'),
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
              child: TabBarView(
                controller: _tabController,
                children: [
                  _expensesTab(),
                  _profitTab(),
                  const SizedBox.shrink(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ExpenseDetailPage extends StatelessWidget {
  const _ExpenseDetailPage({required this.expense});

  final _ExpenseSummary expense;

  Future<void> _showDeleteConfirm(BuildContext context) async {
    await showDialog<void>(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.help_outline,
                  color: Color(0xFF86B2C8),
                  size: 50,
                ),
                const SizedBox(height: 12),
                const Text(
                  'Are you sure?',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Do you really want to delete this Record(s)? This record\ncannot restored Once deleted.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, color: Colors.black54),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                      ),
                      child: Text(tr(context, 'Yes, proceed', 'Ndiyo, endelea')),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                      ),
                      child: Text(tr(context, 'No, cancel', 'Hapana, ghairi')),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          tr(context, 'Profits & Expenses', 'Faida na Gharama'),
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            const SizedBox(height: 8),
            Text(
              tr(context, 'Purcheses Expenses', 'Gharama za Ununuzi'),
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(border: Border.all(color: Colors.blue)),
              child: Column(
                children: [
                  const _ExpenseDetailHeader(),
                  Row(
                    children: [
                      _detailCell('2026-02-20', 20),
                      _detailCell('Food', 12),
                      _detailCell('210,000.00', 20, color: Colors.green),
                      _detailCell('210,000.00', 20, color: Colors.green),
                      Expanded(
                        flex: 13,
                        child: InkWell(
                          onTap: () => _showDeleteConfirm(context),
                          child: Padding(
                            padding: EdgeInsets.all(10),
                            child: Text(
                              tr(context, 'Delete', 'Futa'),
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _detailCell(String value, int flex, {Color? color}) {
    return Expanded(
      flex: flex,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: const BoxDecoration(
          border: Border(right: BorderSide(color: Colors.blue)),
        ),
        child: Text(
          value,
          textAlign: TextAlign.right,
          style: TextStyle(
            color: color ?? Colors.black,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class _ExpenseDetailHeader extends StatelessWidget {
  const _ExpenseDetailHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.blue)),
      ),
      child: Row(
        children: [
          _HeaderCell(label: tr(context, 'Date', 'Tarehe'), flex: 20),
          _HeaderCell(label: tr(context, 'Title', 'Kichwa'), flex: 12),
          _HeaderCell(label: tr(context, 'Amount', 'Kiasi'), flex: 20),
          _HeaderCell(label: tr(context, 'Balance', 'Salio'), flex: 20),
          _HeaderCell(label: tr(context, 'Delete', 'Futa'), flex: 13),
        ],
      ),
    );
  }
}

class _HeaderCell extends StatelessWidget {
  const _HeaderCell({required this.label, required this.flex});

  final String label;
  final int flex;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: const BoxDecoration(
          border: Border(right: BorderSide(color: Colors.blue)),
        ),
        child: Text(
          label,
          textAlign: TextAlign.left,
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}

class _ExpenseSummary {
  const _ExpenseSummary({required this.title, required this.amount});

  final String title;
  final String amount;
}

class _FormField extends StatelessWidget {
  const _FormField({required this.label, required this.child});

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
