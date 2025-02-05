import 'package:flutter/material.dart';

class HelpSupportPage extends StatelessWidget {
  const HelpSupportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Help & Support'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
           
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(Icons.email),
                title: const Text('Contact Us via Email'),
                subtitle: const Text('support@evcabapp.com'),
                onTap: () {
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.phone),
                title: const Text('Call Us'),
                subtitle: const Text('+1-800-123-456'),
                onTap: () {
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.question_answer),
                title: const Text('FAQs'),
                subtitle: const Text('Find answers to common questions.'),
                onTap: () {
                  // Navigate to FAQ page if available
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.chat),
                title: const Text('Live Chat Support'),
                subtitle: const Text('Chat with our support team in real-time.'),
                onTap: () {
                  // Navigate to live chat or integrate with a chat service
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.report_problem),
                title: const Text('Report an Issue'),
                subtitle: const Text('Let us know about any issues you’re facing.'),
                onTap: () {
                  // Navigate to issue reporting form or functionality
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.feedback),
                title: const Text('Give Feedback'),
                subtitle: const Text('Share your experience or suggestions.'),
                onTap: () {
                  // Navigate to feedback form
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.location_on),
                title: const Text('Locate Us'),
                subtitle: const Text('Find our office locations.'),
                onTap: () {
                  // Add navigation to a map or office details page
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
