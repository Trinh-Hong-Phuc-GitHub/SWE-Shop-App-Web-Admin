import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uber_shop_app_web_admin/views/screens/side_bar_screens/widgets/order_list_widget.dart';

class OrdersScreen extends StatefulWidget {
  static const String routeName = '/orders-screen';

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  String _sortBy = 'default';

  Widget _rowHeader(String text, int flex) {
    return Expanded(
      flex: flex,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey.shade700,
          ),
          color: Colors.pink.shade900,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            text,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  void _sortOrders(String sortBy) {
    setState(() {
      _sortBy = sortBy;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  alignment: Alignment.topLeft,
                  padding: const EdgeInsets.all(10),
                  child: const Text(
                    'Orders',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 36,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 30,),
                  child: DropdownButton<String>(
                    value: _sortBy,
                    onChanged: (String? value) {
                      _sortOrders(value!);
                    },
                    items: <String>[
                      'default',
                      'latest_first',
                      'oldest_first',
                    ].map<DropdownMenuItem<String>>((String value) {
                      String text = 'Default';
                      if (value == 'latest_first') {
                        text = 'Latest First';
                      } else if (value == 'oldest_first') {
                        text = 'Oldest First';
                      }
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          text,
                          style: TextStyle(fontSize: 14),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                _rowHeader('ORDER DATE', 2),
                _rowHeader('PRODUCT IMAGE', 1),
                _rowHeader('PRODUCT NAME', 3),
                _rowHeader('QUANTITY', 1),
                _rowHeader('PRICE', 1),
                _rowHeader('VIEW MORE', 1),
              ],
            ),
            OrderListWidget(sortBy: _sortBy),
          ],
        ),
      ),
    );
  }
}
