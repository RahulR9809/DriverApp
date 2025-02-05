import 'package:employerapp/views/auth/login_page.dart';
import 'package:employerapp/views/auth/otp_page.dart';
import 'package:employerapp/controllers/auth_bloc/auth_bloc.dart';
import 'package:employerapp/core/colors.dart';
import 'package:employerapp/widgets/refactored_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final TextEditingController signupemailcontroller = TextEditingController();

class AuthSignup extends StatelessWidget {
  AuthSignup({super.key});
  final TextEditingController signupnamecontroller = TextEditingController();
  final TextEditingController signupphonecontroller = TextEditingController();
  final TextEditingController signuppasswordcontroller =
      TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration:
                const BoxDecoration(gradient: CustomColors.backgroundGradient),
          ),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(32.0),
              child: Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 40),
                      child: const Column(
                        children: [
                          Icon(
                            Icons.electric_car,
                            size: 80,
                            color: CustomColors.white,
                          ),
                          SizedBox(height: 20),
                          Text(
                            'Electra Ride',
                            style: TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                              color: CustomColors.white,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Your Eco-Friendly Travel Solution',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
                    ReusableTextField(
                      controller: signupnamecontroller,
                      label: 'Name',
                      icon: Icons.person,
                    ),
                    const SizedBox(height: 16),
                    ReusableTextField(
                      controller: signupemailcontroller,
                      label: 'Email',
                      icon: Icons.email,
                    ),
                    const SizedBox(height: 16),
                    ReusableTextField(
                      controller: signupphonecontroller,
                      label: 'Phone',
                      icon: Icons.phone,
                    ),
                    const SizedBox(height: 16),
                    ReusableTextField(
                      controller: signuppasswordcontroller,
                      label: 'Password',
                      icon: Icons.lock,
                      isPassword: true,
                    ),
                    const SizedBox(height: 24),
                    BlocConsumer<AuthBloc, AuthState>(
                      listener: (context, state) {
                        if (state is SignupSuccess) {
                          showSnackBar(
                              context,
                              'OTP sent to verify your account',
                              CustomColors.green);

                          Future.delayed(const Duration(milliseconds: 500), () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const OtpPage()),
                            );
                          });
                        } else if (state is ErrorState) {
                          showSnackBar(context, 'Failed to create an account',
                              CustomColors.red);
                        }
                      },
                      builder: (context, state) {
                        if (state is LoadingState) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                        return ReusableButton(
                          text: 'Sign Up',
                          onPressed: () {
                            if (!_validateFields(context)) return;

                            final name = signupnamecontroller.text;
                            final email = signupemailcontroller.text;
                            final phone = signupphonecontroller.text;
                            final password = signuppasswordcontroller.text;
                            BlocProvider.of<AuthBloc>(context).add(
                              SignUpButtonClickedEvent(
                                name: name,
                                email: email,
                                phone: phone,
                                password: password,
                              ),
                            );
                          },
                        );
                      },
                    ),
                    const SizedBox(height: 50),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Already have an account?',
                          style: TextStyle(color: CustomColors.white),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const Login()),
                            );
                          },
                          child: const Text(
                            'Login',
                            style: TextStyle(color: CustomColors.white),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool _validateFields(BuildContext context) {
    if (signupnamecontroller.text.isEmpty) {
      showSnackBar(context, 'Name cannot be empty', CustomColors.red);
      return false;
    }

    final email = signupemailcontroller.text;
    final emailRegex =
        RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if (email.isEmpty) {
      showSnackBar(context, 'Email cannot be empty', CustomColors.red);
      return false;
    } else if (!emailRegex.hasMatch(email)) {
      showSnackBar(context, 'Please enter a valid email', CustomColors.red);
      return false;
    }

    final phone = signupphonecontroller.text;
    if (phone.isEmpty) {
      showSnackBar(context, 'Phone cannot be empty', CustomColors.red);
      return false;
    } else if (phone.length != 10 || !RegExp(r'^\d{10}$').hasMatch(phone)) {
      showSnackBar(
          context, 'Phone number must be exactly 10 digits', CustomColors.red);
      return false;
    }

    final password = signuppasswordcontroller.text;
    if (password.isEmpty) {
      showSnackBar(context, 'Password cannot be empty', CustomColors.red);
      return false;
    } else if (password.length < 6) {
      showSnackBar(
          context, 'Password must be at least 6 characters', CustomColors.red);
      return false;
    }

    return true;
  }
}
