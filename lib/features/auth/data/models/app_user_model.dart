import '../../domain/entities/app_user.dart';

class AppUserModel extends AppUser {
  const AppUserModel({
    required super.uid,
    required super.email,
    required super.name,
    required super.role,
  });

  /// Firestore stores role as a plain string ('student' or 'startupAdmin')
  /// since enums aren't a native Firestore type.
  factory AppUserModel.fromMap(String uid, Map<String, dynamic> data) {
    return AppUserModel(
      uid: uid,
      email: data['email'] as String,
      name: data['name'] as String,
      role: (data['role'] as String) == 'startupAdmin'
          ? UserRole.startupAdmin
          : UserRole.student,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'name': name,
      'role': role == UserRole.startupAdmin ? 'startupAdmin' : 'student',
    };
  }
}