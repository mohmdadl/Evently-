import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:enevtly/core/di/injection_container.dart';
import 'package:enevtly/core/services/image_upload_service.dart';
import 'package:enevtly/features/events/domain/entities/event_entity.dart';
import 'package:enevtly/features/events/domain/usecases/create_event_usecase.dart';
import 'package:enevtly/features/events/domain/usecases/get_all_events_usecase.dart';
import 'package:enevtly/features/events/domain/usecases/register_for_event_usecase.dart';
import 'package:enevtly/features/events/domain/usecases/search_events_usecase.dart';

/// Events Provider
class EventsProvider with ChangeNotifier {
  final CreateEventUseCase createEventUseCase;
  final GetAllEventsUseCase getAllEventsUseCase;
  final SearchEventsUseCase searchEventsUseCase;
  final RegisterForEventUseCase registerForEventUseCase;
  final ImageUploadService imageUploadService;
  
  EventsProvider({
    required this.createEventUseCase,
    required this.getAllEventsUseCase,
    required this.searchEventsUseCase,
    required this.registerForEventUseCase,
    required this.imageUploadService,
  });
  
  factory EventsProvider.create() {
    final sl = ServiceLocator();
    return EventsProvider(
      createEventUseCase: sl.get<CreateEventUseCase>(),
      getAllEventsUseCase: sl.get<GetAllEventsUseCase>(),
      searchEventsUseCase: sl.get<SearchEventsUseCase>(),
      registerForEventUseCase: sl.get<RegisterForEventUseCase>(),
      imageUploadService: sl.get<ImageUploadService>(),
    );
  }
  
  List<EventEntity> _events = [];
  List<EventEntity> _searchResults = [];
  bool _isLoading = false;
  bool _isCreating = false;
  bool _isSearching = false;
  String? _errorMessage;
  bool _hasMore = true;
  String? _lastEventId;
  
  // Getters
  List<EventEntity> get events => _events;
  List<EventEntity> get searchResults => _searchResults;
  bool get isLoading => _isLoading;
  bool get isCreating => _isCreating;
  bool get isSearching => _isSearching;
  String? get errorMessage => _errorMessage;
  bool get hasMore => _hasMore;
  
  /// Get all events
  Future<void> getAllEvents({bool refresh = false}) async {
    if (_isLoading) return;
    
    if (refresh) {
      _events = [];
      _lastEventId = null;
      _hasMore = true;
    }
    
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    
    final result = await getAllEventsUseCase(
      GetAllEventsParams(
        limit: 20,
        lastEventId: _lastEventId,
      ),
    );
    
    result.fold(
      (failure) {
        _isLoading = false;
        _errorMessage = failure.message;
        notifyListeners();
      },
      (newEvents) {
        if (newEvents.isEmpty) {
          _hasMore = false;
        } else {
          _events.addAll(newEvents);
          _lastEventId = newEvents.last.id;
        }
        _isLoading = false;
        notifyListeners();
      },
    );
  }
  
  /// Create event with image upload
  Future<bool> createEvent({
    required String title,
    required String description,
    required File imageFile,
    required DateTime eventDate,
    required String location,
    required String userId,
    required String userName,
    String? userPhoto,
    String? category,
  }) async {
    _isCreating = true;
    _errorMessage = null;
    notifyListeners();
    
    try {
      // Upload image first
      final imageUrl = await imageUploadService.uploadImage(imageFile);
      
      // Create event
      final event = EventEntity(
        id: '', // Will be generated
        title: title,
        description: description,
        imageUrl: imageUrl,
        eventDate: eventDate,
        location: location,
        createdBy: userId,
        createdByName: userName,
        createdByPhoto: userPhoto,
        createdAt: DateTime.now(),
        attendees: [],
        attendeesCount: 0,
        category: category,
      );
      
      final result = await createEventUseCase(CreateEventParams(event: event));
      
      return result.fold(
        (failure) {
          _isCreating = false;
          _errorMessage = failure.message;
          notifyListeners();
          return false;
        },
        (createdEvent) {
          _events.insert(0, createdEvent);
          _isCreating = false;
          notifyListeners();
          return true;
        },
      );
    } catch (e) {
      _isCreating = false;
      _errorMessage = 'Failed to create event: ${e.toString()}';
      notifyListeners();
      return false;
    }
  }
  
  /// Search events
  Future<void> searchEvents(String query) async {
    if (query.isEmpty) {
      _searchResults = [];
      notifyListeners();
      return;
    }
    
    _isSearching = true;
    _errorMessage = null;
    notifyListeners();
    
    final result = await searchEventsUseCase(SearchEventsParams(query: query));
    
    result.fold(
      (failure) {
        _isSearching = false;
        _errorMessage = failure.message;
        notifyListeners();
      },
      (results) {
        _searchResults = results;
        _isSearching = false;
        notifyListeners();
      },
    );
  }
  
  /// Register for event
  Future<bool> registerForEvent(String eventId, String userId) async {
    final result = await registerForEventUseCase(
      RegisterForEventParams(eventId: eventId, userId: userId),
    );
    
    return result.fold(
      (failure) {
        _errorMessage = failure.message;
        notifyListeners();
        return false;
      },
      (_) {
        // Update local event
        final eventIndex = _events.indexWhere((e) => e.id == eventId);
        if (eventIndex != -1) {
          final event = _events[eventIndex];
          final updatedAttendees = List<String>.from(event.attendees)..add(userId);
          _events[eventIndex] = event.copyWith(
            attendees: updatedAttendees,
            attendeesCount: updatedAttendees.length,
          );
          notifyListeners();
        }
        return true;
      },
    );
  }
  
  /// Clear error
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
  
  /// Clear search results
  void clearSearch() {
    _searchResults = [];
    notifyListeners();
  }
}
