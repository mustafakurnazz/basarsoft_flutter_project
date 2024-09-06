import 'package:basarsoft/core/model/activity_history_model.dart';
import 'package:basarsoft/View/activityHistory/activity_history_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../activityDetails/activity_details_view.dart';

class ActivityHistoryPage extends StatelessWidget {
  const ActivityHistoryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ActivityHistoryViewModel(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Geçmiş Aktiviteler"),
          backgroundColor: Colors.teal,
        ),
        body: Consumer<ActivityHistoryViewModel>(
          builder: (context, viewModel, child) {
            return FutureBuilder<List<Activity>>(
              future: viewModel.activitiesFuture,
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
                  padding: const EdgeInsets.all(8.0),
                  itemCount: activities.length,
                  itemBuilder: (context, index) {
                    final activity = activities[index];
                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      elevation: 5,
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(16.0),
                        leading: const CircleAvatar(
                          backgroundColor: Colors.teal,
                          child: Icon(
                            Icons.directions_walk,
                            color: Colors.white,
                          ),
                        ),
                        title: Text(
                          DateFormat('dd/MM/yyyy – HH:mm').format(activity.timestamp.toDate()),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          '${(activity.totalDistance / 1000).toStringAsFixed(2)} km',
                          style: const TextStyle(color: Colors.grey),
                        ),
                        trailing: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ActivityDetailsPage(activity: activity),
                              ),
                            );
                          },
                          child: Text('Detaylar'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.teal, 
                            foregroundColor: Colors.white, 
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
