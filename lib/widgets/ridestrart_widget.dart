import 'package:employerapp/chat/chat_page.dart';
import 'package:employerapp/ridepage.dart/bloc/ride_bloc.dart';
import 'package:employerapp/ridepage.dart/bloc/ride_state.dart';
import 'package:employerapp/ridepage.dart/otp.dart';
import 'package:employerapp/widgets/refactored.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';



class RideDetailsBottomSheet extends StatelessWidget {
  final Map<String, dynamic> rideData;

  const RideDetailsBottomSheet({Key? key, required this.rideData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
        final pickUpLocation = rideData['pickUpLocation'] ?? 'Unknown';
    return DraggableScrollableSheet(
      initialChildSize: 0.4,
      minChildSize: 0.1,
      maxChildSize: 0.8,
      expand: false,
      builder: (BuildContext context, ScrollController scrollController) {
        return BlocBuilder<RideBloc, RideState>(
          builder: (context, state) {
            final isButtonEnabled = state is ReachedButtonEnabledState;

            return SafeArea(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(26)),
                ),
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(16.0),
              children: [
                // Driver Details
                Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.grey.shade200,
                      child: Icon(
                        Icons.person, // Pass your icon here
                        size: 30,
                        color: Colors.black, // Adjust the color as needed
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Head to Customer s Location',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const Divider(),

                // Location Details
                ListTile(
                  leading: const Icon(Icons.flag),
                  title: const Text('Current location'),
                ),
                ListTile(
                  leading: const Icon(Icons.location_pin),
                  title: const Text('Pickup Point'),
                  subtitle: Text(pickUpLocation),
                ),
                const Divider(),
                SizedBox(
                  height: 20,
                ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => ChatPage()),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.black,
                            backgroundColor: Colors.greenAccent,
                          ),
                          child: const Icon(Icons.message),
                        ),
                        ElevatedButton(
                          onPressed: isButtonEnabled
                              ? () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(builder: (context) => OtpRideStart(rideData:rideData,)),
                                  );
                                }
                              : null,
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.black,
                            backgroundColor: isButtonEnabled
                                ? Colors.greenAccent
                                : Colors.grey,
                          ),
                          child: const Text('Reached'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}




class ReusableButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color buttonColor;

  const ReusableButton({
    required this.text,
    required this.onPressed,
    required this.buttonColor,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: buttonColor, // Use dynamic color based on the state
      ),
      child: Text(text),
    );
  }
}


class RideRequestCard extends StatelessWidget {
  final Map<String, dynamic> rideRequestData;
  final VoidCallback onAccept;
  final String livelocation;

  const RideRequestCard({
    required this.rideRequestData,
    required this.onAccept,
    super.key,
    required this.livelocation,
  });

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.all(20.0),
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.0),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 6.0,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Text(
                    'Ride Request',
                    style: TextStyle(
                      fontSize: screenWidth * 0.06,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.circle, color: Colors.blue, size: 16),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        rideRequestData['pickUpLocation'],
                        style: TextStyle(
                          fontSize: screenWidth * 0.045,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.location_on, color: Colors.red, size: 16),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        rideRequestData['dropOffLocation'] ??
                            'Unknown Location',
                        style: TextStyle(
                          fontSize: screenWidth * 0.045,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onAccept,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  padding: EdgeInsets.symmetric(
                    vertical: screenHeight * 0.02,
                  ),
                ),
                child: Text(
                  'Accept',
                  style: TextStyle(
                    fontSize: screenWidth * 0.05,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

