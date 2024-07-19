import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MonthlyRevenueComparisonStackedBarChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
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

        // Group orders by month and vendor
        Map<String, Map<String, double>> monthlyRevenue = {};

        for (var doc in snapshot.data!.docs) {
          if (doc['accepted'] == true && doc['orderStatus'] == 'Delivered Successfully') {
            DateTime orderDate = (doc['orderDate'] as Timestamp).toDate();
            String month = DateFormat('yyyy-MM').format(orderDate);
            String vendorId = doc['vendorId'];
            double price = doc['price'];

            if (!monthlyRevenue.containsKey(month)) {
              monthlyRevenue[month] = {};
            }

            if (!monthlyRevenue[month]!.containsKey(vendorId)) {
              monthlyRevenue[month]![vendorId] = 0;
            }

            monthlyRevenue[month]![vendorId] = monthlyRevenue[month]![vendorId]! + price;
          }
        }

        // Get unique vendor IDs
        Set<String> vendorIds = {};
        monthlyRevenue.values.forEach((vendorMap) {
          vendorIds.addAll(vendorMap.keys);
        });

        // Sort months
        List<String> sortedMonths = monthlyRevenue.keys.toList()..sort();

        // Create bar groups for the chart
        List<BarChartGroupData> barGroups = [];
        double maxY = 0;
        for (int monthIndex = 0; monthIndex < sortedMonths.length; monthIndex++) {
          String month = sortedMonths[monthIndex];
          List<BarChartRodData> rods = [];
          int vendorIndex = 0;
          double totalRevenueForMonth = 0;
          for (String vendorId in vendorIds) {
            double revenue = monthlyRevenue[month]![vendorId] ?? 0;
            totalRevenueForMonth += revenue;
            rods.add(BarChartRodData(
              toY: revenue,
              color: Colors.primaries[vendorIndex % Colors.primaries.length],
              width: 20,
            ));
            vendorIndex++;
          }
          maxY = maxY < totalRevenueForMonth ? totalRevenueForMonth : maxY;

          barGroups.add(BarChartGroupData(
            x: monthIndex,
            barRods: rods,
          ));
        }

        return Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.blueAccent, width: 2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Monthly Revenue Comparison',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              SizedBox(
                height: 300,
                child: BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.spaceEvenly,
                    maxY: maxY,
                    barTouchData: BarTouchData(enabled: false),
                    titlesData: FlTitlesData(
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 40,
                          getTitlesWidget: (value, meta) {
                            String month = sortedMonths[value.toInt()];
                            return SideTitleWidget(
                              axisSide: meta.axisSide,
                              child: Text(
                                DateFormat.MMM().format(DateTime.parse('$month-01')),
                                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                              ),
                            );
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
                              child: Text(
                                value.toInt().toString(),
                                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
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
          ),
        );
      },
    );
  }
}
