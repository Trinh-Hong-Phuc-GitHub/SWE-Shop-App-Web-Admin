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
    List<String> productImages = List<String>.from(widget.orderData['productImage']);

    return Scaffold(
      appBar: AppBar(
        title: Text('Order Detail'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
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
                    items: productImages.map((imageUrl) {
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
                  Text(
                    'Image ${_currentImageIndex + 1} of ${productImages.length}',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
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
                        'Order Detail',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.pink),
                      ),
                      _buildDetailItem('Order Id', widget.orderData['orderId']),
                      _buildDetailItem('Order Date', widget.orderData['orderDate'].toDate().toString()),
                      Text(
                        'Product Information',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.pink),
                      ),
                      _buildDetailItem('Product Name', widget.orderData['productName']),
                      _buildDetailItem('Quantity', widget.orderData['quantity'].toString()),
                      _buildDetailItem('Price', '\$${widget.orderData['price'].toString()}'),
                      _buildDetailItem('Size', widget.orderData['productSize']),
                      SizedBox(height: 10),
                      Text(
                        'Buyer Information',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.pink),
                      ),
                      SizedBox(height: 4),
                      _buildDetailItem('Full Name', widget.orderData['fullName']),
                      _buildDetailItem('Email', widget.orderData['email']),
                      _buildDetailItem('Phone Number', widget.orderData['phoneNumber']),
                      _buildDetailItem('Address', widget.orderData['address']),
                      SizedBox(height: 10),
                      Text(
                        'Order Status',
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
        'Accepted',
        style: TextStyle(
          fontSize: 18,
          color: Colors.blue,
          fontWeight: FontWeight.bold,
        ),
      );
    } else {
      return Text(
        'Rejected',
        style: TextStyle(
          fontSize: 18,
          color: Colors.red,
          fontWeight: FontWeight.bold,
        ),
      );
    }
  }
}
