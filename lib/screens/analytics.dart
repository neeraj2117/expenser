import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class Analytics extends StatefulWidget {
  const Analytics({Key? key}) : super(key: key);

  @override
  State<Analytics> createState() => _AnalyticsState();
}

class _AnalyticsState extends State<Analytics> {
  bool _loading = true;
  List<BarChartGroupData> _weeklyData = [];
  List<BarChartGroupData> _monthlyData = [];
  Map<int, String> _weeklyCategories = {};
  Map<int, String> _monthlyCategories = {};

  @override
  void initState() {
    super.initState();
    _fetchTransactionData();
  }

  Future<void> _fetchTransactionData() async {
    String userId = FirebaseAuth.instance.currentUser?.uid ?? 'unknown_user';

    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('transactions')
        .where('user_id', isEqualTo: userId)
        .get();

    List<QueryDocumentSnapshot> docs = snapshot.docs;

    Map<int, double> weeklyData = {};
    Map<int, double> monthlyData = {};
    Map<int, String> weeklyCategories = {};
    Map<int, String> monthlyCategories = {};

    DateTime now = DateTime.now();
    DateTime startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    DateTime startOfMonth = DateTime(now.year, now.month, 1);

    for (var doc in docs) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      DateTime date = (data['date'] as Timestamp).toDate();
      double amount = data['amount'];
      String category = data['category'];

      // Weekly data
      if (date.isAfter(startOfWeek)) {
        int day = date.weekday;
        weeklyData[day] = (weeklyData[day] ?? 0) + amount;
        weeklyCategories[day] = category;
      }

      // Monthly data
      if (date.isAfter(startOfMonth)) {
        int day = date.day;
        monthlyData[day] = (monthlyData[day] ?? 0) + amount;
        monthlyCategories[day] = category;
      }
    }

    setState(() {
      _weeklyData = _createBarChartData(weeklyData);
      _monthlyData = _createBarChartData(monthlyData);
      _weeklyCategories = weeklyCategories;
      _monthlyCategories = monthlyCategories;
      _loading = false;
    });
  }

  List<BarChartGroupData> _createBarChartData(Map<int, double> data) {
    return data.entries.map((entry) {
      return BarChartGroupData(
        x: entry.key,
        barRods: [
          BarChartRodData(
            toY: entry.value,
            color: Colors.blue,
            width: 16,
          ),
        ],
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Analytics Page',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildChartTitle('Weekly Expenses'),
                  const SizedBox(height: 16),
                  _buildBarChart(_weeklyData, _weeklyCategories, true),
                  const SizedBox(height: 32),
                  _buildChartTitle('Monthly Expenses'),
                  const SizedBox(height: 16),
                  _buildBarChart(_monthlyData, _monthlyCategories, false),
                ],
              ),
            ),
    );
  }

  Widget _buildChartTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 19,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildBarChart(List<BarChartGroupData> data,
      Map<int, String> categories, bool isWeekly) {
    return AspectRatio(
      aspectRatio: 1.5,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          barGroups: data,
          barTouchData: BarTouchData(
            touchTooltipData: BarTouchTooltipData(
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                String category = isWeekly
                    ? _weeklyCategories[group.x.toInt()] ?? 'No Category'
                    : _monthlyCategories[group.x.toInt()] ?? 'No Category';
                return BarTooltipItem(
                  category,
                  TextStyle(color: Colors.white),
                );
              },
            ),
          ),
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
            leftTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  switch (value.toInt()) {
                    case 1:
                      return const Text('Mon');
                    case 2:
                      return const Text('Tue');
                    case 3:
                      return const Text('Wed');
                    case 4:
                      return const Text('Thu');
                    case 5:
                      return const Text('Fri');
                    case 6:
                      return const Text('Sat');
                    case 7:
                      return const Text('Sun');
                    default:
                      return const Text('');
                  }
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
