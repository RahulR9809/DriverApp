part of 'dash_bloc.dart';

@immutable
sealed class DashEvent {}
 


class FetchTripsData extends DashEvent {}

class FetchTopTrips extends DashEvent {}


class FetchDashEvent extends DashEvent {}


class FetchRevenueEvent extends DashEvent {} 


