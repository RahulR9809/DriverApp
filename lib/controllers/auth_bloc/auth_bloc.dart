
// ignore_for_file: non_constant_identifier_names

import 'package:bloc/bloc.dart';
import 'package:employerapp/model/login_model.dart';
import 'package:employerapp/model/registeration_model.dart';
import 'package:employerapp/model/signup_model.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../repository/auth_controller.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthService authService;
  AuthBloc({required this.authService}) : super(AuthInitial()) {
    on<ResendOtPEvent>(
      (event, emit) async {
        emit(LoadingState());
        try {
          await authService.getOTP(event.email);
          emit(LoadedState());
          if (kDebugMode) {
            print('Emitting LoadedState for ResendOtPEvent');
          }
        } catch (e) {
          if (kDebugMode) {
            print('Error in ResendOtPEvent: $e');
          }
          emit(ErrorState(message: 'Failed to send OTP'));
        }
      },
    );

    on<SubmitOTPEvent>(
      (event, emit) async {
        emit(LoadingState());
        try {
          await authService.verifyOtp(event.otp);
          emit(VerifiedState());
          if (kDebugMode) {
            print('Emitting VerifiedState for SubmitOTPEvent');
          }
        } catch (e) {
          if (kDebugMode) {
            print('Error in SubmitOTPEvent: $e');
          }
          emit(ErrorState(message: 'Failed creating account'));
        }
      },
    );

    on<SignUpButtonClickedEvent>((event, emit) async {
      emit(LoadingState());
      try {
        SignupModel signupModel = SignupModel(
          name: event.name,
          phone: event.phone,
          email: event.email,
          password: event.password,
        );

        final data = await authService.signup(signupModel);
        if (data !=null) {
          if (kDebugMode) {
            print('Signup successful, emitting SignupSuccess');
          }
          emit(SignupSuccess());
        }
      } catch (error) {
        if (kDebugMode) {
          print('Error in SignUpButtonClickedEvent: $error');
        }
        emit(ErrorState(message: 'Error during signup'));
      }
    });

    on<ButtonClickedEvent>((event, emit) async {
      if (event.username.isEmpty || event.password.isEmpty) {
        if (kDebugMode) {
          print('Username or password is empty, emitting ErrorState');
        }
        emit(ErrorState(message: 'Username and password cannot be empty.'));
        return;
      }

      emit(LoadingState());

      try {
        LoginModel loginModel =
            LoginModel(email: event.username, password: event.password);

        final response = await authService.login(loginModel);

        if (response != null) {
          final bool isAccepted = response['isAccepted'] ?? false;
          final Blocked = response['error'];
          if (Blocked != null && Blocked == '401') {
            if (kDebugMode) {
              print('User is blocked, emitting BlockedState');
            }
            emit(BlockedState());
          } else if (!isAccepted) {
            if (kDebugMode) {
              print('User is pending approval, emitting PendingState');
            }
            emit(PendingState());
          } else {
            if (kDebugMode) {
              print('Login successful, emitting LoadedState');
            }
            emit(LoadedState());
          }
        }
      } catch (e) {
        if (kDebugMode) {
          print('Error in ButtonClickedEvent: $e');
        }
        emit(ErrorState(message: 'An error occurred: ${e.toString()}'));
      }
    });

    on<SubmitRegistration>((event, emit) async {
      SharedPreferences pref = await SharedPreferences.getInstance();
      final driverId = pref.getString('userId');

      if (driverId == null) {
        if (kDebugMode) {
          print('Driver ID not found, emitting ErrorState');
        }
        emit(ErrorState(message: 'Driver ID not found in SharedPreferences'));
        return;
      }

      emit(LoadingState());
      if (kDebugMode) {
        print('Emitting LoadingState for SubmitRegistration');
      }

      try {
        final model = DriverRegistrationModel(
          driverId: driverId,
          licenseNumber: event.licenseNumber,
          rcNumber: event.rcNumber,
          vehicleType: event.vehicleType,
          profileImage: event.profileImage,
          licenseImage: event.licenseImage,
          vehiclePermit: event.vehiclePermit,
        );

        await authService.submitDriverRegistration(model);
        emit(DriverRegistrationSuccess());
      } catch (error, stackTrace) {
        if (kDebugMode) {
          print('Error during driver registration: $error\n$stackTrace');
        }
        emit(ErrorState(message: 'Failed to register driver: $error'));
      }
    });

    on<AuthCheckingEvent>((event, emit) async {
      emit(LoadingState());

      SharedPreferences pref = await SharedPreferences.getInstance();
      final String? loginToken = pref.getString('accesstoken');
      final bool? isAccepted = pref.getBool('isAccepted');

      if (loginToken != null) {
        if (isAccepted == true) {
          if (kDebugMode) {
            print('User authenticated, emitting AuthenticatedState');
          }
          emit(AuthenticatedState());
        } else if (isAccepted == false) {
          if (kDebugMode) {
            print('User pending approval, emitting PendingState');
          }
          emit(PendingState());
        }
      } else {
        emit(UnauthenticatedState());
      }
    });
  }
}
