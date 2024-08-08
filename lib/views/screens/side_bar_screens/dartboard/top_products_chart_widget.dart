import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class TopProductsChartWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.pink.shade900, width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('orders').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No data available'));
          }

          // Tính toán tổng số lượng đã đặt của mỗi sản phẩm
          Map<String, int> productPurchaseCount = {};
          for (var doc in snapshot.data!.docs) {
            List products = doc['products'];
            for (var product in products) {
              String productName = product['productName'];
              int quantity = product['quantity'];
              productPurchaseCount[productName] =
                  (productPurchaseCount[productName] ?? 0) + quantity;
            }
          }

          // Lấy danh sách top 5 sản phẩm bán chạy nhất
          List<MapEntry<String, int>> topProducts = productPurchaseCount.entries.toList()
            ..sort((a, b) => b.value.compareTo(a.value));
          topProducts = topProducts.take(5).toList();

          List<BarChartGroupData> barGroups = topProducts.asMap().entries.map((entry) {
            int index = entry.key;
            MapEntry<String, int> productEntry = entry.value;

            return BarChartGroupData(
              x: index,
              barRods: [
                BarChartRodData(
                  toY: productEntry.value.toDouble(),
                  color: Colors.pink,
                  width: 20,
                ),
              ],
            );
          }).toList();

          return Column(
            children: [
              Text(
                'Top Sản Phẩm Bán Chạy',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.pink.shade900,
                ),
              ),
              SizedBox(height: 10),
              SizedBox(
                height: 300,
                child: BarChart(
                  BarChartData(
                    titlesData: FlTitlesData(
                      topTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 60, // Tăng kích thước để có thêm không gian
                          getTitlesWidget: (value, meta) {
                            int index = value.toInt();
                            if (index >= 0 && index < topProducts.length) {
                              return SideTitleWidget(
                                axisSide: meta.axisSide,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                  child: Column(
                                    children: [
                                      Flexible(
                                        child: Text(
                                          topProducts[index].key,
                                          style: TextStyle(fontSize: 12, color: Colors.black),
                                          textAlign: TextAlign.center,
                                          softWrap: true,
                                          maxLines: 2, // Đặt số dòng tối đa
                                          overflow: TextOverflow.ellipsis, // Thêm dấu ba chấm nếu quá dài
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            } else {
                              return Container();
                            }
                          },
                        ),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 40,
                          getTitlesWidget: (value, meta) {
                            return SideTitleWidget(
                              axisSide: meta.axisSide,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Text(
                                  value.toInt().toString(),
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    borderData: FlBorderData(show: false),
                    barGroups: barGroups,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
