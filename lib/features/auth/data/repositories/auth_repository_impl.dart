import '../../domain/entities/app_user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource dataSource;

  AuthRepositoryImpl(this.dataSource);

  @override
  Stream<AppUser?> watchAuthState() => dataSource.watchAuthState();

  @override
  Future<AppUser> signIn({required String email, required String password}) {
    return dataSource.signIn(email: email, password: password);
  }

  @override
  Future<AppUser> signUp({
    required String email,
    required String password,
    required String name,
    required UserRole role,
  }) {
    return dataSource.signUp(email: email, password: password, name: name, role: role);
  }

  @override
  Future<void> signOut() => dataSource.signOut();
}