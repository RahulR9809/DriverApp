import 'package:employerapp/controllers/dash_bloc/bloc/dash_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class RevenuePage extends StatefulWidget {
  const RevenuePage({super.key});

  @override
  State<RevenuePage> createState() => _RevenuePageState();
}

class _RevenuePageState extends State<RevenuePage> {
  late DashBloc _dashBloc;
  String startMonth = DateFormat('yyyy-MM')
      .format(DateTime.now().subtract(const Duration(days: 30)));
  String endMonth = DateFormat('yyyy-MM').format(DateTime.now());

  @override
  void initState() {
    super.initState();
    _dashBloc = context.read<DashBloc>();
    _dashBloc.add(FetchRevenueEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              final dashBloc = BlocProvider.of<DashBloc>(context);
              dashBloc.add(FetchDashEvent());
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back)),
        title: const Text('Revenue Summary',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blueAccent,
        elevation: 4,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: LayoutBuilder(
          builder: (context, constraints) {
            double screenWidth = constraints.maxWidth;

            return Column(
              children: [
                _buildFilterSection(screenWidth),
                const SizedBox(height: 20),
                Expanded(
                  child: BlocBuilder<DashBloc, DashState>(
                    builder: (context, state) {
                      if (state is DashLoading) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state is RevenueData) {
                        var data = state.data;

                        if (data.containsKey('tripData')) {
                          List<Map<String, dynamic>> trips =
                              List<Map<String, dynamic>>.from(data['tripData']);

                          DateTime startDate = DateTime.parse('$startMonth-01');
                          DateTime endDate = DateTime.parse('$endMonth-01')
                              .add(const Duration(days: 30));

                          List<Map<String, dynamic>> filteredTrips =
                              trips.where((trip) {
                            DateTime tripDate =
                                DateTime.parse(trip['createdAt']);
                            return tripDate.isAfter(startDate) &&
                                tripDate.isBefore(endDate) &&
                                trip['tripStatus'] == 'completed';
                          }).toList();

                          double totalRevenue = filteredTrips.fold(
                              0.0, (sum, trip) => sum + trip['fare']);

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildRevenueDisplay(totalRevenue, startDate,
                                  endDate, screenWidth),
                              const SizedBox(height: 20),
                              Expanded(child: _buildTripList(filteredTrips)),
                            ],
                          );
                        } else {
                          return _buildNoDataMessage('No trip data available.');
                        }
                      } else if (state is LatestTripsError) {
                        return _buildNoDataMessage('Error: ${state.message}');
                      }
                      return Container();
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildFilterSection(double screenWidth) {
    return SingleChildScrollView(
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        color: Colors.blueGrey[50],
        child: Padding(
          padding: EdgeInsets.all(screenWidth * 0.04),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Filter by Month Range",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey[800])),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: _buildMonthSelector("Start Month", startMonth,
                        (newValue) {
                      setState(() {
                        startMonth = newValue!;
                      });
                    }),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child:
                        _buildMonthSelector("End Month", endMonth, (newValue) {
                      setState(() {
                        endMonth = newValue!;
                      });
                    }),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMonthSelector(
      String label, String currentMonth, ValueChanged<String?> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(
                fontWeight: FontWeight.bold, color: Colors.blueGrey[700])),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.blueGrey[300]!),
          ),
          child: DropdownButton<String>(
            value: currentMonth,
            onChanged: onChanged,
            isExpanded: true,
            underline: const SizedBox(),
            items: _generateMonthList().map((month) {
              return DropdownMenuItem(
                value: month,
                child: Row(
                  children: [
                    const Icon(Icons.calendar_today,
                        size: 18, color: Colors.blueGrey),
                    const SizedBox(width: 8),
                    Text(
                      DateFormat('MMM-yy').format(DateTime.parse('$month-01')),
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  List<String> _generateMonthList() {
    DateTime now = DateTime.now();
    return List.generate(12, (index) {
      DateTime month = DateTime(now.year, now.month - index, 1);
      return DateFormat('yyyy-MM').format(month);
    });
  }

  Widget _buildRevenueDisplay(double totalRevenue, DateTime startDate,
      DateTime endDate, double screenWidth) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      color: Colors.transparent,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          gradient: LinearGradient(
            colors: [Colors.green.shade300, Colors.green.shade600],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: EdgeInsets.all(screenWidth * 0.05),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Total Revenue',
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            const SizedBox(height: 8),
            Text(
              '\$${totalRevenue.toStringAsFixed(2)}',
              style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            const SizedBox(height: 8),
            Text(
              '${DateFormat('MMMM yyyy').format(startDate)} - ${DateFormat('MMMM yyyy').format(endDate)}',
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTripList(List<Map<String, dynamic>> trips) {
    return ListView.builder(
      itemCount: trips.length,
      itemBuilder: (context, index) {
        final trip = trips[index];
        final user = trip['users'] != null && trip['users'].isNotEmpty
            ? trip['users'][0]
            : null;

        return Card(
          elevation: 3,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: ListTile(
            contentPadding: const EdgeInsets.all(16),
            title: Text(
              'Trip: ${trip['pickUpLocation']} → ${trip['dropOffLocation']}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              'Fare: \$${trip['fare'].toStringAsFixed(2)}\nUser: ${user != null ? user['name'] : "Not Available"}',
              style: TextStyle(fontSize: 14, color: Colors.grey[700]),
            ),
          ),
        );
      },
    );
  }

  Widget _buildNoDataMessage(String message) {
    return Center(
      child: Text(message,
          style: const TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red)),
    );
  }
}
