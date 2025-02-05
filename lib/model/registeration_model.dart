import 'package:http/http.dart'as http;
import 'package:image_picker/image_picker.dart';

class DriverRegistrationModel {
  final String driverId;
  final String licenseNumber;
  final String rcNumber;
  final String vehicleType;
  final XFile? profileImage;
  final XFile? licenseImage;
  final XFile? vehiclePermit;

  DriverRegistrationModel({
    required this.driverId,
    required this.licenseNumber,
    required this.rcNumber,
    required this.vehicleType,
    this.profileImage,
    this.licenseImage,
    this.vehiclePermit,
  });

  Map<String, String> toFields() {
    return {
      'driverId': driverId,
      'licenseNumber': licenseNumber,
      'vehicleRC': rcNumber,
      'vehicleType': vehicleType,
    };
  }

  Future<List<MapEntry<String, http.MultipartFile>>> toFiles() async {
    final files = <MapEntry<String, http.MultipartFile>>[];

    if (profileImage != null) {
      files.add(MapEntry(
        'ProfileImg',
        await http.MultipartFile.fromPath('ProfileImg', profileImage!.path),
      ));
    }

    if (licenseImage != null) {
      files.add(MapEntry(
        'licensePhoto',
        await http.MultipartFile.fromPath('licensePhoto', licenseImage!.path),
      ));
    }

    if (vehiclePermit != null) {
      files.add(MapEntry(
        'permit',
        await http.MultipartFile.fromPath('permit', vehiclePermit!.path),
      ));
    }

    return files;
  }
}
