import 'package:dartz/dartz.dart';
import 'package:enevtly/core/error/failures.dart';
import 'package:enevtly/features/auth/domain/entities/user_entity.dart';

/// Authentication Repository Interface
/// This defines what the auth repository should do
abstract class AuthRepository {
  /// Sign in with Google
  Future<Either<Failure, UserEntity>> signInWithGoogle();
  
  /// Sign out
  Future<Either<Failure, void>> signOut();
  
  /// Get current user
  Future<Either<Failure, UserEntity?>> getCurrentUser();
  
  /// Check if user is signed in
  Future<Either<Failure, bool>> isSignedIn();
  
  /// Update user profile
  Future<Either<Failure, UserEntity>> updateUserProfile({
    required String userId,
    String? displayName,
    String? photoUrl,
  });
}
