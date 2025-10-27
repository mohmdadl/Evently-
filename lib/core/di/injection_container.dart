import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';

import 'package:enevtly/core/network/network_info.dart';
import 'package:enevtly/core/services/image_upload_service.dart';

import 'package:enevtly/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:enevtly/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:enevtly/features/auth/domain/repositories/auth_repository.dart';
import 'package:enevtly/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:enevtly/features/auth/domain/usecases/sign_in_with_google_usecase.dart';
import 'package:enevtly/features/auth/domain/usecases/sign_out_usecase.dart';

import 'package:enevtly/features/events/data/datasources/events_remote_datasource.dart';
import 'package:enevtly/features/events/data/repositories/events_repository_impl.dart';
import 'package:enevtly/features/events/domain/repositories/events_repository.dart';
import 'package:enevtly/features/events/domain/usecases/create_event_usecase.dart';
import 'package:enevtly/features/events/domain/usecases/get_all_events_usecase.dart';
import 'package:enevtly/features/events/domain/usecases/register_for_event_usecase.dart';
import 'package:enevtly/features/events/domain/usecases/search_events_usecase.dart';

/// Service locator for dependency injection
class ServiceLocator {
  static final ServiceLocator _instance = ServiceLocator._internal();
  factory ServiceLocator() => _instance;
  ServiceLocator._internal();
  
  final Map<Type, dynamic> _services = {};
  
  /// Register a service
  void register<T>(T service) {
    _services[T] = service;
  }
  
  /// Get a service
  T get<T>() {
    final service = _services[T];
    if (service == null) {
      throw Exception('Service of type $T not found');
    }
    return service as T;
  }
  
  /// Check if service is registered
  bool has<T>() {
    return _services.containsKey(T);
  }
  
  /// Clear all services
  void clear() {
    _services.clear();
  }
}

/// Initialize all dependencies
Future<void> initializeDependencies() async {
  final sl = ServiceLocator();
  
  // Core
  sl.register<http.Client>(http.Client());
  sl.register<InternetConnectionChecker>(InternetConnectionChecker.createInstance());
  sl.register<NetworkInfo>(NetworkInfoImpl(sl.get<InternetConnectionChecker>()));
  
  // Firebase
  sl.register<FirebaseAuth>(FirebaseAuth.instance);
  sl.register<FirebaseFirestore>(FirebaseFirestore.instance);
  sl.register<GoogleSignIn>(GoogleSignIn(scopes: ['email']));
  
  // Services
  sl.register<ImageUploadService>(
    ImageUploadService(client: sl.get<http.Client>()),
  );
  
  // Auth
  sl.register<AuthRemoteDataSource>(
    AuthRemoteDataSourceImpl(
      firebaseAuth: sl.get<FirebaseAuth>(),
      googleSignIn: sl.get<GoogleSignIn>(),
      firestore: sl.get<FirebaseFirestore>(),
    ),
  );
  
  sl.register<AuthRepository>(
    AuthRepositoryImpl(
      remoteDataSource: sl.get<AuthRemoteDataSource>(),
      networkInfo: sl.get<NetworkInfo>(),
    ),
  );
  
  sl.register<SignInWithGoogleUseCase>(
    SignInWithGoogleUseCase(sl.get<AuthRepository>()),
  );
  
  sl.register<SignOutUseCase>(
    SignOutUseCase(sl.get<AuthRepository>()),
  );
  
  sl.register<GetCurrentUserUseCase>(
    GetCurrentUserUseCase(sl.get<AuthRepository>()),
  );
  
  // Events
  sl.register<EventsRemoteDataSource>(
    EventsRemoteDataSourceImpl(
      firestore: sl.get<FirebaseFirestore>(),
    ),
  );
  
  sl.register<EventsRepository>(
    EventsRepositoryImpl(
      remoteDataSource: sl.get<EventsRemoteDataSource>(),
      networkInfo: sl.get<NetworkInfo>(),
    ),
  );
  
  sl.register<CreateEventUseCase>(
    CreateEventUseCase(sl.get<EventsRepository>()),
  );
  
  sl.register<GetAllEventsUseCase>(
    GetAllEventsUseCase(sl.get<EventsRepository>()),
  );
  
  sl.register<SearchEventsUseCase>(
    SearchEventsUseCase(sl.get<EventsRepository>()),
  );
  
  sl.register<RegisterForEventUseCase>(
    RegisterForEventUseCase(sl.get<EventsRepository>()),
  );
}
