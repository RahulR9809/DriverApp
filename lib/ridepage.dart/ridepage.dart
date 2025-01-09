import 'package:employerapp/controller/chat_socketcontroller.dart';
import 'package:employerapp/ridepage.dart/map/map_pages.dart';
import 'package:employerapp/ridepage.dart/bloc/ride_bloc.dart';
import 'package:employerapp/ridepage.dart/bloc/ride_event.dart';
import 'package:employerapp/ridepage.dart/bloc/ride_state.dart';
import 'package:employerapp/widgets/refactored.dart';
import 'package:employerapp/widgets/ridestrart_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CustomSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const CustomSwitch({super.key, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: 1.5,
      child: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: Colors.white,
        activeTrackColor: Colors.green.shade800,
        inactiveThumbColor: Colors.white,
        inactiveTrackColor: Colors.red.shade700,
        thumbColor:
            MaterialStateProperty.all(Colors.blue.shade600), 
        trackColor: MaterialStateProperty.all(
            const Color.fromARGB(255, 115, 117, 122)),
        splashRadius: 30.0,
        overlayColor:
            MaterialStateProperty.all(Colors.green.shade300.withOpacity(0.5)),
      ),
    );
  }
}


class RidePage extends StatefulWidget {
  const RidePage({super.key});

  @override
  State<RidePage> createState() => _RidePageState();
}

class _RidePageState extends State<RidePage> {
  String currentLocation = '';
  Map<String, dynamic>? rideData; 
  DriverSocketChatService driverSocketChatService = DriverSocketChatService();

  @override
  Widget build(BuildContext context) {
    // Get screen size using MediaQuery
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        children: [
          BlocBuilder<RideBloc, RideState>(
            builder: (context, state) {
              if (state is PicupSimulationState) {
                return MapboxPicupSimulation(
                  startPoint: state.currentlocation,
                  endPoint: state.picuplocation,
                );
              }
    
              if (state is ReachedButtonEnabledState) {
                final previousState = context.read<RideBloc>().previousState;
                if (previousState is PicupSimulationState) {
                  return MapboxPicupSimulation(
                    startPoint: previousState.currentlocation,
                    endPoint: previousState.picuplocation,
                  );
                }
              }
    
              return const MapboxWidget();
            },
          ),
          BlocListener<RideBloc, RideState>(
            listener: (context, state) async {
              if (state is RideAcceptedstate) {
                showLoadingDialog(context);
                await Future.delayed(const Duration(seconds: 4));
                if (Navigator.canPop(context)) Navigator.pop(context);
                rideData = state.rideData;
                showRideDetailsSheet(context, rideData!);
              }
            },
            child: BlocBuilder<RideBloc, RideState>(
              builder: (context, state) {
                if (state is RideRequestVisible) {
                  return Stack(
                    children: [
                      // Reject Button
                      Positioned(
                        bottom: screenHeight * 0.18 + 150,
                        right: screenWidth / 7.5 - 25,
                        child: FloatingActionButton(
                          onPressed: () {
                            BlocProvider.of<RideBloc>(context)
                                .add(RideRejected());
                          },
                          backgroundColor: Colors.white,
                          elevation: 5.0,
                          shape: const CircleBorder(),
                          child: const Icon(Icons.close,
                              color: Colors.black, size: 29.0),
                        ),
                      ),
    
                      RideRequestCard(
                        rideRequestData: state.requestData,
                        onAccept: () {
                          BlocProvider.of<RideBloc>(context)
                              .add(RideAcceptedEvent());
                        },
                        livelocation: currentLocation,
                      ),
                    ],
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
    
          Positioned(
            top: screenHeight * 0.04,  // 2% from the top
            right: screenWidth * 0.04,  // 4% from the right
            child: BlocBuilder<RideBloc, RideState>(
              buildWhen: (previous, current) =>
                  current is RideOnlineState, 
              builder: (context, state) {
                bool isOnline = state is RideOnlineState && state.isOnline;
    
                return CustomSwitch(
                  value: isOnline,
                  onChanged: (value) {
                    BlocProvider.of<RideBloc>(context)
                        .add(ToggleOnlineStatus(value));
                  },
                );
              },
            ),
          ),
    
          Positioned(
            bottom: screenHeight * 0.05, // 5% from the bottom
            right: screenWidth * 0.07,   // 7% from the right
            child: FloatingActionButton(
              onPressed: () {
                if (rideData != null) {
                  showRideDetailsSheet(context, rideData!);
                }
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25), // Set the border radius here
              ),
              backgroundColor: Colors.white,
              child: const Icon(Icons.radio_button_unchecked, size: 40, color: Colors.blue),
            ),
          ),
        ],
      ),
    );
  }

  void showRideDetailsSheet(
      BuildContext context, Map<String, dynamic>? rideData) {
    if (rideData == null) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
      ),
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return RideDetailsBottomSheet(rideData: rideData);
      },
    );
  }
}
