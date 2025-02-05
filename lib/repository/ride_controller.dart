import 'dart:async';
import 'dart:convert';
import 'package:employerapp/model/complete_ride_model.dart';
import 'package:employerapp/model/reject_ride.dart';
import 'package:employerapp/model/ride_accept_model.dart';
import 'package:employerapp/model/start_ride_model.dart';
import 'package:employerapp/repository/auth_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

Future<String?> accessToken() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  final token = pref.getString('accesstoken');
  return token;
}

Future<void> storeSessionCookie(String cookie) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('cookie', cookie);
}

Future<String?> getSessionCookie() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('cookie');
}

String baseUrl = 'http://$ipConfig:3001/api/trip/driver';

class RideController {
  Future<Map<String, dynamic>> acceptRide(
      RideAcceptModel rideAcceptModel) async {
    try {
      final accesstoken = await accessToken();
      final url = Uri.parse('$baseUrl/accept-ride');
      final model = jsonEncode(rideAcceptModel.toJson());
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accesstoken',
      };

      if (kDebugMode) {
        print('Access token: $accesstoken');
      }

      final response = await http.post(
        url,
        headers: headers,
        body: model,
      );

      if (response.statusCode == 201) {
        final cookie = response.headers['set-cookie'];
        if (cookie != null) {
          await storeSessionCookie(cookie);
          if (kDebugMode) {
            print('Session cookie stored: $cookie');
          }
        }

        final responseData = jsonDecode(response.body);
        if (kDebugMode) {
          print('Response data: $responseData');
        }
        return responseData;
      } else if (response.statusCode == 400) {
        throw Exception('Bad Request: No necessary data to process request');
      } else {
        throw Exception(
            'Failed to accept ride. Status code: ${response.statusCode}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error occurred: $e');
      }
      rethrow;
    }
  }

  Future<void> rejectRide(RejectRideModel rejectRideModel) async {
    try {
      final url = Uri.parse('$baseUrl/reject-ride');
      final model = jsonEncode(rejectRideModel.tojson());

      final accesstoken = await accessToken();

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accesstoken',
        },
        body: model,
      );

      if (response.statusCode == 200) {
        if (kDebugMode) {
          print('Ride Rejected Successfully: ${response.body}');
        }
      } else {
        if (kDebugMode) {
          print('Failed to reject ride: ${response.body}');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error occurred: $e');
      }
    }
  }

  Future<void> startRide(StartRideModel startRideModel) async {
    try {
      final url = Uri.parse('$baseUrl/start-ride');
      final model = jsonEncode(startRideModel.toJson());

      final accesstoken = await accessToken();
      final cookie = await getSessionCookie();
      if (kDebugMode) {
        print('this is teh session cookie:$cookie');
      }
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accesstoken',
          'Cookie': cookie!,
        },
        body: model,
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (kDebugMode) {
          print('Ride Started Successfully:$responseData');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error occurred: $e');
      }
    }
  }

  Future<void> completeRide(CompleteRideModel completeRideModel) async {
    try {
      final url = Uri.parse('$baseUrl/complete-ride');
      final model = jsonEncode(completeRideModel.tojson());

      final accesstoken = await accessToken();

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accesstoken',
        },
        body: model,
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (kDebugMode) {
          print('Ride Completed Successfully: $responseData');
        }
      } else {
        if (kDebugMode) {
          print('Failed to complete ride: ${response.body}');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error occurred: $e');
      }
    }
  }
}
