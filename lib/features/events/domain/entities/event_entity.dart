import 'package:equatable/equatable.dart';

/// Event Entity
class EventEntity extends Equatable {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final DateTime eventDate;
  final String location;
  final String createdBy; // User ID
  final String createdByName; // User display name
  final String? createdByPhoto; // User photo URL
  final DateTime createdAt;
  final DateTime? updatedAt;
  final List<String> attendees; // List of user IDs
  final int attendeesCount;
  final String? category;
  
  const EventEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.eventDate,
    required this.location,
    required this.createdBy,
    required this.createdByName,
    this.createdByPhoto,
    required this.createdAt,
    this.updatedAt,
    required this.attendees,
    required this.attendeesCount,
    this.category,
  });
  
  @override
  List<Object?> get props => [
    id,
    title,
    description,
    imageUrl,
    eventDate,
    location,
    createdBy,
    createdByName,
    createdByPhoto,
    createdAt,
    updatedAt,
    attendees,
    attendeesCount,
    category,
  ];
  
  /// Check if event is in the past
  bool get isPastEvent => eventDate.isBefore(DateTime.now());
  
  /// Check if user is attending
  bool isUserAttending(String userId) {
    return attendees.contains(userId);
  }
  
  /// Copy with
  EventEntity copyWith({
    String? id,
    String? title,
    String? description,
    String? imageUrl,
    DateTime? eventDate,
    String? location,
    String? createdBy,
    String? createdByName,
    String? createdByPhoto,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<String>? attendees,
    int? attendeesCount,
    String? category,
  }) {
    return EventEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      eventDate: eventDate ?? this.eventDate,
      location: location ?? this.location,
      createdBy: createdBy ?? this.createdBy,
      createdByName: createdByName ?? this.createdByName,
      createdByPhoto: createdByPhoto ?? this.createdByPhoto,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      attendees: attendees ?? this.attendees,
      attendeesCount: attendeesCount ?? this.attendeesCount,
      category: category ?? this.category,
    );
  }
}
