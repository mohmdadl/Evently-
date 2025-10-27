import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:enevtly/core/error/failures.dart';
import 'package:enevtly/core/usecases/usecase.dart';
import 'package:enevtly/features/events/domain/entities/event_entity.dart';
import 'package:enevtly/features/events/domain/repositories/events_repository.dart';

/// Get all events use case
class GetAllEventsUseCase implements UseCase<List<EventEntity>, GetAllEventsParams> {
  final EventsRepository repository;
  
  GetAllEventsUseCase(this.repository);
  
  @override
  Future<Either<Failure, List<EventEntity>>> call(GetAllEventsParams params) async {
    return await repository.getAllEvents(
      limit: params.limit,
      lastEventId: params.lastEventId,
    );
  }
}

/// Params for getting all events
class GetAllEventsParams extends Equatable {
  final int? limit;
  final String? lastEventId;
  
  const GetAllEventsParams({
    this.limit,
    this.lastEventId,
  });
  
  @override
  List<Object?> get props => [limit, lastEventId];
}
