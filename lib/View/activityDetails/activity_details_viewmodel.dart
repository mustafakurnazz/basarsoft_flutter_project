import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:basarsoft/core/model/activity_history_model.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map/flutter_map.dart';

class ActivityDetailsViewModel extends ChangeNotifier {
  final Activity activity;

  ActivityDetailsViewModel(this.activity);

  LatLng get initialCenter => activity.startLocation ?? LatLng(0, 0);
  List<LatLng> get routePoints => activity.routePoints;
  LatLng? get startLocation => activity.startLocation;
  LatLng? get endLocation => activity.endLocation;
  final MapController mapController = MapController();

  String get formattedTotalDistance =>
      '${(activity.totalDistance / 1000).toStringAsFixed(2)} km';

  String get formattedTimer => _formatTimer(Duration(seconds: activity.activityTimer));

  String get formattedDate => DateFormat('dd/MM/yyyy – HH:mm').format(activity.timestamp.toDate());

  void goToStartLocation() {
    if (startLocation != null) {
      moveToLocation(startLocation!);
    }
  }

   void moveToLocation(LatLng location) {
    mapController.move(location, 16.0); 
  }

  String _formatTimer(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$hours:$minutes:$seconds';
  }
}
