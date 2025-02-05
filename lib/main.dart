import 'package:employerapp/controllers/auth_bloc/auth_bloc.dart';
import 'package:employerapp/controllers/chat_bloc/chat_bloc.dart';
import 'package:employerapp/controllers/dash_bloc/bloc/dash_bloc.dart';
import 'package:employerapp/repository/auth_controller.dart';
import 'package:employerapp/views/auth/intro_page.dart';
import 'package:employerapp/repository/chat_controller.dart';
import 'package:employerapp/repository/chat_socketcontroller.dart';
import 'package:employerapp/repository/ride_controller.dart';
import 'package:employerapp/repository/socket_controller.dart';
import 'package:employerapp/controllers/navbar_bloc/bottom_nav_bloc.dart';
import 'package:employerapp/views/Nav/main_page.dart';
import 'package:employerapp/controllers/ride_bloc/ride_bloc.dart';
import 'package:employerapp/controllers/map_bloc/animation_state_bloc.dart';
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
          create: (context) => ChatBloc()
        ),
         BlocProvider(
          create: (context) => AnimationStateBloc()
        ),
        BlocProvider(create: (context)=>DashBloc())
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
