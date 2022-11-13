import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_pixels/image_pixels.dart';
import 'package:pixel_app_flutter/domain/apps/apps.dart';
import 'package:pixel_app_flutter/l10n/l10n.dart';
import 'package:pixel_app_flutter/presentation/app/colors.dart';
import 'package:pixel_app_flutter/presentation/widgets/app/molecules/shade_scrollable.dart';
import 'package:pixel_app_flutter/presentation/widgets/app/organisms/screen_data.dart';
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
    return BlocBuilder<GetAppsListBloc, GetAppsListState>(
      builder: (context, state) {
        return state.maybeWhen(
          loading: (s) {
            return const Center(child: CircularProgressIndicator());
          },
          failure: (payload, error) {
            return const _ErrorGettingApplicationsListWidget();
          },
          orElse: (apps) {
            final screen = Screen.of(context, watch: false);
            return screen.whenType(
              orElse: () => _TabletBody(apps: apps),
              handset: () => _HandsetBody(apps: apps),
            );
          },
        );
      },
    );
  }
}

class _TabletBody extends StatelessWidget {
  const _TabletBody({
    required this.apps,
  });

  @protected
  final List<ApplicationInfo> apps;

  @protected
  static const kBorderRadius = BorderRadius.all(Radius.circular(8));

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 37),
          child: Text(
            context.l10n.appsTabTitle,
            style: Theme.of(context).textTheme.headline4,
          ),
        ),
        Expanded(
          child: Align(
            alignment: Alignment.centerRight,
            child: SizedBox(
              width: MediaQuery.of(context).size.width * .7,
              child: ShadeGridViewBuilder(
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 37),
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 220,
                  childAspectRatio: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: apps.length,
                itemBuilder: (context, index) {
                  final app = apps[index];
                  final icon = app.icon;

                  return ImagePixels(
                    imageProvider: icon == null ? null : MemoryImage(icon),
                    builder: (context, img) {
                      return Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: img.hasImage
                              ? () {
                                  final packageName = app.packageName;
                                  if (packageName == null) return;
                                  context
                                      .read<LaunchAppCubit>()
                                      .launchApp(packageName);
                                }
                              : null,
                          borderRadius: kBorderRadius,
                          child: Ink(
                            key: ValueKey(app.name),
                            decoration: BoxDecoration(
                              borderRadius: kBorderRadius,
                              color: img.hasImage
                                  ? img.pixelColorAtAlignment
                                          ?.call(Alignment.center) ??
                                      Colors.white
                                  : AppColors.of(context).background,
                            ),
                            child: icon == null
                                ? const Icon(Icons.image_not_supported_outlined)
                                : img.hasImage
                                    ? RawImage(image: img.uiImage)
                                    : const SizedBox.shrink(),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _HandsetBody extends StatelessWidget {
  const _HandsetBody({required this.apps});

  @protected
  final List<ApplicationInfo> apps;

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
          child: ShadeListViewBuilder(
            itemCount: apps.length,
            itemBuilder: (context, index) {
              final app = apps[index];
              final icon = app.icon;
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: InkWell(
                  borderRadius: const BorderRadius.all(Radius.circular(6)),
                  onTap: () {
                    final packageName = app.packageName;
                    if (packageName == null) return;
                    context.read<LaunchAppCubit>().launchApp(packageName);
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
          ),
        ),
      ],
    );
  }
}

class _ErrorGettingApplicationsListWidget extends StatelessWidget {
  const _ErrorGettingApplicationsListWidget();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 75,
            color: AppColors.of(context).error,
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            context.l10n.errorGettingApplicationsListMessage,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
