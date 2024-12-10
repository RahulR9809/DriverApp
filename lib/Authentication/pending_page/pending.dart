// pending_page.dart
import 'package:employerapp/profilepage/profilepage.dart';
import 'package:flutter/material.dart';

class PendingPage extends StatelessWidget {
  const PendingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        
        title: const Text('Pending Approval'),
        centerTitle: true,
        backgroundColor: Colors.teal,
         actions: [
    IconButton(
      icon: const Icon(Icons.account_circle), // You can use any icon or even a custom profile picture
      onPressed: () {
Navigator.push(context, MaterialPageRoute(builder: (context)=>const ProfilePage()));      },
    ),
  ],
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.hourglass_empty, size: 80, color: Colors.teal),
            SizedBox(height: 20),
            Text(
              'Your registration is under review',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
            Text(
              'We will notify you once the process is complete.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
