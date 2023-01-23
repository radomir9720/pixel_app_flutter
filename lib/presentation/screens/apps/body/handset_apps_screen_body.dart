part of '../apps_screen.dart';

class _HandsetBody extends StatefulWidget {
  const _HandsetBody();

  @override
  State<_HandsetBody> createState() => _HandsetBodyState();
}

class _HandsetBodyState extends State<_HandsetBody> {
  // double? height;
  double maxHeight = 0;

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
  void dispose() {
    scrollController
      ..removeListener(onControllerScroll)
      ..dispose();

    super.dispose();
  }

  TextSpan hightlightTitlePart({
    required String highlightInTitle,
    required String fullTitle,
  }) {
    final title = fullTitle;

    if (highlightInTitle.isEmpty) {
      return TextSpan(text: title);
    }

    final indexes = RegExp(highlightInTitle, caseSensitive: false)
        .allMatches(title)
        .map((e) => [e.start, e.end])
        .expand((element) => element)
        .toList();

    final parts = title.splitByIndexes(indexes);

    return TextSpan(
      children: List.generate(
        parts.length,
        (index) {
          final part = parts[index];
          return TextSpan(
            text: part,
            style: TextStyle(
              backgroundColor:
                  part.toLowerCase() == highlightInTitle.toLowerCase()
                      ? AppColors.of(context).primaryAccent
                      : null,
            ),
          );
        },
      ),
    );
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
        ),
        // const SizedBox(height: 20),
        BlocBuilder<SearchAppCubit, SearchAppState>(
          builder: (context, state) {
            return Expanded(
              child: Scrollbar(
                controller: scrollController,
                child: FadeListViewBuilder(
                  itemCount: state.apps.length,
                  createController: () => scrollController,
                  disposeController: false,
                  padding: const EdgeInsets.only(top: 16),
                  itemBuilder: (context, index) {
                    final app = state.apps[index];
                    final icon = app.icon;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: InkWell(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(6)),
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
                            RichText(
                              text: hightlightTitlePart(
                                fullTitle:
                                    app.name ?? context.l10n.noAppNameCaption,
                                highlightInTitle: state.searchString,
                              ),
                            )
                          ],
                        ),
                      ),
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
