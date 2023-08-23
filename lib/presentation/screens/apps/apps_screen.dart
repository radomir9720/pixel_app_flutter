import 'dart:async';

import 'package:animated_scroll_view/animated_scroll_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_pixels/image_pixels.dart';
import 'package:pixel_app_flutter/domain/apps/apps.dart';
import 'package:pixel_app_flutter/l10n/l10n.dart';
import 'package:pixel_app_flutter/presentation/app/colors.dart';
import 'package:pixel_app_flutter/presentation/app/icons.dart';
import 'package:pixel_app_flutter/presentation/screens/apps/widgets/app_title.dart';
import 'package:pixel_app_flutter/presentation/screens/apps/widgets/search_app_text_field.dart';
import 'package:pixel_app_flutter/presentation/widgets/app/organisms/screen_data.dart';
import 'package:pixel_app_flutter/presentation/widgets/common/atoms/responsive_padding.dart';
import 'package:re_seedwork/re_seedwork.dart';
import 'package:re_widgets/re_widgets.dart';

part './body/handset_apps_screen_body.dart';
part './body/tablet_apps_screen_body.dart';
part './widgets/error_getting_applications_list.dart';

class AppsScreen extends StatefulWidget {
  const AppsScreen({super.key});

  @override
  State<AppsScreen> createState() => _AppsScreenState();
}

class _AppsScreenState extends State<AppsScreen> {
  late final StreamSubscription<void> launchAppSubscription;

  @override
  void initState() {
    super.initState();

    launchAppSubscription = context
        .read<LaunchAppCubit>()
        .stream
        .where((event) => event.isFailure)
        .listen(onLaunchAppFailure);
  }

  void onLaunchAppFailure(AsyncData<String?, Object> state) {
    context.showSnackBar(context.l10n.errorLaunchingTheAppMessage);
  }

  @override
  void dispose() {
    launchAppSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetAppsListBloc, GetAppsListState>(
      builder: (context, state) {
        return state.maybeWhen(
          orElse: (s) {
            return const Center(child: CircularProgressIndicator());
          },
          failure: (payload, error) {
            return const _ErrorGettingApplicationsListWidget();
          },
          success: (apps) {
            return BlocProvider(
              create: (context) => SearchAppCubit(apps: apps),
              child: const _ResponsiveAppsScreenBody(),
            );
          },
        );
      },
    );
  }
}

class _ResponsiveAppsScreenBody extends StatefulWidget {
  const _ResponsiveAppsScreenBody();

  @override
  State<_ResponsiveAppsScreenBody> createState() =>
      _ResponsiveAppsScreenBodyState();
}

class _ResponsiveAppsScreenBodyState extends State<_ResponsiveAppsScreenBody> {
  late final StreamSubscription<void> pinnedAppsSubscription;
  final eventController = DefaultEventController<ApplicationInfo>();
  late final ItemsNotifier<ApplicationInfo> itemsNotifier;
  final searchTextFieldController = TextEditingController();
  bool forceNotify = false;

  @override
  void initState() {
    super.initState();

    itemsNotifier = DefaultItemsNotifier(
      onItemsUpdate: onItemsUpdate,
    );

    pinnedAppsSubscription =
        context.read<ManagePinnedAppsBloc>().stream.listen(onPinAppResult);
  }

  void onItemsUpdate(List<ApplicationInfo> updatedList) {
    context.read<SearchAppCubit>().update(
          filtered: ApplicationsEntity(updatedList),
        );
  }

  void onPinAppResult(ManagePinnedAppsState state) {
    state.maybeWhen(
      orElse: () {},
      success: (app) {
        var newIndex = 0;
        final state = context.read<SearchAppCubit>().state;
        final apps = state.all;
        final allAppsSorted = apps.updateApp(app).sorted;
        final filtered = allAppsSorted.filterByName(state.searchString);
        context.read<SearchAppCubit>().update(all: allAppsSorted);
        newIndex = filtered.indexOf(app);
        if (newIndex == -1) {
          Future<void>.error('Error finding new index for unpinned element');
          return;
        }

        eventController.moveAdaptive(
          item: app,
          newIndex: newIndex,
          forceNotify: forceNotify,
        );
      },
      failure: (error) {
        final e = error;
        final appName = e.appName ?? '';
        final message = e.type.when(
          add: () => context.l10n.errorPinningApp(appName),
          remove: () => context.l10n.errorPinningApp(appName),
        );
        context.showSnackBar(message);
      },
    );
  }

  @override
  void dispose() {
    eventController.close();
    pinnedAppsSubscription.cancel();
    searchTextFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ResponsivePadding(
      child: FormFactorResponsive(
        orElse: (_) {
          forceNotify = true;
          return _TabletBody(
            itemsNotifier: itemsNotifier,
            eventController: eventController,
            searchTextFieldController: searchTextFieldController,
          );
        },
        handset: (screenData) {
          forceNotify = screenData.orientation == Orientation.landscape;
          return _HandsetBody(
            itemsNotifier: itemsNotifier,
            eventController: eventController,
            orientation: screenData.orientation,
            searchTextFieldController: searchTextFieldController,
          );
        },
      ),
    );
  }
}
