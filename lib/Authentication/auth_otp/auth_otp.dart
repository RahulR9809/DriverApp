import 'package:employerapp/Authentication/auth_signup/auth_signup.dart';
import 'package:employerapp/Authentication/bloc/auth_bloc.dart';
import 'package:employerapp/Authentication/registeration/registeration.dart';
import 'package:employerapp/controller/auth_controller.dart';
import 'package:employerapp/core/colors.dart';
import 'package:employerapp/widgets/refactored.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OtpPage extends StatefulWidget {
  const OtpPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _OtpPageState createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  final List<TextEditingController> _otpControllers =
      List.generate(4, (_) => TextEditingController());

  void onChanged(String value, int index) {
    if (value.length == 1) {
      if (index < 3) {
        FocusScope.of(context).nextFocus();
      }
    } else if (value.isEmpty) {
      if (index > 0) {
        FocusScope.of(context).previousFocus();
      }
    }
  }

  String getFullOtp() {
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
    final authService = AuthService();
    return BlocProvider(
      create: (context) => AuthBloc(authService: authService),
      child: Scaffold(
        body: Stack(
          children: [
            // Gradient background
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: gradientlist,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
            Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Container for GIF or Image
                    Container(
                      height: 250, // Height for the GIF container
                      decoration: BoxDecoration(
                        color: white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.asset(
                          'asset/otp.png', // Corrected asset path
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),

                    const SizedBox(height: 40),
                    const Text(
                      'Enter the OTP sent to your email',
                      style: TextStyle(
                        fontSize: 20,
                        color: white,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 40),

                    // Row of OTP input boxes
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(4, (index) {
                        return _buildOtpBox(index);
                      }), // 4 OTP boxes
                    ),

                    const SizedBox(height: 30),

                    // Resend and Confirm Buttons
                    BlocConsumer<AuthBloc, AuthState>(
                      listener: (context, state) {
                        if (state is LoadedState) {
                          showSnackBar(
                              context, 'OTP sent successfully', Colors.green);
                        } else if (state is ErrorState) {
                          showSnackBar(context, 'Failed', red);
                        } else if (state is LoadingState) {
                          const CircularProgressIndicator();
                        } else if (state is VerifiedState) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const DriverRegistrationPage()),
                          );
                        }
                      },
                      builder: (context, state) {
                        if (state is LoadingState) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ReusableButton(
                                text: 'Resend',
                                onPressed: () {
                                  final email = signupemailcontroller.text;

                                  BlocProvider.of<AuthBloc>(context)
                                      .add(ResendOtPEvent(email: email));
                                }),
                            ReusableButton(
                                text: 'Confirm',
                                onPressed: () {
                                  final otp = getFullOtp();
                                  BlocProvider.of<AuthBloc>(context)
                                      .add(SubmitOTPEvent(otp: otp));
                                })
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper function to create OTP input field boxes
  Widget _buildOtpBox(int index) {
    return SizedBox(
      width: 60,
      child: TextField(
        controller: _otpControllers[index],
        onChanged: (value) => onChanged(value, index),
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        decoration: InputDecoration(
          filled: true,
          fillColor: white,
          counterText: '',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.transparent),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.blueAccent, width: 2),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.grey, width: 1),
          ),
        ),
        style: const TextStyle(fontSize: 24, color: Colors.black),
      ),
    );
  }
}
