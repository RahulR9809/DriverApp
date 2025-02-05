part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}

class ResendOtPEvent extends AuthEvent {
  final String email;

  ResendOtPEvent({required this.email});
}

class SubmitOTPEvent extends AuthEvent {
  final String otp;
  SubmitOTPEvent({required this.otp});
}

final class SignUpButtonClickedEvent extends AuthEvent {
  final String name;
  final String email;
  final String password;
  final String phone;

  SignUpButtonClickedEvent(
      {required this.phone,
      required this.name,
      required this.email,
      required this.password});
}

final class ButtonClickedEvent extends AuthEvent {
  final String username;
  final String password;

  ButtonClickedEvent({required this.username, required this.password});
}

class SubmitRegistration extends AuthEvent {
  final String licenseNumber;
  final String rcNumber;
  final String vehicleType;
  final XFile? profileImage;
  final XFile? licenseImage;
  final XFile? vehiclePermit;

  SubmitRegistration({
    required this.licenseNumber,
    required this.rcNumber,
    required this.vehicleType,
    this.profileImage,
    this.licenseImage,
    this.vehiclePermit,
  });
}

class AuthCheckingEvent extends AuthEvent {}
