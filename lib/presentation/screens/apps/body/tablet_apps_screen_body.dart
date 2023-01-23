part of '../apps_screen.dart';

class _TabletBody extends StatefulWidget {
  const _TabletBody({
    required this.apps,
  });

  @protected
  final List<ApplicationInfo> apps;

  @protected
  static const kBorderRadius = BorderRadius.all(Radius.circular(8));

  @override
  State<_TabletBody> createState() => _TabletBodyState();
}

class _TabletBodyState extends State<_TabletBody> {
  final scrollController = ScrollController();
  final textFieldHeightNotifier = SearchAppTextFieldHeightNotifier()
    ..setDefaultHeight(40);

  @override
  void dispose() {
    scrollController.dispose();
    textFieldHeightNotifier.dispose();
    super.dispose();
  }

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
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32)
                        .copyWith(top: 37, bottom: 24),
                    child: SearchAppTextField(
                      heightNotifier: textFieldHeightNotifier,
                    ),
                  ),
                  BlocBuilder<SearchAppCubit, SearchAppState>(
                    builder: (context, state) {
                      return Expanded(
                        child: Scrollbar(
                          controller: scrollController,
                          child: FadeGridViewBuilder(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 32,
                              vertical: 37,
                            ).copyWith(top: 0),
                            createController: () => scrollController,
                            disposeController: false,
                            gridDelegate:
                                const SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: 220,
                              childAspectRatio: 2,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                            ),
                            itemCount: state.apps.length,
                            itemBuilder: (context, index) {
                              return _AppCard(app: state.apps[index]);
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _AppCard extends StatelessWidget {
  const _AppCard({
    required this.app,
  });

  @protected
  final ApplicationInfo app;

  @override
  Widget build(BuildContext context) {
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
                    context.read<LaunchAppCubit>().launchApp(packageName);
                  }
                : null,
            borderRadius: _TabletBody.kBorderRadius,
            child: Ink(
              key: ValueKey(app.name),
              decoration: BoxDecoration(
                borderRadius: _TabletBody.kBorderRadius,
                color: img.hasImage
                    ? img.pixelColorAtAlignment?.call(
                          Alignment.center,
                        ) ??
                        Colors.white
                    : AppColors.of(context).background,
              ),
              child: icon == null
                  ? const Icon(
                      Icons.image_not_supported_outlined,
                    )
                  : img.hasImage
                      ? RawImage(image: img.uiImage)
                      : const SizedBox.shrink(),
            ),
          ),
        );
      },
    );
  }
}
