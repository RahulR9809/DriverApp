// import 'package:employerapp/ridepage.dart/bloc/ride_bloc.dart';
// import 'package:employerapp/ridepage.dart/bloc/ride_event.dart';
// import 'package:employerapp/ridepage.dart/bloc/ride_state.dart';
// import 'package:employerapp/widgets/refactored.dart';
// import 'package:employerapp/widgets/ride_widget.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_map/flutter_map.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class RidePage extends StatefulWidget {
//   const RidePage({super.key});

//   @override
//   State<RidePage> createState() => _RidePageState();
// }

// class _RidePageState extends State<RidePage> {
//   bool isOnline = false; // State to manage the online/offline toggle
//   String currentLocation = '';
//   Map<String, dynamic>? rideData; // To store ride details after acceptance

//   @override
//   Widget build(BuildContext context) {
//     final mapController = MapController();
//     return SafeArea(
//       child: Scaffold(
//         body: Stack(
//           children: [
//             // Map Widget
//             MapboxWidget(controller: mapController),

//             // Bloc Listener for RideSuccess state
//             BlocListener<RideBloc, RideState>(
//               listener: (context, state) async {
//                 if (state is RideAcceptedstate) {
//                   showLoadingDialog(context); // Show the loading dialog

//                   // Simulating loading time (replace with actual logic)
//                   await Future.delayed(const Duration(seconds: 4));

//                   // Dismiss the dialog and show RideDetailsSheet
//                   Navigator.pop(context);
//                   setState(() {
//                     // ignore: unnecessary_cast
//                     rideData = (state as RideAcceptedstate).rideData;
//                   });

//                   if (kDebugMode) {
//                     print('this is ride data$rideData');
//                   }

//                   // Show Bottom Sheet after dialog is dismissed
//                   void showRideDetailsSheet(BuildContext context, Map<String, dynamic> rideData) {
//   showModalBottomSheet(
//     context: context,
//     builder: (context) => Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Text('Ride Details'),
//           const SizedBox(height: 16),
//           Text('Ride Data: $rideData'),
//         ],
//       ),
//     ),
//   );
// }

//                 }
//               },
//               child: BlocBuilder<RideBloc, RideState>(
//                 builder: (context, state) {
//                   if (state is RideRequestVisible) {
//                     return Stack(
//                       children: [
//                         // Reject Button
//                         Positioned(
//                           bottom: MediaQuery.of(context).size.height * 0.16 + 150,
//                           right: MediaQuery.of(context).size.width / 7.5 - 25,
//                           child: FloatingActionButton(
//                             onPressed: () {
//                               BlocProvider.of<RideBloc>(context)
//                                   .add(RideRejected());
//                             },
//                             backgroundColor: Colors.white,
//                             elevation: 5.0,
//                             shape: const CircleBorder(),
//                             child: const Icon(Icons.close,
//                                 color: Colors.black, size: 29.0),
//                           ),
//                         ),

//                         // Ride Request Card
//                         RideRequestCard(
//                           rideRequestData: state.requestData,
//                           onAccept: () {
//                             BlocProvider.of<RideBloc>(context)
//                                 .add(RideAccepted());
//                           },
//                           livelocation: currentLocation,
//                         ),
//                       ],
//                     );
//                   }
//                   return const SizedBox.shrink();
//                 },
//               ),
//             ),

//             Positioned(
//               top: 16,
//               right: 16,
//               child: CustomSwitch(
//                 value: isOnline,
//                 onChanged: (value) async {
//                   setState(() {
//                     isOnline = value;
//                   });
//                   if (isOnline) {
//                     final locationService = LocationService();
//                     try {
//                       final location = await locationService.getCurrentLocation(
//                         predefinedLatitude: 9.93213798131877,
//                         predefinedLongitude: 76.31803168453493,
//                       );
//                       SharedPreferences ridelocation =
//                           await SharedPreferences.getInstance();
//                       await ridelocation.setString(
//                           'ridelocation', location.toString());
//                       if (kDebugMode) {
//                         print("Predefined Location: $location");
//                       }
//                       currentLocation = location.toString();

//                       // Connect to the socket
//                       BlocProvider.of<RideBloc>(context).connectSocket(context);
//                     } catch (e) {
//                       if (kDebugMode) {
//                         print("Error getting location: $e");
//                       }
//                     }
//                   } else {
//                     // Disconnect from the socket
//                     BlocProvider.of<RideBloc>(context)
//                         .socketService
//                         .disconnect();
//                   }
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }







// import 'package:employerapp/controller/chat_socketcontroller.dart';
// import 'package:employerapp/ridepage.dart/bloc/ride_bloc.dart';
// import 'package:employerapp/ridepage.dart/bloc/ride_event.dart';
// import 'package:employerapp/ridepage.dart/bloc/ride_state.dart';
// import 'package:employerapp/widgets/refactored.dart';
// import 'package:employerapp/widgets/ride_widget.dart';
// import 'package:employerapp/widgets/ridestrart_widget.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// class RidePage extends StatefulWidget {
//   const RidePage({super.key});

//   @override
//   State<RidePage> createState() => _RidePageState();
// }

// class _RidePageState extends State<RidePage> {
//   bool isOnline = false; // State to manage the online/offline toggle
//   String currentLocation = '';
//   Map<String, dynamic>? rideData; // To store ride details after acceptance
//   bool isRideAccepted = false; // State to manage the floating button visibility
//   DriverSocketChatService driverSocketChatService = DriverSocketChatService();

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         body: Stack(
//           children: [
//             // Map Widget
//             const MapboxWidget(),

//             // Bloc Listener for RideAcceptedState
//             BlocListener<RideBloc, RideState>(
//               listener: (context, state) async {
//                 if (state is RideAcceptedstate) {
//                   // Show Loading Dialog
//                   showLoadingDialog(context);

//                   // Simulating API or loading delay
//                   await Future.delayed(const Duration(seconds: 4));

//                   // Close the dialog
//                   if (Navigator.canPop(context)) Navigator.pop(context);

//                   // // Update ride data
//                   // setState(() {
//                   //   rideData = state.rideData;
//                   //   isRideAccepted =
//                   //       true; // Show floating button after acceptance
//                   // });
//                   isRideAccepted = true;
//                   // Show Ride Details Bottom Sheet
//                   showRideDetailsSheet(context, rideData!);
//                 }
//               },
//               child:
//                   BlocBuilder<RideBloc, RideState>(builder: (context, state) {
//                 if (state is RideRequestVisible) {
//                   return Stack(
//                     children: [
//                       // Reject Button
//                       Positioned(
//                         bottom: MediaQuery.of(context).size.height * 0.16 + 150,
//                         right: MediaQuery.of(context).size.width / 7.5 - 25,
//                         child: FloatingActionButton(
//                           onPressed: () {
//                             BlocProvider.of<RideBloc>(context)
//                                 .add(RideRejected());
//                           },
//                           backgroundColor: Colors.white,
//                           elevation: 5.0,
//                           shape: const CircleBorder(),
//                           child: const Icon(Icons.close,
//                               color: Colors.black, size: 29.0),
//                         ),
//                       ),

//                       // Ride Request Card
//                       RideRequestCard(
//                         rideRequestData: state.requestData,
//                         onAccept: () {
//                           BlocProvider.of<RideBloc>(context)
//                               .add(RideAccepted());
//                         },
//                         livelocation: currentLocation,
//                       ),
//                     ],
//                   );
//                 }
//                 return const SizedBox.shrink();
//               }),
//             ),

//             Positioned(
//               top: 16,
//               right: 16,
//               child: BlocBuilder<RideBloc, RideState>(
//                 builder: (context, state) {
//                   bool isOnline = false; // Default state

//                   if (state is RideOnlineState) {
//                     isOnline = state.isOnline; // Update from Bloc state
//                   }

//                   return CustomSwitch(
//                     value: isOnline,
//                     onChanged: (value) {
//                       // Dispatch event to toggle online status
//                       BlocProvider.of<RideBloc>(context)
//                           .add(ToggleOnlineStatus(value));
//                     },
//                   );
//                 },
//               ),
//             ),

//             if (isRideAccepted) // Only show the floating button after ride acceptance
//               Positioned(
//                 bottom: 30,
//                 right: 30,
//                 child: FloatingActionButton(
//                   onPressed: () {
//                     if (rideData != null) {
//                       showRideDetailsSheet(context, rideData!);

//                       // In your existing RidePage widget
//                     }
//                   },
//                   backgroundColor: Colors.blue,
//                   child: const Icon(Icons.info, size: 30),
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }

// // In your existing RidePage widget

//   void showRideDetailsSheet(
//       BuildContext context, Map<String, dynamic>? rideData) {
//     if (rideData == null) return;

//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
//       ),
//       backgroundColor: Colors.transparent,
//       builder: (BuildContext context) {
//         return RideDetailsBottomSheet(rideData: rideData);
//       },
//     );
//   }
// }

// class CustomSwitch extends StatelessWidget {
//   final bool value;
//   final ValueChanged<bool> onChanged;

//   const CustomSwitch({super.key, required this.value, required this.onChanged});

//   @override
//   Widget build(BuildContext context) {
//     return Transform.scale(
//       scale: 1.5, // Makes the switch larger
//       child: Switch(
//         value: value,
//         onChanged: onChanged,
//         activeColor: Colors.white,
//         activeTrackColor: Colors.green.shade800,
//         inactiveThumbColor: Colors.white,
//         inactiveTrackColor: Colors.red.shade700,
//         thumbColor:
//             MaterialStateProperty.all(Colors.blue.shade600), // Corrected here
//         trackColor: MaterialStateProperty.all(
//             const Color.fromARGB(255, 115, 117, 122)), // Corrected here
//         splashRadius: 30.0, // Adds a nice splash effect
//         overlayColor: MaterialStateProperty.all(
//             Colors.green.shade300.withOpacity(0.5)), // Corrected here
//       ),
//     );
//   }
// }




import 'package:employerapp/controller/chat_socketcontroller.dart';
import 'package:employerapp/ridepage.dart/bloc/ride_bloc.dart';
import 'package:employerapp/ridepage.dart/bloc/ride_event.dart';
import 'package:employerapp/ridepage.dart/bloc/ride_state.dart';
import 'package:employerapp/widgets/refactored.dart';
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
  Map<String, dynamic>? rideData; // To store ride details after acceptance
  bool isRideAccepted = false; // State to manage the floating button visibility
  DriverSocketChatService driverSocketChatService = DriverSocketChatService();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            // Map Widget
            const MapboxWidget(),

            // Bloc Listener for RideAcceptedState
            BlocListener<RideBloc, RideState>(
              listener: (context, state) async {
                if (state is RideAcceptedstate) {
                  // Show Loading Dialog
                  showLoadingDialog(context);

                  // Simulating API or loading delay
                  await Future.delayed(const Duration(seconds: 4));

                  // Close the dialog
                  if (Navigator.canPop(context)) Navigator.pop(context);

                  // Update ride data
                  setState(() {
                    rideData = state.rideData;
                    isRideAccepted = true; // Show floating button
                  });

                  // Show Ride Details Bottom Sheet
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
                          bottom: MediaQuery.of(context).size.height * 0.16 + 150,
                          right: MediaQuery.of(context).size.width / 7.5 - 25,
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

                        // Ride Request Card
                        RideRequestCard(
                          rideRequestData: state.requestData,
                          onAccept: () {
                          BlocProvider.of<RideBloc>(context).add(RideAcceptedEvent());

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

            // Online/Offline Toggle Switch
            Positioned(
              top: 16,
              right: 16,
              child: BlocBuilder<RideBloc, RideState>(
                buildWhen: (previous, current) =>
                    current is RideOnlineState, // Update only for online state
                builder: (context, state) {
                  bool isOnline = state is RideOnlineState && state.isOnline;

                  return CustomSwitch(
                    value: isOnline,
                    onChanged: (value) {
                      BlocProvider.of<RideBloc>(context)
                          .add(ToggleOnlineStatus(value));
                          // Navigator.push(context, MaterialPageRoute(builder: (context)=>ChatPage()));
                    },
                  );
                },
              ),
            ),

            // Floating Action Button for Ride Details
            if (isRideAccepted)
              Positioned(
                bottom: 30,
                right: 30,
                child: FloatingActionButton(
                  onPressed: () {
                    if (rideData != null) {
                      showRideDetailsSheet(context, rideData!);
                    }
                  },
                  backgroundColor: Colors.blue,
                  child: const Icon(Icons.info, size: 30),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // Show Ride Details Bottom Sheet
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

// Custom Switch Widget
class CustomSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const CustomSwitch({super.key, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: 1.5, // Makes the switch larger
      child: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: Colors.white,
        activeTrackColor: Colors.green.shade800,
        inactiveThumbColor: Colors.white,
        inactiveTrackColor: Colors.red.shade700,
        thumbColor:
            MaterialStateProperty.all(Colors.blue.shade600), // Corrected here
        trackColor: MaterialStateProperty.all(
            const Color.fromARGB(255, 115, 117, 122)), // Corrected here
        splashRadius: 30.0,
        overlayColor: MaterialStateProperty.all(
            Colors.green.shade300.withOpacity(0.5)),
      ),
    );
  }
}
