part of '../apps_screen.dart';

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
