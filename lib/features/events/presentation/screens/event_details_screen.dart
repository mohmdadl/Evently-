import 'package:cached_network_image/cached_network_image.dart';
import 'package:enevtly/core/utils/date_formatter.dart';
import 'package:enevtly/features/events/domain/entities/event_entity.dart';
import 'package:enevtly/features/events/presentation/widgets/rsvp_button.dart';
import 'package:flutter/material.dart';

class EventDetailsScreen extends StatelessWidget {
  final EventEntity event;

  const EventDetailsScreen({
    super.key,
    required this.event,
  });

  @override
  Widget build(BuildContext context) {
    final isPastEvent = event.isPastEvent;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App Bar with Image
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  CachedNetworkImage(
                    imageUrl: event.imageUrl,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      color: Colors.grey[300],
                      child: const Center(child: CircularProgressIndicator()),
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: Colors.grey[300],
                      child: const Icon(Icons.event, size: 80),
                    ),
                  ),
                  // Gradient overlay
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.7),
                        ],
                      ),
                    ),
                  ),
                  if (isPastEvent)
                    Positioned(
                      top: 100,
                      right: 16,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          'PAST EVENT',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),

          // Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    event.title,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 16),

                  // Organizer Info
                  Card(
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage: event.createdByPhoto != null
                            ? NetworkImage(event.createdByPhoto!)
                            : null,
                        child: event.createdByPhoto == null
                            ? const Icon(Icons.person)
                            : null,
                      ),
                      title: const Text('Organized by'),
                      subtitle: Text(
                        event.createdByName,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Date & Time
                  _buildInfoCard(
                    context,
                    icon: Icons.calendar_today,
                    title: 'Date & Time',
                    content: DateFormatter.formatDateTime(event.eventDate),
                  ),
                  const SizedBox(height: 12),

                  // Location
                  _buildInfoCard(
                    context,
                    icon: Icons.location_on,
                    title: 'Location',
                    content: event.location,
                  ),
                  const SizedBox(height: 12),

                  // Attendees
                  _buildInfoCard(
                    context,
                    icon: Icons.people,
                    title: 'Attendees',
                    content: '${event.attendeesCount} ${event.attendeesCount == 1 ? 'person' : 'people'} attending',
                  ),
                  const SizedBox(height: 24),

                  // Description
                  Text(
                    'About Event',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    event.description,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          height: 1.5,
                        ),
                  ),
                  const SizedBox(height: 24),

                  // Category (if available)
                  if (event.category != null) ...[
                    Text(
                      'Category',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Chip(
                      label: Text(event.category!),
                      backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
                    ),
                    const SizedBox(height: 24),
                  ],

                  // RSVP Button
                  if (!isPastEvent)
                    SizedBox(
                      width: double.infinity,
                      child: RsvpButton(
                        event: event,
                        isCompact: false,
                      ),
                    ),

                  if (isPastEvent)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.event_busy, color: Colors.grey),
                          SizedBox(width: 8),
                          Text(
                            'This event has ended',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String content,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              icon,
              color: Theme.of(context).primaryColor,
              size: 24,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    content,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
