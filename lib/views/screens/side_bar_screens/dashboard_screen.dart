import 'package:flutter/material.dart';
import 'package:uber_shop_app_web_admin/views/screens/side_bar_screens/dartboard/revenue_pie_chart_widget.dart';
import 'dartboard/dardboard_stats_widget.dart';
import 'dartboard/monthly_revenue_comparison_stacked_bar_chart.dart';
import 'dartboard/top_products_chart_widget.dart';

class DashboardScreen extends StatelessWidget {
  static const String routeName = '\DashboardScreen';

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        alignment: Alignment.topLeft,
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Thống Kê',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 36,
              ),
            ),
            SizedBox(height: 20),
            Divider(
              color: Colors.grey,
            ),
            DashboardStatsWidget(),
            // SizedBox(height: 20),
            // MonthlyRevenueComparisonStackedBarChart(),
            SizedBox(height: 20),
            TopProductsChartWidget(),
            SizedBox(height: 20),
            RevenuePieChartWidget(),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
