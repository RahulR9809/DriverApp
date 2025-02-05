import 'package:employerapp/controllers/navbar_bloc/bottom_nav_bloc.dart';
import 'package:employerapp/views/Nav/nav_page.dart';
import 'package:employerapp/views/home/home_page.dart';
import 'package:employerapp/views/profile/profilepage.dart';
import 'package:employerapp/views/ride.dart/ride_page.dart';
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
  void initState() {
    super.initState();
    context.read<BottomNavBloc>().add(UpdateTab(0));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<BottomNavBloc, BottomNavState>(
        builder: (context, state) {
          int currentIndex = 0; 
          if (state is BottomNavigationState) {
            currentIndex = state.selectedIndex; 
          }
          return IndexedStack(
            index: currentIndex,
            children: _pages,
          );
        },
      ),
      bottomNavigationBar: const CustomBottomNavBar(), 
    );
  }
}
