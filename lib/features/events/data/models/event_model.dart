import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enevtly/features/events/domain/entities/event_entity.dart';

/// Event Model - data representation
class EventModel extends EventEntity {
  const EventModel({
    required super.id,
    required super.title,
    required super.description,
    required super.imageUrl,
    required super.eventDate,
    required super.location,
    required super.createdBy,
    required super.createdByName,
    super.createdByPhoto,
    required super.createdAt,
    super.updatedAt,
    required super.attendees,
    required super.attendeesCount,
    super.category,
  });
  
  /// Convert from Entity to Model
  factory EventModel.fromEntity(EventEntity entity) {
    return EventModel(
      id: entity.id,
      title: entity.title,
      description: entity.description,
      imageUrl: entity.imageUrl,
      eventDate: entity.eventDate,
      location: entity.location,
      createdBy: entity.createdBy,
      createdByName: entity.createdByName,
      createdByPhoto: entity.createdByPhoto,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      attendees: entity.attendees,
      attendeesCount: entity.attendeesCount,
      category: entity.category,
    );
  }
  
  /// Convert from Firestore document to Model
  factory EventModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    
    return EventModel(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      eventDate: (data['eventDate'] as Timestamp).toDate(),
      location: data['location'] ?? '',
      createdBy: data['createdBy'] ?? '',
      createdByName: data['createdByName'] ?? '',
      createdByPhoto: data['createdByPhoto'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: data['updatedAt'] != null 
          ? (data['updatedAt'] as Timestamp).toDate() 
          : null,
      attendees: List<String>.from(data['attendees'] ?? []),
      attendeesCount: data['attendeesCount'] ?? 0,
      category: data['category'],
    );
  }
  
  /// Convert from JSON to Model
  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      imageUrl: json['imageUrl'],
      eventDate: DateTime.parse(json['eventDate']),
      location: json['location'],
      createdBy: json['createdBy'],
      createdByName: json['createdByName'],
      createdByPhoto: json['createdByPhoto'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: json['updatedAt'] != null 
          ? DateTime.parse(json['updatedAt']) 
          : null,
      attendees: List<String>.from(json['attendees']),
      attendeesCount: json['attendeesCount'],
      category: json['category'],
    );
  }
  
  /// Convert Model to Firestore document
  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'eventDate': Timestamp.fromDate(eventDate),
      'location': location,
      'createdBy': createdBy,
      'createdByName': createdByName,
      'createdByPhoto': createdByPhoto,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
      'attendees': attendees,
      'attendeesCount': attendeesCount,
      'category': category,
    };
  }
  
  /// Convert Model to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'eventDate': eventDate.toIso8601String(),
      'location': location,
      'createdBy': createdBy,
      'createdByName': createdByName,
      'createdByPhoto': createdByPhoto,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'attendees': attendees,
      'attendeesCount': attendeesCount,
      'category': category,
    };
  }
}
