import 'package:bloc/bloc.dart';
import 'package:employerapp/controller/auth_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
        } catch (e) {
          emit(ErrorState(message: 'failed to send otp'));
        }
      },
    );

    on<SubmitOTPEvent>(
      (event, emit) async {
        emit(LoadingState());
        try {
          await authService.verifyOtp(event.otp);
          emit(VerifiedState());
        } catch (e) {
          emit(ErrorState(message: 'failed creating account'));
        }
      },
    );

    on<SignUpButtonClickedEvent>((event, emit) async {
      emit(LoadingState());
      try {
        await authService.signup(
          event.name,
          event.email,
          event.password,
          event.phone,
        );
        emit(SignupSuccess());
      } catch (error) {
        emit(ErrorState(message: 'error signup'));
      }
    });



    // on<ButtonClickedEvent>((event, emit) async {
    //   if (event.username.isEmpty || event.password.isEmpty) {
    //     emit(ErrorState(message: 'Username and password cannot be empty.'));
    //     return;
    //   }

    //   emit(LoadingState());

    //   try {
    //     final response =
    //         await authService.login(event.username, event.password);

    //     if (response != null) {
    //       final bool isAccepted = response['isAccepted'] ?? false;
    //       final  isBlocked=response['error'];
    //       if (kDebugMode) {
    //         print('is accepted $isAccepted');
    //       }
    //       if (!isAccepted) {
    //         emit(PendingState()); 
    //       } else if (isAccepted){
    //         emit(LoadedState());
    //       } else if(isBlocked){
    //         emit(BlockedState());
    //       }
    //     }
    //   } catch (e) {
    //     if (kDebugMode) {
    //       print('emitting unauth');
    //     }
    //     emit(ErrorState(message: 'An error occurred: ${e.toString()}'));
    //   }
    // });


    on<ButtonClickedEvent>((event, emit) async {
  if (event.username.isEmpty || event.password.isEmpty) {
    emit(ErrorState(message: 'Username and password cannot be empty.'));
    return;
  }

  emit(LoadingState());

  try {
    final response = await authService.login(event.username, event.password);

    if (response != null) {
      final bool isAccepted = response['isAccepted'] ?? false;
final Blocked=response['error'];
      if (Blocked != null && Blocked == '401') {
        emit(BlockedState());
      } else if (!isAccepted) {
        emit(PendingState());
      } else {
        emit(LoadedState());
      }
    }
  } catch (e) {
    if (kDebugMode) {
      print('emitting unauth');
    }
    emit(ErrorState(message: 'An error occurred: ${e.toString()}'));
  }
});




    on<SubmitRegistration>((event, emit) async {
      SharedPreferences pref = await SharedPreferences.getInstance();
      final driverId = pref.getString('userId');

      if (driverId == null) {
        emit(ErrorState(message: 'Driver ID not found in SharedPreferences'));
        return;
      }

      emit(LoadingState());

      try {
        // Call to submit driver registration
        await authService.submitDriverRegistration(
          driverId: driverId,
          licenseNumber: event.licenseNumber,
          rcNumber: event.rcNumber,
          vehicleType: event.vehicleType,
          profileImage: event.profileImage,
          licenseImage: event.licenseImage,
          vehiclePermit: event.vehiclePermit,
        );
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
          // If user ID exists and is accepted, emit AuthenticatedState
          emit(AuthenticatedState());
        } else if (isAccepted == false) {
          // If user ID exists but is not accepted, emit PendingState
          emit(PendingState());
        }
      } else {
        // If no user ID, emit UnauthenticatedState
        emit(UnauthenticatedState());
      }
    });
  }
}
