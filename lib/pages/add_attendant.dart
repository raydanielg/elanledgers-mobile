// pages/add_attendant.dart
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:duka_app/l10n/locale_utils.dart';

class AddAttendantPage extends StatefulWidget {
  const AddAttendantPage({super.key});

  @override
  State<AddAttendantPage> createState() => _AddAttendantPageState();
}

class _AddAttendantPageState extends State<AddAttendantPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  final List<_Waiter> _waiters = [_Waiter(name: 'JUMA JUMA', active: true)];

  final List<_Member> _members = [
    _Member(name: 'JUST LEO', phone: '+255718421103', active: true),
  ];
  String _t(String en, String sw) => tr(context, en, sw);

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _showWaiterDialog({
    required bool isEdit,
    String initialName = '',
  }) async {
    final controller = TextEditingController(text: initialName);

    await showDialog<void>(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 460),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      isEdit
                          ? _t('Update Waiter', 'Sasisha Mhudumu')
                          : _t(
                              'Add | Register Waiter',
                              'Ongeza | Sajili Mhudumu',
                            ),
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                const Divider(height: 1),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          _t('Waiter Name', 'Jina la Mhudumu'),
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                      ),
                      const SizedBox(height: 4),
                      _inputField(controller: controller, hint: 'Waiter name'),
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
                          backgroundColor: Colors.blueGrey,
                          foregroundColor: Colors.white,
                        ),
                        child: Text(_t('Close', 'Funga')),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                        ),
                        child: Text(
                          isEdit
                              ? _t('Update', 'Sasisha')
                              : _t('Create', 'Unda'),
                        ),
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
  }

  Future<void> _showDeleteConfirm() async {
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
                  size: 90,
                ),
                const SizedBox(height: 12),
                Text(
                  _t('Are you sure?', 'Una uhakika?'),
                  style: TextStyle(fontSize: 44, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Do you really want to delete this Record(s)? This record\ncannot restored Once deleted.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 22, color: Colors.black54),
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
                      child: Text(_t('Yes, proceed', 'Ndiyo, endelea')),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                      ),
                      child: Text(_t('No, cancel', 'Hapana, ghairi')),
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

  Widget _waitersTab() {
    return Column(
      children: [
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _t('Waiters', 'Wahudumu'),
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700),
            ),
            const SizedBox(width: 8),
            OutlinedButton(
              onPressed: () => _showWaiterDialog(isEdit: false),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.lightBlue),
                foregroundColor: Colors.lightBlue,
              ),
              child: Text(_t('Add Waiter', 'Ongeza Mhudumu')),
            ),
          ],
        ),
        const SizedBox(height: 10),
        const Divider(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
          child: const Row(
            children: [
              Expanded(
                child: Text(
                  'Name',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
              Expanded(
                child: Text(
                  'Status',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
              Expanded(
                child: Text(
                  'Permission',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
        ),
        const Divider(height: 1),
        ..._waiters.map((waiter) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      const CircleAvatar(
                        radius: 12,
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.person_outline,
                          color: Colors.blue,
                          size: 14,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(waiter.name),
                    ],
                  ),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: CupertinoSwitch(
                      value: waiter.active,
                      onChanged: (value) {
                        setState(() {
                          waiter.active = value;
                        });
                      },
                      activeTrackColor: Colors.lightBlue,
                    ),
                  ),
                ),
                Expanded(
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () => _showWaiterDialog(
                          isEdit: true,
                          initialName: waiter.name,
                        ),
                        child: const Text(
                          'Edit',
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      InkWell(
                        onTap: _showDeleteConfirm,
                        child: Text(
                          _t('Delete', 'Futa'),
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
          );
        }),
      ],
    );
  }

  Widget _membersTab() {
    return Column(
      children: [
        const SizedBox(height: 16),
        const Text(
          'TRAVELLER CREATIVE DESIGN Attendants',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 10),
        const Divider(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
          child: const Row(
            children: [
              Expanded(
                child: Text(
                  'Name',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
              Expanded(
                child: Text(
                  'Phone',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
              Expanded(
                child: Text(
                  'Status',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
              Expanded(
                child: Text(
                  'Permission',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
        ),
        const Divider(height: 1),
        ..._members.map((member) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      const CircleAvatar(
                        radius: 12,
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.person_outline,
                          color: Colors.blue,
                          size: 14,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(member.name),
                    ],
                  ),
                ),
                Expanded(child: Text(member.phone)),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: CupertinoSwitch(
                      value: member.active,
                      onChanged: (value) {
                        setState(() {
                          member.active = value;
                        });
                      },
                      activeTrackColor: Colors.lightBlue,
                    ),
                  ),
                ),
                Expanded(
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute<void>(
                              builder: (_) => _MemberPermissionsPage(
                                title: 'Update ${member.name}',
                                initialName: member.name,
                                initialPhone: member.phone,
                                actionLabel: 'Update',
                              ),
                            ),
                          );
                        },
                        child: const Text(
                          'Edit',
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      InkWell(
                        onTap: _showDeleteConfirm,
                        child: Text(
                          _t('Delete', 'Futa'),
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
          );
        }),
      ],
    );
  }

  Widget _addNewTab() {
    return _MemberPermissionsPage(
      title: _t('Create Member', 'Unda Mwanachama'),
      initialName: '',
      initialPhone: '',
      actionLabel: _t('Create', 'Unda'),
      embedMode: true,
    );
  }

  Widget _inputField({
    required TextEditingController controller,
    required String hint,
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
          controller: controller,
          textAlign: TextAlign.start,
          textAlignVertical: TextAlignVertical.center,
          decoration: InputDecoration(
            hintText: hint,
            border: InputBorder.none,
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(vertical: 12),
          ),
        ),
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
          _t('Attendants', 'Wahudumu'),
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
                icon: const Icon(Icons.list),
                text: _t('Waiters', 'Wahudumu'),
              ),
              Tab(
                icon: const Icon(Icons.list_alt),
                text: _t('Members', 'Wanachama'),
              ),
              Tab(
                icon: const Icon(Icons.add_circle_outline),
                text: _t('Add New', 'Ongeza Mpya'),
              ),
            ],
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: TabBarView(
                controller: _tabController,
                children: [_waitersTab(), _membersTab(), _addNewTab()],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MemberPermissionsPage extends StatefulWidget {
  const _MemberPermissionsPage({
    required this.title,
    required this.initialName,
    required this.initialPhone,
    required this.actionLabel,
    this.embedMode = false,
  });

  final String title;
  final String initialName;
  final String initialPhone;
  final String? actionLabel;
  final bool embedMode;

  @override
  State<_MemberPermissionsPage> createState() => _MemberPermissionsPageState();
}

class _MemberPermissionsPageState extends State<_MemberPermissionsPage> {
  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;

  final Map<String, bool> _permissions = {
    'Make This User Manager': false,
    'Can make Sales': true,
    'Can Create Invoice': false,
    'Can manage orders': false,
    'Can view sales reports': false,
    'Can view and manage customers': false,
    'Can Print Receipt': false,
    'Can enable sales commission': false,
    'Can add new products': false,
    'Can view stock balance list': false,
    'Can count and update stock': false,
    'Can add stock-ins': false,
    'Can manage suppliers': false,
    'Can record bad stock': false,
    'Can view profit estimate': false,
    'Can view stock value': false,
    'Can view loss': false,
    'Can View Profit': false,
    'Can add expenses': false,
    'Can view cash-in records': false,
    'Can view cash-out records': false,
    'Can view Accounts & cash flow report': false,
    'Can view profit and loss report': false,
    'Can send SMS': false,
    'Can set SMS sender ID': false,
    'Can add contact': false,
    'Can send Email': false,
    'Can manage customers': false,
    'Can add contact category': false,
    'Can View Dashboard Summary': false,
    'Can View Reports': false,
    'Can give discounts': false,
    'Can edit daily entries': false,
    'Can delete daily entries': false,
    'Can backdate entries': false,
    'Can return stock': false,
    'Can generate barcodes': false,
    'Can preview receipts before printing': false,
    'Can manage warehouse': false,
    'Preferred Notification Method': false,
    'Default Message Template': false,
    'Enable Category Mode': false,
    'Enable Customer Mode': false,
    'Enable Team Mode': false,
    'Enable Non-staff Mode': false,
    'List order items': false,
    'Make user Teller': false,
  };

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialName);
    _phoneController = TextEditingController(text: widget.initialPhone);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Widget _section(String title, List<String> items, {String? helper}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 14),
        Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
        if (helper != null)
          Text(
            helper,
            style: const TextStyle(
              color: Colors.blue,
              fontStyle: FontStyle.italic,
            ),
          ),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black12),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Column(
            children: items.map((item) => _permissionRow(item)).toList(),
          ),
        ),
      ],
    );
  }

  Widget _permissionRow(String key) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.black12)),
      ),
      child: Row(
        children: [
          Expanded(child: Text(key)),
          CupertinoSwitch(
            value: _permissions[key] ?? false,
            onChanged: (value) => setState(() => _permissions[key] = value),
            activeTrackColor: Colors.lightBlue,
          ),
        ],
      ),
    );
  }

  Widget _headerFields() {
    return Row(
      children: [
        Expanded(
          child: _EditableField(
            label: 'Name',
            controller: _nameController,
            hint: 'JUST LEO',
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _EditableField(
            label: 'Phone',
            controller: _phoneController,
            hint: '+255718421103',
          ),
        ),
      ],
    );
  }

  Widget _body() {
    return ListView(
      padding: const EdgeInsets.all(10),
      children: [
        Center(
          child: Text(
            widget.title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
          ),
        ),
        const Divider(),
        _headerFields(),
        _section(
          'Management',
          const ['Make This User Manager'],
          helper: '[if you enable this all features will be enabled]',
        ),
        _section('Sales & Receipt', const [
          'Can make Sales',
          'Can Create Invoice',
          'Can manage orders',
          'Can view sales reports',
          'Can view and manage customers',
          'Can Print Receipt',
          'Can enable sales commission',
        ]),
        _section('Stock setup', const [
          'Can add new products',
          'Can view stock balance list',
          'Can count and update stock',
          'Can add stock-ins',
          'Can manage suppliers',
          'Can record bad stock',
        ]),
        _section('Stock reports', const [
          'Can view profit estimate',
          'Can view stock value',
          'Can view loss',
        ]),
        _section('Profit Expense & Cashflow', const [
          'Can View Profit',
          'Can add expenses',
          'Can view cash-in records',
          'Can view cash-out records',
          'Can view Accounts & cash flow report',
          'Can view profit and loss report',
        ]),
        _section('SMS', const [
          'Can send SMS',
          'Can set SMS sender ID',
          'Can add contact',
        ]),
        _section('Email', const ['Can send Email']),
        _section('Campaign', const [
          'Can manage customers',
          'Can add contact category',
        ]),
        _section('other', const [
          'Can View Dashboard Summary',
          'Can View Reports',
          'Can give discounts',
          'Can edit daily entries',
          'Can delete daily entries',
          'Can backdate entries',
          'Can return stock',
          'Can generate barcodes',
          'Can preview receipts before printing',
          'Can manage warehouse',
        ]),
        _section('notifications', const [
          'Preferred Notification Method',
          'Default Message Template',
        ]),
        _section('Display', const [
          'Enable Category Mode',
          'Enable Customer Mode',
          'Enable Team Mode',
          'Enable Non-staff Mode',
          'List order items',
        ]),
        _section('Tresury & Banking', const ['Make user Teller']),
        if (widget.actionLabel != null) ...[
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
              child: Text(widget.actionLabel!),
            ),
          ),
        ],
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.embedMode) {
      return _body();
    }

    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          tr(context, 'Attendants', 'Wahudumu'),
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      body: SafeArea(child: _body()),
    );
  }
}

class _EditableField extends StatelessWidget {
  const _EditableField({
    required this.label,
    required this.controller,
    required this.hint,
  });

  final String label;
  final TextEditingController controller;
  final String hint;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w700)),
        const SizedBox(height: 4),
        Container(
          height: 44,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.lightBlue),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: TextField(
              controller: controller,
              textAlignVertical: TextAlignVertical.center,
              decoration: InputDecoration(
                hintText: hint,
                border: InputBorder.none,
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _Waiter {
  _Waiter({required this.name, required this.active});

  final String name;
  bool active;
}

class _Member {
  _Member({required this.name, required this.phone, required this.active});

  final String name;
  final String phone;
  bool active;
}
