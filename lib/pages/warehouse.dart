// pages/warehouse.dart
import 'package:flutter/material.dart';
import 'package:duka_app/l10n/locale_utils.dart';

class WarehousePage extends StatefulWidget {
  const WarehousePage({super.key});

  @override
  State<WarehousePage> createState() => _WarehousePageState();
}

class _WarehousePageState extends State<WarehousePage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

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

  Widget _storesTab() {
    return Padding(
      padding: EdgeInsets.all(8),
      child: Align(
        alignment: Alignment.topLeft,
        child: Text(
          tr(context, 'Customers Stock', 'Hisa za Wateja'),
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  Widget _warehouseTab() {
    return Padding(
      padding: EdgeInsets.all(8),
      child: Align(
        alignment: Alignment.topLeft,
        child: Text(
          tr(context, 'Stores', 'Maduka'),
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.w700,
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
          tr(context, 'Warehouse', 'Ghala'),
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700),
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
                icon: Icon(Icons.storefront_outlined),
                text: tr(context, 'Stores & Products', 'Maduka na Bidhaa'),
              ),
              Tab(
                icon: Icon(Icons.warehouse_outlined),
                text: tr(context, 'Create Stores', 'Unda Maduka'),
              ),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [_storesTab(), _warehouseTab()],
            ),
          ),
        ],
      ),
    );
  }
}
