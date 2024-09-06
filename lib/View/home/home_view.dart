import 'package:basarsoft/core/service/firebase_auth_service.dart';
import 'package:basarsoft/View/activityHistory/activity_history_view.dart';
import 'package:basarsoft/View/newActivity/new_activity_view.dart';
import 'package:basarsoft/View/home/home_page_view_model.dart';
import 'package:basarsoft/core/widget/infocard.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart'; 

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HomePageViewModel()..loadUserData(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Profil"),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () {
                FirebaseAuthService().signOut(context);
              },
            ),
          ],
        ),
        body: Consumer<HomePageViewModel>(
          builder: (context, viewModel, child) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        const SizedBox(width: 20),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              viewModel.userName,
                              style: const TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    Row(
                      children: [
                        Flexible(
                          child: InfoCard(
                            title: "Toplam Mesafe",
                            value: "${(viewModel.totalDistance / 1000).toStringAsFixed(2)} km",
                            icon: Icons.directions_walk,
                            backgroundColor: Colors.blueAccent,
                            iconColor: Colors.black,
                          ),
                        ),
                        const SizedBox(width: 15),
                        Flexible(
                          child: InfoCard(
                            title: "Toplam Süre",
                            value: viewModel.formatTimer(viewModel.totalDuration),
                            icon: Icons.timer,
                            backgroundColor: Colors.green,
                            iconColor: Colors.black,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 15),
                    Row(
                      children: [
                        Expanded(
                          child: InfoCard(
                            title: "Aktivite Sayısı",
                            value: viewModel.count.toString(),
                            icon: Icons.event_available,
                            backgroundColor: Colors.orangeAccent,
                            iconColor: Colors.black,
                          ),
                        ),
                        const SizedBox(width: 15),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Haftalık Yürüyüş Hedefi",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            CircularPercentIndicator(
                              radius: 100.0,
                              lineWidth: 15.0,
                              animation: true,
                              percent: viewModel.weeklyProgress,
                              center: Text(
                                "${(viewModel.weeklyProgress * 100).toStringAsFixed(1)}%",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 22.0),
                              ),
                              circularStrokeCap: CircularStrokeCap.round,
                              progressColor: Colors.blueAccent,
                              backgroundColor: Colors.grey.shade200,
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              "Haftalık Hedef: 10 km",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w500),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                              backgroundColor: Colors.blueAccent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                            icon: const Icon(Icons.directions_run, size: 28),
                            label: const Text(
                              "Yeni Aktivite",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => NewActivityPage(),
                                ),
                              ).then((_) {
                                viewModel.loadUserData();
                              });
                            },
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                              backgroundColor: Colors.greenAccent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                            icon: const Icon(Icons.history, size: 28),
                            label: const Text(
                              "Aktivite Geçmişi",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const ActivityHistoryPage(),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
