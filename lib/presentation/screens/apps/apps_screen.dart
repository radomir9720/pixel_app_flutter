import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_pixels/image_pixels.dart';
import 'package:pixel_app_flutter/domain/apps/apps.dart';
import 'package:pixel_app_flutter/l10n/l10n.dart';
import 'package:pixel_app_flutter/presentation/app/colors.dart';
import 'package:pixel_app_flutter/presentation/screens/apps/widgets/search_app_text_field.dart';
import 'package:pixel_app_flutter/presentation/widgets/app/organisms/screen_data.dart';
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

  void onLaunchAppFailure(AsyncData<String?, Object> event) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(context.l10n.errorLaunchingTheAppMessage),
      ),
    );
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
              child: FormFactorAdaptive(
                orElse: (_) => _TabletBody(apps: apps),
                handset: (screenData) => _HandsetBody(
                  orientation: screenData.orientation,
                ),
              ),
            );
          },
        );
      },
    );
  }
}
