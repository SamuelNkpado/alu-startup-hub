import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/app_user.dart';
import '../models/app_user_model.dart';

class AuthRemoteDataSource {
  final fb_auth.FirebaseAuth firebaseAuth;
  final FirebaseFirestore firestore;

  AuthRemoteDataSource(this.firebaseAuth, this.firestore);

  /// Combines two async sources: Firebase Auth's own auth-state stream
  /// (tells us WHO is signed in) with a Firestore lookup (tells us their
  /// name/role). asyncMap lets us await the Firestore read for every
  /// emission from the auth stream.
  Stream<AppUser?> watchAuthState() {
    return firebaseAuth.authStateChanges().asyncMap((firebaseUser) async {
      if (firebaseUser == null) return null;
      final doc = await firestore.collection('users').doc(firebaseUser.uid).get();
      if (!doc.exists) return null;
      return AppUserModel.fromMap(firebaseUser.uid, doc.data()!);
    });
  }

  Future<AppUserModel> signIn({required String email, required String password}) async {
    final credential = await firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    final uid = credential.user!.uid;
    final doc = await firestore.collection('users').doc(uid).get();
    return AppUserModel.fromMap(uid, doc.data()!);
  }

  Future<AppUserModel> signUp({
    required String email,
    required String password,
    required String name,
    required UserRole role,
  }) async {
    final credential = await firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    final uid = credential.user!.uid;

    final model = AppUserModel(uid: uid, email: email, name: name, role: role);
    await firestore.collection('users').doc(uid).set(model.toMap());
    return model;
  }

  Future<void> signOut() async {
    await firebaseAuth.signOut();
  }
}