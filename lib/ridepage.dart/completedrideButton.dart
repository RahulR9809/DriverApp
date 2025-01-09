import 'package:employerapp/ridepage.dart/bloc/ride_bloc.dart';
import 'package:employerapp/ridepage.dart/bloc/ride_event.dart';
import 'package:employerapp/ridepage.dart/bloc/ride_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CompleteRidePage extends StatelessWidget {

  const CompleteRidePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Complete Ride'),
      ),
      body: Center(
        child: BlocConsumer<RideBloc, RideState>(
          listener: (context, state) {
            if (state is RideCompletedState) {
              // You can show a success message here or navigate
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Ride completed!')),
              );
            }
            if (state is RideErrorState) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
          builder: (context, state) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                  
                    context.read<RideBloc>().add(
                          CompleteRideEvent(),
                    );
                  },
                  child: Text('Complete Ride'),
                ),
                if (state is RideErrorState) 
                  Text('Error: ${state.message}', style: TextStyle(color: Colors.red)),
              ],
            );
          },
        ),
      ),
    );
  }
}
