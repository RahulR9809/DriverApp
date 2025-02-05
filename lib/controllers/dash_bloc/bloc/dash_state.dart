part of 'dash_bloc.dart';

@immutable
sealed class DashState {}

final class DashInitial extends DashState {}



class DashLoading extends DashState {}

class TripsDataLoaded extends DashState{
    final Map<String, dynamic> data;

  TripsDataLoaded({required this.data});

}


class TripCountError extends DashState {
  final String message;

  TripCountError(this.message);
}




class FetchedDashData extends DashState {
  final Map<String, dynamic> data;

  FetchedDashData(this.data);
}



class RevenueData extends DashState {
  final Map<String, dynamic> data;

  RevenueData(this.data);
}

class LatestTripsError extends DashState {
  final String message;

  LatestTripsError(this.message);
}



