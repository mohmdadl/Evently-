import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:enevtly/core/error/failures.dart';
import 'package:enevtly/core/usecases/usecase.dart';
import 'package:enevtly/features/events/domain/entities/event_entity.dart';
import 'package:enevtly/features/events/domain/repositories/events_repository.dart';

/// Search events use case
class SearchEventsUseCase implements UseCase<List<EventEntity>, SearchEventsParams> {
  final EventsRepository repository;
  
  SearchEventsUseCase(this.repository);
  
  @override
  Future<Either<Failure, List<EventEntity>>> call(SearchEventsParams params) async {
    return await repository.searchEvents(params.query);
  }
}

/// Params for searching events
class SearchEventsParams extends Equatable {
  final String query;
  
  const SearchEventsParams({required this.query});
  
  @override
  List<Object?> get props => [query];
}
