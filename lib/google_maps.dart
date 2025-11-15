import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class GoogleMaps extends StatefulWidget {
  const GoogleMaps({super.key});

  @override
  State<GoogleMaps> createState() => _GoogleMapsState();
}

class _GoogleMapsState extends State<GoogleMaps> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: FlutterMap(
        // mapController: MapController(),
        options: MapOptions(
          initialCenter: LatLng(35.768663, 51.458457),
          initialZoom: 5,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.example.store',
            // + many other options
          ),
          MarkerLayer(
            markers: [
              Marker(
                point: LatLng(35.768663, 51.458457),
                width: 80,
                height: 80,
                child: Text(
                  'نمایندگی دیجی کالا شعبه تهران',
                  style: TextStyle(color: Colors.red),
                ),
              ),
              Marker(
                point: LatLng(37.278906, 49.584580),
                width: 80,
                height: 80,
                child: Text('نمایندگی دیجی کالا شعبه رشت',
                  style: TextStyle(color: Colors.red),),
              ),
              Marker(
                point: LatLng(31.315439, 48.663467),
                width: 80,
                height: 80,
                child: Text('نمایندگی دیجی کالا شعبه اهواز',
                  style: TextStyle(color: Colors.red),),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
