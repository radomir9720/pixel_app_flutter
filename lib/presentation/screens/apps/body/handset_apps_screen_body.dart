part of '../apps_screen.dart';

class _HandsetBody extends StatefulWidget {
  const _HandsetBody({
    required this.orientation,
    required this.itemsNotifier,
    required this.eventController,
    required this.searchTextFieldController,
  });

  @protected
  final Orientation orientation;

  @protected
  final ItemsNotifier<ApplicationInfo> itemsNotifier;

  @protected
  final DefaultEventController<ApplicationInfo> eventController;

  @protected
  final TextEditingController searchTextFieldController;

  @override
  State<_HandsetBody> createState() => _HandsetBodyState();
}

class _HandsetBodyState extends State<_HandsetBody> {
  final scrollController = ScrollController();

  double? prevScrollOffset;
  final textFieldHeightNotifier = SearchAppTextFieldHeightNotifier()
    ..setDefaultHeight(40);

  @override
  void initState() {
    scrollController.addListener(onControllerScroll);
    super.initState();
  }

  void onControllerScroll() {
    final offset = scrollController.offset;
    final prev = prevScrollOffset;
    if (prev != null) {
      if (offset < 0) return;
      if (offset > scrollController.position.maxScrollExtent) return;
      if (offset < prev) {
        textFieldHeightNotifier.increase(prev - offset);
      } else {
        textFieldHeightNotifier.decrease(offset - prev);
      }
    }
    prevScrollOffset = offset;
  }

  @override
  void didUpdateWidget(covariant _HandsetBody oldWidget) {
    textFieldHeightNotifier.expandToMax();
    scrollController.jumpTo(0);
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    scrollController
      ..removeListener(onControllerScroll)
      ..dispose();

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
        //
        const SizedBox(height: 20),
        //
        SearchAppTextField(
          heightNotifier: textFieldHeightNotifier,
          controller: widget.searchTextFieldController,
        ),
        //
        BlocBuilder<SearchAppCubit, SearchAppState>(
          buildWhen: (previous, current) => current.shouldRebuild,
          builder: (context, state) {
            final searchString = state.searchString;
            final apps = [...state.filtered];

            return Expanded(
              child: Scrollbar(
                controller: scrollController,
                child: FadeScrollable(
                  createController: () => scrollController,
                  disposeController: false,
                  scrollable: (_) {
                    return CustomScrollView(
                      controller: scrollController,
                      slivers: [
                        const SliverPadding(padding: EdgeInsets.only(top: 20)),
                        //
                        if (widget.orientation == Orientation.portrait)
                          SliverAnimatedListView<ApplicationInfo>(
                            items: apps,
                            itemsNotifier: widget.itemsNotifier,
                            eventController: widget.eventController,
                            idMapper: (obj) => obj.packageName ?? '',
                            itemBuilder: (item) {
                              return _AppListTile(
                                app: item,
                                searchString: searchString,
                                eventController: widget.eventController,
                              );
                            },
                          )
                        else
                          SliverAnimatedGridView<ApplicationInfo>(
                            items: apps,
                            eventController: widget.eventController,
                            itemsNotifier: widget.itemsNotifier,
                            idMapper: (obj) => obj.packageName ?? '',
                            itemBuilder: (item) {
                              return _AppListTile(
                                app: item,
                                searchString: searchString,
                                eventController: widget.eventController,
                                forceNotify: true,
                              );
                            },
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisExtent: 56,
                            ),
                          ),
                        //
                        const SliverToBoxAdapter(
                          child: AvoidBottomInsetWidget(),
                        ),
                      ],
                    );
                  },
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

class _AppListTile extends StatelessWidget {
  const _AppListTile({
    required this.app,
    required this.searchString,
    required this.eventController,
    this.forceNotify = false,
  });

  @protected
  final DefaultEventController<ApplicationInfo> eventController;

  @protected
  final ApplicationInfo app;

  @protected
  final String searchString;

  @protected
  final bool forceNotify;

  @override
  Widget build(BuildContext context) {
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
            //
            Expanded(
              child: AppTitle(
                highlightInTitle: searchString,
                fullTitle: app.name,
              ),
            ),
            //
            IconButton(
              onPressed: () {
                context.read<ManagePinnedAppsBloc>().add(
                      app.pinned
                          ? ManagePinnedAppsEvent.remove(app)
                          : ManagePinnedAppsEvent.add(app),
                    );
              },
              icon: Icon(
                app.pinned ? PixelIcons.pin : PixelIcons.pinOutline,
                size: 15,
                color: app.pinned ? null : AppColors.of(context).borderAccent,
              ),
            )
          ],
        ),
      ),
    );
  }
}
