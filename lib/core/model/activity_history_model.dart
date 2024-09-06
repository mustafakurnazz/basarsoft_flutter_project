import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:latlong2/latlong.dart';

class Activity {
  final String activityId;
  final String userId;
  final double totalDistance;
  final int activityTimer;
  final double averageSpeed;
  final LatLng? startLocation;
  final LatLng? endLocation;
  final Timestamp timestamp;
  final List<LatLng> routePoints;

  Activity({
    required this.activityId,
    required this.userId,
    required this.totalDistance,
    required this.activityTimer,
    required this.averageSpeed,
    this.startLocation,
    this.endLocation,
    required this.timestamp,
    required this.routePoints,
  });

  factory Activity.fromFirestore(DocumentSnapshot doc) {
  Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

  List<LatLng> points = (data['routePoints'] as List?)
          ?.map((point) => LatLng(point.latitude, point.longitude))
          .toList() ??
      [];

  return Activity(
    activityId: data['activityId'],
    userId: data['userId'],
    totalDistance: data['totalDistance'],
    activityTimer: data['activityTimer'],
    averageSpeed: data['averageSpeed'],
    startLocation: data['startLocation'] != null
        ? LatLng(data['startLocation'].latitude, data['startLocation'].longitude)
        : null,
    endLocation: data['endLocation'] != null
        ? LatLng(data['endLocation'].latitude, data['endLocation'].longitude)
        : null,
    timestamp: data['timestamp'],
    routePoints: points,
  );
 }
}
