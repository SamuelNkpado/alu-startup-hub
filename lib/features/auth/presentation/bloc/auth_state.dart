import 'package:equatable/equatable.dart';
import '../../domain/entities/app_user.dart';

class AuthState extends Equatable {
  final AppUser? user;
  final bool isLoading;
  final bool isSubmitting;
  final String? error;

  const AuthState({
    this.user,
    this.isLoading = true, // true until the first auth-state emission arrives
    this.isSubmitting = false,
    this.error,
  });

  bool get isAuthenticated => user != null;

  AuthState copyWith({
    AppUser? user,
    bool clearUser = false,
    bool? isLoading,
    bool? isSubmitting,
    String? error,
  }) {
    return AuthState(
      user: clearUser ? null : (user ?? this.user),
      isLoading: isLoading ?? this.isLoading,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      error: error,
    );
  }

  @override
  List<Object?> get props => [user, isLoading, isSubmitting, error];
}