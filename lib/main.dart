// import 'package:flutter/material.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'KYONS',
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
       
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//         useMaterial3: true,
//       ),
//       home: const MyHomePage(title: 'KYONS'),
//     );
//   }
// }

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key, required this.title});



//   final String title;

//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   int _counter = 0;

//   void _incrementCounter() {
//     setState(() {
      
//       _counter++;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
    
//     return Scaffold(
//       appBar: AppBar(
       
//         backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      
//         title: Text(widget.title),
//       ),
//       body: Center(
       
//         child: Column(
          
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             const Text(
//               'You have pushed the button this many times:',
//             ),
//             Text(
//               '$_counter',
//               style: Theme.of(context).textTheme.headlineMedium,
//             ),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _incrementCounter,
//         tooltip: 'Increment',
//         child: const Icon(Icons.add),
//       ),
//     );
//   }
// }



import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

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

  late GoogleMapController _mapController;
  final LatLng _chicagoCenter = const LatLng(41.8781, -87.6298);

  final Map<String, BitmapDescriptor> _icons = {};

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

  @override
  void initState() {
    super.initState();
    _loadCustomIcons();
  }

  Future<void> _loadCustomIcons() async {
    _icons["Soccer"] = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(size: Size(48, 48)), 'assets/soccer.png');
    _icons["Basketball"] = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(size: Size(48, 48)), 'assets/basketball.png');
    _icons["Tennis"] = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(size: Size(48, 48)), 'assets/tennis.png');
    setState(() {});
  }

  Set<Marker> _getFilteredMarkers() {
    return _venues
        .where((venue) => _selectedSport == "All" || venue["sport"] == _selectedSport)
        .map((venue) => Marker(
              markerId: MarkerId(venue["name"]),
              position: venue["position"],
              icon: _icons[venue["sport"]] ?? BitmapDescriptor.defaultMarker,
              infoWindow: InfoWindow(
                title: venue["name"],
                snippet:
                    "${venue["sport"]} | ${venue["hours"]} | Activity: ${venue["activityLevel"]}",
              ),
            ))
        .toSet();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chicago Sports Complexes"),
      ),
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: (controller) => _mapController = controller,
            initialCameraPosition: CameraPosition(
              target: _chicagoCenter,
              zoom: 12,
            ),
            markers: _getFilteredMarkers(),
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

