
import 'package:employerapp/Authentication/LoginPage/login.dart';
import 'package:employerapp/Authentication/auth_signup/auth_signup.dart';
import 'package:employerapp/core/colors.dart';
import 'package:employerapp/widgets/refactored.dart';
import 'package:flutter/material.dart';

class IntroPage extends StatelessWidget {
  const IntroPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Background with a black and grey gradient for a modern look
      backgroundColor: CustomColors.lightGrey,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [CustomColors.black, CustomColors.darkGrey],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Top image with dark container and shadow for a bold effect
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.6),
                        blurRadius: 30,
                        offset: const Offset(0, 8),
                      ),
                    ],
                    borderRadius: BorderRadius.circular(20),
                    color: CustomColors.black,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset(
                      'asset/Man track taxi driver cab on tablet map.jpg',
                      height: 300,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
            ),

            // Text section with white and light grey combo for contrast
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Welcome to Electra Ride',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: CustomColors.white, // Light text on dark background
                      letterSpacing: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Effortless EV Rides Await',
                    style: TextStyle(
                      fontSize: 24,
                      color: CustomColors.white,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Experience eco-friendly travel with us! Sign up or log in to explore a convenient, sustainable way to navigate the city.',
                    style: TextStyle(
                      fontSize: 16,
                      color: CustomColors.white,
                      height: 1.5,
                      fontWeight: FontWeight.w300,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            // Buttons section with black and white contrast
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: [
                  // Login Button with white text on black background
                  Container(
                    width: double.infinity,
                    height: 55,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                      borderRadius: BorderRadius.circular(30),
                      color: CustomColors.white, // White background for contrast
                    ),
                    child: actionButton(
                      
                      context,
                      'Login',
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Login(),
                          ),
                        );
                        
                      },
                      Colors.white
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Sign Up Button with black background and white text
                  Container(
                    width: double.infinity,
                    height: 55,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                      borderRadius: BorderRadius.circular(30),
                      color: CustomColors.black, // Black background for the button
                    ),
                    child: actionButton(
                      context,
                      'Sign Up',
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AuthSignup(),
                          ),
                        );
                      },
                                            Colors.white

                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
