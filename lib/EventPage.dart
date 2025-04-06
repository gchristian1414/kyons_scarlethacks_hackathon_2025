import 'package:flutter/material.dart';
import 'package:map_app/venue_data.dart';


class EventPage extends StatefulWidget {
  const EventPage({super.key});

  @override
  State<EventPage> createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  List<Map<String, dynamic>> _events = [];

  void _addEvent(Map<String, dynamic> event) {
    setState(() {
      _events.add(event);
    });
  }

  void _toggleRSVP(int index) {
    setState(() {
      _events[index]['isGoing'] = !_events[index]['isGoing'];
      _events[index]['attendees'] += _events[index]['isGoing'] ? 1 : -1;
    });
  }

  void _showAddEventDialog() {
    final titleController = TextEditingController();
    final dateController = TextEditingController();
    final timeController = TextEditingController();

    String? selectedPark;
    String? selectedSport;

    final allSports = <String>{};
    for (var venue in chicagoVenues) {
      for (var sport in venue['sports'] as List) {
        allSports.add(sport);
      }
    }
    final sportOptions = allSports.toList();

    List<String> getFilteredParks() {
      if (selectedSport == null) return [];
      return chicagoVenues
          .where((v) => (v['sports'] as List).contains(selectedSport))
          .map((v) => v['name'] as String)
          .toSet()
          .toList();
    }

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Add Event'),
        content: StatefulBuilder(
          builder: (context, setModalState) => SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: 'Event Title'),
                ),
                DropdownButtonFormField<String>(
                  value: selectedSport,
                  decoration: const InputDecoration(labelText: 'Select Sport'),
                  items: sportOptions.map((sport) {
                    return DropdownMenuItem(value: sport, child: Text(sport));
                  }).toList(),
                  onChanged: (value) {
                    setModalState(() {
                      selectedSport = value;
                      selectedPark = null;
                    });
                  },
                ),
                DropdownButtonFormField<String>(
                  value: selectedPark,
                  decoration: const InputDecoration(labelText: 'Select Park'),
                  items: getFilteredParks().map((park) {
                    return DropdownMenuItem(value: park, child: Text(park));
                  }).toList(),
                  onChanged: selectedSport == null
                      ? null
                      : (value) => setModalState(() => selectedPark = value),
                ),
                TextField(
                  controller: dateController,
                  readOnly: true,
                  decoration: const InputDecoration(labelText: 'Select Date'),
                  onTap: () async {
                    final pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                    );
                    if (pickedDate != null) {
                      dateController.text = pickedDate.toString().split(' ')[0];
                    }
                  },
                ),
                TextField(
                  controller: timeController,
                  readOnly: true,
                  decoration: const InputDecoration(labelText: 'Select Time'),
                  onTap: () async {
                    final pickedTime = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );
                    if (pickedTime != null) {
                      final now = DateTime.now();
                      final dt = DateTime(now.year, now.month, now.day, pickedTime.hour, pickedTime.minute);
                      final formatted = TimeOfDay.fromDateTime(dt).format(context);
                      timeController.text = formatted;
                    }
                  },
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              if (titleController.text.isEmpty || selectedPark == null || selectedSport == null) return;

              _addEvent({
                'id': DateTime.now().millisecondsSinceEpoch.toString(),
                'title': titleController.text,
                'park': selectedPark!,
                'sport': selectedSport!,
                'date': dateController.text,
                'time': timeController.text,
                'attendees': 0,
                'isGoing': false,
              });
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Events'),
        centerTitle: true,
      ),
      body: _events.isEmpty
          ? const Center(child: Text('No events yet. Tap + to add one!'))
          : ListView.builder(
              itemCount: _events.length,
              itemBuilder: (context, index) {
                final event = _events[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: ListTile(
                    title: Text(event['title']),
                    subtitle: Text('${event['sport']} @ ${event['park']} on ${event['date']} at ${event['time']}'),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Attending: ${event['attendees']}'),
                        Checkbox(
                          value: event['isGoing'],
                          onChanged: (_) => _toggleRSVP(index),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddEventDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}
