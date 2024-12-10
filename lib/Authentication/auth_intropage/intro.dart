// import 'package:employerapp/Authentication/LoginPage/login.dart';
// import 'package:employerapp/Authentication/auth_signup/auth_signup.dart';
// import 'package:employerapp/core/colors.dart';
// import 'package:employerapp/widgets/refactored.dart';
// import 'package:flutter/material.dart';

// class IntroPage extends StatelessWidget {
//   const IntroPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         decoration: const BoxDecoration(
// gradient: LinearGradient(colors: gradientlist) 
//         ),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           children: [
//             // Top image with design enhancements
//             Stack(
//               alignment: Alignment.center,
//               children: [
//                 ClipRRect(
//                   borderRadius: const BorderRadius.vertical(bottom: Radius.circular(10),top: Radius.circular(10)), // Rounded corners
//                   child: Image.asset(
//                     'asset/Man track taxi driver cab on tablet map.jpg', // Replace with your image path
//                     height: 300,
//                     width: double.infinity,
//                     fit: BoxFit.cover,
//                   ),
//                 ),
                
//               ],
//             ),
        
//             // Text section
//             const Padding(
//               padding: EdgeInsets.symmetric(horizontal: 24.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   Text(
//                     'Welcome to Electra Ride',
//                     style: TextStyle(
//                       fontSize: 30,
//                       fontWeight: FontWeight.bold,
//                       color: white,
//                     ),
//                     textAlign: TextAlign.center,
//                   ),
//                   SizedBox(height: 10),
//                   Text(
//                     'Effortless EV Rides Await',
//                     style: TextStyle(
//                       fontSize: 20,
//                       color: lightgrey,
//                     ),
//                     textAlign: TextAlign.center,
//                   ),
//                   SizedBox(height: 20),
//                   Text(
//                     'Experience eco-friendly travel with us! Sign up or log in to explore a convenient, sustainable way to navigate the city.',
//                     style: TextStyle(
//                       fontSize: 16,
//                       color: lightgrey,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
        
//             // Buttons section
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 24.0),
//               child: Column(
//                 children: [
//                   // Login Button
//                   actionButton(
//                     context,
//                     ' Login ',
//                     () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(builder: (context) => const Login()),
//                       );
//                     },
//                   ),
//                   const SizedBox(height: 16),
//                   // Sign Up Button
//                   actionButton(
//                     context,
//                     'Sign Up',
//                     () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(builder: (context) => AuthSignup()),
//                       );
//                     },
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }



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
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(colors: gradientlist),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Top image with enhancements
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.asset(
                      'asset/Man track taxi driver cab on tablet map.jpg',
                      height: 280,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
            ),

            // Text section
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Welcome to Electra Ride',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                      color: white,
                      letterSpacing: 1.2,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Effortless EV Rides Await',
                    style: TextStyle(
                      fontSize: 20,
                      color: lightgrey,
                      fontStyle: FontStyle.italic,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Experience eco-friendly travel with us! Sign up or log in to explore a convenient, sustainable way to navigate the city.',
                    style: TextStyle(
                      fontSize: 16,
                      color: lightgrey,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            // Buttons section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: [
                  // Login Button with shadow and refined style
                  Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: actionButton(
                      context,
                      ' Login ',
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Login()),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Sign Up Button with shadow and refined style
                  Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: actionButton(
                      context,
                      'Sign Up',
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AuthSignup()),
                        );
                      },
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
