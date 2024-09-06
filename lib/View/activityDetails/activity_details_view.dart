import 'package:basarsoft/core/model/activity_history_model.dart';
import 'package:basarsoft/View/activityDetails/activity_details_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:provider/provider.dart';

class ActivityDetailsPage extends StatelessWidget {
  final Activity activity;

  const ActivityDetailsPage({Key? key, required this.activity}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ActivityDetailsViewModel(activity),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Aktivite Detayları"),
          backgroundColor: Colors.deepPurple, 
          elevation: 0,
        ),
        body: Consumer<ActivityDetailsViewModel>(
          builder: (context, viewModel, child) {
            return Column(
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      FlutterMap(
                        mapController: viewModel.mapController,
                        options: MapOptions(
                          initialCenter: viewModel.initialCenter,
                          initialZoom: 16.0,
                        ),
                        children: [
                          TileLayer(
                            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                          ),
                          PolylineLayer(
                            polylines: [
                              Polyline(
                                points: viewModel.routePoints,
                                strokeWidth: 4.0,
                                color: Colors.deepPurpleAccent, 
                              ),
                            ],
                          ),
                          MarkerLayer(
                            markers: [
                              if (viewModel.startLocation != null)
                                Marker(
                                  point: viewModel.startLocation!,
                                 child:  const Icon(Icons.location_on, color: Colors.green),
                                ),
                              if (viewModel.endLocation != null)
                                Marker(
                                  point: viewModel.endLocation!,
                                  child:  const Icon(Icons.location_on, color: Colors.red),
                                ),
                            ],
                          ),
                        ],
                      ),
                      Positioned(
                        top: 16.0,
                        right: 16.0,
                        child: FloatingActionButton(
                          onPressed: () {viewModel.goToStartLocation();}, 
                          backgroundColor: Colors.deepPurple,
                          child: const Icon(Icons.navigation, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, -2),
                      ),
                    ],
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(24.0)),
                  ),
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Aktivite Bilgileri",
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.deepPurple,
                            ),
                      ),
                      const SizedBox(height: 16.0),
                      _buildInfoRow(Icons.directions_walk, "Toplam Mesafe", viewModel.formattedTotalDistance),
                      _buildInfoRow(Icons.timer, "Süre", viewModel.formattedTimer),
                      _buildInfoRow(Icons.calendar_today, "Tarih", viewModel.formattedDate),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.deepPurple),
          const SizedBox(width: 16.0),
          Text(
            "$label: ",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(color: Colors.black54),
            ),
          ),
        ],
      ),
    );
  }
}
