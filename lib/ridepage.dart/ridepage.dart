// import 'package:employerapp/ridepage.dart/bloc/ride_bloc.dart';
// import 'package:employerapp/ridepage.dart/bloc/ride_event.dart';
// import 'package:employerapp/ridepage.dart/bloc/ride_state.dart';
// import 'package:employerapp/widgets/ride_widget.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_map/flutter_map.dart';
// import 'package:mapbox_gl/mapbox_gl.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class RidePage extends StatefulWidget {
//   const RidePage({
//     super.key,
//   });

//   @override
//   State<RidePage> createState() => _RidePageState();
// }

// class _RidePageState extends State<RidePage> {
//   bool isOnline = false; // State to manage the online/offline toggle
//  String currentLocation = '';
//   @override
//   Widget build(BuildContext context) {
//     final mapController = MapController();
//     return SafeArea(
//       child: Scaffold(
//         body: Stack(
//           children: [
//             // Your map widget
//             // MapWidget(controller: mapController),
//             MapboxPolylineWidget(
//   startPoint: LatLng(12.971598, 77.594566), // Example start coordinates
//   endPoint: LatLng(12.935223, 77.624649),   // Example end coordinates
//   startImage: 'assets/images/driver.png',   // Replace with your asset path
//   endImage: 'assets/images/user.png',      // Replace with your asset path
// ),

//             // BlocBuilder to handle ride request visibility and actions
//             BlocBuilder<RideBloc, RideState>(
//               builder: (context, state) {
//                 if (state is RideRequestVisible) {
//                   return Stack(
//                     children: [
//                       // Bottom button (already in your code)
//                       Positioned(
//                         bottom: MediaQuery.of(context).size.height * 0.22 + 120,
//                         right: MediaQuery.of(context).size.width / 6.9 - 25,
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

//                       // Ride request card
//                       RideRequestCard(
//                         rideRequestData: state.requestData,
//                         onAccept: () {
//                           BlocProvider.of<RideBloc>(context).add(RideAccepted());
//                         }, livelocation:currentLocation,
//                       ),
//                     ],
//                   );
//                 }
//                 return const SizedBox.shrink();
//               },
//             ),

// CustomSwitch(
//   value: isOnline,
//   onChanged: (value) async {
//     setState(() {
//       isOnline = value;
//     });
//     if (isOnline) {
//       final locationService = LocationService();
//       try {
//         final location = await locationService.getCurrentLocation(
//           predefinedLatitude: 9.93213798131877,
//           predefinedLongitude: 76.31803168453493,
//         );
//         SharedPreferences ridelocation = await SharedPreferences.getInstance();
//         await ridelocation.setString('ridelocation', location.toString());
//         print("Predefined Location: $location");
//         currentLocation=location.toString();

//         // Connect to the socket
//         BlocProvider.of<RideBloc>(context).connectSocket(context);
//       } catch (e) {
//         print("Error getting location: $e");
//       }
//     } else {
//       // Disconnect from the socket
//       BlocProvider.of<RideBloc>(context).socketService.disconnect();
//     }
//   },
// )

//           ],
//         ),
//       ),
//     );
//   }
// }

// import 'package:employerapp/ridepage.dart/bloc/ride_bloc.dart';
// import 'package:employerapp/ridepage.dart/bloc/ride_event.dart';
// import 'package:employerapp/ridepage.dart/bloc/ride_state.dart';
// import 'package:employerapp/widgets/ride_widget.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_map/flutter_map.dart';
// import 'package:mapbox_gl/mapbox_gl.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class RidePage extends StatefulWidget {
//   const RidePage({
//     super.key,
//   });

//   @override
//   State<RidePage> createState() => _RidePageState();
// }

// class _RidePageState extends State<RidePage> {
//   bool isOnline = false; // State to manage the online/offline toggle
//  String currentLocation = '';
//   @override
//   Widget build(BuildContext context) {
//     final mapController = MapController();
//     return SafeArea(
//       child: Scaffold(
//         body: Stack(
//           children: [
//             // Your map widget
//             MapboxWidget(controller: mapController),

//             // BlocBuilder to handle ride request visibility and actions
//             BlocBuilder<RideBloc, RideState>(
//               builder: (context, state) {
//                 if (state is RideRequestVisible) {
//                   return Stack(
//                     children: [
//                       // Bottom button (already in your code)
//                       Positioned(
//                         bottom: MediaQuery.of(context).size.height * 0.22 + 120,
//                         right: MediaQuery.of(context).size.width / 6.9 - 25,
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

//                       // Ride request card
//                       RideRequestCard(
//                         rideRequestData: state.requestData,
//                         onAccept: () {
//                           BlocProvider.of<RideBloc>(context).add(RideAccepted());
//                         }, livelocation:currentLocation,
//                       ),
//                     ],
//                   );
//                 }
//                 return const SizedBox.shrink();
//               },
//             ),

// CustomSwitch(
//   value: isOnline,
//   onChanged: (value) async {
//     setState(() {
//       isOnline = value;
//     });
//     if (isOnline) {
//       final locationService = LocationService();
//       try {
//         final location = await locationService.getCurrentLocation(
//           predefinedLatitude: 9.93213798131877,
//           predefinedLongitude: 76.31803168453493,
//         );
//         SharedPreferences ridelocation = await SharedPreferences.getInstance();
//         await ridelocation.setString('ridelocation', location.toString());
//         print("Predefined Location: $location");
//         currentLocation=location.toString();

//         // Connect to the socket
//         BlocProvider.of<RideBloc>(context).connectSocket(context);
//       } catch (e) {
//         print("Error getting location: $e");
//       }
//     } else {
//       // Disconnect from the socket
//       BlocProvider.of<RideBloc>(context).socketService.disconnect();
//     }
//   },
// )

//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:employerapp/ridepage.dart/bloc/ride_bloc.dart';
import 'package:employerapp/ridepage.dart/bloc/ride_event.dart';
import 'package:employerapp/ridepage.dart/bloc/ride_state.dart';
import 'package:employerapp/widgets/refactored.dart';
import 'package:employerapp/widgets/ride_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RidePage extends StatefulWidget {
  const RidePage({super.key});

  @override
  State<RidePage> createState() => _RidePageState();
}

class _RidePageState extends State<RidePage> {
  bool isOnline = false; // State to manage the online/offline toggle
  String currentLocation = '';
  Map<String, dynamic>? rideData; // To store ride details after acceptance

  @override
  Widget build(BuildContext context) {
    final mapController = MapController();
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            // Map Widget
            MapboxWidget(controller: mapController),

            // Bloc Listener for RideSuccess state
            BlocListener<RideBloc, RideState>(
              listener: (context, state) async {
                if (state is RideAcceptedstate) {
                  showLoadingDialog(context); // Show the loading dialog

                  // Simulating loading time (replace with actual logic)
                  await Future.delayed(const Duration(seconds: 4));

                  // Dismiss the dialog and show RideDetailsSheet
                  Navigator.pop(context);
                  setState(() {
                    rideData = (state as RideAcceptedstate).rideData;
                  });
                  print('this is ride data$rideData');
                 
                }
              },
              child: BlocBuilder<RideBloc, RideState>(
                builder: (context, state) {
                  if (state is RideRequestVisible) {
                    return Stack(
                      children: [
                        // Reject Button
                        Positioned(
                          bottom:
                              MediaQuery.of(context).size.height * 0.22 + 150,
                          right: MediaQuery.of(context).size.width / 6.9 - 25,
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
                            BlocProvider.of<RideBloc>(context)
                                .add(RideAccepted());
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
              bottom: 16,
              right: 16,
              child: CustomSwitch(
                value: isOnline,
                onChanged: (value) async {
                  setState(() {
                    isOnline = value;
                  });
                  if (isOnline) {
                    final locationService = LocationService();
                    try {
                      final location = await locationService.getCurrentLocation(
                        predefinedLatitude: 9.93213798131877,
                        predefinedLongitude: 76.31803168453493,
                      );
                      SharedPreferences ridelocation =
                          await SharedPreferences.getInstance();
                      await ridelocation.setString(
                          'ridelocation', location.toString());
                      print("Predefined Location: $location");
                      currentLocation = location.toString();

                      // Connect to the socket
                      BlocProvider.of<RideBloc>(context).connectSocket(context);
                    } catch (e) {
                      print("Error getting location: $e");
                    }
                  } else {
                    // Disconnect from the socket
                    BlocProvider.of<RideBloc>(context)
                        .socketService
                        .disconnect();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
