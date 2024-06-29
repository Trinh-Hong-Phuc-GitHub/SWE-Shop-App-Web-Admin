import 'package:flutter/material.dart';
import '../../../models/vendor_user_models.dart';

class VendorDetailScreen extends StatelessWidget {
  final VendorUserModel vendor;

  VendorDetailScreen({required this.vendor});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(vendor.businessName ?? 'Vendor Detail'),
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
                  vendor.storeImage ?? '',
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
                      _buildDetailItem('Business Name', vendor.businessName ?? 'Not available'),
                      _buildDetailItem('City', vendor.cityValue ?? 'Not available'),
                      _buildDetailItem('State', vendor.stateValue ?? 'Not available'),
                      _buildDetailItem('Country', vendor.countryValue ?? 'Not available'),
                      _buildDetailItem('Email', vendor.emailAddress ?? 'Not available'),
                      _buildDetailItem('Phone', vendor.phoneNumber ?? 'Not available'),
                      _buildDetailItem('Vendor ID', vendor.vendorId ?? 'Not available'),
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
              color: Colors.blue,
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
