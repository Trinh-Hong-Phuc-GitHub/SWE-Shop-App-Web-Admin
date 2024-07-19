import 'package:flutter/material.dart';
import 'package:uber_shop_app_web_admin/views/screens/side_bar_screens/widgets/withdrawal_list_widget.dart';

class WithdrawalScreen extends StatelessWidget {
  static const String routeName = '\WithdrawalScreen';

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

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            alignment: Alignment.topLeft,
            padding: const EdgeInsets.all(10),
            child: const Text(
              'Withdrawal',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 36,
              ),
            ),
          ),
          Row(
            children: [
              _rowHeader('BUSINESS NAME', 2),
              _rowHeader('ACCOUNT NAME', 2),
              _rowHeader('BANK NAME', 2),
              _rowHeader('ACCOUNT NUMBER', 2),
              _rowHeader('AMOUNT', 1),
            ],
          ),
          WithdrawalListWidget(),
        ],
      ),
    );
  }
}
