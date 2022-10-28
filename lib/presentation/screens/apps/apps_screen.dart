import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pixel_app_flutter/domain/apps/apps.dart';
import 'package:pixel_app_flutter/l10n/l10n.dart';
import 'package:pixel_app_flutter/presentation/widgets/app/molecules/shade_scrollable.dart';
import 'package:re_seedwork/re_seedwork.dart';

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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.l10n.appsTabTitle,
          style: Theme.of(context).textTheme.headline4,
        ),
        const SizedBox(height: 20),
        Expanded(
          child: BlocBuilder<GetAppsListBloc, GetAppsListState>(
            builder: (context, state) {
              return state.maybeWhen(
                loading: (s) {
                  return const Center(child: CircularProgressIndicator());
                },
                orElse: (apps) {
                  return ShadeListViewBuilder(
                    itemCount: apps.length,
                    itemBuilder: (context, index) {
                      final app = apps[index];
                      final icon = app.icon;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: InkWell(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(6)),
                          onTap: () {
                            final packageName = app.packageName;
                            if (packageName == null) return;
                            context
                                .read<LaunchAppCubit>()
                                .launchApp(packageName);
                          },
                          child: Row(
                            children: [
                              if (icon == null)
                                const Icon(Icons.image_not_supported_outlined)
                              else
                                Image.memory(
                                  icon,
                                  height: 46,
                                  width: 46,
                                ),
                              const SizedBox(width: 14),
                              Text(app.name ?? context.l10n.noAppNameCaption),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
