import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

void main() {
  runApp(const SportsMapApp());
}

class SportsMapApp extends StatelessWidget {
  const SportsMapApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Chicago Sports Map',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const MapScreen(),
    );
  }
}

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final List<String> _sports = ["All", "Soccer", "Basketball", "Tennis"];
  String _selectedSport = "All";

  final List<Map<String, dynamic>> _venues = [
    {
      "name": "Harrison Park",
      "position": LatLng(41.8600, -87.6560),
      "sport": "Soccer",
      "hours": "6 AM - 10 PM",
      "activityLevel": "Moderate",
    },
    {
      "name": "Margate Park",
      "position": LatLng(41.9732, -87.6516),
      "sport": "Basketball",
      "hours": "6 AM - 11 PM",
      "activityLevel": "High",
    },
    {
      "name": "Wicker Park",
      "position": LatLng(41.9088, -87.6796),
      "sport": "Tennis",
      "hours": "7 AM - 9 PM",
      "activityLevel": "Low",
    },
  ];

 List<Marker> _getFilteredMarkers() {
  return _venues
      .where((venue) =>
          _selectedSport == "All" || venue["sport"] == _selectedSport)
      .map((venue) {
    return Marker(
      point: venue["position"] as LatLng,
      width: 60,
      height: 60,
      child: Tooltip(
        message:
            "${venue["name"]}\n${venue["sport"]} • ${venue["hours"]} • Activity: ${venue["activityLevel"]}",
        child: Icon(
          _getSportIcon(venue["sport"]),
          size: 32,
          color: Colors.green,
        ),
      ),
    );
  }).toList();
}

  IconData _getSportIcon(String sport) {
    switch (sport) {
      case "Soccer":
        return Icons.sports_soccer;
      case "Basketball":
        return Icons.sports_basketball;
      case "Tennis":
        return Icons.sports_tennis;
      default:
        return Icons.location_on;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Chicago Sports Complexes")),
      body: Stack(
        children: [
          FlutterMap(
            options: MapOptions(
              center: LatLng(41.8781, -87.6298),
              zoom: 12.0,
            ),
            children: [
              TileLayer(
                urlTemplate:
                    'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                subdomains: ['a', 'b', 'c'],
              ),
              MarkerLayer(
                markers: _getFilteredMarkers(),
              ),
            ],
          ),
          Positioned(
            top: 10,
            left: 10,
            right: 10,
            child: Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: DropdownButton<String>(
                  isExpanded: true,
                  value: _selectedSport,
                  items: _sports
                      .map((sport) => DropdownMenuItem(
                            value: sport,
                            child: Text(sport),
                          ))
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _selectedSport = value;
                      });
                    }
                  },
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}