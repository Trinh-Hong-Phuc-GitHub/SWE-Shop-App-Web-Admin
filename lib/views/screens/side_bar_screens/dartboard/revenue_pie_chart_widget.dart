import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pie_chart/pie_chart.dart';

class RevenuePieChartWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('orders')
          .where('accepted', isEqualTo: true)
          .where('orderStatus', isEqualTo: 'Giao Thành Công')
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> orderSnapshot) {
        if (orderSnapshot.hasError) {
          return Center(child: Text('Something went wrong'));
        }

        if (orderSnapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        return StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('vendors').snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> vendorSnapshot) {
            if (vendorSnapshot.hasError) {
              return Center(child: Text('Something went wrong'));
            }

            if (vendorSnapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            Map<String, String> vendorIdToNameMap = {};
            vendorSnapshot.data!.docs.forEach((doc) {
              vendorIdToNameMap[doc.id] = doc['businessName'];
            });

            Map<String, double> vendorRevenueMap = {};

            orderSnapshot.data!.docs.forEach((doc) {
              String vendorId = doc['vendorId'];
              double price = (doc['totalPrice'] ?? 0).toDouble();
              String vendorName = vendorIdToNameMap[vendorId] ?? 'Unknown Vendor';

              if (vendorRevenueMap.containsKey(vendorName)) {
                vendorRevenueMap[vendorName] = vendorRevenueMap[vendorName]! + price;
              } else {
                vendorRevenueMap[vendorName] = price;
              }
            });

            List<Color> colorList = [
              Colors.blue,
              Colors.green,
              Colors.orange,
              Colors.red,
              Colors.purple,
              Colors.teal,
              Colors.yellow,
              Colors.cyan,
            ];

            return Container(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Phân Phối Doanh Thu',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.pink.shade900,),
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: PieChart(
                          dataMap: vendorRevenueMap,
                          colorList: colorList,
                          chartRadius: MediaQuery.of(context).size.width / 3.2,
                          chartType: ChartType.ring,
                          legendOptions: LegendOptions(
                            showLegendsInRow: false,
                            legendPosition: LegendPosition.right,
                            showLegends: true,
                            legendShape: BoxShape.circle,
                            legendTextStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          chartValuesOptions: ChartValuesOptions(
                            showChartValueBackground: true,
                            showChartValues: true,
                            showChartValuesInPercentage: true,
                            showChartValuesOutside: false,
                          ),
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        flex: 1,
                        child: ListView(
                          shrinkWrap: true,
                          children: vendorRevenueMap.entries.map((entry) {
                            return Card(
                              elevation: 2,
                              margin: EdgeInsets.symmetric(vertical: 4),
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: Colors.pink,
                                  child: Text(
                                    entry.key[0],
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                                title: Text(entry.key),
                                trailing: Text(
                                  '${entry.value.toStringAsFixed(0)}' + ' đ',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.pink.shade900,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
