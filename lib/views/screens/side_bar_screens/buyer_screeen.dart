import 'package:flutter/material.dart';
import 'package:uber_shop_app_web_admin/views/screens/side_bar_screens/widgets/buyer_list_widget.dart';

class BuyersScreen extends StatefulWidget {
  static const String id = '\buyersScreen';

  @override
  State<BuyersScreen> createState() => _BuyersScreenState();
}

class _BuyersScreenState extends State<BuyersScreen> {
  String searchQuery = '';

  Widget _rowHeader(int flex, String text) {
    return Expanded(
        flex: flex,
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade700),
            color: Colors.pink.shade900,
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              alignment: Alignment.topLeft,
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Manage Buyers',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 36,
                    ),
                  ),
                  Container(
                    width: 300,
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            onChanged: (value) {
                              setState(() {
                                searchQuery = value;
                              });
                            },
                            decoration: InputDecoration(
                              hintText: 'Search Buyers',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide.none,
                              ),
                              filled: true,
                              fillColor: Colors.grey.shade200,
                              contentPadding: EdgeInsets.symmetric(horizontal: 16),
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.search),
                          onPressed: () {
                            // Trigger search if needed
                            setState(() {});
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                _rowHeader(1, 'PROFILE IMAGE'),
                _rowHeader(1, 'FULL NAME'),
                _rowHeader(2, 'EMAIL'),
                _rowHeader(3, 'ADDRESS'),
                _rowHeader(1, 'PHONE'),
                _rowHeader(1, 'VIEW MORE'),
              ],
            ),
            BuyersListWidget(searchQuery: searchQuery),
          ],
        ),
      ),
    );
  }
}
