import 'package:geolocator/geolocator.dart';
import '../models/venue.dart';

class VenueService {
  static final List<Venue> venues = [
    Venue(
      id: '1',
      name: 'Lincoln Park Soccer Field',
      latitude: 41.9214,
      longitude: -87.6513,
      sportType: 'Soccer',
      neighborhood: 'Lincoln Park',
      hours: '6:00 AM - 10:00 PM',
      activityLevel: 4,
    ),
    Venue(
      id: '2',
      name: 'Humboldt Park Basketball Court',
      latitude: 41.9018,
      longitude: -87.7016,
      sportType: 'Basketball',
      neighborhood: 'Humboldt Park',
      hours: '7:00 AM - 9:00 PM',
      activityLevel: 3,
    ),
    Venue(
      id: '3',
      name: 'Margate Tennis Court',
      latitude: 41.9732,
      longitude: -87.6498,
      sportType: 'Tennis',
      neighborhood: 'Uptown',
      hours: '8:00 AM - 8:00 PM',
      activityLevel: 2,
    ),
  ];

  static List<Venue> getFilteredVenues(String sportType) {
    if (sportType == 'All') return venues;
    return venues.where((venue) => venue.sportType == sportType).toList();
  }

  static List<Venue> getNearbyVenues(Position userLocation, {int limit = 5}) {
    final venuesWithDistance = venues.map((venue) => {
          'venue': venue,
          'distance': Geolocator.distanceBetween(
            userLocation.latitude,
            userLocation.longitude,
            venue.latitude,
            venue.longitude,
          ),
        }).toList()
      ..sort((a, b) => (a['distance'] as double).compareTo(b['distance'] as double));
    
    return venuesWithDistance
        .map((v) => v['venue'] as Venue)
        .take(limit)
        .toList();
  }

  static List<String> getAvailableSports() {
    return ['All', ...venues.map((v) => v.sportType).toSet().toList()];
  }
} 