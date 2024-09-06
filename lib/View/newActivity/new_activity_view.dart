import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:provider/provider.dart';
import 'package:basarsoft/View/newActivity/new_activity_view_model.dart';

class NewActivityPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final newActivityViewModel = context.watch<NewActivityViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Yeni Aktivite"),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.blueGrey,
      ),
      body: Column(
        children: [
          Stack(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height / 2.5,
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
              Positioned(
                top: 10,
                right: 10,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 6,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: newActivityViewModel.weatherDescription != null &&
                          newActivityViewModel.temperature != null
                      ? Text(
                          '${newActivityViewModel.temperature.toStringAsFixed(0)}°C',
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        )
                      : const CircularProgressIndicator(),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildInfoCard(
                    title: 'Toplam Mesafe',
                    value: '${(newActivityViewModel.totalDistance / 1000).toStringAsFixed(2)} km',
                  ),
                  const SizedBox(height: 10),
                  _buildInfoCard(
                    title: 'Geçen Süre',
                    value: newActivityViewModel.formattedActivityTimer,
                  ),
                  const SizedBox(height: 10),
                  _buildInfoCard(
                    title: 'Ortalama Hız',
                    value: '${newActivityViewModel.averageSpeed.toStringAsFixed(1)} km/h',
                  ),
                  const Spacer(),
                  _buildActionButton(
                    context: context,
                    label: "Başlat",
                    color: Colors.green,
                    onTap: () => newActivityViewModel.startActivity(),
                  ),
                  const SizedBox(height: 10),
                  _buildActionButton(
                    context: context,
                    label: "Bitir",
                    color: Colors.red,
                    onTap: () {
                      newActivityViewModel.stopActivity();
                      _showInfo(context, newActivityViewModel);
                    },
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard({required String title, required String value}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blueGrey[50],
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Colors.black54,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required BuildContext context,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 50,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Center(
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
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
