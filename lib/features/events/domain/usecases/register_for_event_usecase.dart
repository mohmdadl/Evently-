import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:enevtly/core/error/failures.dart';
import 'package:enevtly/core/usecases/usecase.dart';
import 'package:enevtly/features/events/domain/repositories/events_repository.dart';

/// Register for event use case
class RegisterForEventUseCase implements UseCase<void, RegisterForEventParams> {
  final EventsRepository repository;
  
  RegisterForEventUseCase(this.repository);
  
  @override
  Future<Either<Failure, void>> call(RegisterForEventParams params) async {
    return await repository.registerForEvent(
      eventId: params.eventId,
      userId: params.userId,
    );
  }
}

/// Params for registering for event
class RegisterForEventParams extends Equatable {
  final String eventId;
  final String userId;
  
  const RegisterForEventParams({
    required this.eventId,
    required this.userId,
  });
  
  @override
  List<Object?> get props => [eventId, userId];
}
