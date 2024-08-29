import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePageViewModel extends ChangeNotifier {
  double totalDistance = 0.0;
  Duration totalDuration = Duration.zero;
  int count = 0;

  Future<void> loadUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance
          .collection('activities')
          .where('userId', isEqualTo: user.uid)
          .get();

      double distance = 0.0;
      Duration duration = Duration.zero;
      int activityCount = snapshot.docs.length;

      for (var doc in snapshot.docs) {
        distance += (doc.data()['totalDistance'] ?? 0.0);
        duration += Duration(seconds: (doc.data()['activityTimer'] ?? 0));
      }

      totalDistance = distance;
      totalDuration = duration;
      count = activityCount;
      notifyListeners(); 
    }
  }

  String formatTimer(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$hours:$minutes:$seconds';
  }
}
