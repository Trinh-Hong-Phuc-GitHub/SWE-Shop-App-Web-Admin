import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DashboardStatsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: _buildStatItem(
              icon: Icons.store,
              label: 'Tài khoản cửa hàng',
              stream: FirebaseFirestore.instance.collection('vendors').snapshots(),
              dataBuilder: (QuerySnapshot snapshot) =>
                  snapshot.docs.length.toString(),
              iconColor: Colors.pink,
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: _buildStatItem(
              icon: Icons.person,
              label: 'Tài khoản người mua',
              stream: FirebaseFirestore.instance.collection('buyers').snapshots(),
              dataBuilder: (QuerySnapshot snapshot) =>
                  snapshot.docs.length.toString(),
              iconColor: Colors.pink,
            ),
          ),
          // SizedBox(width: 16),
          // Expanded(
          //   child: _buildStatItem(
          //     icon: Icons.shopping_bag,
          //     label: 'Total Successful Orders',
          //     stream: FirebaseFirestore.instance.collection('orders').snapshots(),
          //     dataBuilder: (QuerySnapshot snapshot) {
          //       int successfulOrdersCount = 0;
          //       snapshot.docs.forEach((doc) {
          //         if (doc['accepted'] == true &&
          //             doc['orderStatus'] == "Delivered Successfully") {
          //           successfulOrdersCount++;
          //         }
          //       });
          //       return successfulOrdersCount.toString();
          //     },
          //     iconColor: Colors.pink,
          //   ),
          // ),
          // SizedBox(width: 16),
          // Expanded(
          //   child: _buildStatItem(
          //     icon: Icons.attach_money,
          //     label: 'Total Revenue',
          //     stream: FirebaseFirestore.instance.collection('orders').snapshots(),
          //     dataBuilder: (QuerySnapshot snapshot) {
          //       double totalRevenue = 0;
          //       snapshot.docs.forEach((doc) {
          //         if (doc['accepted'] == true &&
          //             doc['orderStatus'] == "Delivered Successfully") {
          //           totalRevenue += doc['price'] ?? 0;
          //         }
          //       });
          //       return '\$' + totalRevenue.toStringAsFixed(2);
          //     },
          //     iconColor: Colors.pink,
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required Stream<QuerySnapshot> stream,
    required String Function(QuerySnapshot) dataBuilder,
    required Color iconColor,
  }) {
    return StreamBuilder<QuerySnapshot>(
      stream: stream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return _buildStatBox(icon, label, 'Error');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildStatBox(icon, label, 'Loading...');
        }

        return _buildStatBox(icon, label, dataBuilder(snapshot.data!));
      },
    );
  }

  Widget _buildStatBox(IconData icon, String label, String data) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.pink.shade900, width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 50, color: Colors.pink),
          SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 4),
          Text(data),
        ],
      ),
    );
  }
}
