import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:basarsoft/Models/activity_history_model.dart';
import 'package:intl/intl.dart';

class ActivityHistoryPage extends StatefulWidget {
  const ActivityHistoryPage({Key? key}) : super(key: key);

  @override
  _ActivityHistoryPageState createState() => _ActivityHistoryPageState();
}

class _ActivityHistoryPageState extends State<ActivityHistoryPage> {
  late Future<List<Activity>> _activitiesFuture;

  @override
  void initState() {
    super.initState();
    _activitiesFuture = fetchUserActivities();
  }

  Future<List<Activity>> fetchUserActivities() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return [];
    }

    final querySnapshot = await FirebaseFirestore.instance
        .collection('activities')
        .where('userId', isEqualTo: user.uid)
        .orderBy('timestamp', descending: true)
        .get();

    return querySnapshot.docs.map((doc) {
      return Activity.fromFirestore(doc);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Geçmiş Aktiviteler"),
      ),
      body: FutureBuilder<List<Activity>>(
        future: _activitiesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
              print('Hata: ${snapshot.error}');
            return const Center(child: Text('Bir hata oluştu.'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Hiç aktivite bulunamadı.'));
          }

          final activities = snapshot.data!;
          return ListView.builder(
            itemCount: activities.length,
            itemBuilder: (context, index) {
              final activity = activities[index];
              return Card(
                child: ListTile(
                  title: Text(DateFormat('dd/MM/yyyy – HH:mm')
                      .format(activity.timestamp.toDate())),
                  subtitle: Text('${activity.totalDistance.toStringAsFixed(1)} km'),
                  trailing: ElevatedButton(
                    onPressed: () {
                      // Detaylar sayfasına yönlendirme kodu buraya eklenecek
                    },
                    child: const Text('Detaylar'),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
