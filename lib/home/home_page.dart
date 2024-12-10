import 'package:employerapp/controller/socket_controller.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // @override
  // void initState() {
  //   super.initState();
  //   // Initialize and connect the driver socket when the app starts
  //   final driverSocketService = DriverSocketService();
  //   driverSocketService.connect(context); // Pass BuildContext here
  // }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Driver Dashboard'),
        backgroundColor: Colors.tealAccent,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Dashboard Cards
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  InfoCard(title: 'Total Earnings', value: '\$3,450', icon: Icons.money),
                  InfoCard(title: 'Completed Rides', value: '120', icon: Icons.directions_car),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  InfoCard(title: 'Battery Status', value: '85%', icon: Icons.battery_charging_full),
                  InfoCard(title: 'Rating', value: '4.9', icon: Icons.star),
                ],
              ),
              const SizedBox(height: 32),

              // Earnings Chart
              const Text(
                'Earnings Overview',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.tealAccent),
              ),
              const SizedBox(height: 16),
              const EarningsChart(),
              const SizedBox(height: 32),

            ],
          ),
        ),
      ),
    );
  }
}

class InfoCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const InfoCard({Key? key, required this.title, required this.value, required this.icon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey[850],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 8,
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.4,
        height: 140,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.tealAccent, size: 36),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(fontSize: 16, color: Colors.white70),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class EarningsChart extends StatelessWidget {
  const EarningsChart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: LineChart(
        LineChartData(
          gridData: FlGridData(show: true, getDrawingHorizontalLine: (value) {
            return FlLine(color: Colors.white.withOpacity(0.2), strokeWidth: 1);
          }),
          borderData: FlBorderData(show: true, border: Border.all(color: Colors.white.withOpacity(0.5), width: 1)),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: true, getTitlesWidget: (value, meta) {
                return Text(
                  value.toStringAsFixed(0),
                  style: const TextStyle(fontSize: 10, color: Colors.white),
                );
              }),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: true, getTitlesWidget: (value, meta) {
                return Text(
                  value.toStringAsFixed(0),
                  style: const TextStyle(fontSize: 10, color: Colors.white),
                );
              }),
            ),
          ),
          lineBarsData: [
            LineChartBarData(
              spots: const [
                FlSpot(0, 0),
                FlSpot(1, 1.2),
                FlSpot(2, 2.5),
                FlSpot(3, 1.5),
                FlSpot(4, 2.8),
                FlSpot(5, 3.0),
                FlSpot(6, 3.5),
              ],
              isCurved: true,
              color: Colors.tealAccent,
              dotData: FlDotData(show: false),
              belowBarData: BarAreaData(show: true, color: Colors.tealAccent.withOpacity(0.3)),
            ),
          ],
        ),
      ),
    );
  }
}

