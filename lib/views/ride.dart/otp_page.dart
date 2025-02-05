

import 'package:employerapp/controllers/ride_bloc/ride_bloc.dart';
import 'package:employerapp/controllers/ride_bloc/ride_event.dart';
import 'package:employerapp/controllers/ride_bloc/ride_state.dart';
import 'package:employerapp/views/ride.dart/ride_start_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
class OtpRideStart extends StatefulWidget {
      final Map<String, dynamic>? rideData;

  const OtpRideStart({super.key, this.rideData});

  @override
  State<OtpRideStart> createState() => _OtpRideStartState();
}

class _OtpRideStartState extends State<OtpRideStart> {
  final List<TextEditingController> _otpControllers = List.generate(
    4,
    (index) => TextEditingController(),
  );

  String _getOtp() {
    return _otpControllers.map((controller) => controller.text).join();
  }

  @override
  void dispose() {
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        leading:  Container(),
        title: const Text('Verify OTP'),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        elevation: 0,
      ),
      body: BlocListener<RideBloc, RideState>(
        listener: (context, state) {
          if (state is RideStartedState) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Ride started')),
            );
Navigator.pushReplacement(
  context,
  MaterialPageRoute(
    builder: (context) => RideStartpage(rideData: widget.rideData),
  ),
);
          } else if (state is RideErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        child: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blueAccent, Colors.lightBlue],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Enter the OTP sent to your registered mobile number',
                  style: TextStyle(
                    fontSize: 18.0,
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(4, (index) {
                    return Container(
                      width: 50,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8.0),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 6.0,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: _otpControllers[index],
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        maxLength: 1,
                        style: const TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                        ),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          counterText: '',
                          hintText: '•',
                          hintStyle: TextStyle(color: Colors.grey),
                        ),
                        onChanged: (value) {
                          if (value.isNotEmpty && index < 3) {
                            FocusScope.of(context).nextFocus();
                          } else if (value.isEmpty && index > 0) {
                            FocusScope.of(context).previousFocus();
                          }
                        },
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 30.0),
                ElevatedButton(
                  onPressed: () {
                    final otp = _getOtp();
                    if (otp.length == 4) {
                      context.read<RideBloc>().add(
                            StartRideEvent(
                              tripOtp: otp,
                            ),
                          );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please enter a valid OTP')),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 80, vertical: 15),
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    shadowColor: Colors.black38,
                    elevation: 5,
                  ),
                  child: const Text(
                    'Start Ride',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
