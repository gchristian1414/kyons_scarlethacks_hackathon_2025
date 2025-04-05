class Venue {
  final String id;
  final String name;
  final double latitude;
  final double longitude;
  final String sportType;
  final String neighborhood;
  final String hours;
  final int activityLevel; // 1-5 scale
  final List<Activity> activities;

  Venue({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.sportType,
    required this.neighborhood,
    required this.hours,
    required this.activityLevel,
    this.activities = const [],
  });
}

class Activity {
  final String id;
  final String venueId;
  final String sportType;
  final DateTime dateTime;
  final int maxParticipants;
  final List<String> participants;
  final String organizerId;

  Activity({
    required this.id,
    required this.venueId,
    required this.sportType,
    required this.dateTime,
    required this.maxParticipants,
    this.participants = const [],
    required this.organizerId,
  });
} 