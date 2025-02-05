import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:employerapp/controllers/dash_bloc/bloc/dash_bloc.dart';

class RideDetails extends StatefulWidget {
  const RideDetails({super.key});

  @override
  State<RideDetails> createState() => _RideDetailsState();
}

class _RideDetailsState extends State<RideDetails> {
  @override
  void initState() {
    super.initState();
    final dashBloc = BlocProvider.of<DashBloc>(context);
    dashBloc.add(FetchTripsData()); 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
  leading: IconButton(
    onPressed: () {
      Navigator.pop(context);
      final dashBloc = BlocProvider.of<DashBloc>(context);
    dashBloc.add(FetchDashEvent());
    },
    icon: const Icon(Icons.arrow_back),
  ),
  title: const Text('Trip Details'),
  backgroundColor: Colors.teal,
  actions: [
    IconButton(
      onPressed: () {
        final dashBloc = BlocProvider.of<DashBloc>(context);
        dashBloc.add(FetchTripsData()); 
      },
      icon: const Icon(Icons.refresh),
      tooltip: "Refresh",
    ),
  ],
),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: BlocBuilder<DashBloc, DashState>(
  builder: (context, state) {
    if (state is DashLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (state is TripsDataLoaded) {
      final allTrips = state.data['tripDetails'] as List<dynamic>?;

      if (allTrips == null || allTrips.isEmpty) {
        return const Center(child: Text('No trips available.'));
      }

      final completedTrips = allTrips.where((trip) => trip['tripStatus'] == 'completed').toList();

      if (completedTrips.isEmpty) {
        return const Center(child: Text('No completed trips available.'));
      }

      return ListView.builder(
        itemCount: completedTrips.length,
        itemBuilder: (context, index) {
          final trip = completedTrips[index];

          return Card(
            elevation: 4,
            margin: const EdgeInsets.symmetric(vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildRow(Icons.location_on, "Pickup", trip['pickUpLocation']),
                  _buildRow(Icons.flag, "Drop-off", trip['dropOffLocation']),
                  const Divider(),
                  _buildRow(Icons.attach_money, "Fare", "\$${trip['fare'].toStringAsFixed(2)}"),
                  _buildRow(Icons.timeline, "Distance", "${trip['distance']} km"),
                  _buildRow(Icons.timer, "Duration", "${trip['duration']} min"),
                  _buildRow(Icons.payment, "Payment", trip['paymentMethod']),
                  _buildRow(Icons.directions_car, "Trip Status", trip['tripStatus'].toUpperCase()),
                ],
              ),
            ),
          );
        },
      );
    } else {
      return const Center(child: Text('No trip details found.'));
    }
  },
),

        ),
      ),
    );
  }

  Widget _buildRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.teal, size: 22),
          const SizedBox(width: 8),
          Text(
            "$label: ",
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 16),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
