import 'package:employerapp/Authentication/auth_signup/auth_signup.dart';
import 'package:employerapp/Authentication/bloc/auth_bloc.dart';
import 'package:employerapp/Authentication/pending_page/pending.dart';
import 'package:employerapp/core/colors.dart';
import 'package:employerapp/mainpage/mainpage.dart';
import 'package:employerapp/widgets/refactored.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quickalert/models/quickalert_type.dart';

class Login extends StatelessWidget {
  const Login({super.key});



  @override
  Widget build(BuildContext context) {
    final usernameController = TextEditingController();
    final passwordController = TextEditingController();

    return Scaffold(
      body: Stack(
        children: [
          // Background with a gradient color
          Container(
              decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [CustomColors.black, CustomColors.darkGrey],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
          ),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(32.0),
              child: BlocListener<AuthBloc, AuthState>(
                listener: (context, state) {
                  if (state is LoadingState) {
                    const CircularProgressIndicator();
                  } else if (state is ErrorState) {
ReachedDialog.showLocationReachedDialog(context,
                text: 'Wrong email or password.',
                title: 'Error',
                type: QuickAlertType.warning);                  }
                   else if (state is PendingState) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const PendingPage()),
                    );
                  } 
                  else if (state is LoadedState) {
                    showSnackBar(context, 'Successfully logged in', CustomColors.green);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const MainPage()),
                    );
                  } else if (state is BlockedState) {
ReachedDialog.showLocationReachedDialog(context,
                text: 'Your account has been blocked. Please contact support',
                title: 'Access Denied!',
                type: QuickAlertType.error);                  }
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Branding Area
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
                              color:CustomColors.lightGrey,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Input Fields with Cards
                    ReusableTextField(
                      controller: usernameController,
                      label: 'Email',
                      icon: Icons.email,
                    ),

                    const SizedBox(height: 16),

                    ReusableTextField(
                      controller: passwordController,
                      label: 'Password',
                      icon: Icons.lock,
                      isPassword: true,
                    ),

                    const SizedBox(height: 24),

                    // Login Button
                    ReusableButton(
                      text: 'Login',
                      onPressed: () {
                        // Validate inputs
                        final email = usernameController.text;
                        final password = passwordController.text;

                        // Check email
                        if (email.isEmpty) {
                          showSnackBar(context, 'Email cannot be empty', CustomColors.red);
                          return;
                        }
                        final emailRegex = RegExp(
                          r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
                        );
                        if (!emailRegex.hasMatch(email)) {
                          showSnackBar(
                              context, 'Please enter a valid email', CustomColors.red);
                          return;
                        }

                        // Check password
                        if (password.isEmpty) {
                          showSnackBar(
                              context, 'Password cannot be empty', CustomColors.red);
                          return;
                        }
                        if (password.length < 6) {
                          showSnackBar(context,
                              'Password must be at least 6 characters', CustomColors.red);
                          return;
                        }

                        // Dispatch login event if validation passes
                        BlocProvider.of<AuthBloc>(context).add(
                          ButtonClickedEvent(
                            username: email,
                            password: password,
                          ),
                        );
                      },
                    ),

                    // Footer Section
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Don\'t have an account?',
                            style: TextStyle(color:CustomColors. white)),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AuthSignup()),
                            );
                          },
                          child: const Text(
                            'Sign Up',
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
}
