import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:external_app_launcher/external_app_launcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pixel_app_flutter/domain/apps/apps.dart';
import 'package:pixel_app_flutter/l10n/l10n.dart';
import 'package:pixel_app_flutter/presentation/app/assets.dart';
import 'package:pixel_app_flutter/presentation/app/colors.dart';
import 'package:pixel_app_flutter/presentation/routes/main_router.dart';
import 'package:pixel_app_flutter/presentation/widgets/common/organisms/title_wrapper.dart';
import 'package:re_seedwork/re_seedwork.dart';
import 'package:re_widgets/re_widgets.dart';

class NavigatorScreen extends StatefulWidget {
  const NavigatorScreen({super.key});

  @override
  State<NavigatorScreen> createState() => _NavigatorScreenState();
}

class _NavigatorScreenState extends State<NavigatorScreen> {
  final mapsNotifier = _InstalledMapsNotifier();

  @override
  void initState() {
    super.initState();
    mapsNotifier.load();
  }

  @override
  void dispose() {
    mapsNotifier.dispose();
    super.dispose();
  }

  @protected
  static const kDefaultNavAppTileTextStyle = TextStyle(
    height: 1.2,
    fontSize: 16,
    fontWeight: FontWeight.w500,
    fontStyle: FontStyle.normal,
  );

  @protected
  static const kNoNavAppsErrorTextStyle = TextStyle(
    height: 1.2,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    fontStyle: FontStyle.italic,
  );

  @override
  Widget build(BuildContext context) {
    return TitleWrapper(
      title: context.l10n.navigatorTabTitle,
      body: ListView(
        children: [
          BlocConsumer<NavigatorFastAccessBloc, NavigatorFastAccessState>(
            listenWhen: (previous, current) => current.isFailure,
            listener: (context, state) {
              context.showSnackBar(
                context.l10n.errorSwitchingFastAccessMessage,
              );
            },
            builder: (context, state) {
              return SwitchListTile(
                value: state.payload,
                title: Text(context.l10n.fastAccessTileTitle),
                subtitle: Text(context.l10n.fastAccessTileHint),
                onChanged: (value) async {
                  bool? turnOn;
                  if (value) {
                    final selected =
                        context.read<NavigatorAppBloc>().state.payload;
                    if (selected == null) {
                      await context.showSnackBar(
                        context.l10n.firstSelectDefaultNavAppErrorMessage,
                      );
                      return;
                    }
                    turnOn = await context.router
                        .push<bool>(const EnableFastAccessDialogRoute());
                  }
                  if (context.mounted && ((turnOn ?? false) || !value)) {
                    context
                        .read<NavigatorFastAccessBloc>()
                        .add(NavigatorFastAccessEvent.set(value: value));
                  }
                },
              );
            },
          ),
          const Divider(endIndent: 16, indent: 16, height: 32),
          Padding(
            padding: const EdgeInsets.all(16).copyWith(top: 0),
            child: Text(
              context.l10n.defaultNavAppTileTitle,
              style: kDefaultNavAppTileTextStyle.copyWith(
                color: context.colors.text,
              ),
            ),
          ),
          ValueListenableBuilder<_InstalledMapsState>(
            valueListenable: mapsNotifier,
            builder: (context, state, child) {
              return state.maybeWhen(
                loading: (payload) {
                  return const Center(child: CircularProgressIndicator());
                },
                orElse: (payload) {
                  if (payload.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text(
                          context.l10n.noNavAppsOnDeviceErrorMessage,
                          style: kNoNavAppsErrorTextStyle.copyWith(
                            color: context.colors.hintText,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  }

                  return BlocConsumer<NavigatorAppBloc, NavigatorAppState>(
                    listenWhen: (previous, current) => current.isFailure,
                    listener: (context, state) {
                      context.showSnackBar(
                        context.l10n.errorSettingDefaultNavAppMessage,
                      );
                    },
                    builder: (context, state) {
                      return Column(
                        children: List.generate(
                          payload.length,
                          (index) {
                            final item = payload[index];
                            return RadioListTile<String>(
                              value: item.platformPackage,
                              groupValue: state.payload,
                              title: Text(item.name),
                              secondary: SizedBox.square(
                                dimension: 40,
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                  child: SvgPicture.asset(item.asset),
                                ),
                              ),
                              onChanged: (value) {
                                if (value == null) return;
                                context
                                    .read<NavigatorAppBloc>()
                                    .add(NavigatorAppEvent.set(value));
                              },
                            );
                          },
                        ),
                      );
                    },
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

typedef _InstalledMapsState = AsyncData<List<_MapApp>, Object>;

@immutable
final class _MapApp {
  const _MapApp({
    required this.asset,
    required this.iosPackage,
    required this.androidPackage,
    required this.name,
  });

  final String asset;
  final String name;
  final String? iosPackage;
  final String? androidPackage;

  bool get hasPlatformPackage {
    if (Platform.isAndroid) return androidPackage != null;
    if (Platform.isIOS) return iosPackage != null;
    return false;
  }

  String get platformPackage {
    if (Platform.isAndroid) {
      return androidPackage.checkNotNull('Android package');
    }
    if (Platform.isIOS) return iosPackage.checkNotNull('iOS Package');

    throw UnimplementedError();
  }
}

final class _InstalledMapsNotifier extends ValueNotifier<_InstalledMapsState> {
  _InstalledMapsNotifier() : super(const _InstalledMapsState.initial([]));

  @protected
  static const kAndroidIdentifiers = <_MapApp>[
    _MapApp(
      androidPackage: 'com.google.android.apps.maps',
      iosPackage: 'comgooglemaps',
      asset: MapIcons.google,
      name: 'Google',
    ),
    _MapApp(
      androidPackage: 'com.google.android.apps.mapslite',
      iosPackage: null,
      asset: MapIcons.googleGo,
      name: 'Google Go',
    ),
    _MapApp(
      androidPackage: null,
      iosPackage: 'iosamap',
      asset: MapIcons.apple,
      name: 'Apple',
    ),
    _MapApp(
      androidPackage: null,
      iosPackage: 'qqmap',
      asset: MapIcons.amap,
      name: 'QQ',
    ),
    _MapApp(
      androidPackage: null,
      iosPackage: 'tomtomgo',
      asset: MapIcons.tomtomgo,
      name: 'TomTom Go',
    ),
    _MapApp(
      androidPackage: 'com.autonavi.minimap',
      iosPackage: null,
      asset: MapIcons.amap,
      name: 'AutoNavi',
    ),
    _MapApp(
      androidPackage: 'com.baidu.BaiduMap',
      iosPackage: 'baidumap',
      asset: MapIcons.baidu,
      name: 'Baidu',
    ),
    _MapApp(
      androidPackage: 'com.waze',
      iosPackage: 'waze',
      asset: MapIcons.waze,
      name: 'Waze',
    ),
    _MapApp(
      androidPackage: 'ru.yandex.yandexnavi',
      iosPackage: 'yandexnavi',
      asset: MapIcons.yandexNavi,
      name: 'Яндекс Навигатор',
    ),
    _MapApp(
      androidPackage: 'ru.yandex.yandexmaps',
      iosPackage: 'yandexmaps',
      asset: MapIcons.yandexMaps,
      name: 'Яндекс Карты',
    ),
    _MapApp(
      androidPackage: 'com.citymapper.app.release',
      iosPackage: 'citymapper',
      asset: MapIcons.citymapper,
      name: 'Citymapper',
    ),
    _MapApp(
      androidPackage: 'com.mapswithme.maps.pro',
      iosPackage: 'mapswithme',
      asset: MapIcons.mapswithme,
      name: 'Maps.me',
    ),
    _MapApp(
      androidPackage: 'net.osmand',
      iosPackage: 'osmandmaps',
      asset: MapIcons.osmand,
      name: 'OsmAnd',
    ),
    _MapApp(
      androidPackage: 'net.osmand.plus',
      iosPackage: null,
      asset: MapIcons.osmandplus,
      name: 'OsmAnd Plus',
    ),
    _MapApp(
      androidPackage: 'ru.dublgis.dgismobile',
      iosPackage: 'dgis',
      asset: MapIcons.doubleGis,
      name: '2ГИС',
    ),
    _MapApp(
      androidPackage: 'com.tencent.map',
      iosPackage: null,
      asset: MapIcons.tencent,
      name: 'Tencent',
    ),
    _MapApp(
      androidPackage: 'com.here.app.maps',
      iosPackage: 'here-location',
      asset: MapIcons.here,
      name: 'Here',
    ),
    _MapApp(
      androidPackage: 'com.huawei.maps.app',
      iosPackage: null,
      asset: MapIcons.petal,
      name: 'Petal',
    ),
  ];

  Future<void> load() async {
    value = value.inLoading();
    final availableMaps = [
      for (final map in kAndroidIdentifiers)
        if (map.hasPlatformPackage &&
            await LaunchApp.isAppInstalled(
                  androidPackageName: map.androidPackage,
                  iosUrlScheme: map.iosPackage,
                ) ==
                true)
          map,
    ];
    value = AsyncData.success(availableMaps);
  }
}
