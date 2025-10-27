import 'package:enevtly/features/auth/presentation/providers/auth_provider.dart';
import 'package:enevtly/features/events/domain/entities/event_entity.dart';
import 'package:enevtly/features/events/presentation/providers/events_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RsvpButton extends StatelessWidget {
  final EventEntity event;
  final bool isCompact;

  const RsvpButton({
    super.key,
    required this.event,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final eventsProvider = Provider.of<EventsProvider>(context);
    final currentUser = authProvider.currentUser;

    if (currentUser == null) {
      return ElevatedButton.icon(
        onPressed: () {
          Navigator.pushNamed(context, '/login');
        },
        icon: const Icon(Icons.login, size: 18),
        label: const Text('Login to RSVP'),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
      );
    }

    final isAttending = event.isUserAttending(currentUser.id);
    final isCreator = event.createdBy == currentUser.id;

    // Don't show RSVP button for event creator
    if (isCreator) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.blue[50],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.blue),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.star, size: 18, color: Colors.blue[700]),
            const SizedBox(width: 8),
            Text(
              'Organizer',
              style: TextStyle(
                color: Colors.blue[700],
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      );
    }

    if (isCompact) {
      return IconButton(
        onPressed: () => _toggleAttendance(context, eventsProvider, currentUser.id),
        icon: Icon(
          isAttending ? Icons.event_available : Icons.event_available_outlined,
          color: isAttending ? Colors.green : Colors.grey,
        ),
        tooltip: isAttending ? 'Leave Event' : 'Attend Event',
      );
    }

    return ElevatedButton.icon(
      onPressed: () => _toggleAttendance(context, eventsProvider, currentUser.id),
      icon: Icon(
        isAttending ? Icons.check_circle : Icons.event_available,
        size: 18,
      ),
      label: Text(isAttending ? 'Attending' : 'Attend Event'),
      style: ElevatedButton.styleFrom(
        backgroundColor: isAttending ? Colors.green : null,
        foregroundColor: isAttending ? Colors.white : null,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }

  Future<void> _toggleAttendance(
    BuildContext context,
    EventsProvider eventsProvider,
    String userId,
  ) async {
    final isAttending = event.isUserAttending(userId);
    
    bool success;
    if (isAttending) {
      success = await eventsProvider.leaveEvent(event.id, userId);
      if (context.mounted && success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('You have left the event'),
            backgroundColor: Colors.orange,
            duration: Duration(seconds: 1),
          ),
        );
      }
    } else {
      success = await eventsProvider.attendEvent(event.id, userId);
      if (context.mounted && success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('You are now attending this event!'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 1),
          ),
        );
      }
    }
    
    // Show error if failed
    if (!success && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(eventsProvider.errorMessage ?? 'Failed to update attendance'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }
}
