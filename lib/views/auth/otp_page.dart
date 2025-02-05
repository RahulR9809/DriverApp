import 'package:employerapp/views/auth/signup_page.dart';
import 'package:employerapp/controllers/auth_bloc/auth_bloc.dart';
import 'package:employerapp/views/auth/registeration_page.dart';
import 'package:employerapp/repository/auth_controller.dart';
import 'package:employerapp/core/colors.dart';
import 'package:employerapp/widgets/refactored_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OtpPage extends StatefulWidget {
  const OtpPage({super.key});

  @override
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
    String otp = _otpControllers.map((controller) => controller.text).join();
    return otp;
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
            Container(
              decoration: const BoxDecoration(
                gradient: CustomColors.backgroundGradient,
              ),
            ),
            Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 250,
                      decoration: BoxDecoration(
                        color: CustomColors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.asset(
                          'asset/otp.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    const Text(
                      'Enter the OTP sent to your email',
                      style: TextStyle(
                        fontSize: 20,
                        color: CustomColors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 40),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(4, (index) {
                        return _buildOtpBox(index);
                      }),
                    ),
                    const SizedBox(height: 30),
                    BlocConsumer<AuthBloc, AuthState>(
                      listener: (context, state) {
                        if (state is LoadedState) {
                          showSnackBar(
                              context, 'OTP sent successfully', Colors.green);
                        } else if (state is ErrorState) {
                          showSnackBar(context, 'Failed', CustomColors.red);
                        } else if (state is LoadingState) {
                          if (kDebugMode) {
                            print('Loading... Please wait.');
                          }
                        } else if (state is VerifiedState) {
                          if (kDebugMode) {
                            print('OTP verified successfully');
                          }
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
          fillColor: CustomColors.white,
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
