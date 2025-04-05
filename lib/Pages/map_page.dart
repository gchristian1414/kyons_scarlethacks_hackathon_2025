// // import 'package:flutter/material.dart';
// // import 'package:google_maps_flutter/google_maps_flutter.dart';

// // class MapPage extends StatefulWidget {
// //   const MapPage({super.key});

// //   @override
// //   State<MapPage> createState() => _MapPageState();
// // }

// // class _MapPageState extends State<MapPage> {
// //   GoogleMapController? mapController;
// //   String _selectedSport = 'All';
// //   Map<String, dynamic>? _selectedVenue;

// //   final LatLng _chicagoCenter = const LatLng(41.8781, -87.6298);

// //   final List<Map<String, dynamic>> _venues = [
// //     {
// //       'id': '1',
// //       'name': 'Lincoln Park Soccer Field',
// //       'lat': 41.9214,
// //       'lng': -87.6513,
// //       'sport': 'Soccer',
// //       'hours': '6:00 AM - 10:00 PM',
// //       'activity': 4,
// //     },
// //     {
// //       'id': '2',
// //       'name': 'Humboldt Park Basketball Court',
// //       'lat': 41.9018,
// //       'lng': -87.7016,
// //       'sport': 'Basketball',
// //       'hours': '7:00 AM - 9:00 PM',
// //       'activity': 3,
// //     },
// //     {
// //       'id': '3',
// //       'name': 'Margate Tennis Court',
// //       'lat': 41.9732,
// //       'lng': -87.6498,
// //       'sport': 'Tennis',
// //       'hours': '8:00 AM - 8:00 PM',
// //       'activity': 2,
// //     },
// //   ];

// //   Set<Marker> _getVenueMarkers() {
// //     return _venues
// //         .where((venue) => _selectedSport == 'All' || venue['sport'] == _selectedSport)
// //         .map((venue) => Marker(
// //               markerId: MarkerId(venue['id']),
// //               position: LatLng(venue['lat'], venue['lng']),
// //               infoWindow: InfoWindow(
// //                 title: venue['name'],
// //                 snippet: '${venue['sport']} — ${venue['hours']}',
// //               ),
// //               icon: BitmapDescriptor.defaultMarkerWithHue(
// //                 venue['sport'] == 'Soccer'
// //                     ? BitmapDescriptor.hueGreen
// //                     : venue['sport'] == 'Basketball'
// //                         ? BitmapDescriptor.hueOrange
// //                         : BitmapDescriptor.hueAzure,
// //               ),
// //             ))
// //         .toSet();
// //   }

// //   List<String> _getSportTypes() {
// //     return ['All', ..._venues.map((v) => v['sport'] as String).toSet()];
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: const Text('Chicago Sports Map',style: TextStyle(fontWeight: FontWeight.bold),),
// //         actions: [
// //           DropdownButton<String>(
// //             value: _selectedSport,
// //             onChanged: (value) => setState(() => _selectedSport = value!),
// //             items: _getSportTypes()
// //                 .map((sport) => DropdownMenuItem(
// //                       value: sport,
// //                       child: Text(sport),
// //                     ))
// //                 .toList(),
// //           ),
// //         ],
// //       ),
// //       body: Column(
// //         children: [
// //           Expanded(
// //             child: GoogleMap(
// //               onMapCreated: (controller) => mapController = controller,
// //               initialCameraPosition: CameraPosition(
// //                 target: _chicagoCenter,
// //                 zoom: 12,
// //               ),
// //               markers: _getVenueMarkers(),
// //               myLocationEnabled: false,
// //             ),
// //           ),
// //           Padding(
// //             padding: const EdgeInsets.all(8.0),
// //             child: Text('See available venues:',style: TextStyle(fontWeight: FontWeight.bold),),
// //           ),
// //           DropdownButton<Map<String, dynamic>>(
// //             isExpanded: true,
// //             hint: const Text('Select a venue',style: TextStyle(fontWeight: FontWeight.bold),),
// //             value: null,
// //             items: _venues
// //                 .where((v) => _selectedSport == 'All' || v['sport'] == _selectedSport)
// //                 .map((venue) => DropdownMenuItem<Map<String, dynamic>>(
// //                       value: venue,
// //                       child: Text('${venue['name']} - ${venue['sport']}'),
// //                     ))
// //                 .toList(),
// //             onChanged: (venue) {
// //               if (venue != null) {
// //                 showDialog(
// //                   context: context,
// //                   builder: (_) => AlertDialog(
// //                     title: Text(venue['name']),
// //                     content: Text(
// //                       'Sport: ${venue['sport']}\n'
// //                       'Hours: ${venue['hours']}\n'
// //                       'Activity Level: ${venue['activity']}★',
// //                     ),
// //                   ),
// //                 );
// //               }
// //             },
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }




// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:flutter/services.dart' show rootBundle;
// import 'package:csv/csv.dart';

// class Venue {
//   final String id;
//   final String name;
//   final double lat;
//   final double lng;
//   final String sport;
//   final String hours;
//   final int activity;

//   Venue({
//     required this.id,
//     required this.name,
//     required this.lat,
//     required this.lng,
//     required this.sport,
//     required this.hours,
//     required this.activity,
//   });

//   factory Venue.fromCsv(List<dynamic> row) {
//     return Venue(
//       id: row[1].toString(),
//       name: '${row[3]} - ${row[5]}',
//       lat: double.tryParse(row[8].toString()) ?? 0.0,
//       lng: double.tryParse(row[7].toString()) ?? 0.0,
//       sport: row[5].toString(),
//       hours: '6:00 AM - 10:00 PM',
//       activity: 3,
//     );
//   }
// }

// class MapPage extends StatefulWidget {
//   const MapPage({super.key});

//   @override
//   State<MapPage> createState() => _MapPageState();
// }

// class _MapPageState extends State<MapPage> {
//   GoogleMapController? mapController;
//   String _selectedSport = 'All';
//   List<Venue> _venues = [];

//   final LatLng _chicagoCenter = const LatLng(41.8781, -87.6298);

//   @override
//   void initState() {
//     super.initState();
//     loadVenuesFromCsv();
//   }

//   Future<void> loadVenuesFromCsv() async {
//     final data = await rootBundle.loadString('assets/CPD_Facilities.csv');
//     final csv = const CsvToListConverter().convert(data, eol: '\n');
//     csv.removeAt(0); // Remove header
//     setState(() {
//       _venues = csv.map((row) => Venue.fromCsv(row)).toList();
//     });
//   }

//   Set<Marker> _getVenueMarkers() {
//     return _venues
//         .where((venue) => _selectedSport == 'All' || venue.sport == _selectedSport)
//         .map((venue) => Marker(
//               markerId: MarkerId(venue.id),
//               position: LatLng(venue.lat, venue.lng),
//               infoWindow: InfoWindow(
//                 title: venue.name,
//                 snippet: '${venue.sport} — ${venue.hours}',
//               ),
//               icon: BitmapDescriptor.defaultMarkerWithHue(
//                 venue.sport.contains('Soccer')
//                     ? BitmapDescriptor.hueGreen
//                     : venue.sport.contains('Basketball')
//                         ? BitmapDescriptor.hueOrange
//                         : BitmapDescriptor.hueAzure,
//               ),
//             ))
//         .toSet();
//   }

//   List<String> _getSportTypes() {
//     return ['All', ..._venues.map((v) => v.sport).toSet()];
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Chicago Sports Map'),
//         actions: [
//           DropdownButton<String>(
//             value: _selectedSport,
//             onChanged: (value) => setState(() => _selectedSport = value!),
//             items: _getSportTypes()
//                 .map((sport) => DropdownMenuItem(
//                       value: sport,
//                       child: Text(sport),
//                     ))
//                 .toList(),
//           ),
//         ],
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: GoogleMap(
//               onMapCreated: (controller) => mapController = controller,
//               initialCameraPosition: CameraPosition(
//                 target: _chicagoCenter,
//                 zoom: 12,
//               ),
//               markers: _getVenueMarkers(),
//               myLocationEnabled: false,
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Text('See available venues:'),
//           ),
//           DropdownButton<Venue>(
//             isExpanded: true,
//             hint: const Text('Select a venue'),
//             items: _venues
//                 .where((v) => _selectedSport == 'All' || v.sport == _selectedSport)
//                 .map((venue) => DropdownMenuItem<Venue>(
//                       value: venue,
//                       child: Text('${venue.name} - ${venue.sport}'),
//                     ))
//                 .toList(),
//             onChanged: (venue) {
//               if (venue != null) {
//                 showDialog(
//                   context: context,
//                   builder: (_) => AlertDialog(
//                     title: Text(venue.name),
//                     content: Text(
//                       'Sport: ${venue.sport}\n'
//                       'Hours: ${venue.hours}\n'
//                       'Activity Level: ${venue.activity}★',
//                     ),
//                   ),
//                 );
//               }
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:map_app/venue_data.dart';


class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  GoogleMapController? mapController;
  String _selectedSport = 'All';
  final LatLng _chicagoCenter = const LatLng(41.8781, -87.6298);

  List<Map<String, dynamic>> get _filteredVenues {
    return _selectedSport == 'All'
        ? chicagoVenues
        : chicagoVenues.where((v) => v['sport'] == _selectedSport).toList();
  }

  Set<Marker> _getVenueMarkers() {
    return _filteredVenues.map((venue) => Marker(
          markerId: MarkerId(venue['id']),
          position: LatLng(venue['lat'], venue['lng']),
          infoWindow: InfoWindow(
            title: venue['name'],
            snippet: '${venue['sport']} — ${venue['hours']}',
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(
            venue['sport'].contains('Soccer')
                ? BitmapDescriptor.hueGreen
                : venue['sport'].contains('Basketball')
                    ? BitmapDescriptor.hueOrange
                    : BitmapDescriptor.hueAzure,
          ),
        )).toSet();
  }

  List<String> _getSportTypes() {
    return ['All', ...chicagoVenues.map((v) => v['sport'] as String).toSet()];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chicago Sports Map'),
        actions: [
          DropdownButton<String>(
            value: _selectedSport,
            onChanged: (value) => setState(() => _selectedSport = value!),
            items: _getSportTypes()
                .map((sport) => DropdownMenuItem(
                      value: sport,
                      child: Text(sport),
                    ))
                .toList(),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: GoogleMap(
              onMapCreated: (controller) => mapController = controller,
              initialCameraPosition: CameraPosition(
                target: _chicagoCenter,
                zoom: 12,
              ),
              markers: _getVenueMarkers(),
              myLocationEnabled: false,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('See available venues:'),
          ),
          DropdownButton<Map<String, dynamic>>(
            isExpanded: true,
            hint: const Text('Select a venue'),
            items: _filteredVenues
                .map((venue) => DropdownMenuItem<Map<String, dynamic>>(
                      value: venue,
                      child: Text('${venue['name']} - ${venue['sport']}'),
                    ))
                .toList(),
            onChanged: (venue) {
              if (venue != null) {
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: Text(venue['name']),
                    content: Text(
                      'Sport: ${venue['sport']}\n'
                      'Hours: ${venue['hours']}\n'
                      'Activity Level: ${venue['activity']}★',
                    ),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
