import 'package:employerapp/views/auth/login_page.dart';
import 'package:employerapp/views/auth/signup_page.dart';
import 'package:employerapp/core/colors.dart';
import 'package:employerapp/widgets/refactored_widget.dart';
import 'package:flutter/material.dart';

class IntroPage extends StatelessWidget {
  const IntroPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration:
            const BoxDecoration(gradient: CustomColors.backgroundGradient),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
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
                      color: CustomColors.white,
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: [
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
                      color: CustomColors.white,
                    ),
                    child: actionButton(context, 'Login', () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Login(),
                        ),
                      );
                    }, Colors.white),
                  ),
                  const SizedBox(height: 16),
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
                      color: CustomColors.black,
                    ),
                    child: actionButton(context, 'Sign Up', () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AuthSignup(),
                        ),
                      );
                    }, Colors.white),
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
