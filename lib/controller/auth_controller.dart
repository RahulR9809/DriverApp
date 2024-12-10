import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

Map<String, dynamic>? userData;
final driveip='10.0.2.2';
class AuthService {
  String baseUrl = "http://$driveip:3001/api/auth/";

  Future<void> storeSessionCookie(String cookie) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('session_cookie', cookie);
  }

  Future<String?> getSessionCookie() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('session_cookie');
  }

  Future<String?> signup(
      String name, String email, String password, String phone) async {
    try {
      final url = Uri.parse('$baseUrl/driver/signup');
      final headers = {'Content-Type': 'application/json'};
      final body = jsonEncode({
        'name': name,
        'email': email,
        'phone': phone,
        'password': password,
      });

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
        if (response.statusCode == 201) {
          print(data);
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
        if (cookie != null) {
          await storeSessionCookie(cookie);
        }

        final data = json.decode(response.body);
        print(data);
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
        print(data);
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

  Future<Map<String, dynamic>?> login(String email, String password) async {
    try {
      final url = Uri.parse('$baseUrl/driver/login');
      final headers = {'Content-Type': 'application/json'};
      final body = jsonEncode({
        'email': email,
        'password': password,
      });
      debugPrint('Request body: $body');

      final response = await http.post(
        url,
        headers: headers,
        body: body,
      );
      if (response.statusCode == 200) {
        final dynamic data = json.decode(response.body);
        final coordi=data['coordinates'];
        print(coordi);
        print('accesstoken:${data['accessToken']}');
        print(response.body);
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
      } else {
        throw Exception('Failed to log in: ${response.body}');
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

  Future<void> submitDriverRegistration({
    required String driverId,
    required String licenseNumber,
    required String rcNumber,
    required String vehicleType,
    XFile? profileImage,
    XFile? licenseImage,
    XFile? vehiclePermit,
  }) async {
    try {
      final uri =
          Uri.parse('http://$driveip:3001/api/auth/driver/complete-profile');
      final request = http.MultipartRequest('POST', uri);

      request.fields['driverId'] = driverId;
      request.fields['licenseNumber'] = licenseNumber;
      request.fields['vehicleRC'] = rcNumber;
      request.fields['vehicleType'] = vehicleType;

      if (profileImage != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'ProfileImg',
            profileImage.path,
          ),
        );
      }

      if (licenseImage != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'licensePhoto',
            licenseImage.path,
          ),
        );
      }

      if (vehiclePermit != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'permit',
            vehiclePermit.path,
          ),
        );
      }

      final response = await request.send();

      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();

        debugPrint('Registration Successful: $responseBody');
      } else {
        throw Exception(
            'Failed to submit registration: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error occurred while submitting registration: $e');
    }
  }
}
