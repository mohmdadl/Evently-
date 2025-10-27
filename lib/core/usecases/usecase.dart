import 'package:dartz/dartz.dart';
import 'package:enevtly/core/error/failures.dart';

/// Base UseCase interface
/// All use cases should implement this
abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

/// For use cases that don't need parameters
class NoParams {
  const NoParams();
}
