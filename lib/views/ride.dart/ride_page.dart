import 'package:employerapp/controllers/ride_bloc/ride_bloc.dart';
import 'package:employerapp/repository/chat_socketcontroller.dart';
import 'package:employerapp/views/map/map_pages.dart';
import 'package:employerapp/controllers/ride_bloc/ride_event.dart';
import 'package:employerapp/controllers/ride_bloc/ride_state.dart';
import 'package:employerapp/widgets/refactored_widget.dart';
import 'package:employerapp/widgets/ride_widget.dart';
import 'package:employerapp/widgets/ridestrart_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
              } else if (state is RideCancelledState) {
                showSnackBar(
                    context, 'Ride Cancelled Successfully', Colors.green);

                const MapboxWidget();
              }
            },
            child: BlocBuilder<RideBloc, RideState>(
              builder: (context, state) {
                if (state is RideRequestVisible) {
                  return Stack(
                    children: [
                      Center(
                        child: RideRequestCard(
                          rideRequestData: state.requestData,
                          onAccept: () {
                            BlocProvider.of<RideBloc>(context)
                                .add(RideAcceptedEvent());
                          },
                          onReject: (){
                             BlocProvider.of<RideBloc>(context)
                                  .add(RideRejected());
                          },
                          livelocation: currentLocation,
                        ),
                      ),
                    ],
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
          Positioned(
            top: screenHeight * 0.04,
            right: screenWidth * 0.04,
            child: BlocBuilder<RideBloc, RideState>(
              buildWhen: (previous, current) => current is RideOnlineState,
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
            bottom: screenHeight * 0.05,
            right: screenWidth * 0.07,
            child: FloatingActionButton(
              onPressed: () {
                if (rideData != null) {
                  showRideDetailsSheet(context, rideData!);
                }
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
              backgroundColor: Colors.white,
              child: const Icon(Icons.radio_button_unchecked,
                  size: 40, color: Colors.blue),
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
