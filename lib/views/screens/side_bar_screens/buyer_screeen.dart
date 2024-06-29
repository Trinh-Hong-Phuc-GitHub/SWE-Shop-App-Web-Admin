import 'package:flutter/material.dart';
import 'package:uber_shop_app_web_admin/views/screens/side_bar_screens/widgets/buyer_list_widget.dart';

class BuyersScreen extends StatefulWidget {
  static const String id = '\buyersScreen';

  @override
  State<BuyersScreen> createState() => _BuyersScreenState();
}

class _BuyersScreenState extends State<BuyersScreen> {
  Widget _rowHeader(int flex, String text) {
    return Expanded(
        flex: flex,
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade700),
            color: Colors.yellow.shade900,
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              text,
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                alignment: Alignment.topLeft,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Manage Buyers',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 36,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Row(
                children: [
                  _rowHeader(1, 'PROFILE IMAGE'),
                  _rowHeader(3, 'FULL NAME'),
                  _rowHeader(2, 'EMAIL'),
                  // _rowHeader(2, 'ADDRESS'),
                  _rowHeader(1, 'ACTION'),
                  _rowHeader(1, 'VIEW MORE'),
                ],
              ),
              BuyersListWidget(),
            ],
          ),
        ),
      ),
    );
  }
}