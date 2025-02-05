import 'package:bloc/bloc.dart';
import 'package:employerapp/repository/dash_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
part 'dash_event.dart';
part 'dash_state.dart';


class DashBloc extends Bloc<DashEvent, DashState> {
  final DashController dashController = DashController();
  String startMonth = DateFormat('yyyy-MM').format(DateTime.now().subtract(const Duration(days: 30)));
  String endMonth = DateFormat('yyyy-MM').format(DateTime.now());
  DashBloc() : super(DashInitial()) {
    on<FetchTripsData>((event, emit) async {
      emit(DashLoading());
      try {
        final data = await dashController.tripsData();
        if (data != null) {
        
          if (kDebugMode) {
            print('this is from bloc :$data');
          }
          emit(TripsDataLoaded(data:data));
        } else {
          emit(TripCountError("Failed to fetch trip count"));
        }
      } catch (e) {
        emit(TripCountError("An error occurred: $e"));
      }
    });

on<FetchDashEvent>((event, emit) async {
  emit(DashLoading());
  try {
    final data = await dashController.dashData();
    if (data != null && data["tripData"] != null) {
      List<dynamic> trips = data["tripData"];
      
      DateTime today = DateTime.now();
      String todayStr = "${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}";

      List<dynamic> completedTrips = trips.where((trip) => trip["tripStatus"] == "completed").toList();

      double totalRevenue = 0;
      double todaysRevenue = 0;
      for (var trip in completedTrips) {
        double fare = trip["fare"] ?? 0.0;

        totalRevenue += fare;

        String tripDate = trip["createdAt"].substring(0, 10); 
        if (tripDate == todayStr) {
          todaysRevenue += fare;
        }
      }
if (kDebugMode) {
  print('the count:${completedTrips.length}');
}
if (kDebugMode) {
  print('today amount:$todaysRevenue');
}
if (kDebugMode) {
  print('total amount:$totalRevenue');
}
      emit(FetchedDashData({
        "completedTripsCount": completedTrips.length,
        "todaysRevenue": todaysRevenue,
        "totalRevenue": totalRevenue,
      }));
    } else {
      emit(LatestTripsError("Failed to fetch latest trips"));
    }
  } catch (e) {
    emit(LatestTripsError("An error occurred: $e"));
  }
});

on<FetchRevenueEvent>((event, emit) async {
  emit(DashLoading());
  try {
    final data = await dashController.dashData();

    if (data != null) {
      emit(RevenueData(data));
    } else {
      emit(LatestTripsError("Failed to fetch latest trips"));
    }
  } catch (e) {
    emit(LatestTripsError("An error occurred: $e"));
  }
});




    
  }
}
