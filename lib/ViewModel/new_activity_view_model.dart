import 'dart:async';
import 'package:basarsoft/Models/new_activity_model.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class NewActivityViewModel extends ChangeNotifier {
  final MapController mapController = MapController();
  List<Marker> markers = [];
  List<LatLng> routePoints = [];
  LatLng? startLocation;
  LatLng? endLocation;
  LatLng? myLocation;
  StreamSubscription<Position>? positionStreamSubscription;

  double totalDistance = 0.0;
  Duration activityTimer = Duration.zero;
  double averageSpeed = 0.0;
  Timer? timer;

  NewActivityViewModel() {
    userCurrentLocation();
  }

  Future<void> userCurrentLocation() async {
    try {
      Position position = await _determinePosition();
      LatLng currentLatLng = LatLng(position.latitude, position.longitude);
      myLocation = currentLatLng;
      mapController.move(currentLatLng, 15.0);
      routePoints.add(currentLatLng);
      notifyListeners();
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  void addPoint(LatLng position, Color color) {
    markers.add(
      Marker(
        point: position,
        width: 10,
        height: 10,
        child: Container(
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
    notifyListeners();
  }

  void startActivity() {
    resetActivity();

    if (myLocation != null) {
      startLocation = myLocation;
      addPoint(startLocation!, Colors.green);
    }

    positionStreamSubscription = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.best,
        distanceFilter: 10,
      ),
    ).listen((Position position) {
      LatLng currentLatLng = LatLng(position.latitude, position.longitude);
      if (routePoints.isNotEmpty) {
        totalDistance += Geolocator.distanceBetween(
          routePoints.last.latitude,
          routePoints.last.longitude,
          currentLatLng.latitude,
          currentLatLng.longitude,
        );
      }
      routePoints.add(currentLatLng);
      mapController.move(currentLatLng, 15.0);
      _updateAverageSpeed();
      notifyListeners();
    });

    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      activityTimer = Duration(seconds: activityTimer.inSeconds + 1);
      _updateAverageSpeed();
      notifyListeners();
    });
  }

  void _updateAverageSpeed() {
    if (activityTimer.inSeconds > 0) {
      averageSpeed = ((totalDistance / 1000) / (activityTimer.inSeconds / 3600));
    }
  }

  void stopActivity() {
    positionStreamSubscription?.cancel();
    timer?.cancel();

    if (routePoints.isNotEmpty) {
      endLocation = routePoints.last;
      addPoint(endLocation!, Colors.red);
    }

    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      NewActivityModel activity = NewActivityModel(
        userId: user.uid,
        totalDistance: totalDistance,
        activityTimer: activityTimer.inSeconds,
        averageSpeed: averageSpeed,
        startLocation: startLocation,
        endLocation: endLocation,
        timestamp: Timestamp.now(),
      );

      FirebaseFirestore.instance.collection('activities').add(activity.toMap());
    }
    notifyListeners();
  }

   void resetActivity() {
    totalDistance = 0.0;
    activityTimer = Duration.zero;
    averageSpeed = 0.0;
    routePoints.clear();
    markers.clear();
  }

  String get formattedActivityTimer {
    return _formatTimer(activityTimer);
  }

  String _formatTimer(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$hours:$minutes:$seconds';
  }
}
