import 'package:flutter/material.dart';
import 'package:pixel_app_flutter/presentation/app/extensions.dart';
import 'package:pixel_app_flutter/presentation/widgets/app/organisms/screen_data.dart';
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
  static const (double, double) kScreenFlexRange = (600, 700);

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
        final height = Screen.of(context).size.height;

        return InkWell(
          onTap: () => onTap(item.pageIndex),
          onLongPress: () => onLongTap?.call(item.pageIndex),
          borderRadius: !showTitle
              ? borderRadius
              : borderRadius.copyWith(
                  topRight: circularRadius,
                  bottomRight: circularRadius,
                ),
          child: Row(
            children: [
              SizedBox(
                width: height.flexSize(
                  screenFlexRange: kScreenFlexRange,
                  valueClampRange: (38, 45),
                ),
                height: height.flexSize(
                  screenFlexRange: kScreenFlexRange,
                  valueClampRange: (42, 50),
                ),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: borderRadius,
                    color: selected
                        ? colors.selectedBackground
                        : colors.unselectedBackground,
                  ),
                  child: Icon(
                    item.icon,
                    size: height.flexSize(
                      screenFlexRange: kScreenFlexRange,
                      valueClampRange: (15, 20),
                    ),
                    color: colors.icon,
                  ),
                ),
              ),
              if (showTitle) ...[
                const SizedBox(width: 17),
                SizedBox(
                  width: 88,
                  child: Text(
                    item.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: textStyle.copyWith(
                      fontSize: height.flexSize(
                        screenFlexRange: kScreenFlexRange,
                        valueClampRange: (11, 13),
                      ),
                      color: selected
                          ? colors.selectedText
                          : colors.unselectedText,
                    ),
                  ),
                ),
                const SizedBox(width: 17),
              ],
            ],
          ),
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
