import 'package:employerapp/model/chat_model.dart';
import 'package:employerapp/repository/auth_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class ChatService {
  final String baseUrl='http://$ipConfig:3001/api/chat';

Future<void> sendMessage(ChatModel chatModel) async {
  try {

  final model=jsonEncode(chatModel.toJson());

    final response = await http.post(
      Uri.parse('$baseUrl/sendMessage'),
      headers: {
        'Content-Type': 'application/json',
      },
   body:model
    );

    if (response.statusCode == 201) {
      if (kDebugMode) {
        print("Message sent successfully!");
      }
      if (kDebugMode) {
        print('Response Body: ${response.body}');
      }
    } else {
      if (kDebugMode) {
        print("Failed to send message: ${response.statusCode} - ${response.body}");
      }
    }
  } catch (e) {
    if (kDebugMode) {
      print("Error sending message: $e");
    }
  }
}


  Future<List<dynamic>> getMessages({
    required String token,
    required String tripId,
  }) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/messages/$tripId'), 
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return data['messages']; 
      } else {
        if (kDebugMode) {
          print("Failed to fetch messages: ${response.body}");
        }
        return [];
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error fetching messages: $e");
      }
      return [];
    }
  }
}
