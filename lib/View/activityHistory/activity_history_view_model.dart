import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:basarsoft/core/model/activity_history_model.dart';

class ActivityHistoryViewModel extends ChangeNotifier {
  Future<List<Activity>> activitiesFuture = Future.value([]);

  ActivityHistoryViewModel() {
    fetchUserActivities();
  }

  Future<void> fetchUserActivities() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      activitiesFuture = Future.value([]);
      return;
    }

    final querySnapshot = await FirebaseFirestore.instance
        .collection('activities')
        .where('userId', isEqualTo: user.uid)
        .orderBy('timestamp', descending: true)
        .get();

    activitiesFuture = Future.value(querySnapshot.docs.map((doc) {
      return Activity.fromFirestore(doc);
    }).toList());

    notifyListeners(); 
  }
}
