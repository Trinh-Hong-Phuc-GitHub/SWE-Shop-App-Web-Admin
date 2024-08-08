import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OrderDetailScreen extends StatefulWidget {
  final DocumentSnapshot orderData;

  OrderDetailScreen({required this.orderData});

  @override
  _OrderDetailScreenState createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  int _currentImageIndex = 0;

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> products = List<Map<String, dynamic>>.from(widget.orderData['products']);

    return Scaffold(
      appBar: AppBar(
        title: Text('Chi Tiết Đơn Hàng'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Chi Tiết Đơn Hàng',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.pink),
                      ),
                      _buildDetailItem('Id', widget.orderData['orderId']),
                      _buildDetailItem('Thời Gian Đặt', widget.orderData['orderDate'].toDate().toString()),
                      _buildDetailItem('Trạng Thái', widget.orderData['orderStatus']),
                      SizedBox(height: 10),
                      Text(
                        'Thông Tin Sản Phẩm',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.pink),
                      ),
                      SizedBox(height: 4),
                      ...products.map((product) => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CarouselSlider(
                            options: CarouselOptions(
                              height: 300.0,
                              onPageChanged: (index, reason) {
                                setState(() {
                                  _currentImageIndex = index;
                                });
                              },
                            ),
                            items: List<String>.from(product['productImage']).map((imageUrl) {
                              return Builder(
                                builder: (BuildContext context) {
                                  return AspectRatio(
                                    aspectRatio: 1.0,
                                    child: Image.network(
                                      imageUrl,
                                      fit: BoxFit.cover,
                                    ),
                                  );
                                },
                              );
                            }).toList(),
                          ),
                          SizedBox(height: 10),
                          Center(
                            child: Text(
                              'Ảnh ${_currentImageIndex + 1} / ${List<String>.from(product['productImage']).length}',
                              style: TextStyle(fontSize: 16, color: Colors.grey),
                            ),
                          ),
                          _buildDetailItem('Tên Sản Phẩm', product['productName']),
                          _buildDetailItem('Số Lượng', product['quantity'].toString()),
                          _buildDetailItem('Đơn Giá', '${product['price'].toString()} đ'),
                          _buildDetailItem('Size', product['productSize']),
                          SizedBox(height: 10),
                        ],
                      )),
                      Text(
                        'Thông Tin Khách Hàng',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.pink),
                      ),
                      SizedBox(height: 4),
                      _buildDetailItem('Họ tên', widget.orderData['fullName']),
                      _buildDetailItem('Email', widget.orderData['email']),
                      _buildDetailItem('Số điện thoại', widget.orderData['phoneNumber']),
                      _buildDetailItem('Địa chỉ', widget.orderData['address']),
                      SizedBox(height: 10),
                      Text(
                        'Trạng Thái',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.pink),
                      ),
                      SizedBox(height: 4),
                      _buildOrderStatus(widget.orderData['accepted']),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailItem(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.pink,
            ),
          ),
          SizedBox(height: 4),
          Text(
            value ?? 'Not available',
            style: TextStyle(
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderStatus(bool? accepted) {
    if (accepted == true) {
      return Text(
        'Đã Xác Nhận',
        style: TextStyle(
          fontSize: 18,
          color: Colors.blue,
          fontWeight: FontWeight.bold,
        ),
      );
    } else {
      return Text(
        'Chưa Xác Nhận',
        style: TextStyle(
          fontSize: 18,
          color: Colors.red,
          fontWeight: FontWeight.bold,
        ),
      );
    }
  }
}
