import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:latlong2/latlong.dart';

class NewActivityModel {
  final String activityId;
  final String userId;
  final double totalDistance;
  final int activityTimer;
  final double averageSpeed;
  final LatLng? startLocation;
  final LatLng? endLocation;
  final List<LatLng> routePoints; 
  final Timestamp timestamp;

  NewActivityModel({
    required this.activityId,
    required this.userId,
    required this.totalDistance,
    required this.activityTimer,
    required this.averageSpeed,
    this.startLocation,
    this.endLocation,
    required this.routePoints, 
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'activityId': activityId,
      'userId': userId,
      'totalDistance': totalDistance,
      'activityTimer': activityTimer,
      'averageSpeed': averageSpeed,
      'startLocation': startLocation != null
          ? GeoPoint(startLocation!.latitude, startLocation!.longitude)
          : null,
      'endLocation': endLocation != null
          ? GeoPoint(endLocation!.latitude, endLocation!.longitude)
          : null,
      'routePoints': routePoints
          .map((point) => GeoPoint(point.latitude, point.longitude))
          .toList(),
      'timestamp': timestamp,
    };
  }
}
