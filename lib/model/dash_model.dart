// @immutable
// class DashState {
//   final int? completedTripCount;
//   final List<dynamic>? latestTrips;
//   final bool isLoading; // For loading state
//   final String? error; // For error messages

//   const DashState({
//     this.completedTripCount,
//     this.latestTrips,
//     this.isLoading = false,
//     this.error,
//   });

//   DashState copyWith({
//     int? completedTripCount,
//     List<dynamic>? latestTrips,
//     bool? isLoading,
//     String? error,
//   }) {
//     return DashState(
//       completedTripCount: completedTripCount ?? this.completedTripCount,
//       latestTrips: latestTrips ?? this.latestTrips,
//       isLoading: isLoading ?? this.isLoading,
//       error: error,
//     );
//   }
// }

// class DashInitial extends DashState {
//   const DashInitial() : super();
// }
