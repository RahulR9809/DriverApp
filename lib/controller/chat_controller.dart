import 'package:employerapp/controller/auth_controller.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class ChatService {
  final String baseUrl='http://$ipConfig:3001/api/chat';

Future<void> sendMessage({
  required String senderId,
  required String recieverId,
  required String message,
  required String tripId,
  required String senderType,
  required String driverId,
  required String userId,
}) async {
  try {
 SharedPreferences pref = await SharedPreferences.getInstance();
      final String? loginToken = pref.getString('accesstoken');
    // Debug print
    print('Request Body: ${{
      "senderId": senderId,
      "recieverId": recieverId,
      "message": message,
      "tripId": tripId,
      "senderType": senderType,
      "driverId": driverId,
      "userId": userId,
      // "token":loginToken
    }}');

    final response = await http.post(
      Uri.parse('$baseUrl/sendMessage'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "senderId": senderId,
        "recieverId": recieverId,
        "message": message,
        "tripId": tripId,
        "senderType": senderType,
        "driverId": driverId,
        "userId": userId,
      }),
    );

    if (response.statusCode == 201) {
      print("Message sent successfully!");
      print('Response Status: ${response.statusCode}');
      print('Response Body: ${response.body}');
    } else {
      print("Failed to send message: ${response.statusCode} - ${response.body}");
    }
  } catch (e) {
    print("Error sending message: $e");
  }
}


  // Retrieve Chat Messages
  Future<List<dynamic>> getMessages({
    required String token,
    required String tripId,
  }) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/messages/$tripId'), // Example endpoint
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return data['messages']; // Assuming API returns {"messages": [...]}
      } else {
        print("Failed to fetch messages: ${response.body}");
        return [];
      }
    } catch (e) {
      print("Error fetching messages: $e");
      return [];
    }
  }
}
