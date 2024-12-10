import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

const String baseUrl = 'http://10.0.2.2:3001/api/trip/driver';

class RideController {
  Future<Map<String, dynamic>> acceptRide({
    required String tripId,
    required String driverId,
    required String status,
  }) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    final token = pref.getString('accesstoken');
    final url = Uri.parse('$baseUrl/accept-ride');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    final body = jsonEncode({
      'tripId': tripId,
      'driverId': driverId,
      'status': status,
    });

    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 201) {
      final responseData = jsonDecode(response.body);
      print( '$responseData');
      return responseData;
    } else if (response.statusCode == 400) {
      throw Exception('Bad Request: No necessary data to process request');
    } else {
      throw Exception(
          'Failed to accept ride. Status code: ${response.statusCode}');
    }
  }

  Future<void> rejectRide({
    required String driverId,
    required String status,
    required String tripId,
  }) async {
    final url = Uri.parse('$baseUrl/reject-ride');

    final body = {
      'driverId': driverId,
      'status': status,
      'tripId': tripId,
    };

    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      final token = pref.getString('accesstoken');
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        print('Ride Rejected Successfully: ${response.body}');
      } else {
        print('Failed to reject ride: ${response.body}');
      }
    } catch (e) {
      print('Error occurred: $e');
    }
  }

  Future<void> startRide({
    required String tripOtp,
    required String tripId,
    required String sessionOtp, // Represents the OTP from session
  }) async {
    final url = Uri.parse('$baseUrl/start-ride');

    final body = {
      'tripOtp': tripOtp,
      'tripId': tripId,
    };

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
              'Bearer $sessionOtp', // Assuming session OTP is used as a token
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        print('Ride Started Successfully: ${responseData['tripDetail']}');
      } else {
        print('Failed to start ride: ${response.body}');
      }
    } catch (e) {
      print('Error occurred: $e');
    }
  }

  Future<void> completeRide({
    required String tripId,
    required String userId,
  }) async {
    final url = Uri.parse('$baseUrl/completeRide');

    final body = {
      'tripId': tripId,
      'userId': userId,
    };

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        print('Ride Completed Successfully: ${responseData['message']}');
      } else {
        print('Failed to complete ride: ${response.body}');
      }
    } catch (e) {
      print('Error occurred: $e');
    }
  }
}
