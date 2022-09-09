import 'package:flutter/material.dart';
import 'package:pixel_app_flutter/presentation/widgets/common/atoms/nav_bar_colors.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({
    super.key,
    required this.tabIcons,
    required this.activeIndex,
    required this.onTap,
  });

  @protected
  final List<IconData> tabIcons;

  @protected
  final int activeIndex;

  @protected
  final ValueSetter<int> onTap;

  @override
  Widget build(BuildContext context) {
    final colors = ArgumentError.checkNotNull(
      Theme.of(context).extension<NavBarColors>(),
      'NavBarColors',
    );

    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: colors.divider,
          ),
        ),
      ),
      height: 64,
      child: Row(
        children: List.generate(tabIcons.length, (index) {
          return Expanded(
            child: InkWell(
              onTap: () => onTap(index),
              child: BottomNavBarItem(
                icon: tabIcons[index],
                selected: index == activeIndex,
              ),
            ),
          );
        }),
      ),
    );
  }
}

class BottomNavBarItem extends StatelessWidget {
  const BottomNavBarItem({
    super.key,
    required this.icon,
    required this.selected,
  });

  @protected
  final bool selected;

  @protected
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final colors = ArgumentError.checkNotNull(
      Theme.of(context).extension<NavBarColors>(),
      'NavBarColors',
    );

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const SizedBox(height: 5),
        Icon(icon, color: colors.icon),
        if (selected)
          Container(
            height: 5,
            width: 31,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(24),
              ),
              color: colors.selectedBackground,
            ),
          )
        else
          const SizedBox(height: 5),
      ],
    );
  }
}
