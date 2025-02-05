import 'dart:convert';
import 'package:employerapp/model/login_model.dart';
import 'package:employerapp/model/registeration_model.dart';
import 'package:employerapp/model/signup_model.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
const ipConfig='10.0.2.2';
Map<String, dynamic>? userData;

class AuthService {
  String baseUrl = "http://$ipConfig:3001/api/auth/";

  Future<void> storeSessionCookie(String cookie) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('session_cookie', cookie);
  }

  Future<String?> getSessionCookie() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('session_cookie');
  }

  Future<String?> signup(SignupModel signupModel) async {
    try {
      final url = Uri.parse('$baseUrl/driver/signup');
      final headers = {'Content-Type': 'application/json'};
      final body = jsonEncode(signupModel.toJson());

      debugPrint('Request body: $body');

      final response = await http.post(
        url,
        headers: headers,
        body: body,
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        final cookie = response.headers['set-cookie'];
        if (cookie != null) {
          await storeSessionCookie(cookie);
        }

        final data = json.decode(response.body);
        if (response.statusCode == 201|| response.statusCode == 200) {
          if (kDebugMode) {
            print(data);
          }
          if (kDebugMode) {
            print('this is the data${data['message']}');
          }
          return data['message'];
        } else {
          return data['message'];
        }
      } else {
        return Future.error('Failed to signup: ${response.body}');
      }
    } catch (e) {
      return Future.error('Error in signup: $e');
    }
  }



  Future<String?> getOTP(String email) async {
    try {
      final url = Uri.parse('$baseUrl/driver/resend-otp');
      final headers = {'Content-Type': 'application/json'};
      final body = jsonEncode({"email": email});
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        final cookie = response.headers['set-cookie'];
        if (kDebugMode) {
          print('cookie:$cookie');
        }
        if (cookie != null) {
          await storeSessionCookie(cookie);
        }

        final data = json.decode(response.body);
        if (kDebugMode) {
          print(data);
        }
        return data['message'];
      } else {
        throw Exception('Failed to resend OTP: ${response.body}');
      }
    } catch (e) {
      return Future.error('Error in getOTP: $e');
    }
  }

  Future<Map<String, dynamic>?> verifyOtp(String otp) async {
    try {
      final url = Uri.parse('$baseUrl/driver/verify-otp');
      final cookie = await getSessionCookie();
      final headers = {
        'Content-Type': 'application/json',
        if (cookie != null) 'Cookie': cookie,
      };
      final body = jsonEncode({"otp": otp});
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final userData = data['data'];
        if (kDebugMode) {
          print(data);
        }
        // final String message = data['message'];
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('userId', userData['_id']);
        return userData;
      } else {
        throw Exception('Failed to verify OTP: ${response.body}');
      }
    } catch (e) {
      return Future.error('Error verifying OTP: $e');
    }
  }

  // ignore: body_might_complete_normally_nullable
  Future<Map<String, dynamic>?> login(LoginModel  loginmodel) async {
    try {
      final url = Uri.parse('$baseUrl/driver/login');
      final headers = {'Content-Type': 'application/json'};
      final body = jsonEncode(loginmodel.toJson());
      debugPrint('Request body: $body');

      final response = await http.post(
        url,
        headers: headers,
        body: body,
      );
      if (response.statusCode == 200) {
        final dynamic data = json.decode(response.body);
        final coordi=data['coordinates'];
        if (kDebugMode) {
          print(coordi);
        }
        if (kDebugMode) {
          print('accesstoken:${data['accessToken']}');
        }
        if (kDebugMode) {
          print(response.body);
        }
        SharedPreferences pref = await SharedPreferences.getInstance();
          String accesstoken=data['accessToken'];
        pref.setString('accesstoken', accesstoken);
         pref.setString('login_id', data['data']['id'].toString());
        pref.setBool('isAccepted', data['data']['isAccepted']);
        SharedPreferences logpref = await SharedPreferences.getInstance();
        logpref.setString('user_name', data['data']['name']);
        logpref.setString('user_email', data['data']['email']);
        logpref.setString('user_phone', data['data']['phone'].toString());
        logpref.setString(
            'user_licenseNumber', data['data']['licenseNumber'].toString());
        logpref.setString('user_vehicleType', data['data']['vehicleType']);
        logpref.setString(
            'user_rc_Number', data['data']['rc_Number'].toString());
        logpref.setString('user_licenseUrl', data['data']['licenseUrl']);
        logpref.setString('user_profileUrl', data['data']['profileUrl']);
        logpref.setString('user_vehiclePermit', data['data']['permitUrl']);
        return {
          'id': data['data']['id'].toString(),
          'isAccepted': data['data']['isAccepted'],
        };
      }  else if (response.statusCode == 401) {
        debugPrint('Forbidden: ${response.body}');
        return {'error': '401'};
      } 
    } catch (e, stackTrace) {
      if (kDebugMode) {
        print('Error in login: $e');
      }
      if (kDebugMode) {
        print('Stack trace: $stackTrace');
      }
      return Future.error('Error in login: $e');
    }
  }

   Future<void> submitDriverRegistration(DriverRegistrationModel model) async {
    try {
      final uri = Uri.parse('$baseUrl/driver/complete-profile');
      final request = http.MultipartRequest('POST', uri);

      // Add fields
      request.fields.addAll(model.toFields());

      // Add files
      final files = await model.toFiles();
      for (var file in files) {
        request.files.add(file.value);
      }

      final response = await request.send();

      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        if (kDebugMode) {
          print('Registration Successful: $responseBody');
        }
      } else {
        throw Exception('Failed to submit registration: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error occurred while submitting registration: $e');
    }
  }
}
