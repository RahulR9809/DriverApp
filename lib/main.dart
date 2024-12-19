import 'package:employerapp/Authentication/bloc/auth_bloc.dart';
import 'package:employerapp/chat/bloc/chat_bloc.dart';
import 'package:employerapp/controller/auth_controller.dart';
import 'package:employerapp/Authentication/auth_intropage/intro.dart';
import 'package:employerapp/controller/chat_controller.dart';
import 'package:employerapp/controller/chat_socketcontroller.dart';
import 'package:employerapp/controller/ride_controller.dart';
import 'package:employerapp/controller/socket_controller.dart';
import 'package:employerapp/customBottomNav/bloc/bottom_nav_bloc.dart';
import 'package:employerapp/mainpage/mainpage.dart';
import 'package:employerapp/ridepage.dart/bloc/ride_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
DriverSocketChatService driverSocketChatService=DriverSocketChatService();
ChatService chatService=ChatService();
void main() async {
  driverSocketChatService.initializeSocket();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final DriverSocketService socketService = DriverSocketService();
    final RideController rideController=RideController();
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthBloc(authService: AuthService())..add(AuthCheckingEvent()),
        ),
         BlocProvider(
          create: (context) => BottomNavBloc()
        ),
        
         BlocProvider(
          create: (context) => RideBloc(rideController,socketService: socketService,)
        ),
        
          BlocProvider(
          create: (context) => ChatBloc(chatService:chatService )
        ),
      ],
      child: MaterialApp(
        theme: ThemeData(primaryColor: Colors.black),
        debugShowCheckedModeBanner: false,
        home: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is AuthenticatedState) {
              return const MainPage();
            } else if (state is LoadingState) {
              return const Center(child: CircularProgressIndicator());
            }
            return const IntroPage();
          },
        ),
      ),
    );
  }
}
