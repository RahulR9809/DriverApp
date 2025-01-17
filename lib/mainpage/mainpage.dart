import 'package:employerapp/customBottomNav/bloc/bottom_nav_bloc.dart';
import 'package:employerapp/customBottomNav/nav_page.dart';
import 'package:employerapp/home/home_page.dart';
import 'package:employerapp/payment/payment.dart';
import 'package:employerapp/profilepage/profilepage.dart';
import 'package:employerapp/ridepage.dart/completedrideButton.dart';
import 'package:employerapp/ridepage.dart/otp.dart';
import 'package:employerapp/ridepage.dart/ridepage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final List<Widget> _pages = [
    const HomePage(),
    const RidePage(),     
    const ProfilePage(),  
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<BottomNavBloc, BottomNavState>(
        builder: (context, state) {
          int currentIndex = 0; // Default index to home
          if (state is BottomNavigationState) {
            currentIndex = state.selectedIndex; // Current index from state
          }
          return IndexedStack(
            index: currentIndex,
            children: _pages,
          );
        },
      ),
      bottomNavigationBar: const CustomBottomNavBar(), // Add your custom bottom nav bar here
    );
  }
}
