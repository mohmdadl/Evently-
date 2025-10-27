import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:enevtly/core/error/failures.dart';
import 'package:enevtly/core/usecases/usecase.dart';
import 'package:enevtly/features/events/domain/entities/event_entity.dart';
import 'package:enevtly/features/events/domain/repositories/events_repository.dart';

/// Create event use case
class CreateEventUseCase implements UseCase<EventEntity, CreateEventParams> {
  final EventsRepository repository;
  
  CreateEventUseCase(this.repository);
  
  @override
  Future<Either<Failure, EventEntity>> call(CreateEventParams params) async {
    return await repository.createEvent(params.event);
  }
}

/// Params for creating event
class CreateEventParams extends Equatable {
  final EventEntity event;
  
  const CreateEventParams({required this.event});
  
  @override
  List<Object?> get props => [event];
}
