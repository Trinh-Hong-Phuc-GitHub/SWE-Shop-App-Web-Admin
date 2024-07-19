import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BuyerDetailScreen extends StatelessWidget {
  final DocumentSnapshot buyerData;

  BuyerDetailScreen({required this.buyerData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(buyerData['fullName'] ?? 'Buyer Detail'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.network(
                  buyerData['profileImage'] ?? '',
                  width: 150,
                  height: 150,
                  fit: BoxFit.cover,
                ),
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
                      _buildDetailItem('Full Name', buyerData['fullName'] ?? 'Not available'),
                      _buildDetailItem('Email', buyerData['email'] ?? 'Not available'),
                      _buildDetailItem('Address', buyerData['address'] ?? 'Not available'),
                      _buildDetailItem('Phone Number', buyerData['phoneNumber'] ?? 'Not available'),
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
