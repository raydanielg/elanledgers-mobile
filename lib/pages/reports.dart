// pages/reports.dart
import 'package:flutter/material.dart';
import 'package:duka_app/l10n/locale_utils.dart';

class ReportsPage extends StatefulWidget {
  const ReportsPage({super.key});

  @override
  State<ReportsPage> createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage> {
  String _selectedFilter = 'Today';
  bool _showCustomRange = false;

  final List<_ReportCategory> _categories = const [
    _ReportCategory(
      title: 'Stock Reports',
      count: 3,
      items: ['Total Stock', 'Low Stock', 'Purchase History'],
    ),
    _ReportCategory(
      title: 'Sales Reports',
      count: 8,
      items: [
        'Total Sales',
        'Cash Sales',
        'Credit Sales',
        'Sales by Category',
        'Sales by Product',
        'Unpaid Sales by Product',
        'Sales by Customer',
        'Sales by Staff',
      ],
    ),
    _ReportCategory(
      title: 'Customer Reports',
      count: 2,
      items: ['All Customers', 'On-Credit Customers'],
    ),
    _ReportCategory(
      title: 'Expenses Reports',
      count: 3,
      items: ['All Expenses', 'Paid Expenses', 'Unpaid Expenses'],
    ),
    _ReportCategory(
      title: 'Profit & Loss Reports',
      count: 3,
      items: ['Profit', 'Profit Estimate', 'Loss'],
    ),
    _ReportCategory(
      title: 'Cash Flow Reports',
      count: 3,
      items: ['Cash', 'Cash Out', 'Cash In'],
    ),
  ];

  String _t(String text) {
    switch (text) {
      case 'Reports':
        return tr(context, text, 'Ripoti');
      case 'Filter':
        return tr(context, text, 'Chuja');
      case 'Search........':
        return tr(context, text, 'Tafuta........');
      case 'Select filter to proceed':
        return tr(context, text, 'Chagua chujio kuendelea');
      case 'Select Custom Range':
        return tr(context, text, 'Chagua Muda Maalum');
      case 'Custom':
        return tr(context, text, 'Maalum');
      case 'Today':
        return tr(context, text, 'Leo');
      case 'Yesterday':
        return tr(context, text, 'Jana');
      case 'This Week':
        return tr(context, text, 'Wiki hii');
      case 'Last Week':
        return tr(context, text, 'Wiki iliyopita');
      case 'This Month':
        return tr(context, text, 'Mwezi huu');
      case 'Last Month':
        return tr(context, text, 'Mwezi uliopita');
      case 'Last 3 Months':
        return tr(context, text, 'Miezi 3 iliyopita');
      case 'This Year':
        return tr(context, text, 'Mwaka huu');
      case 'Stock Reports':
        return tr(context, text, 'Ripoti za Hisa');
      case 'Sales Reports':
        return tr(context, text, 'Ripoti za Mauzo');
      case 'Customer Reports':
        return tr(context, text, 'Ripoti za Wateja');
      case 'Expenses Reports':
        return tr(context, text, 'Ripoti za Gharama');
      case 'Profit & Loss Reports':
        return tr(context, text, 'Ripoti ya Faida na Hasara');
      case 'Cash Flow Reports':
        return tr(context, text, 'Ripoti ya Mtiririko wa Fedha');
      case 'Total Stock':
        return tr(context, text, 'Jumla ya Hisa');
      case 'Low Stock':
        return tr(context, text, 'Hisa Chini');
      case 'Purchase History':
        return tr(context, text, 'Historia ya Ununuzi');
      case 'Total Sales':
        return tr(context, text, 'Mauzo Yote');
      case 'Cash Sales':
        return tr(context, text, 'Mauzo ya Cash');
      case 'Credit Sales':
        return tr(context, text, 'Mauzo ya Mkopo');
      case 'Sales by Category':
        return tr(context, text, 'Mauzo kwa Kategoria');
      case 'Sales by Product':
        return tr(context, text, 'Mauzo kwa Bidhaa');
      case 'Unpaid Sales by Product':
        return tr(context, text, 'Mauzo Yasiyolipwa kwa Bidhaa');
      case 'Sales by Customer':
        return tr(context, text, 'Mauzo kwa Mteja');
      case 'Sales by Staff':
        return tr(context, text, 'Mauzo kwa Mfanyakazi');
      case 'All Customers':
        return tr(context, text, 'Wateja Wote');
      case 'On-Credit Customers':
        return tr(context, text, 'Wateja wa Mkopo');
      case 'All Expenses':
        return tr(context, text, 'Gharama Zote');
      case 'Paid Expenses':
        return tr(context, text, 'Gharama Zilizolipwa');
      case 'Unpaid Expenses':
        return tr(context, text, 'Gharama Zisizolipwa');
      case 'Profit':
        return tr(context, text, 'Faida');
      case 'Profit Estimate':
        return tr(context, text, 'Makadirio ya Faida');
      case 'Loss':
        return tr(context, text, 'Hasara');
      case 'Cash':
        return tr(context, text, 'Fedha Taslimu');
      case 'Cash Out':
        return tr(context, text, 'Fedha Zilizotoka');
      case 'Cash In':
        return tr(context, text, 'Fedha Zilizopokelewa');
      default:
        return text;
    }
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
                            _t('Select filter to proceed'),
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
                          label: _t('Custom'),
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
                            _t('Select Custom Range'),
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
          label: _t(labels.first),
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
              label: _t(labels[0]),
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
              label: _t(labels[1]),
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

  Widget _reportCard(_ReportCategory category) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        border: Border.all(color: Colors.black12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            color: Colors.grey.shade200,
            child: Row(
              children: [
                const Icon(
                  Icons.assessment_outlined,
                  color: Colors.blue,
                  size: 16,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    _t(category.title),
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.lightBlue,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${category.count}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          ...category.items.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '› ',
                    style: TextStyle(color: Colors.grey, fontSize: 18),
                  ),
                  Expanded(
                    child: Text(_t(item), style: const TextStyle(fontSize: 15)),
                  ),
                ],
              ),
            ),
          ),
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
          _t('Reports'),
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        actions: [
          TextButton.icon(
            onPressed: _showFilterDialog,
            icon: const Icon(
              Icons.filter_alt_outlined,
              color: Colors.lightBlue,
            ),
            label: Text(
              _t('Filter'),
              style: TextStyle(
                color: Colors.lightBlue,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: _t('Search........'),
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
              child: GridView.builder(
                itemCount: _categories.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 0.58,
                ),
                itemBuilder: (context, index) {
                  return _reportCard(_categories[index]);
                },
              ),
            ),
          ],
        ),
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

class _ReportCategory {
  const _ReportCategory({
    required this.title,
    required this.count,
    required this.items,
  });

  final String title;
  final int count;
  final List<String> items;
}
