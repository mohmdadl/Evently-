import 'package:dartz/dartz.dart';
import 'package:enevtly/core/error/failures.dart';
import 'package:enevtly/core/usecases/usecase.dart';
import 'package:enevtly/features/auth/domain/repositories/auth_repository.dart';

/// Sign out use case
class SignOutUseCase implements UseCase<void, NoParams> {
  final AuthRepository repository;
  
  SignOutUseCase(this.repository);
  
  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    return await repository.signOut();
  }
}
