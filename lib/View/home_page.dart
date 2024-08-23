import 'package:basarsoft/Sevice/firebase_auth_service.dart';
import 'package:basarsoft/Widget/infocard.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  final FirebaseAuthService auth = FirebaseAuthService();
  final double totalDistance;
  final Duration totalDuration;
  final int count;

  HomePage({
    super.key,
    required this.totalDistance,
    required this.totalDuration,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profil"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              auth.signOut(context);
            },
          ),
        ],
      ),
      body: Center(
        child: Stack(
          children: [
            configureImage("assets/images/walk.png", 70, 10),
            configureInforCard("Toplam Mesafe =" + ' ${totalDistance.toStringAsFixed(1)} km', 110),
            configureImage("assets/images/timer.png", 210, 25),
            configureInforCard("Toplam Süre = " + _formatDuration(totalDuration), 255),
            configureImage("assets/images/total.png", 370,30),
            configureInforCard("Toplam Aktivite Sayısı =" + ' $count', 405),
            configureButton("Yeni Aktivite", 30, 120),
            configureButton("Aktivite Geçmişi", 235, 130),
          ],
        ),
      ),
    );
  }

  Positioned configureButton(String text, double left, double width) {
    return Positioned(
            left: left,
            top: 560,
            width: width,
            height: 50,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  text,
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          );
  }

  Positioned configureInforCard(String title, double top) {
    return Positioned(
            left: 165,
            top: top,
            child: InfoCard(
              title: title,
            ),
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

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$hours:$minutes:$seconds';
  }
}
