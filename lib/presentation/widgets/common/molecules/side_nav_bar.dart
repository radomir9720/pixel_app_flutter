import 'package:flutter/material.dart';
import 'package:pixel_app_flutter/presentation/widgets/common/atoms/nav_bar_colors.dart';

class SideNavBar extends StatelessWidget {
  const SideNavBar({
    super.key,
    required this.items,
    required this.activeIndex,
    required this.onTap,
    this.onLongTap,
    this.showTitle = true,
  });

  @protected
  final List<SideNavBarItem> items;

  @protected
  final int activeIndex;

  @protected
  final ValueSetter<int> onTap;

  @protected
  final ValueSetter<int>? onLongTap;

  @protected
  final bool showTitle;

  @protected
  static const circularRadius = Radius.circular(100);

  @protected
  static const textStyle = TextStyle(
    fontSize: 11,
    height: 1.21,
    fontWeight: FontWeight.w500,
    fontStyle: FontStyle.normal,
  );

  @override
  Widget build(BuildContext context) {
    final colors = ArgumentError.checkNotNull(
      Theme.of(context).extension<NavBarColors>(),
      'NavBarColors',
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: List.generate(items.length, (index) {
        final isFirst = index == 0;
        final isLast = index == items.length - 1;
        final item = items[index];
        final selected = item.pageIndex == activeIndex;
        final borderRadius = BorderRadius.vertical(
          top: isFirst ? circularRadius : Radius.zero,
          bottom: isLast ? circularRadius : Radius.zero,
        );

        return Row(
          children: [
            SizedBox(
              width: 38,
              height: 42,
              child: InkWell(
                onTap: () => onTap(item.pageIndex),
                onLongPress: () => onLongTap?.call(item.pageIndex),
                borderRadius: borderRadius,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: borderRadius,
                    color: selected
                        ? colors.selectedBackground
                        : colors.unselectedBackground,
                  ),
                  child: Icon(
                    item.icon,
                    size: 15,
                    color: colors.icon,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 17),
            if (showTitle)
              Text(
                item.title,
                style: textStyle.copyWith(
                  color: selected ? colors.selectedText : colors.unselectedText,
                ),
              ),
          ],
        );
      }),
    );
  }
}

class SideNavBarItem {
  const SideNavBarItem({
    required this.icon,
    required this.title,
    required this.pageIndex,
  });

  final IconData icon;

  final String title;

  final int pageIndex;
}
