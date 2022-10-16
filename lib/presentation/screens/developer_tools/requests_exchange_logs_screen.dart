import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pixel_app_flutter/domain/data_source/data_source.dart';
import 'package:pixel_app_flutter/l10n/l10n.dart';
import 'package:pixel_app_flutter/presentation/routes/main_router.dart';

class RequestsExchangeLogsScreen extends StatefulWidget {
  const RequestsExchangeLogsScreen({super.key});

  @override
  State<RequestsExchangeLogsScreen> createState() =>
      _RequestsExchangeLogsScreenState();
}

class _RequestsExchangeLogsScreenState extends State<RequestsExchangeLogsScreen>
    with SingleTickerProviderStateMixin {
  late final TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AutoTabsRouter(
      homeIndex: tabController.index,
      routes: const [
        ProcessedExchangeLogsRoute(),
        RawExchangeLogsRoute(),
      ],
      builder: (context, child, animation) {
        final tabsRouter = AutoTabsRouter.of(context);

        return Scaffold(
          appBar: AppBar(
            leading: BackButton(
              onPressed: context.router.pop,
            ),
            title: Text(context.l10n.requestsExchangeLogsScreenTitle),
            actions: [
              IconButton(
                onPressed: () {
                  context.router.push(const RequestsExchangeLogsFilterFlow());
                },
                icon: const Icon(Icons.filter_list_alt),
              ),
              BlocBuilder<PauseLogsUpdatingCubit, bool>(
                builder: (context, pause) {
                  return IconButton(
                    onPressed: () {
                      context.read<PauseLogsUpdatingCubit>().toggle();
                    },
                    icon: Icon(
                      pause ? Icons.play_arrow : Icons.pause,
                    ),
                  );
                },
              ),
            ],
            bottom: TabBar(
              controller: tabController,
              onTap: (value) {
                tabsRouter.setActiveIndex(value);
                tabController.index = value;
              },
              tabs: [
                Tab(text: context.l10n.processedRequestsTabTitle),
                Tab(text: context.l10n.rawRequestsTabTitle),
              ],
            ),
          ),
          body: FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
      },
    );
  }
}
