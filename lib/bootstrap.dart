// Copyright (c) 2022, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:pixel_app_flutter/app/helpers/crashlytics_helper.dart';
import 'package:pixel_app_flutter/app/helpers/firebase_bloc_observer.dart';
import 'package:pixel_app_flutter/app/scopes/main_scope.dart';
import 'package:pixel_app_flutter/bootstrap.config.dart';
import 'package:pixel_app_flutter/data/services/bluetooth_data_source.dart';
import 'package:pixel_app_flutter/data/services/demo_data_source.dart';
import 'package:pixel_app_flutter/data/storages/developer_tools_parameters_storage.dart';
import 'package:pixel_app_flutter/domain/data_source/data_source.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum Environment {
  prod(prodKey),
  stg(stgKey),
  dev(devKey);

  const Environment(this.value);

  static const prodKey = 'prod';
  static const stgKey = 'stg';
  static const devKey = 'dev';

  final String value;

  bool get isDev => this == Environment.dev;
  bool get isStg => this == Environment.stg;
  bool get isProd => this == Environment.prod;

  R when<R>({
    required R Function() prod,
    required R Function() stg,
    required R Function() dev,
  }) {
    switch (this) {
      case Environment.prod:
        return prod();
      case Environment.stg:
        return stg();
      case Environment.dev:
        return dev();
    }
  }
}

Future<void> bootstrap(
  FutureOr<Widget> Function(List<NavigatorObserver> Function() observersBuilder)
      builder,
  Environment env,
) async {
  // SizeProvider.initialize(sizeConverter:
  // const SizeConverter(fo: fo, si: si));

  await Firebase.initializeApp();

  await CrashlyticsHelper.initialize();

  await FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(kReleaseMode);

  FlutterError.onError = CrashlyticsHelper.recordFlutterError;

  Bloc.observer = FirebaseBlocObserver();

  await configureDependencies(env);

  await runZonedGuarded(
    () async => runApp(
      MainScope(
        child: await builder(
          () => [
            FirebaseAnalyticsObserver(
              analytics: FirebaseAnalytics.instance,
              routeFilter: (route) {
                return route is PageRoute || route is DialogRoute;
              },
            ),
          ],
        ),
      ),
    ),
    CrashlyticsHelper.recordError,
  );
}

@InjectableInit()
Future<void> configureDependencies(Environment env) async {
  final getIt = GetIt.instance;

  await _configureManualDeps(getIt, env);
  $initGetIt(getIt, environment: env.value);
}

Future<void> _configureManualDeps(GetIt getIt, Environment env) async {
  final gh = GetItHelper(getIt)..factory<Environment>(() => env);

  await gh.factoryAsync<SharedPreferences>(
    SharedPreferences.getInstance,
    preResolve: true,
  );

  await gh.factoryAsync(
    PackageInfo.fromPlatform,
    preResolve: true,
  );

  gh
    ..singleton<DeveloperToolsParametersStorage>(
      DeveloperToolsParametersStorageImpl(preferences: getIt.get()),
    )
    ..factory<List<DataSource>>(
      () {
        final devToolsParamsStorage =
            getIt.get<DeveloperToolsParametersStorage>();
        return [
          if (Platform.isAndroid)
            BluetoothDataSource(
              bluetoothSerial: FlutterBluetoothSerial.instance,
            ),
          DemoDataSource(
            generateRandomErrors: () {
              return env.isDev &&
                  devToolsParamsStorage
                      .data.enableRandomErrorGenerationForDemoDataSource;
            },
            updatePeriodMillis: () {
              return devToolsParamsStorage.data.requestsPeriodInMillis;
            },
          ),
        ];
      },
    );
}
