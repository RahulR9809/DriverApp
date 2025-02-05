// import 'package:employerapp/core/colors.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:fl_chart/fl_chart.dart';

// import 'package:employerapp/controllers/dash_bloc/bloc/dash_bloc.dart';
// import 'package:employerapp/views/ride_details/revenue_page.dart';
// import 'package:employerapp/views/ride_details/ride_details.dart';

// class HomePage extends StatefulWidget {
//   const HomePage({super.key});

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   double goalAmount = 0;
//   double currentEarnings = 400;

//   @override
//   void initState() {
//     super.initState();
//     final dashBloc = BlocProvider.of<DashBloc>(context);
//     dashBloc.add(FetchDashEvent());
//   }

//   // void _showGoalDialog() {
//   //   TextEditingController goalController = TextEditingController();

//   //   showDialog(
//   //     context: context,
//   //     builder: (context) => AlertDialog(
//   //       title: const Text("Set Goal"),
//   //       content: Column(
//   //         mainAxisSize: MainAxisSize.min,
//   //         children: [

//   //           const SizedBox(height: 10),
//   //           TextField(
//   //             controller: goalController,
//   //             keyboardType: TextInputType.number,
//   //             decoration: const InputDecoration(
//   //               labelText: "Enter goal amount (min: 1000)",
//   //               border: OutlineInputBorder(),
//   //             ),
//   //           ),
//   //         ],
//   //       ),
//   //       actions: [
//   //         TextButton(
//   //           onPressed: () {
//   //             Navigator.pop(context);
//   //           },
//   //           child: const Text("Cancel"),
//   //         ),
//   //         ElevatedButton(
//   //           onPressed: () {
//   //             double enteredAmount = double.tryParse(goalController.text) ?? 0;
//   //             if (enteredAmount >= 1000) {
//   //               setState(() {
//   //                 goalAmount = enteredAmount;
//   //               });
//   //               Navigator.pop(context);
//   //             } else {
//   //               ScaffoldMessenger.of(context).showSnackBar(
//   //                 const SnackBar(
//   //                   content: Text("Goal must be at least \$1000"),
//   //                   backgroundColor: Colors.red,
//   //                 ),
//   //               );
//   //             }
//   //           },
//   //           child: const Text("Set Goal"),
//   //         ),
//   //       ],
//   //     ),
//   //   );
//   // }

//   @override
//   Widget build(BuildContext context) {
//     // double progress = (goalAmount > 0) ? (currentEarnings / goalAmount) : 0;

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Driver Dashboard',style: TextStyle(color: CustomColors.white,),),
//         backgroundColor: CustomColors.lightBlue,
//         centerTitle: true,
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             children: [
//               GestureDetector(
//                 onTap: () => Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => const RevenuePage()),
//                 ),
//                 child: const ActivityTrackerCard(),
//               ),
//               const SizedBox(height: 20),

//               Row(
//                 children: [
//                   GestureDetector(
//                     onTap: () => Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                           builder: (context) => const RideDetails()),
//                     ),
//                     child:const TripDetails()
//                   ),
//                   const SizedBox(width: 8),
//                   const Expanded(
//                     flex: 2,
//                     child: UniqueInfoCard(
//                       title: 'Completed Rides',
//                       icon: Icons.directions_car,
//                       height: 120,
//                     ),
//                   ),
//                 ],
//               ),

//               const SizedBox(height: 16),

//               // Set Goal and Progress Column
//               // Row(
//               //   children: [
//               //     Expanded(
//               //       child: GestureDetector(
//               //         onTap: _showGoalDialog,
//               //         child: const SetGoal()
//               //       ),
//               //     ),
//               //     const SizedBox(width: 10),
//               //     Expanded(
//               //       child: Stack(
//               //         alignment: Alignment.center,
//               //         children: [
//               //           Container(
//               //             height: 120,
//               //             width: 120,
//               //             decoration: BoxDecoration(
//               //               shape: BoxShape.circle,
//               //               color: Colors.white,
//               //               boxShadow: [
//               //                 BoxShadow(
//               //                   color: Colors.black.withOpacity(0.1),
//               //                   blurRadius: 10,
//               //                   offset: const Offset(0, 4),
//               //                 ),
//               //               ],
//               //             ),
//               //             child: Padding(
//               //               padding: const EdgeInsets.all(12.0),
//               //               child: CircularProgressIndicator(
//               //                 value: progress.clamp(0, 1),
//               //                 strokeWidth: 10,
//               //                 backgroundColor: Colors.grey.shade200,
//               //                 valueColor: const AlwaysStoppedAnimation<Color>(
//               //                     Colors.teal),
//               //               ),
//               //             ),
//               //           ),
//               //           Column(
//               //             mainAxisAlignment: MainAxisAlignment.center,
//               //             children: [
//               //               Text(
//               //                 "${(progress * 100).toStringAsFixed(1)}%",
//               //                 style: const TextStyle(
//               //                   fontSize: 30,
//               //                   fontWeight: FontWeight.w600,
//               //                   color: Colors.teal,
//               //                   letterSpacing: 1.2,
//               //                 ),
//               //               ),
//               //               const SizedBox(height: 8),
//               //               const Text(
//               //                 "Goal Progress",
//               //                 style: TextStyle(
//               //                   fontSize: 14,
//               //                   color: Colors.grey,
//               //                   fontWeight: FontWeight.w400,
//               //                 ),
//               //               ),
//               //             ],
//               //           ),
//               //         ],
//               //       ),
//               //     ),
//               //   ],
//               // ),

//               const SizedBox(height: 32),

//               const Text(
//                 'Earnings Overview',
//                 style: TextStyle(
//                   fontWeight: FontWeight.bold,
//                   fontSize: 18,
//                   color: CustomColors.lightBlue,
//                 ),
//               ),
//               const SizedBox(height: 16),
//               const EarningsChart(),
//               const SizedBox(height: 32),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// class SetGoal extends StatelessWidget {
//   const SetGoal({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//           shape:
//               RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//           elevation: 8,
//           child: Container(
//             height: 120,
//             decoration: BoxDecoration(
//              color: CustomColors.lightBlue,
//               borderRadius: BorderRadius.circular(20),
//             ),
//             child: const Padding(
//               padding: EdgeInsets.all(16.0),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.spaceAround,
//                 children: [
//                   // Icon(Icons.flag, color: Colors.teal.shade700, size: 36),
//                   Text(
//                     'Set Goal',
//                     style: TextStyle(
//                       fontSize: 14,
//                       fontWeight: FontWeight.bold,
//                       color: CustomColors.white,
//                     ),
//                   ),

//                 ],
//               ),
//             ),
//           ),
//         );
//   }
// }

// class TripDetails extends StatelessWidget {
//   const TripDetails({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//           shape:
//               RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//           elevation: 8,
//           child: Container(
//             height: 120,
//             decoration: BoxDecoration(
//              color: CustomColors.lightBlue,
//               borderRadius: BorderRadius.circular(20),
//             ),
//             child: const Padding(
//               padding: EdgeInsets.all(16.0),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.spaceAround,
//                 children: [
//                   // Icon(Icons.list, color: Colors.teal.shade700, size: 36),
//                   Text(
//                     'Trip details',
//                     style: TextStyle(
//                       fontSize: 14,
//                       fontWeight: FontWeight.bold,
//                       color: CustomColors.white,
//                     ),
//                   ),

//                 ],
//               ),
//             ),
//           ),
//         );
//   }
// }

// class UniqueInfoCard extends StatelessWidget {
//   final String title;
//   final IconData icon;
//   final double height;

//   const UniqueInfoCard({
//     super.key,
//     required this.title,
//     required this.icon,
//     required this.height,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<DashBloc, DashState>(
//       builder: (context, state) {
//         String value = 'Loading...'; // Default loading text

//         if (state is FetchedDashData) {
//           int tripCount = state.data["completedTripsCount"] ?? 0;
//           value = tripCount.toString();
//         }

//         return Card(
//           shape:
//               RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//           elevation: 8,
//           child: Container(
//             height: height,
//             decoration: BoxDecoration(
//              color: CustomColors.lightBlue,
//               borderRadius: BorderRadius.circular(20),
//             ),
//             child: Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.spaceAround,
//                 children: [
//                   // Icon(icon, color: Colors.teal.shade700, size: 36),
//                   Text(
//                     title,
//                     style: const TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                       color: CustomColors.white,
//                     ),
//                   ),
//                   state is FetchedDashData
//                       ? Text(
//                           value,
//                           style: const TextStyle(
//                             fontSize: 20,
//                             fontWeight: FontWeight.bold,
//                             color: CustomColors.white,
//                           ),
//                         )
//                       : const Expanded(child:  CircularProgressIndicator()),
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }

// class EarningsChart extends StatelessWidget {
//   const EarningsChart({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: 200,
//       child: LineChart(
//         LineChartData(
//           gridData: FlGridData(
//               show: true,
//               getDrawingHorizontalLine: (value) {
//                 return FlLine(
//                     color: Colors.grey.withOpacity(0.2), strokeWidth: 1);
//               }),
//           borderData: FlBorderData(
//               show: true,
//               border:
//                   Border.all(color: Colors.grey.withOpacity(0.5), width: 1)),
//           titlesData: FlTitlesData(
//             leftTitles: AxisTitles(
//               sideTitles: SideTitles(
//                   showTitles: true,
//                   getTitlesWidget: (value, meta) {
//                     return Text(
//                       value.toStringAsFixed(0),
//                       style: const TextStyle(fontSize: 10, color: Colors.teal),
//                     );
//                   }),
//             ),
//             bottomTitles: AxisTitles(
//               sideTitles: SideTitles(
//                   showTitles: true,
//                   getTitlesWidget: (value, meta) {
//                     return Text(
//                       value.toStringAsFixed(0),
//                       style: const TextStyle(fontSize: 10, color: Colors.teal),
//                     );
//                   }),
//             ),
//           ),
//           lineBarsData: [
//             LineChartBarData(
//               spots: const [
//                 FlSpot(0, 0),
//                 FlSpot(1, 1.2),
//                 FlSpot(2, 2.5),
//                 FlSpot(3, 1.5),
//                 FlSpot(4, 2.8),
//                 FlSpot(5, 3.0),
//                 FlSpot(6, 3.5),
//               ],
//               isCurved: true,
//               color: Colors.teal,
//               dotData: const FlDotData(show: false),
//               belowBarData:
//                   BarAreaData(show: true, color: Colors.teal.withOpacity(0.3)),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class GoalsCard extends StatelessWidget {
//   const GoalsCard({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//       elevation: 8,
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               'Daily Goal Progress',
//               style: TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.teal,
//               ),
//             ),
//             const SizedBox(height: 8),
//             LinearProgressIndicator(
//               value: 0.75, // Example progress (75%)
//               color: Colors.teal,
//               backgroundColor: Colors.teal.withOpacity(0.3),
//             ),
//             const SizedBox(height: 16),
//             const Text(
//               'Weekly Goal Progress',
//               style: TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.teal,
//               ),
//             ),
//             const SizedBox(height: 8),
//             LinearProgressIndicator(
//               value: 0.5, // Example progress (50%)
//               color: Colors.teal,
//               backgroundColor: Colors.teal.withOpacity(0.3),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class ActivityTrackerCard extends StatelessWidget {
//   const ActivityTrackerCard({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//       elevation: 6,
//       color: CustomColors.lightBlue,
//       child: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: BlocBuilder<DashBloc, DashState>(
//           builder: (context, state) {
//             if (state is FetchedDashData) {
//               double todaysRevenue = state.data["todaysRevenue"] ?? 0;
//               double totalRevenue = state.data["totalRevenue"] ?? 0;

//               return Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   // Today's Earnings Section
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         const Text(
//                           "Today's Earnings",
//                           style: TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.bold,
//                             color: CustomColors.white,
//                           ),
//                         ),
//                         const SizedBox(height: 8),
//                         Text(
//                           '\$${todaysRevenue.toStringAsFixed(2)}',
//                           style: const TextStyle(
//                             fontSize: 26,
//                             fontWeight: FontWeight.bold,
//                             color: CustomColors.white,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   const SizedBox(width: 16),
//                   // Total Earnings Section
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         const Text(
//                           'Total Earnings',
//                           style: TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.bold,
//                             color: CustomColors.white,
//                           ),
//                         ),
//                         const SizedBox(height: 8),
//                         Text(
//                           '\$${totalRevenue.toStringAsFixed(2)}',
//                           style: const TextStyle(
//                             fontSize: 26,
//                             fontWeight: FontWeight.bold,
//                             color: CustomColors.white,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               );
//             }

//             return const Center(child: CircularProgressIndicator());
//           },
//         ),
//       ),
//     );
//   }
// }

import 'package:employerapp/core/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fl_chart/fl_chart.dart';

import 'package:employerapp/controllers/dash_bloc/bloc/dash_bloc.dart';
import 'package:employerapp/views/ride_details/revenue_page.dart';
import 'package:employerapp/views/ride_details/ride_details.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double goalAmount = 0;
  double currentEarnings = 400;

  @override
  void initState() {
    super.initState();
    final dashBloc = BlocProvider.of<DashBloc>(context);
    dashBloc.add(FetchDashEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Driver Dashboard',
          style: TextStyle(
            color: CustomColors.white,
          ),
        ),
        backgroundColor: CustomColors.lightBlue,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const SizedBox(
                height: 24,
              ),
              GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const RevenuePage()),
                ),
                child: const ActivityTrackerCard(),
              ),
              const SizedBox(height: 30),
              Row(
                children: [
                  GestureDetector(
                      onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const RideDetails()),
                          ),
                      child: const TripDetails()),
                  const SizedBox(width: 8),
                  const Expanded(
                    flex: 2,
                    child: UniqueInfoCard(
                      title: 'Completed Rides',
                      icon: Icons.directions_car,
                      height: 120,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              const Text(
                'Earnings Overview',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  color: CustomColors.lightBlue,
                ),
              ),
              const SizedBox(height: 20),
              const EarningsChart(),
            ],
          ),
        ),
      ),
    );
  }
}

class TripDetails extends StatelessWidget {
  const TripDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 8,
      child: Container(
        height: 120,
        decoration: BoxDecoration(
          color: CustomColors.lightBlue,
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                'Trip details',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: CustomColors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class UniqueInfoCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final double height;

  const UniqueInfoCard({
    super.key,
    required this.title,
    required this.icon,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashBloc, DashState>(
      builder: (context, state) {
        String value = 'Loading...'; // Default loading text

        if (state is FetchedDashData) {
          int tripCount = state.data["completedTripsCount"] ?? 0;
          value = tripCount.toString();
        }

        return Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          elevation: 8,
          child: Container(
            height: height,
            decoration: BoxDecoration(
              color: CustomColors.lightBlue,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: CustomColors.white,
                    ),
                  ),
                  state is FetchedDashData
                      ? Text(
                          value,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: CustomColors.white,
                          ),
                        )
                      : const Expanded(child: CircularProgressIndicator()),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class EarningsChart extends StatelessWidget {
  const EarningsChart({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: CustomColors.chartcolor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: CustomColors.grey.withOpacity(0.1),
              offset: const Offset(0, 4),
              blurRadius: 10,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: SizedBox(
            height: 220,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: CustomColors.grey.withOpacity(0.2),
                      strokeWidth: 1,
                    );
                  },
                  getDrawingVerticalLine: (value) {
                    return FlLine(
                      color: CustomColors.grey.withOpacity(0.2),
                      strokeWidth: 1,
                    );
                  },
                ),
                borderData: FlBorderData(
                  show: true,
                  border: Border.all(
                    color: CustomColors.grey.withOpacity(0.5),
                    width: 1,
                  ),
                ),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          value.toStringAsFixed(0),
                          style: const TextStyle(
                              fontSize: 12, color: CustomColors.black),
                        );
                      },
                      reservedSize: 30,
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          value.toStringAsFixed(0),
                          style: const TextStyle(
                              fontSize: 12, color: CustomColors.black),
                        );
                      },
                      reservedSize: 30,
                    ),
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
                    color: CustomColors.green,
                    dotData: const FlDotData(
                      show: true,
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      color: CustomColors.lightBlue.withOpacity(0.3),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class GoalsCard extends StatelessWidget {
  const GoalsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 8,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Daily Goal Progress',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.teal,
              ),
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: 0.75,
              color: Colors.teal,
              backgroundColor: Colors.teal.withOpacity(0.3),
            ),
            const SizedBox(height: 16),
            const Text(
              'Weekly Goal Progress',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.teal,
              ),
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: 0.5,
              color: Colors.teal,
              backgroundColor: Colors.teal.withOpacity(0.3),
            ),
          ],
        ),
      ),
    );
  }
}

class ActivityTrackerCard extends StatelessWidget {
  const ActivityTrackerCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 6,
      color: CustomColors.lightBlue,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: BlocBuilder<DashBloc, DashState>(
          builder: (context, state) {
            if (state is FetchedDashData) {
              double todaysRevenue = state.data["todaysRevenue"] ?? 0;
              double totalRevenue = state.data["totalRevenue"] ?? 0;

              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Today's Earnings",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: CustomColors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '\$${todaysRevenue.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: CustomColors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Total Earnings',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: CustomColors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '\$${totalRevenue.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: CustomColors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }

            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}
