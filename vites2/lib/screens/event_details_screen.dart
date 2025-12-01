import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vites2/models/event.dart';
import 'package:vites2/services/event_service.dart';

class EventDetailsScreen extends StatefulWidget {
  final Event event;

  const EventDetailsScreen({super.key, required this.event});

  @override
  State<EventDetailsScreen> createState() => _EventDetailsScreenState();
}

class _EventDetailsScreenState extends State<EventDetailsScreen> {
  final EventService _eventService = EventService();
  late bool _isJoining;

  @override
  void initState() {
    super.initState();
    _isJoining = widget.event.participants
        .contains(FirebaseAuth.instance.currentUser?.uid);
  }

  void _toggleRsvp() {
    setState(() {
      _isJoining = !_isJoining;
    });
    _eventService.rsvpEvent(widget.event.id, _isJoining);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.event.title),
        actions: [
          TextButton(
            onPressed: _toggleRsvp,
            child: Text(
              _isJoining ? 'Ayrıl' : 'Katıl',
              style: TextStyle(
                color: Theme.of(context).textTheme.bodyLarge?.color,
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tarih: ${DateFormat('dd/MM/yyyy').format(widget.event.date.toDate())}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 10),
            Text(widget.event.description),
            const SizedBox(height: 20),
            Text(
              'Katılımcılar (${widget.event.participants.length})',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: widget.event.participants.length,
                itemBuilder: (context, index) {
                  final participantId = widget.event.participants[index];
                  return ListTile(
                    leading: const Icon(Icons.person),
                    title: Text(participantId),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
