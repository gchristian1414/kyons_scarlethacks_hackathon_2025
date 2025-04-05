import 'package:flutter/material.dart';
import '../models/venue.dart';

class VenueDetailsDialog extends StatelessWidget {
  final Venue venue;

  const VenueDetailsDialog({Key? key, required this.venue}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(venue.name),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Sport: ${venue.sportType}'),
            Text('Neighborhood: ${venue.neighborhood}'),
            Text('Hours: ${venue.hours}'),
            Text('Activity Level: ${'⭐' * venue.activityLevel}'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // TODO: Implement activity creation
                Navigator.pop(context);
              },
              child: const Text('Create Activity'),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Close'),
        ),
      ],
    );
  }
} 