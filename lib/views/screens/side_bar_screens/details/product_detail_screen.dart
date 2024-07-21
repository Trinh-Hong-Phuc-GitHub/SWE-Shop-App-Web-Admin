import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProductDetailScreen extends StatefulWidget {
  final DocumentSnapshot productData;

  ProductDetailScreen({required this.productData});

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _currentImageIndex = 0;

  @override
  Widget build(BuildContext context) {
    List<String> productImages = List<String>.from(widget.productData['productImage']);
    List<String> sizes = List<String>.from(widget.productData['sizeList']);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.productData['productName'] ?? 'Product Detail'),
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
                      _buildDetailItem('Product Name', widget.productData['productName'] ?? 'Not available'),
                      _buildDetailItem('Brand', widget.productData['brandName'] ?? 'Not available'),
                      _buildDetailItem('Business Name', widget.productData['businessName'] ?? 'Not available'),
                      _buildDetailItem('Category', widget.productData['category'] ?? 'Not available'),
                      _buildDetailItem('Price', '\$${widget.productData['productPrice'].toString()}' ?? 'Not available'),
                      _buildDetailItem('Quantity', widget.productData['productQuantity'].toString() ?? 'Not available'),
                      SizedBox(height: 10),
                      Text(
                        'Description',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.pink),
                      ),
                      SizedBox(height: 4),
                      Container(
                        constraints: BoxConstraints(maxWidth: 800),
                        child: Text(
                          widget.productData['description'] ?? 'Not available',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      SizedBox(height: 10),
                      _buildDetailItem('Phone Number', widget.productData['phoneNumber'] ?? 'Not available'),
                      _buildDetailItem('City', widget.productData['cityValue'] ?? 'Not available'),
                      _buildDetailItem('State', widget.productData['stateValue'] ?? 'Not available'),
                      _buildDetailItem('Country', widget.productData['countryValue'] ?? 'Not available'),
                      _buildDetailItem('Rating', widget.productData['rating'].toString() ?? 'Not available'),
                      _buildDetailItem('Total Reviews', widget.productData['totalReviews'].toString() ?? 'Not available'),
                      SizedBox(height: 10),
                      Text(
                        'Sizes Available',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.pink),
                      ),
                      Wrap(
                        spacing: 8.0,
                        children: sizes.map((size) => Chip(label: Text(size))).toList(),
                      ),
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
            value,
            style: TextStyle(
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }
}
