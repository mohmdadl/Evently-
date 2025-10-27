import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:enevtly/core/config/app_config.dart';
import 'package:enevtly/core/error/exceptions.dart';
import 'package:enevtly/features/auth/data/models/user_model.dart';

/// Remote data source for authentication
abstract class AuthRemoteDataSource {
  Future<UserModel> signInWithGoogle();
  Future<void> signOut();
  Future<UserModel?> getCurrentUser();
  Future<bool> isSignedIn();
  Future<UserModel> updateUserProfile({
    required String userId,
    String? displayName,
    String? photoUrl,
  });
}

/// Implementation of AuthRemoteDataSource
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth firebaseAuth;
  final GoogleSignIn googleSignIn;
  final FirebaseFirestore firestore;
  
  AuthRemoteDataSourceImpl({
    required this.firebaseAuth,
    required this.googleSignIn,
    required this.firestore,
  });
  
  @override
  Future<UserModel> signInWithGoogle() async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      
      if (googleUser == null) {
        throw AuthException('Google sign-in was cancelled');
      }
      
      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      
      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken ?? '',
        idToken: googleAuth.idToken ?? '',
      );
      
      // Sign in to Firebase with the Google credential
      final userCredential = await firebaseAuth.signInWithCredential(credential);
      final firebaseUser = userCredential.user;
      
      if (firebaseUser == null) {
        throw AuthException('Failed to sign in with Google');
      }
      
      // Create user model
      final userModel = UserModel(
        id: firebaseUser.uid,
        email: firebaseUser.email ?? '',
        displayName: firebaseUser.displayName ?? '',
        photoUrl: firebaseUser.photoURL,
        createdAt: DateTime.now(),
      );
      
      // Save user to Firestore
      await _saveUserToFirestore(userModel);
      
      return userModel;
    } on FirebaseAuthException catch (e) {
      throw AuthException(e.message ?? 'Authentication failed');
    } catch (e) {
      throw AuthException('Failed to sign in: ${e.toString()}');
    }
  }
  
  @override
  Future<void> signOut() async {
    try {
      await Future.wait([
        firebaseAuth.signOut(),
        googleSignIn.signOut(),
      ]);
    } catch (e) {
      throw AuthException('Failed to sign out: ${e.toString()}');
    }
  }
  
  @override
  Future<UserModel?> getCurrentUser() async {
    try {
      final firebaseUser = firebaseAuth.currentUser;
      
      if (firebaseUser == null) {
        return null;
      }
      
      // Try to get user from Firestore
      final userDoc = await firestore
          .collection(AppConfig.usersCollection)
          .doc(firebaseUser.uid)
          .get();
      
      if (userDoc.exists) {
        return UserModel.fromFirestore(userDoc);
      }
      
      // If user doesn't exist in Firestore, create from Firebase user
      final userModel = UserModel(
        id: firebaseUser.uid,
        email: firebaseUser.email ?? '',
        displayName: firebaseUser.displayName ?? '',
        photoUrl: firebaseUser.photoURL,
        createdAt: DateTime.now(),
      );
      
      await _saveUserToFirestore(userModel);
      return userModel;
    } catch (e) {
      throw AuthException('Failed to get current user: ${e.toString()}');
    }
  }
  
  @override
  Future<bool> isSignedIn() async {
    return firebaseAuth.currentUser != null;
  }
  
  @override
  Future<UserModel> updateUserProfile({
    required String userId,
    String? displayName,
    String? photoUrl,
  }) async {
    try {
      final userRef = firestore.collection(AppConfig.usersCollection).doc(userId);
      
      final updates = <String, dynamic>{
        'updatedAt': Timestamp.now(),
      };
      
      if (displayName != null) {
        updates['displayName'] = displayName;
      }
      
      if (photoUrl != null) {
        updates['photoUrl'] = photoUrl;
      }
      
      await userRef.update(updates);
      
      // Get updated user
      final userDoc = await userRef.get();
      return UserModel.fromFirestore(userDoc);
    } catch (e) {
      throw AuthException('Failed to update profile: ${e.toString()}');
    }
  }
  
  /// Save user to Firestore
  Future<void> _saveUserToFirestore(UserModel user) async {
    final userRef = firestore.collection(AppConfig.usersCollection).doc(user.id);
    final userDoc = await userRef.get();
    
    if (!userDoc.exists) {
      // Create new user
      await userRef.set(user.toFirestore());
    } else {
      // Update existing user
      await userRef.update({
        'email': user.email,
        'displayName': user.displayName,
        'photoUrl': user.photoUrl,
        'updatedAt': Timestamp.now(),
      });
    }
  }
}
