import 'package:basarsoft/Sevice/firebase_auth_service.dart';
import 'package:basarsoft/View/activity_history_page.dart';
import 'package:basarsoft/View/new_activity_page.dart';
import 'package:basarsoft/ViewModel/home_page_view_model.dart';
import 'package:basarsoft/Widget/infocard.dart';
import 'package:flutter/material.dart';
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
            return Center(
              child: Stack(
                children: [
                  configureImage("assets/images/walk.png", 70, 10),
                  configureInforCard(
                      "Toplam Mesafe = ${(viewModel.totalDistance / 1000).toStringAsFixed(2)} km",
                      110),
                  configureImage("assets/images/timer.png", 210, 25),
                  configureInforCard(
                      "Toplam Süre = ${viewModel.formatTimer(viewModel.totalDuration)}",
                      255),
                  configureImage("assets/images/total.png", 370, 30),
                  configureInforCard("Toplam Aktivite Sayısı = ${viewModel.count}",
                      405),
                  Positioned(
                    left: 30,
                    top: 560,
                    width: 130,
                    height: 50,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NewActivityPage(),
                          ),
                        ).then((_) {
                          viewModel.loadUserData();
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Center(
                          child: Text(
                            "Yeni Aktivite",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 30,
                    top: 560,
                    width: 130,
                    height: 50,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ActivityHistoryPage()),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Center(
                          child: Text(
                            "Aktivite Geçmişi",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Positioned configureInforCard(String title, double top) {
    return Positioned(
      left: 165,
      top: top,
      child: InfoCard(title: title),
    );
  }

  Positioned configureImage(String image, double top, double left) {
    return Positioned(
      left: left,
      top: top,
      child: Image.asset(
        image,
        height: 120,
        fit: BoxFit.cover,
      ),
    );
  }
}
