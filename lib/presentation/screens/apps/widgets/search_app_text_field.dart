import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pixel_app_flutter/domain/apps/apps.dart';
import 'package:pixel_app_flutter/l10n/l10n.dart';

class SearchAppTextFieldHeightNotifier extends ValueNotifier<double?> {
  SearchAppTextFieldHeightNotifier({this.maxHeight = 0}) : super(null);

  double maxHeight;

  double get factor {
    return (value ?? 1) / maxHeight;
  }

  void setDefaultHeight(double height) {
    maxHeight = height;
    value = height;
  }

  void increase(num v) {
    value = ((value ?? 0) + v).clamp(0, maxHeight);
  }

  void decrease(num v) => increase(v * -1);

  void expandToMax() {
    value = maxHeight;
  }
}

class SearchAppTextField extends StatefulWidget {
  const SearchAppTextField({
    super.key,
    required this.heightNotifier,
    this.contentPadding = const EdgeInsets.only(top: 5),
  });

  @protected
  final SearchAppTextFieldHeightNotifier heightNotifier;

  @protected
  final EdgeInsets contentPadding;

  @override
  State<SearchAppTextField> createState() => _SearchAppTextFieldState();
}

class _SearchAppTextFieldState extends State<SearchAppTextField> {
  final textController = TextEditingController();
  final focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    textController.addListener(onTextControllerChange);
  }

  void onTextControllerChange() {
    context.read<SearchAppCubit>().search(textController.text);
  }

  @override
  void dispose() {
    focusNode.dispose();
    textController
      ..removeListener(onTextControllerChange)
      ..dispose();
    super.dispose();
  }

  @protected
  static const kBorderRadius = BorderRadius.all(Radius.circular(16));

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<double?>(
      valueListenable: widget.heightNotifier,
      builder: (context, value, child) {
        return InkWell(
          borderRadius: kBorderRadius,
          onTap: focusNode.requestFocus,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: kBorderRadius,
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 16),
              child: SizedBox(
                height: value,
                child: ClipRRect(
                  child: Opacity(
                    opacity: widget.heightNotifier.factor,
                    child: Row(
                      children: [
                        Expanded(child: child ?? const SizedBox.shrink()),
                        BlocSelector<SearchAppCubit, SearchAppState, bool>(
                          selector: (state) => state.searchString.isNotEmpty,
                          builder: (context, isSearching) {
                            return AnimatedSize(
                              duration: const Duration(milliseconds: 200),
                              child: Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: isSearching
                                    ? TextButton(
                                        style: TextButton.styleFrom(
                                          shape: const RoundedRectangleBorder(
                                            borderRadius: kBorderRadius,
                                          ),
                                          visualDensity: const VisualDensity(
                                            vertical: -3,
                                          ),
                                        ),
                                        onPressed: () {
                                          textController.clear();
                                          focusNode.unfocus();
                                        },
                                        child: Text(
                                          context.l10n.cancelButtonCaption,
                                        ),
                                      )
                                    : Icon(
                                        Icons.search,
                                        color: Theme.of(context)
                                            .inputDecorationTheme
                                            .suffixIconColor,
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
            ),
          ),
        );
      },
      child: TextField(
        focusNode: focusNode,
        controller: textController,
        textInputAction: TextInputAction.search,
        decoration: InputDecoration(
          isDense: true,
          enabledBorder: InputBorder.none,
          contentPadding: EdgeInsets.zero,
          focusedBorder: InputBorder.none,
          hintText: context.l10n.searchTextFieldHint,
        ),
      ),
    );
  }
}
