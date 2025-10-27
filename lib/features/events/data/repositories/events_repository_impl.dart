import 'package:dartz/dartz.dart';
import 'package:enevtly/core/error/exceptions.dart';
import 'package:enevtly/core/error/failures.dart';
import 'package:enevtly/core/network/network_info.dart';
import 'package:enevtly/features/events/data/datasources/events_remote_datasource.dart';
import 'package:enevtly/features/events/data/models/event_model.dart';
import 'package:enevtly/features/events/domain/entities/event_entity.dart';
import 'package:enevtly/features/events/domain/repositories/events_repository.dart';

/// Implementation of EventsRepository
class EventsRepositoryImpl implements EventsRepository {
  final EventsRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;
  
  EventsRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });
  
  @override
  Future<Either<Failure, EventEntity>> createEvent(EventEntity event) async {
    if (await networkInfo.isConnected) {
      try {
        final eventModel = EventModel.fromEntity(event);
        final createdEvent = await remoteDataSource.createEvent(eventModel);
        return Right(createdEvent);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } catch (e) {
        return Left(ServerFailure('Failed to create event: ${e.toString()}'));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }
  
  @override
  Future<Either<Failure, EventEntity>> updateEvent(EventEntity event) async {
    if (await networkInfo.isConnected) {
      try {
        final eventModel = EventModel.fromEntity(event);
        final updatedEvent = await remoteDataSource.updateEvent(eventModel);
        return Right(updatedEvent);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } catch (e) {
        return Left(ServerFailure('Failed to update event: ${e.toString()}'));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }
  
  @override
  Future<Either<Failure, void>> deleteEvent(String eventId) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.deleteEvent(eventId);
        return const Right(null);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } catch (e) {
        return Left(ServerFailure('Failed to delete event: ${e.toString()}'));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }
  
  @override
  Future<Either<Failure, EventEntity>> getEventById(String eventId) async {
    if (await networkInfo.isConnected) {
      try {
        final event = await remoteDataSource.getEventById(eventId);
        return Right(event);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } catch (e) {
        return Left(ServerFailure('Failed to get event: ${e.toString()}'));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }
  
  @override
  Future<Either<Failure, List<EventEntity>>> getAllEvents({
    int? limit,
    String? lastEventId,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final events = await remoteDataSource.getAllEvents(
          limit: limit,
          lastEventId: lastEventId,
        );
        return Right(events);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } catch (e) {
        return Left(ServerFailure('Failed to get events: ${e.toString()}'));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }
  
  @override
  Future<Either<Failure, List<EventEntity>>> getEventsByUser(String userId) async {
    if (await networkInfo.isConnected) {
      try {
        final events = await remoteDataSource.getEventsByUser(userId);
        return Right(events);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } catch (e) {
        return Left(ServerFailure('Failed to get user events: ${e.toString()}'));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }
  
  @override
  Future<Either<Failure, List<EventEntity>>> getAttendingEvents(String userId) async {
    if (await networkInfo.isConnected) {
      try {
        final events = await remoteDataSource.getAttendingEvents(userId);
        return Right(events);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } catch (e) {
        return Left(ServerFailure('Failed to get attending events: ${e.toString()}'));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }
  
  @override
  Future<Either<Failure, List<EventEntity>>> searchEvents(String query) async {
    if (await networkInfo.isConnected) {
      try {
        final events = await remoteDataSource.searchEvents(query);
        return Right(events);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } catch (e) {
        return Left(ServerFailure('Failed to search events: ${e.toString()}'));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }
  
  @override
  Future<Either<Failure, void>> registerForEvent({
    required String eventId,
    required String userId,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.registerForEvent(
          eventId: eventId,
          userId: userId,
        );
        return const Right(null);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } catch (e) {
        return Left(ServerFailure('Failed to register for event: ${e.toString()}'));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }
  
  @override
  Future<Either<Failure, void>> unregisterFromEvent({
    required String eventId,
    required String userId,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.unregisterFromEvent(
          eventId: eventId,
          userId: userId,
        );
        return const Right(null);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } catch (e) {
        return Left(ServerFailure('Failed to unregister from event: ${e.toString()}'));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }
}
