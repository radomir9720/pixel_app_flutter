import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pixel_app_flutter/domain/data_source/data_source.dart';
import 'package:pixel_app_flutter/l10n/l10n.dart';
import 'package:pixel_app_flutter/presentation/screens/developer_tools/widgets/exchange_log_card.dart';

class RequestsExchangeLogsScreen extends StatefulWidget {
  const RequestsExchangeLogsScreen({super.key});

  @override
  State<RequestsExchangeLogsScreen> createState() =>
      _RequestsExchangeLogsScreenState();
}

class _RequestsExchangeLogsScreenState
    extends State<RequestsExchangeLogsScreen> {
  bool pauseUpdating = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.requestsExchangeLogsScreenTitle),
        actions: [
          IconButton(
            onPressed: () => setState(() {
              pauseUpdating = !pauseUpdating;
            }),
            icon: Icon(
              pauseUpdating ? Icons.play_arrow : Icons.pause,
            ),
          )
        ],
      ),
      body: BlocBuilder<RequestsExchangeLogsCubit,
          List<RequestsExchangeLogsEvent>>(
        buildWhen: (previous, current) {
          return !pauseUpdating;
        },
        builder: (context, state) {
          return ListView.separated(
            reverse: true,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemCount: state.length,
            itemBuilder: (context, index) {
              final reverseIndex = state.length - index - 1;
              final item = state[reverseIndex];
              return ExchangeLogCard(item: item);
            },
          );
        },
      ),
    );
  }
}
