import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:provider/provider.dart';
import 'package:basarsoft/ViewModel/new_activity_view_model.dart';

class NewActivityPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final newActivityViewModel = context.watch<NewActivityViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Yeni Aktivite"),
      ),
      body: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height / 2,
            child: FlutterMap(
              mapController: newActivityViewModel.mapController,
              options: MapOptions(
                initialZoom: 13.0,
                onTap: (tapPosition, latlng) {},
              ),
              children: [
                TileLayer(
                  urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                ),
                MarkerLayer(
                  markers: newActivityViewModel.markers,
                ),
                PolylineLayer(
                  polylines: [
                    Polyline(
                      points: newActivityViewModel.routePoints,
                      strokeWidth: 4.0,
                      color: Colors.red,
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${(newActivityViewModel.totalDistance / 1000).toStringAsFixed(2)} km',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 80),
                      Text(
                        '${newActivityViewModel.formattedActivityTimer}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 55),
                      Text(
                        '${newActivityViewModel.averageSpeed.toStringAsFixed(1)} km/h',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Toplam Mesafe",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      
                      SizedBox(width: 45), 
                      Text(
                        "Geçen Süre",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(width: 40,),
                      Text(
                        "Ortalama Hız",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),

                    ],
                  ),
                  const SizedBox(height: 50),
                  GestureDetector(
                    onTap: () {
                      newActivityViewModel.startActivity();
                    },
                    child: Container(
                      width: 200,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: const Center(
                        child: Text(
                          "Başlat",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: () {
                      newActivityViewModel.stopActivity();
                      _showInfo(context, newActivityViewModel);
                    },
                    child: Container(
                      width: 200,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: const Center(
                        child: Text(
                          "Bitir",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showInfo(BuildContext context, NewActivityViewModel newActivityViewModel) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Aktivite Özeti"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Toplam Mesafe: ${(newActivityViewModel.totalDistance / 1000).toStringAsFixed(2)} km'),
              Text('Geçen Süre: ${newActivityViewModel.formattedActivityTimer}'),
              Text('Ortalama Hız: ${newActivityViewModel.averageSpeed.toStringAsFixed(1)} km/h'),
            ],
          ),
          actions: [
            TextButton(
              child: const Text("Tamam"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
