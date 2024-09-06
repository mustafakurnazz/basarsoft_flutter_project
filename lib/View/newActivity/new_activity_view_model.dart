import 'dart:async';
import 'package:basarsoft/core/model/new_activity_model.dart';
import 'package:basarsoft/core/service/database_helper.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class NewActivityViewModel extends ChangeNotifier {
  final MapController mapController = MapController();
  List<Marker> markers = [];
  List<LatLng> routePoints = [];
  LatLng? startLocation;
  LatLng? endLocation;
  LatLng? myLocation;
  StreamSubscription<Position>? positionStreamSubscription;
  String weatherDescription = '';
  double temperature = 0.0;

  double totalDistance = 0.0;
  Duration activityTimer = Duration.zero;
  double averageSpeed = 0.0;
  Timer? timer;

  NewActivityViewModel() {
    userCurrentLocation();
    fetchWeather();
  }

   Future<void> fetchWeather() async {
    if (myLocation == null) {
      await userCurrentLocation();
    }

    final apiKey = '541e8eafcb3c5a03ea17a398247167d4';
    final lat = myLocation?.latitude;
    final lon = myLocation?.longitude;

    if (lat != null && lon != null) {
      final url = Uri.parse(
          'https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&units=metric&appid=$apiKey&lang=tr');

      try {
        final response = await http.get(url);
        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          weatherDescription = data['weather'][0]['description'];
          temperature = data['main']['temp'];
          notifyListeners();
        } else {
          print('Hava durumu verisi alınamadı: ${response.statusCode}');
        }
      } catch (e) {
        print('Hata: $e');
      }
    }
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
      activityId: '', // Boş bırakıyoruz, daha sonra güncelleyeceğiz
      userId: user.uid,
      totalDistance: totalDistance,
      activityTimer: activityTimer.inSeconds,
      averageSpeed: averageSpeed,
      startLocation: startLocation,
      endLocation: endLocation,
      routePoints: routePoints, // Rota noktalarını ekliyoruz
      timestamp: Timestamp.now(),
    );

    // Firestore'a ekle
    FirebaseFirestore.instance.collection('activities').add(activity.toMap()).then((docRef) {
      String activityId = docRef.id;

      // Firestore'da activityId güncelle
      FirebaseFirestore.instance
          .collection('activities')
          .doc(activityId)
          .update({'activityId': activityId});

      // SQLite'a ekle
      NewActivityModel updatedActivity = NewActivityModel(
        activityId: activityId,
        userId: activity.userId,
        totalDistance: activity.totalDistance,
        activityTimer: activity.activityTimer,
        averageSpeed: activity.averageSpeed,
        startLocation: activity.startLocation,
        endLocation: activity.endLocation,
        routePoints: activity.routePoints,
        timestamp: activity.timestamp,
      );

      DatabaseHelper().insertActivity(updatedActivity);
    });
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
