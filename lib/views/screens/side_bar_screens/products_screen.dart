import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uber_shop_app_web_admin/views/screens/side_bar_screens/widgets/product_list_widget.dart';

class ProductsScreen extends StatefulWidget {
  static const String routeName = '\ProductsScreen';

  @override
  _ProductsScreenState createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  String searchQuery = '';
  String selectedCategory = '';

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

  Widget _buildCategoryDropdown() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('categories').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return CircularProgressIndicator();
        }

        List<DropdownMenuItem<String>> categoryItems =
            snapshot.data!.docs.map((doc) {
          return DropdownMenuItem<String>(
            value: doc['categoryName'],
            child: Text(doc['categoryName']),
          );
        }).toList();

        categoryItems.insert(
          0,
          DropdownMenuItem(
            value: '',
            child: Text('Danh Mục'),
          ),
        );

        return DropdownButton<String>(
          value: selectedCategory,
          items: categoryItems,
          onChanged: (String? newValue) {
            setState(() {
              selectedCategory = newValue!;
            });
          },
          hint: Text('Phân Loại'),
        );
      },
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
                  'Sản Phẩm',
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
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 16),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.search),
                        onPressed: () {
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
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(
                  left: 30,
                ),
                child: _buildCategoryDropdown(),
              ),
            ],
          ),
          Row(
            children: [
              _rowHeader('ẢNH', 1),
              _rowHeader('TÊN SẢN PHẨM', 2),
              _rowHeader('ĐƠN GIÁ', 1),
              _rowHeader('DANH MỤC', 1),
              _rowHeader('TRẠNG THÁI', 1),
              _rowHeader('XÓA', 1),
              _rowHeader('XEM THÊM', 1),
            ],
          ),
          ProductListWidget(
              searchQuery: searchQuery, selectedCategory: selectedCategory),
        ],
      ),
    );
  }
}
