


import 'package:employerapp/chat/chat_page.dart';
import 'package:flutter/material.dart';

class RideDetailsBottomSheet extends StatelessWidget {
  final Map<String, dynamic> rideData;

  const RideDetailsBottomSheet({super.key, required this.rideData});

  @override
  Widget build(BuildContext context) {
    final pickUpLocation = rideData['pickUpLocation'] ?? 'Unknown';

    return DraggableScrollableSheet(
      initialChildSize: 0.4, // Initially expanded to 40%
      minChildSize: 0.1, // Minimum height of 10%
      maxChildSize: 0.8, // Maximum height of 80%
      expand: false,
      builder: (BuildContext context, ScrollController scrollController) {
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
                  title: const Text('current location'),
                ),
                ListTile(
                  leading: const Icon(Icons.location_pin),
                  title: const Text('Pickup Point'),
                  subtitle: Text(pickUpLocation),
                ),
                const Divider(),

                // Action Buttons
                Container(
                  height: 80, // Set height and width to make it circular
                  width: 80,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle, // Makes the container circular
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.message),
                    color: Colors.white,
                    onPressed: () {
 Navigator.push(context, MaterialPageRoute(builder: (context)=>ChatPage()));                 },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}



class RideRequestCard extends StatelessWidget {
  final Map<String, dynamic> rideRequestData;
  final VoidCallback onAccept;
  
  final String livelocation;
  const RideRequestCard({required this.rideRequestData, required this.onAccept, super.key, required this.livelocation, });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.all(16.0),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.0),
          boxShadow:const [
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
            const Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  child: Text('Ride Request', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black)),
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
                        style: const TextStyle(fontSize: 16, color: Colors.black87),
                      ),
                    ),
                  ],
                ),
                 Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Column(
                    children: List.generate(3, (index) => const Text('.', style: TextStyle(fontWeight: FontWeight.w900))),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.location_on, color: Colors.red, size: 16),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        rideRequestData['dropOffLocation'] ?? '8 County Road 11/6, Mannington, WY',
                        style: const TextStyle(fontSize: 16, color: Colors.black87),
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
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                ),
                child: const Text(
                  'Accept',
                  style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


//  class CustomSwitch extends StatelessWidget {
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
//         thumbColor: MaterialStateProperty.all(Colors.blue.shade600), // Corrected here
//         trackColor: MaterialStateProperty.all(const Color.fromARGB(255, 115, 117, 122)), // Corrected here
//         splashRadius: 30.0, // Adds a nice splash effect
//         overlayColor: MaterialStateProperty.all(Colors.green.shade300.withOpacity(0.5)), // Corrected here
//       ),
//     );
//   }
// }



