import 'package:external_app_launcher/external_app_launcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pixel_app_flutter/presentation/screens/navigator/navigator_screen.dart';

class NavAppsListTile extends StatelessWidget {
  const NavAppsListTile({super.key, required this.apps});

  @protected
  final List<NavApp> apps;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        apps.length,
        (index) {
          final item = apps[index];
          return ListTile(
            onTap: () async {
              final isInstalled = await LaunchApp.isAppInstalled(
                androidPackageName: item.androidPackage,
                iosUrlScheme: item.iosPackage,
              );

              if (isInstalled == true) {
                await LaunchApp.openApp(
                  androidPackageName: item.androidPackage,
                  iosUrlScheme: item.iosPackage,
                  openStore: false,
                );
                return;
              }
            },
            title: Text(item.name),
            trailing: SizedBox.square(
              dimension: 40,
              child: ClipRRect(
                borderRadius: const BorderRadius.all(
                  Radius.circular(10),
                ),
                child: SvgPicture.asset(item.asset),
              ),
            ),
          );
        },
      ),
    );
  }
}
