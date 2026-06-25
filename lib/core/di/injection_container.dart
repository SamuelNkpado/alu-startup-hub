import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';

import '../../features/opportunities/data/datasources/opportunity_firestore_datasource.dart';
import '../../features/opportunities/data/repositories/opportunity_repository_impl.dart';
import '../../features/opportunities/domain/repositories/opportunity_repository.dart';
import '../../features/opportunities/domain/usecases/close_opportunity.dart';
import '../../features/opportunities/domain/usecases/create_opportunity.dart';
import '../../features/opportunities/domain/usecases/update_opportunity.dart';
import '../../features/opportunities/domain/usecases/watch_open_opportunities.dart';
import '../../features/opportunities/presentation/bloc/opportunity_bloc.dart';

final sl = GetIt.instance; // "service locator" — conventional name for the get_it singleton

/// Called once at app startup, before runApp(). Registers every dependency
/// from the bottom of the dependency graph up: external packages first,
/// then data sources, then repositories, then use cases, then BLoCs.
Future<void> initDependencies() async {
  // ---- external ----
  sl.registerLazySingleton<FirebaseFirestore>(() => FirebaseFirestore.instance);

  // ---- opportunities feature ----
  sl.registerLazySingleton<OpportunityFirestoreDataSource>(
        () => OpportunityFirestoreDataSource(sl()),
  );

  sl.registerLazySingleton<OpportunityRepository>(
        () => OpportunityRepositoryImpl(sl(), sl()),
  );

  sl.registerLazySingleton(() => WatchOpenOpportunities(sl()));
  sl.registerLazySingleton(() => CreateOpportunity(sl()));
  sl.registerLazySingleton(() => UpdateOpportunity(sl()));
  sl.registerLazySingleton(() => CloseOpportunity(sl()));

  // BLoCs are registered as a factory, not a singleton — every time a
  // screen requests one, it gets a fresh instance with its own
  // subscriptions and lifecycle, rather than reusing a stale one.
  sl.registerFactory(
        () => OpportunityBloc(
      watchOpenOpportunities: sl(),
      createOpportunity: sl(),
      closeOpportunity: sl(),
    ),
  );
}