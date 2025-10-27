import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:enevtly/core/constants/app_constants.dart';
import 'package:enevtly/core/resourses/colors_manager.dart';
import 'package:enevtly/core/utils/date_formatter.dart';
import 'package:enevtly/features/auth/presentation/providers/auth_provider.dart';
import 'package:enevtly/features/events/domain/entities/event_entity.dart';
import 'package:enevtly/features/events/presentation/providers/events_provider.dart';
import 'package:enevtly/features/events/presentation/widgets/rsvp_button.dart';

/// Home Screen - Main events listing
class HomeScreen extends StatefulWidget {
  static const String routeName = '/home';
  
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<EventsProvider>(context, listen: false).getAllEvents(refresh: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final eventsProvider = Provider.of<EventsProvider>(context);
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Evently'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.pushNamed(context, AppConstants.searchRoute);
            },
          ),
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.pushNamed(context, AppConstants.profileRoute);
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => eventsProvider.getAllEvents(refresh: true),
        child: eventsProvider.isLoading && eventsProvider.events.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : eventsProvider.events.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    itemCount: eventsProvider.events.length + 1,
                    itemBuilder: (context, index) {
                      if (index == eventsProvider.events.length) {
                        if (eventsProvider.hasMore) {
                          return _buildLoadMoreButton(eventsProvider);
                        }
                        return const SizedBox(height: 20);
                      }
                      
                      final event = eventsProvider.events[index];
                      return _buildEventCard(event, authProvider);
                    },
                  ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushNamed(context, AppConstants.createEventRoute);
        },
        backgroundColor: ColorsManager.primaryColor,
        icon: const Icon(Icons.add),
        label: const Text('Create Event'),
      ),
    );
  }
  
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.event_busy,
            size: 100,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No events yet',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Be the first to create an event!',
            style: TextStyle(color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }
  
  Widget _buildLoadMoreButton(EventsProvider provider) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: provider.isLoading
            ? const CircularProgressIndicator()
            : OutlinedButton(
                onPressed: () => provider.getAllEvents(),
                child: const Text('Load More'),
              ),
      ),
    );
  }
  
  Widget _buildEventCard(EventEntity event, AuthProvider authProvider) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(
            context,
            AppConstants.eventDetailsRoute,
            arguments: event,
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Event Image
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              child: CachedNetworkImage(
                imageUrl: event.imageUrl,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  color: Colors.grey[300],
                  child: const Center(child: CircularProgressIndicator()),
                ),
                errorWidget: (context, url, error) => Container(
                  color: Colors.grey[300],
                  child: const Icon(Icons.event, size: 50),
                ),
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    event.title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  
                  // Date and Time
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        size: 16,
                        color: ColorsManager.primaryColor,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        DateFormatter.formatDateTime(event.eventDate),
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  
                  // Location
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        size: 16,
                        color: ColorsManager.primaryColor,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          event.location,
                          style: TextStyle(color: Colors.grey[600]),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  
                  // Attendees Count and RSVP
                  Row(
                    children: [
                      Icon(
                        Icons.people,
                        size: 18,
                        color: ColorsManager.primaryColor,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${event.attendeesCount} attending',
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                      const Spacer(),
                      RsvpButton(event: event, isCompact: true),
                    ],
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
