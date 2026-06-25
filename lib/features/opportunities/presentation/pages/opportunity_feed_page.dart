import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/injection_container.dart';
import '../bloc/opportunity_bloc.dart';
import '../bloc/opportunity_event.dart';
import '../bloc/opportunity_state.dart';

class OpportunityFeedPage extends StatelessWidget {
  const OpportunityFeedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<OpportunityBloc>()..add(const WatchOpportunitiesStarted()),
      child: Scaffold(
        appBar: AppBar(title: const Text('Opportunities')),
        body: BlocBuilder<OpportunityBloc, OpportunityState>(
          builder: (context, state) {
            if (state.isLoadingFeed && state.opportunities.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state.feedError != null) {
              return Center(child: Text('Something went wrong: ${state.feedError}'));
            }
            if (state.opportunities.isEmpty) {
              return const Center(child: Text('No open opportunities yet.'));
            }
            return ListView.builder(
              itemCount: state.opportunities.length,
              itemBuilder: (context, index) {
                final opportunity = state.opportunities[index];
                return ListTile(
                  title: Text(opportunity.title),
                  subtitle: Text('${opportunity.startupName} · ${opportunity.roleType}'),
                );
              },
            );
          },
        ),
      ),
    );
  }
}