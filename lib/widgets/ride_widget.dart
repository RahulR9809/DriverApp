import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

class LocationService {
  /// Get the current location or use predefined coordinates
  Future<String> getCurrentLocation({
    double? predefinedLatitude,
    double? predefinedLongitude,
  }) async {
    try {
      // Use predefined coordinates if provided
      if (predefinedLatitude != null && predefinedLongitude != null) {
        return await _getLocationDetails(predefinedLatitude, predefinedLongitude);
      }

      // Check location permissions
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Exception("Location services are disabled.");
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception("Location permissions are denied.");
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw Exception("Location permissions are permanently denied.");
      }

      // Get current location
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      ).timeout(const Duration(seconds: 15), onTimeout: () {
        throw Exception("Location fetch timeout exceeded.");
      });

      return await _getLocationDetails(position.latitude, position.longitude);
    } catch (e) {
      throw Exception("Failed to get location: ${e.toString()}");
    }
  }

  /// Get location details (address) from coordinates
  Future<String> _getLocationDetails(double latitude, double longitude) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude).timeout(
        const Duration(seconds: 15),
        onTimeout: () {
          throw Exception("Geocoding timeout exceeded.");
        },
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        return "${place.street}, ${place.locality}, ${place.administrativeArea}, ${place.country}";
      } else {
        throw Exception("No location details found.");
      }
    } catch (e) {
      throw Exception("Failed to fetch location details: ${e.toString()}");
    }
  }
}


// class ReachedDialog {
//   static void showLocationReachedDialog(BuildContext context,{required String title, required String text}) {
//     QuickAlert.show(
//       context: context,
//       barrierDismissible: false,
//       type: QuickAlertType.success,
//       title: title,
//       text: text,
//       confirmBtnText: 'ok',
//       onConfirmBtnTap: () {
//         Navigator.of(context).pop();
//       },
//     );
//   }

// }

class ReachedDialog {
  static void showLocationReachedDialog(
    BuildContext context, {
    required String title,
    required String text,
    VoidCallback? onConfirm, // Optional parameter
  }) {
    QuickAlert.show(
      context: context,
      barrierDismissible: false,
      type: QuickAlertType.success,
      title: title,
      text: text,
      confirmBtnText: 'OK',
      onConfirmBtnTap: () {
        if (onConfirm != null) {
          onConfirm();
        } else {
          Navigator.of(context).pop();
        }
      },
    );
  }
}






