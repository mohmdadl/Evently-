import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enevtly/core/config/app_config.dart';
import 'package:enevtly/core/error/exceptions.dart';
import 'package:enevtly/features/events/data/models/event_model.dart';

/// Remote data source for events
abstract class EventsRemoteDataSource {
  Future<EventModel> createEvent(EventModel event);
  Future<EventModel> updateEvent(EventModel event);
  Future<void> deleteEvent(String eventId);
  Future<EventModel> getEventById(String eventId);
  Future<List<EventModel>> getAllEvents({int? limit, String? lastEventId});
  Future<List<EventModel>> getEventsByUser(String userId);
  Future<List<EventModel>> getAttendingEvents(String userId);
  Future<List<EventModel>> searchEvents(String query);
  Future<void> registerForEvent({required String eventId, required String userId});
  Future<void> unregisterFromEvent({required String eventId, required String userId});
}

/// Implementation of EventsRemoteDataSource
class EventsRemoteDataSourceImpl implements EventsRemoteDataSource {
  final FirebaseFirestore firestore;
  
  EventsRemoteDataSourceImpl({required this.firestore});
  
  @override
  Future<EventModel> createEvent(EventModel event) async {
    try {
      final eventRef = firestore.collection(AppConfig.eventsCollection).doc();
      
      final eventWithId = EventModel(
        id: eventRef.id,
        title: event.title,
        description: event.description,
        imageUrl: event.imageUrl,
        eventDate: event.eventDate,
        location: event.location,
        createdBy: event.createdBy,
        createdByName: event.createdByName,
        createdByPhoto: event.createdByPhoto,
        createdAt: DateTime.now(),
        attendees: [],
        attendeesCount: 0,
        category: event.category,
      );
      
      await eventRef.set(eventWithId.toFirestore());
      
      return eventWithId;
    } catch (e) {
      throw ServerException('Failed to create event: ${e.toString()}');
    }
  }
  
  @override
  Future<EventModel> updateEvent(EventModel event) async {
    try {
      final eventRef = firestore.collection(AppConfig.eventsCollection).doc(event.id);
      
      final updates = event.toFirestore();
      updates['updatedAt'] = Timestamp.now();
      
      await eventRef.update(updates);
      
      final eventDoc = await eventRef.get();
      return EventModel.fromFirestore(eventDoc);
    } catch (e) {
      throw ServerException('Failed to update event: ${e.toString()}');
    }
  }
  
  @override
  Future<void> deleteEvent(String eventId) async {
    try {
      await firestore.collection(AppConfig.eventsCollection).doc(eventId).delete();
    } catch (e) {
      throw ServerException('Failed to delete event: ${e.toString()}');
    }
  }
  
  @override
  Future<EventModel> getEventById(String eventId) async {
    try {
      final eventDoc = await firestore
          .collection(AppConfig.eventsCollection)
          .doc(eventId)
          .get();
      
      if (!eventDoc.exists) {
        throw ServerException('Event not found');
      }
      
      return EventModel.fromFirestore(eventDoc);
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException('Failed to get event: ${e.toString()}');
    }
  }
  
  @override
  Future<List<EventModel>> getAllEvents({int? limit, String? lastEventId}) async {
    try {
      Query query = firestore
          .collection(AppConfig.eventsCollection)
          .orderBy('eventDate', descending: false);
      
      if (lastEventId != null) {
        final lastDoc = await firestore
            .collection(AppConfig.eventsCollection)
            .doc(lastEventId)
            .get();
        query = query.startAfterDocument(lastDoc);
      }
      
      if (limit != null) {
        query = query.limit(limit);
      }
      
      final querySnapshot = await query.get();
      
      return querySnapshot.docs
          .map((doc) => EventModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw ServerException('Failed to get events: ${e.toString()}');
    }
  }
  
  @override
  Future<List<EventModel>> getEventsByUser(String userId) async {
    try {
      final querySnapshot = await firestore
          .collection(AppConfig.eventsCollection)
          .where('createdBy', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .get();
      
      return querySnapshot.docs
          .map((doc) => EventModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw ServerException('Failed to get user events: ${e.toString()}');
    }
  }
  
  @override
  Future<List<EventModel>> getAttendingEvents(String userId) async {
    try {
      final querySnapshot = await firestore
          .collection(AppConfig.eventsCollection)
          .where('attendees', arrayContains: userId)
          .orderBy('eventDate', descending: false)
          .get();
      
      return querySnapshot.docs
          .map((doc) => EventModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw ServerException('Failed to get attending events: ${e.toString()}');
    }
  }
  
  @override
  Future<List<EventModel>> searchEvents(String query) async {
    try {
      // Note: Firestore doesn't support full-text search
      // This is a basic implementation searching by title prefix
      final querySnapshot = await firestore
          .collection(AppConfig.eventsCollection)
          .orderBy('title')
          .startAt([query])
          .endAt([query + '\uf8ff'])
          .get();
      
      return querySnapshot.docs
          .map((doc) => EventModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw ServerException('Failed to search events: ${e.toString()}');
    }
  }
  
  @override
  Future<void> registerForEvent({
    required String eventId,
    required String userId,
  }) async {
    try {
      final eventRef = firestore.collection(AppConfig.eventsCollection).doc(eventId);
      
      await firestore.runTransaction((transaction) async {
        final eventDoc = await transaction.get(eventRef);
        
        if (!eventDoc.exists) {
          throw ServerException('Event not found');
        }
        
        final attendees = List<String>.from(eventDoc.data()?['attendees'] ?? []);
        
        if (attendees.contains(userId)) {
          throw ServerException('Already registered for this event');
        }
        
        attendees.add(userId);
        
        transaction.update(eventRef, {
          'attendees': attendees,
          'attendeesCount': attendees.length,
          'updatedAt': Timestamp.now(),
        });
      });
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException('Failed to register for event: ${e.toString()}');
    }
  }
  
  @override
  Future<void> unregisterFromEvent({
    required String eventId,
    required String userId,
  }) async {
    try {
      final eventRef = firestore.collection(AppConfig.eventsCollection).doc(eventId);
      
      await firestore.runTransaction((transaction) async {
        final eventDoc = await transaction.get(eventRef);
        
        if (!eventDoc.exists) {
          throw ServerException('Event not found');
        }
        
        final attendees = List<String>.from(eventDoc.data()?['attendees'] ?? []);
        attendees.remove(userId);
        
        transaction.update(eventRef, {
          'attendees': attendees,
          'attendeesCount': attendees.length,
          'updatedAt': Timestamp.now(),
        });
      });
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException('Failed to unregister from event: ${e.toString()}');
    }
  }
}
