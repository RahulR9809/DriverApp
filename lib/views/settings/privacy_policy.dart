import 'package:flutter/material.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: (){
Navigator.pop(context);
        }, icon:const Icon(Icons.arrow_back)),
        title: const Text('Privacy Policy'),
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Privacy Policy',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              Text(
                'We value your privacy. This privacy policy explains how we collect, use, and protect your information while using our app.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 8),
              Text(
                '1. Information Collection:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(
                'We collect personal information such as your name, email address, and phone number when you use our app.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 8),
              Text(
                '2. Data Usage:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(
                'Your information is used to improve your experience, process payments, and provide customer support.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 8),
              Text(
                '3. Data Security:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(
                'We use advanced security measures to protect your data from unauthorized access.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16),
              Text(
                'For more details, please contact us via the Help & Support page.',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
