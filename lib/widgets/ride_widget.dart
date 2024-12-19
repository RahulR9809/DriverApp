import 'dart:async';
import 'dart:convert';

import 'package:employerapp/ridepage.dart/bloc/ride_bloc.dart';
import 'package:employerapp/ridepage.dart/bloc/ride_event.dart';
import 'package:employerapp/ridepage.dart/bloc/ride_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:mapbox_gl/mapbox_gl.dart' as mapbox;
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:http/http.dart'as http;
import 'dart:math' as Math;  // Ensure this is imported for the Math functions
final String YOUR_MAPBOX_ACCESS_TOKEN='pk.eyJ1IjoicmFodWw5ODA5IiwiYSI6ImNtM2N0bG5tYjIwbG4ydnNjMXF3Zmt0Y2wifQ.P4kkM2eW7eTZT9Ntw6-JVQ';

class LocationService {
  /// Get the current location or use predefined coordinates
  Future<String> getCurrentLocation({
    double? predefinedLatitude,
    double? predefinedLongitude,
  }) async {
    try {
      // Use predefined coordinates if provided
      if (predefinedLatitude != null && predefinedLongitude != null) {
        return await _getLocationDetails(predefinedLatitude, predefinedLongitude);
      }

      // Check location permissions
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Exception("Location services are disabled.");
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception("Location permissions are denied.");
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw Exception("Location permissions are permanently denied.");
      }

      // Get current location
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      ).timeout(const Duration(seconds: 15), onTimeout: () {
        throw Exception("Location fetch timeout exceeded.");
      });

      return await _getLocationDetails(position.latitude, position.longitude);
    } catch (e) {
      throw Exception("Failed to get location: ${e.toString()}");
    }
  }

  /// Get location details (address) from coordinates
  Future<String> _getLocationDetails(double latitude, double longitude) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude).timeout(
        const Duration(seconds: 15),
        onTimeout: () {
          throw Exception("Geocoding timeout exceeded.");
        },
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        return "${place.street}, ${place.locality}, ${place.administrativeArea}, ${place.country}";
      } else {
        throw Exception("No location details found.");
      }
    } catch (e) {
      throw Exception("Failed to fetch location details: ${e.toString()}");
    }
  }
}








//it is the one which is working corectly

// class MapboxWidget extends StatelessWidget {
//   const MapboxWidget({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: BlocConsumer<RideBloc, RideState>(
//         listener: (context, state) {
//           if (state is RideSimulationResumed) {
//             print('Listener: RideSimulationResumed detected');
//             _updateMap(context, state);
//           }
//         },
//         builder: (context, state) {
//           print('Builder received state: $state');
//           return _buildMap(context, state);
//         },
//       ),
//     );
//   }

//   Widget _buildMap(BuildContext context, RideState state) {
//     print('Building map...');
//     LatLng initialTarget;
//     double initialZoom = 14.0;

//     if (state is RideSimulationInProgress) {
//       print('State is RideSimulationInProgress.');
//       initialTarget = LatLng(state.currentLatitude, state.currentLongitude);
//     } else {
//       print('State is not RideSimulationInProgress. Using default coordinates.');
//       initialTarget = const LatLng(9.968677, 76.318354); // Default coordinates
//     }

//     return MapboxMapWrapper(
//       key: ValueKey(state), 
//       initialTarget: initialTarget,
//       initialZoom: initialZoom,
//       state: state,
//     );
//   }

//   void _updateMap(BuildContext context, RideSimulationResumed state) {
//     print('Updating map for resumed simulation...');
//     final mapController = context.read<MapboxMapController>();
//     PolylineManager(mapController).addPolylineWithIconsAndAnimate(
//       LatLng(state.startLatitude, state.startLongitude),
//       LatLng(state.endLatitude, state.endLongitude),
//     );
//   }
// }

// class MapboxMapWrapper extends StatefulWidget {
//   final LatLng initialTarget;
//   final double initialZoom;
//   final RideState state;

//   const MapboxMapWrapper({
//     required Key key,
//     required this.initialTarget,
//     required this.initialZoom,
//     required this.state,
//   }) : super(key: key);

//   @override
//   _MapboxMapWrapperState createState() => _MapboxMapWrapperState();
// }

// class _MapboxMapWrapperState extends State<MapboxMapWrapper> {
//   late MapboxMapController _mapController;

//   @override
//   Widget build(BuildContext context) {
//     return MapboxMap(
//       onMapCreated: (controller) {
//         _mapController = controller;
//         _initializeOrUpdateMap(controller, context, widget.state);
//       },
//       accessToken: "pk.eyJ1IjoicmFodWw5ODA5IiwiYSI6ImNtM2N0bG5tYjIwbG4ydnNjMXF3Zmt0Y2wifQ.P4kkM2eW7eTZT9Ntw6-JVQ",
//       initialCameraPosition: CameraPosition(target: widget.initialTarget, zoom: widget.initialZoom),
//       styleString: MapboxStyles.MAPBOX_STREETS,
//       zoomGesturesEnabled: true,
//       scrollGesturesEnabled: true,
//       rotateGesturesEnabled: true,
//       tiltGesturesEnabled: true,
//     );
//   }

//   void _initializeOrUpdateMap(MapboxMapController controller, BuildContext context, RideState state) {
//     print('Initializing or updating map with simulation route.');
//     if (state is RideSimulationInProgress) {
//       print('State is RideSimulationInProgress.');
//       PolylineManager(controller).addPolylineWithIconsAndAnimate(
//         LatLng(state.currentLatitude, state.currentLongitude),
//         LatLng(state.endLatitude, state.endLongitude),
//       );
//     } else if (state is RideSimulationResumed) {
//       print('State is RideSimulationResumed.');
//       PolylineManager(controller).addPolylineWithIconsAndAnimate(
//         LatLng(state.startLatitude, state.startLongitude),
//         LatLng(state.endLatitude, state.endLongitude),
//       );
//     }
//   }
// }


// class PolylineManager {
//   final MapboxMapController mapController;

//   PolylineManager(this.mapController);


// Future<void> addPolylineWithIconsAndAnimate(LatLng start, LatLng end) async {
//   try {
//     print('Requesting route from API for: $start -> $end');
//     List<LatLng> route = await _getRouteFromAPI(start, end);

//     if (route.isEmpty) {
//       print('Route API returned an empty route.');
//       return;
//     }
//     print('Route fetched successfully with ${route.length} points.');

//     // Add polyline to the map
//     await mapController.addLine(LineOptions(
//       geometry: route,
//       lineColor: "#0000FF",
//       lineWidth: 5.0,
//     ));

//     // Add start and end icons
//     print('Adding start and end icons...');
//     await mapController.addImage("start-icon", await _loadImage('asset/start.png'));
//     await mapController.addImage("end-icon", await _loadImage('asset/end.png'));

//     // Check if start and end locations are valid
//     print('Start coordinates: $start');
//     print('End coordinates: $end');

//     // Ensure that start and end are not the same
//     if (start == end) {
//       print('Start and end coordinates are the same!');
//     } else {
//       print('Start and end are distinct locations.');
//     }

//     // Add start and end symbols with icons
//     await mapController.addSymbol(SymbolOptions(
//       geometry: start,
//       iconImage: "start-icon",
//       iconSize: 0.1,
//     ));
//     await mapController.addSymbol(SymbolOptions(
//       geometry: end,
//       iconImage: "end-icon",
//       iconSize: 0.1,
//     ));

//     print('Start and end icons added to map.');

//   } catch (e) {
//     print('Error in addPolylineWithIconsAndAnimate: $e');
//   }
// }



//   Future<List<LatLng>> _getRouteFromAPI(LatLng start, LatLng end) async {
//     String accessToken = 'pk.eyJ1IjoicmFodWw5ODA5IiwiYSI6ImNtM2N0bG5tYjIwbG4ydnNjMXF3Zmt0Y2wifQ.P4kkM2eW7eTZT9Ntw6-JVQ';
//     String url =
//         'https://api.mapbox.com/directions/v5/mapbox/driving/${start.longitude},${start.latitude};${end.longitude},${end.latitude}?alternatives=true&geometries=geojson&access_token=$accessToken';

//     try {
//       print('Fetching route from URL: $url');
//       final response = await http.get(Uri.parse(url));
//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//         print('Route API response received:$data');

//         if (data['routes'] == null || data['routes'].isEmpty) {
//           throw Exception('No routes found in the API response');
//         }

//         final route = data['routes'][0]['geometry']['coordinates']
//             .map<LatLng>((point) => LatLng(point[1], point[0]))
//             .toList();
//         return route;
//       } else {
//         throw Exception('Failed to load route data with status: ${response.statusCode}');
//       }
//     } catch (e) {
//       print('Error fetching route from API: $e');
//       throw e;
//     }
//   }

//   Future<Uint8List> _loadImage(String assetPath) async {
//     try {
//       print('Loading image from: $assetPath');
//       final byteData = await rootBundle.load(assetPath);
//       return byteData.buffer.asUint8List();
//     } catch (e) {
//       print('Error loading image: $e');
//       throw e;
//     }
//   }
// }
















































class MapboxWidget extends StatelessWidget {
  const MapboxWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<RideBloc, RideState>(
        listener: (context, state) {
          if (state is RideSimulationResumed) {
            _updateMap(context, state);
          }
        },
        builder: (context, state) {
          return _buildMap(context, state);
        },
      ),
    );
  }

  Widget _buildMap(BuildContext context, RideState state) {
    LatLng initialTarget = const LatLng(9.968677, 76.318354); // Default coordinates
    double initialZoom = 14.0;

    if (state is RideSimulationInProgress) {
      initialTarget = LatLng(state.currentLatitude, state.currentLongitude);
    }

    return MapboxMapWrapper(
      key: ValueKey(state),
      initialTarget: initialTarget,
      initialZoom: initialZoom,
      state: state,
    );
  }

  void _updateMap(BuildContext context, RideSimulationResumed state) {
    final mapController = context.read<MapboxMapController>();
    PolylineManager(mapController).addPolylineWithIconsAndAnimate(
      LatLng(state.startLatitude, state.startLongitude),
      LatLng(state.endLatitude, state.endLongitude),
    );
  }
}

class MapboxMapWrapper extends StatefulWidget {
  final LatLng initialTarget;
  final double initialZoom;
  final RideState state;

  const MapboxMapWrapper({
    required Key key,
    required this.initialTarget,
    required this.initialZoom,
    required this.state,
  }) : super(key: key);

  @override
  _MapboxMapWrapperState createState() => _MapboxMapWrapperState();
}

class _MapboxMapWrapperState extends State<MapboxMapWrapper> {
  late MapboxMapController _mapController;

  @override
  Widget build(BuildContext context) {
    return MapboxMap(
      onMapCreated: (controller) {
        _mapController = controller;
        _initializeOrUpdateMap(controller, context, widget.state);
      },
      accessToken: "pk.eyJ1IjoicmFodWw5ODA5IiwiYSI6ImNtM2N0bG5tYjIwbG4ydnNjMXF3Zmt0Y2wifQ.P4kkM2eW7eTZT9Ntw6-JVQ", // Replace with actual token
      initialCameraPosition: CameraPosition(target: widget.initialTarget, zoom: widget.initialZoom),
      styleString: MapboxStyles.MAPBOX_STREETS,
      zoomGesturesEnabled: true,
      scrollGesturesEnabled: true,
      rotateGesturesEnabled: true,
      tiltGesturesEnabled: true,
    );
  }

  void _initializeOrUpdateMap(MapboxMapController controller, BuildContext context, RideState state) {
    if (state is RideSimulationInProgress) {
      PolylineManager(controller).addPolylineWithIconsAndAnimate(
        LatLng(state.currentLatitude, state.currentLongitude),
        LatLng(state.endLatitude, state.endLongitude),
      );
    } else if (state is RideSimulationResumed) {
      PolylineManager(controller).addPolylineWithIconsAndAnimate(
        LatLng(state.startLatitude, state.startLongitude),
        LatLng(state.endLatitude, state.endLongitude),
      );
    }
  }
}

class PolylineManager {
  final MapboxMapController mapController;

  PolylineManager(this.mapController);

  Future<void> addPolylineWithIconsAndAnimate(LatLng start, LatLng end) async {
    try {
      List<LatLng> route = await _getRouteFromAPI(start, end);

      if (route.isEmpty) {
        print('Route API returned an empty route.');
        return;
      }

      await mapController.addLine(LineOptions(
        geometry: route,
        lineColor: "#0000FF",
        lineWidth: 5.0,
      ));

      await mapController.addImage("start-icon", await _loadImage('asset/start.png'));
      await mapController.addImage("end-icon", await _loadImage('asset/end.png'));

      Symbol startSymbol = await mapController.addSymbol(SymbolOptions(
        geometry: start,
        iconImage: "start-icon",
        iconSize: 0.1,
      ));

      await mapController.addSymbol(SymbolOptions(
        geometry: end,
        iconImage: "end-icon",
        iconSize: 0.1,
      ));

      _animateCameraToFitPolyline(route);
      _animateStartIconAndPolyline(startSymbol, route);
    } catch (e) {
      print('Error in addPolylineWithIconsAndAnimate: $e');
    }
  }

  Future<List<LatLng>> _getRouteFromAPI(LatLng start, LatLng end) async {
    final String accessToken = 'pk.eyJ1IjoicmFodWw5ODA5IiwiYSI6ImNtM2N0bG5tYjIwbG4ydnNjMXF3Zmt0Y2wifQ.P4kkM2eW7eTZT9Ntw6-JVQ'; // Replace with actual token
    final String url = 'https://api.mapbox.com/directions/v5/mapbox/driving/${start.longitude},${start.latitude};${end.longitude},${end.latitude}?alternatives=true&geometries=geojson&access_token=$accessToken';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['routes'] == null || data['routes'].isEmpty) {
          throw Exception('No routes found in the API response');
        }
        return data['routes'][0]['geometry']['coordinates']
            .map<LatLng>((point) => LatLng(point[1], point[0]))
            .toList();
      } else {
        throw Exception('Failed to load route data with status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching route from API: $e');
      throw e;
    }
  }

  Future<Uint8List> _loadImage(String assetPath) async {
    try {
      final byteData = await rootBundle.load(assetPath);
      return byteData.buffer.asUint8List();
    } catch (e) {
      print('Error loading image: $e');
      throw e;
    }
  }

  Future<void> _animateCameraToFitPolyline(List<LatLng> route) async {
    double minLat = route.map((e) => e.latitude).reduce((a, b) => a < b ? a : b);
    double minLng = route.map((e) => e.longitude).reduce((a, b) => a < b ? a : b);
    double maxLat = route.map((e) => e.latitude).reduce((a, b) => a > b ? a : b);
    double maxLng = route.map((e) => e.longitude).reduce((a, b) => a > b ? a : b);

    LatLngBounds bounds = LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );

    await mapController.animateCamera(CameraUpdate.newLatLngBounds(bounds));
    await mapController.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(target: LatLng((minLat + maxLat) / 2, (minLng + maxLng) / 2), zoom: 14.0),
    ));
  }

Future<void> _animateStartIconAndPolyline(Symbol startSymbol, List<LatLng> route) async {
  const duration = Duration(minutes: 1);
  const updateInterval = Duration(milliseconds: 100);
  final totalSteps = duration.inMilliseconds ~/ updateInterval.inMilliseconds;
  double currentStep = 0.0;
  final stepSize = (route.length - 1) / totalSteps; // Corrected step size for smooth movement

  Line? polyline;
  Symbol? endSymbol;

  try {
    // Add the polyline
    polyline = await mapController.addLine(LineOptions(
      geometry: route,
      lineColor: "#0000FF",
      lineWidth: 5.0,
    ));

    // Add the end symbol
    endSymbol = await mapController.addSymbol(SymbolOptions(
      geometry: route.last,
      iconImage: "end-icon",
      iconSize: 0.1,
    ));

    // Animation loop
    Timer.periodic(updateInterval, (timer) async {
      if (currentStep >= route.length - 1) {
        // Ensure the start icon reaches the endpoint
        await mapController.updateSymbol(startSymbol, SymbolOptions(geometry: route.last));

        // Remove the polyline and end symbol after animation ends
        if (polyline != null) await mapController.removeLine(polyline);
        if (endSymbol != null) await mapController.removeSymbol(endSymbol);

        timer.cancel();  // Stop the animation when the endpoint is reached
        return;
      }

      // Get the current position and next position
      int lowerIndex = currentStep.floor();
      int upperIndex = (lowerIndex + 1).clamp(0, route.length - 1);
      double t = currentStep - lowerIndex;

      // Interpolate the position of the start icon
      LatLng interpolatedPosition = LatLng(
        route[lowerIndex].latitude * (1 - t) + route[upperIndex].latitude * t,
        route[lowerIndex].longitude * (1 - t) + route[upperIndex].longitude * t,
      );

      // Update the position of the start symbol
      await mapController.updateSymbol(startSymbol, SymbolOptions(geometry: interpolatedPosition));

      // Increment currentStep to move the icon
      currentStep += stepSize;
    });
  } catch (e) {
    print('Error animating start icon and polyline: $e');
  }
}


}