import 'package:dartz/dartz.dart';
import 'package:enevtly/core/error/failures.dart';
import 'package:enevtly/features/events/domain/entities/event_entity.dart';

/// Events Repository Interface
abstract class EventsRepository {
  /// Create new event
  Future<Either<Failure, EventEntity>> createEvent(EventEntity event);
  
  /// Update event
  Future<Either<Failure, EventEntity>> updateEvent(EventEntity event);
  
  /// Delete event
  Future<Either<Failure, void>> deleteEvent(String eventId);
  
  /// Get event by ID
  Future<Either<Failure, EventEntity>> getEventById(String eventId);
  
  /// Get all events (with pagination)
  Future<Either<Failure, List<EventEntity>>> getAllEvents({
    int? limit,
    String? lastEventId,
  });
  
  /// Get events by user (created by user)
  Future<Either<Failure, List<EventEntity>>> getEventsByUser(String userId);
  
  /// Get events user is attending
  Future<Either<Failure, List<EventEntity>>> getAttendingEvents(String userId);
  
  /// Search events
  Future<Either<Failure, List<EventEntity>>> searchEvents(String query);
  
  /// Register for event (add user to attendees)
  Future<Either<Failure, void>> registerForEvent({
    required String eventId,
    required String userId,
  });
  
  /// Unregister from event (remove user from attendees)
  Future<Either<Failure, void>> unregisterFromEvent({
    required String eventId,
    required String userId,
  });
}
