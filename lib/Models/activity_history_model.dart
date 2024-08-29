import 'package:cloud_firestore/cloud_firestore.dart';

class Activity {
  final double totalDistance;
  final double averageSpeed;
  final int elapsedTime;
  final GeoPoint? startLocation;
  final GeoPoint? endLocation;
  final Timestamp timestamp;

  Activity({
    required this.totalDistance,
    required this.averageSpeed,
    required this.elapsedTime,
    this.startLocation,
    this.endLocation,
    required this.timestamp,
  });

  factory Activity.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Activity(
      totalDistance: data['totalDistance'],
      averageSpeed: data['averageSpeed'],
      elapsedTime: data['elapsedTime'],
      startLocation: data['startLocation'],
      endLocation: data['endLocation'],
      timestamp: data['timestamp'],
    );
  }
}
