import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'models/venue.dart';
import 'services/venue_service.dart';
import 'widgets/venue_details_dialog.dart';

void main() {
  runApp(SportsMapApp());
}

class SportsMapApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chicago Sports Map',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  GoogleMapController? mapController;
  Position? _currentPosition;
  String selectedSport = 'All';
  List<Venue> nearbyVenues = [];
  bool showAllVenues = false;

  @override
  void initState() {
    super.initState();
    _getUserLocation();
  }

  Future<void> _getUserLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) return;

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    setState(() {
      _currentPosition = position;
      if (position != null) {
        nearbyVenues = VenueService.getNearbyVenues(position);
      }
    });
  }

  Set<Marker> _getFilteredMarkers() {
    final venues = showAllVenues
        ? VenueService.getFilteredVenues(selectedSport)
        : nearbyVenues.where((v) => selectedSport == 'All' || v.sportType == selectedSport).toList();

    return venues.map((venue) {
      return Marker(
        markerId: MarkerId(venue.id),
        position: LatLng(venue.latitude, venue.longitude),
        icon: _getSportIcon(venue.sportType),
        infoWindow: InfoWindow(
          title: venue.name,
          snippet: venue.sportType,
          onTap: () {
            showDialog(
              context: context,
              builder: (_) => VenueDetailsDialog(venue: venue),
            );
          },
        ),
      );
    }).toSet();
  }

  BitmapDescriptor _getSportIcon(String sportType) {
    // TODO: Implement custom icons for different sports
    return BitmapDescriptor.defaultMarker;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chicago Sport Complexes'),
        actions: [
          DropdownButton<String>(
            value: selectedSport,
            items: VenueService.getAvailableSports()
                .map((sport) => DropdownMenuItem(
                      value: sport,
                      child: Text(sport),
                    ))
                .toList(),
            onChanged: (value) {
              setState(() {
                selectedSport = value!;
              });
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _currentPosition != null
                  ? LatLng(_currentPosition!.latitude, _currentPosition!.longitude)
                  : const LatLng(41.8781, -87.6298), // Chicago coordinates
              zoom: 12,
            ),
            markers: _getFilteredMarkers(),
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            onMapCreated: (controller) {
              setState(() {
                mapController = controller;
              });
            },
          ),
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Nearby Venues',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    ...nearbyVenues.take(3).map((venue) => ListTile(
                          title: Text(venue.name),
                          subtitle: Text(venue.sportType),
                          onTap: () {
                            mapController?.animateCamera(
                              CameraUpdate.newLatLng(
                                LatLng(venue.latitude, venue.longitude),
                              ),
                            );
                            showDialog(
                              context: context,
                              builder: (_) => VenueDetailsDialog(venue: venue),
                            );
                          },
                        )),
                    if (!showAllVenues)
                      TextButton(
                        onPressed: () {
                          setState(() {
                            showAllVenues = true;
                          });
                        },
                        child: const Text('See More Venues'),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}