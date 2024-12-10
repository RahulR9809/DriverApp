// import 'package:employerapp/core/colors.dart';
// import 'package:employerapp/ridepage.dart/ridepage.dart';
// import 'package:employerapp/widgets/ride_widget.dart';
// import 'package:flutter/material.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class StatusPage extends StatefulWidget {
//   const StatusPage({super.key});

//   @override
//   State<StatusPage> createState() => _StatusPageState();
// }

// class _StatusPageState extends State<StatusPage>
//     with SingleTickerProviderStateMixin {
//   bool isOnline = false; // State to manage the online/offline toggle
//   bool isNavigating = false; // State to prevent multiple navigations
//   late AnimationController _controller; // Controller for the pulse animation
//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       duration: const Duration(seconds: 2),
//       vsync: this,
//     )..repeat(reverse: true); // Repeats the pulse animation
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             colors: isOnline
//                 ? [Colors.green.shade300, Colors.green.shade800]
//                 : [Colors.red.shade300, Colors.red.shade800],
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//           ),
//         ),
//         child: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               // Dynamic image with shadow
//               Container(
//                 decoration: BoxDecoration(),
//                 child: Image.asset(
//                   isOnline ? 'asset/online (1).png' : 'asset/offline.png',
//                   height: 250,
//                   width: 250,
//                 ),
//               ),

//               const SizedBox(height: 30), // Space between image and button

//               // Status Label
//               Text(
//                 isOnline ? "You Are Online!" : "You Are Offline!",
//                 style: TextStyle(
//                   fontSize: 22,
//                   fontWeight: FontWeight.bold,
//                   color: white,
//                   shadows: [
//                     Shadow(
//                       color: black,
//                       offset: const Offset(2, 2),
//                       blurRadius: 5,
//                     ),
//                   ],
//                 ),
//               ),

//               const SizedBox(height: 30), // Space between label and toggle

//               // Custom Toggle Switch
//               Transform.scale(
//                 scale: 1.5, // Makes the switch larger
//                 child: Switch(
//                   value: isOnline,
//                   onChanged: (value) async {
//                     setState(() {
//                       isOnline = value; // Update the state
//                     });

//                     if (value && !isNavigating) {
//                       setState(() {
//                         isNavigating = true;
//                       });
//                       Future.delayed(const Duration(seconds: 2), () async {
//                         if (isOnline) {
//                           final locationService = LocationService();
//                           try {
//                          final location =
//                                 (await locationService.getCurrentLocation(
//                               predefinedLatitude: 37.7749,
//                               predefinedLongitude: -122.4194,
//                             )) ;
//                                SharedPreferences ridelocation = await SharedPreferences.getInstance();
//                          await ridelocation.setString('ridelocation', location as String);
//                             print(
//                                 "Predefined Location: ${location}");
//                           } catch (e) {
//                             print(e);
//                           }

                      
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                                 builder: (context) => RidePage()),
//                           ).then((_) {
//                             // Reset navigation state when back from Ridepage
//                             setState(() {
//                               isNavigating = false;
//                             });
//                           });
//                         } else {
//                           setState(() {
//                             isNavigating = false;
//                           });
//                         }
//                       });
//                     }
//                   },
//                   activeColor: white,
//                   activeTrackColor: Colors.green.shade700,
//                   inactiveThumbColor: white,
//                   inactiveTrackColor: Colors.red.shade700,
//                 ),
//               ),

//               const SizedBox(height: 40), // Space before action button

//               // Action Button with Glow Effect
//               GestureDetector(
//                 onTap: isOnline
//                     ? () {
//                         if (!isNavigating) {
//                           setState(() {
//                             isNavigating = true;
//                           });
//                           Future.delayed(const Duration(seconds: 2), () {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                   builder: (context) => const RidePage()),
//                             ).then((_) {
//                               setState(() {
//                                 isNavigating = false;
//                               });
//                             });
//                           });
//                         }
//                       }
//                     : null,
//                 child: Stack(
//                   alignment: Alignment.center,
//                   children: [
//                     // Outer glowing circle (pulse effect)
//                     AnimatedBuilder(
//                       animation: _controller,
//                       builder: (context, child) {
//                         return Container(
//                           width: 90 + _controller.value * 10,
//                           height: 90 + _controller.value * 10,
//                           decoration: BoxDecoration(
//                             shape: BoxShape.circle,
//                             gradient: isOnline
//                                 ? RadialGradient(
//                                     colors: [
//                                       Colors.green.shade300.withOpacity(0.4),
//                                       Colors.transparent,
//                                     ],
//                                   )
//                                 : null,
//                           ),
//                         );
//                       },
//                     ),

//                     // Main button
//                     Container(
//                       width: 90,
//                       height: 90,
//                       decoration: BoxDecoration(
//                         shape: BoxShape.circle,
//                         gradient: LinearGradient(
//                           colors: isOnline
//                               ? [Colors.green.shade500, Colors.green.shade900]
//                               : [Colors.grey.shade500, Colors.grey.shade700],
//                           begin: Alignment.topLeft,
//                           end: Alignment.bottomRight,
//                         ),
//                         boxShadow: isOnline
//                             ? [
//                                 BoxShadow(
//                                   color: Colors.green.withOpacity(0.5),
//                                   blurRadius: 20,
//                                   spreadRadius: 5,
//                                 )
//                               ]
//                             : [
//                                 BoxShadow(
//                                   color: Colors.black.withOpacity(0.2),
//                                   blurRadius: 10,
//                                 ),
//                               ],
//                       ),
//                       child: Center(
//                         child: Icon(
//                           Icons.electric_car, // EV-specific icon
//                           color: white,
//                           size: 40,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

