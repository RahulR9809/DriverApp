import 'package:flutter/material.dart';

class PaymentPending extends StatefulWidget {
  final Map<String, dynamic>? rideData;

  const PaymentPending({super.key, this.rideData});

  @override
  State<PaymentPending> createState() => _PaymentPendingState();
}

class _PaymentPendingState extends State<PaymentPending> {
  @override
  Widget build(BuildContext context) {
    // Extracting ride data safely
    final rideData = widget.rideData ?? {};
    final acceptRide = rideData['acceptRide'] ?? {};

    final startLocation = acceptRide['startLocation'] ?? {};
    final endLocation = acceptRide['endLocation'] ?? {};
    final fare = acceptRide['fare'] ?? 0.0;
    final distance = acceptRide['distance'] ?? 0;
    final tripStatus = acceptRide['tripStatus'] ?? 'Unknown';
    final pickUpLocation = acceptRide['pickUpLocation'] ?? 'Not available';
    final dropOffLocation = acceptRide['dropOffLocation'] ?? 'Not available';
    final paymentStatus = acceptRide['isPaymentComplete'] ?? false;

    // GST Calculation (assuming 18% GST)
    const gstPercentage = 18.0;
    final gstAmount = (fare * gstPercentage) / 100;
    final totalAmount = fare + gstAmount;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment Pending'),
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Bill Header
            const Text(
              'Ride Invoice',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
            const SizedBox(height: 20),
            
            // Trip Status and Details
            _buildSectionTitle('Trip Details'),
            const SizedBox(height: 10),
            _buildDetailsRow('Trip Status:', tripStatus),
            const SizedBox(height: 10),
            _buildDetailsRow('Pick-Up Location:', pickUpLocation),
            _buildDetailsRow('Drop-Off Location:', dropOffLocation),

            const SizedBox(height: 20),
            const Divider(color: Colors.black26),

            // Fare and Distance Breakdown
            _buildSectionTitle('Fare Breakdown'),
            const SizedBox(height: 10),
            _buildDetailsRow('Fare:', '\$${fare.toStringAsFixed(2)}'),
            _buildDetailsRow('Distance:', '$distance km'),

            const SizedBox(height: 20),
            const Divider(color: Colors.black26),

            // GST Breakdown
            _buildSectionTitle('GST Breakdown'),
            const SizedBox(height: 10),
            _buildDetailsRow('GST (${gstPercentage.toStringAsFixed(0)}%):', '\$${gstAmount.toStringAsFixed(2)}'),

            const SizedBox(height: 20),
            const Divider(color: Colors.black26),

            // Total Amount
            _buildSectionTitle('Total Amount'),
            const SizedBox(height: 10),
            _buildDetailsRow('Total Amount:', '\$${totalAmount.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                )),

            const SizedBox(height: 20),
            const Divider(color: Colors.black26),

            // Payment Status
            _buildSectionTitle('Payment Status'),
            const SizedBox(height: 10),
            Text(
              'Payment Status: ${paymentStatus ? 'Completed' : 'Pending'}',
              style: TextStyle(
                fontSize: 16,
                color: paymentStatus ? Colors.green : Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            // Action Button for Driver: "Awaiting Payment"
            ElevatedButton(
              onPressed: () {
                // Handle driver-side logic for viewing payment status or waiting
              },
              child: Text(paymentStatus ? 'Payment Completed' : 'Payment Pending'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                backgroundColor: paymentStatus ? Colors.green : Colors.orange,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                textStyle: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget for displaying section title
  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.blueGrey,
      ),
    );
  }

  // Widget for displaying detail rows (label and value)
  Widget _buildDetailsRow(String label, String value, {TextStyle? style}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: style ??
              const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
        ),
      ],
    );
  }
}
