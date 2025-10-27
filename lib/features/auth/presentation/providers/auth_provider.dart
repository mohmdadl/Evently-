import 'package:flutter/foundation.dart';
import 'package:enevtly/core/di/injection_container.dart';
import 'package:enevtly/core/usecases/usecase.dart';
import 'package:enevtly/features/auth/domain/entities/user_entity.dart';
import 'package:enevtly/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:enevtly/features/auth/domain/usecases/sign_in_with_google_usecase.dart';
import 'package:enevtly/features/auth/domain/usecases/sign_out_usecase.dart';

/// Authentication Provider
class AuthProvider with ChangeNotifier {
  final SignInWithGoogleUseCase signInWithGoogleUseCase;
  final SignOutUseCase signOutUseCase;
  final GetCurrentUserUseCase getCurrentUserUseCase;
  
  AuthProvider({
    required this.signInWithGoogleUseCase,
    required this.signOutUseCase,
    required this.getCurrentUserUseCase,
  });
  
  factory AuthProvider.create() {
    final sl = ServiceLocator();
    return AuthProvider(
      signInWithGoogleUseCase: sl.get<SignInWithGoogleUseCase>(),
      signOutUseCase: sl.get<SignOutUseCase>(),
      getCurrentUserUseCase: sl.get<GetCurrentUserUseCase>(),
    );
  }
  
  UserEntity? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;
  bool _isAuthenticated = false;
  
  // Getters
  UserEntity? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _isAuthenticated;
  
  /// Sign in with Google
  Future<void> signInWithGoogle() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    
    final result = await signInWithGoogleUseCase(const NoParams());
    
    result.fold(
      (failure) {
        _isLoading = false;
        _errorMessage = failure.message;
        _isAuthenticated = false;
        notifyListeners();
      },
      (user) {
        _currentUser = user;
        _isLoading = false;
        _isAuthenticated = true;
        _errorMessage = null;
        notifyListeners();
      },
    );
  }
  
  /// Sign out
  Future<void> signOut() async {
    _isLoading = true;
    notifyListeners();
    
    final result = await signOutUseCase(const NoParams());
    
    result.fold(
      (failure) {
        _isLoading = false;
        _errorMessage = failure.message;
        notifyListeners();
      },
      (_) {
        _currentUser = null;
        _isLoading = false;
        _isAuthenticated = false;
        _errorMessage = null;
        notifyListeners();
      },
    );
  }
  
  /// Get current user
  Future<void> getCurrentUser() async {
    _isLoading = true;
    notifyListeners();
    
    final result = await getCurrentUserUseCase(const NoParams());
    
    result.fold(
      (failure) {
        _isLoading = false;
        _isAuthenticated = false;
        notifyListeners();
      },
      (user) {
        _currentUser = user;
        _isLoading = false;
        _isAuthenticated = user != null;
        notifyListeners();
      },
    );
  }
  
  /// Clear error
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
