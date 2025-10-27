import 'package:dartz/dartz.dart';
import 'package:enevtly/core/error/failures.dart';
import 'package:enevtly/core/usecases/usecase.dart';
import 'package:enevtly/features/auth/domain/entities/user_entity.dart';
import 'package:enevtly/features/auth/domain/repositories/auth_repository.dart';

/// Get current user use case
class GetCurrentUserUseCase implements UseCase<UserEntity?, NoParams> {
  final AuthRepository repository;
  
  GetCurrentUserUseCase(this.repository);
  
  @override
  Future<Either<Failure, UserEntity?>> call(NoParams params) async {
    return await repository.getCurrentUser();
  }
}
