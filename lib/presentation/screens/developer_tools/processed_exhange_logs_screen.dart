import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pixel_app_flutter/domain/data_source/data_source.dart';
import 'package:pixel_app_flutter/presentation/screens/developer_tools/widgets/exchange_log_card.dart';

class ProcessedExchangeLogsScreen extends StatelessWidget {
  const ProcessedExchangeLogsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final pauseUpdating = context.watch<PauseLogsUpdatingCubit>().state;

    return BlocBuilder<ProcessedRequestsExchangeLogsCubit,
        List<ProcessedRequestsExchangeLogsState>>(
      buildWhen: (previous, current) {
        return !pauseUpdating;
      },
      builder: (context, state) {
        final filter = context.watch<RequestsExchangeLogsFilterCubit>().state;
        final items = state
            .where(
              (element) => element.filter(
                parameterId: filter.parameterId,
                requestType: filter.requestType,
                direction: filter.direction,
              ),
            )
            .toList();

        return ListView.separated(
          reverse: true,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemCount: items.length,
          itemBuilder: (context, index) {
            final reverseIndex = items.length - index - 1;
            final item = items[reverseIndex];
            return ExchangeLogCard.fromDataSourceEvent(
              event: item.data,
              dateTime: item.dateTime,
            );
          },
        );
      },
    );
  }
}
