import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'firebase_options.dart';
import 'core/di/injection_container.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/bloc/auth_event.dart';
import 'features/auth/presentation/bloc/auth_state.dart';
import 'features/auth/presentation/pages/login_page.dart';
import 'features/opportunities/presentation/pages/opportunity_feed_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await initDependencies();
  runApp(const AluStartupHubApp());
}

class AluStartupHubApp extends StatelessWidget {
  const AluStartupHubApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<AuthBloc>()..add(const AuthStateWatchStarted()),
      child: MaterialApp(
        title: 'ALU Startup Hub',
        theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.deepPurple),
        home: const AuthGate(),
      ),
    );
  }
}

/// Listens to AuthBloc and routes between the logged-out and logged-in
/// parts of the app. This single widget is the "gate" mentioned in our
/// security rules design — but note it's a UX convenience, not a security
/// boundary. The real enforcement is Firestore's security rules; this
/// widget just decides what to *show*, since a user could otherwise
/// technically bypass UI navigation. Worth saying explicitly in your demo.
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        if (state.isAuthenticated) {
          return const OpportunityFeedPage();
        }
        return const LoginPage();
      },
    );
  }
}