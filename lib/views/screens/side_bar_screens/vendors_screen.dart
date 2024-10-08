import 'package:flutter/material.dart';
import 'package:uber_shop_app_web_admin/views/screens/side_bar_screens/widgets/vendor_list_widget.dart';

class VendorsScreen extends StatefulWidget {
  static const String routeName = '\VendorsScreen';

  @override
  _VendorsScreenState createState() => _VendorsScreenState();
}

class _VendorsScreenState extends State<VendorsScreen> {
  String searchQuery = '';

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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Cửa Hàng',
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
                            hintText: 'Tìm Kiếm',
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
              _rowHeader('LOGO', 1),
              _rowHeader('TÊN CỬA HÀNG', 2),
              _rowHeader('HOTLINE', 1),
              _rowHeader('KHU VỰC', 1),
              _rowHeader('HÀNH ĐỘNG', 1),
              _rowHeader('THÀNH PHỐ', 1),
              _rowHeader('XEM THÊM', 1),
            ],
          ),
          VendorsListWidget(searchQuery: searchQuery),
        ],
      ),
    );
  }
}
