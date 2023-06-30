import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pixel_app_flutter/domain/data_source/data_source.dart';
import 'package:pixel_app_flutter/domain/data_source/models/package/incoming/authorization_response.dart';
import 'package:pixel_app_flutter/domain/data_source/models/package/outgoing/authorizartion.dart';
import 'package:pixel_app_flutter/domain/data_source/models/package_data/package_data.dart';
import 'package:re_seedwork/re_seedwork.dart';

part 'data_source_authorization_cubit.freezed.dart';

@freezed
class DataSourceAuthorizationState with _$DataSourceAuthorizationState {
  const DataSourceAuthorizationState._();

  const factory DataSourceAuthorizationState.initial(String? id) = _Initial;
  const factory DataSourceAuthorizationState.failure(String? id) = _Failure;
  const factory DataSourceAuthorizationState.sendingInitializationRequest(
    String? id,
  ) = _SendingInitializationRequest;
  const factory DataSourceAuthorizationState.initializationTimeout(String? id) =
      _InitializationTimeout;
  const factory DataSourceAuthorizationState.initializationResponseReceived(
    String? id,
  ) = _InitializationResponseReceived;
  const factory DataSourceAuthorizationState.noSerialNumber(
    String? id,
  ) = _NoSerialNumber;
  const factory DataSourceAuthorizationState.sendingAuthorizationRequest(
    String? id,
  ) = _SendingAuthorizationRequest;
  const factory DataSourceAuthorizationState.authorizationTimeout(String? id) =
      _AuthorizationTimeout;
  const factory DataSourceAuthorizationState.authorized(String? id) =
      _Authorized;
  const factory DataSourceAuthorizationState.errorSavingSerialNumber(
    String? id,
  ) = _ErrorSavingSerialNumber;

  bool get isLoading => maybeWhen(
        sendingAuthorizationRequest: (id) => true,
        sendingInitializationRequest: (id) => true,
        initializationResponseReceived: (id) => true,
        initial: (id) => true,
        orElse: () => false,
      );
}

class DataSourceAuthorizationCubit extends Cubit<DataSourceAuthorizationState>
    with ConsumerBlocMixin {
  DataSourceAuthorizationCubit({
    required this.serialNumberStorage,
    required this.dataSourceStorage,
    this.initializationTimeout = kInitializationTimeout,
    this.authorizationTimeout = kAuthorizationTimeout,
  }) : super(const DataSourceAuthorizationState.initial(null)) {
    subscribe<Optional<DataSourceWithAddress>>(dataSourceStorage, (value) {
      incomingPackagesSubscription?.cancel();
      incomingPackagesSubscription = null;
      value.when(
        undefined: () {},
        presented: (dswa) {
          tryAutoAuthorization(dswa.dataSource);
          incomingPackagesSubscription =
              dswa.dataSource.packageStream.listen((value) {
            value
              ..voidOnModel<AuthorizationInitializationResponse,
                  AuthorizationInitializationResponseIncomingDataSourcePackage>(
                (model) => _onAuthorizationInitializationResponse(
                  model,
                  dswa.dataSource,
                ),
              )
              ..voidOnModel<AuthorizationResponse,
                  AuthorizationResponseIncomingDataSourcePackage>((model) {
                if (model.success) {
                  emit(DataSourceAuthorizationState.authorized(state.id));
                  return;
                }
                dataSourceStorage.put(const Optional.undefined());
                emit(DataSourceAuthorizationState.failure(state.id));
              });
          });
        },
      );
    });
  }

  @visibleForTesting
  StreamSubscription<void>? incomingPackagesSubscription;

  void tryAutoAuthorization(DataSource ds) {
    emit(DataSourceAuthorizationState.sendingInitializationRequest(state.id));

    final package = OutgoingAuthorizationInitializationRequestPackage();
    ds.sendPackage(package);
    Future<void>.delayed(initializationTimeout).then((value) {
      if (isClosed) return;
      state.maybeWhen(
        sendingInitializationRequest: (id) {
          emit(DataSourceAuthorizationState.initializationTimeout(state.id));
          dataSourceStorage.put(const Optional.undefined());
        },
        orElse: () {},
      );
    });
  }

  Future<void> _onAuthorizationInitializationResponse(
    AuthorizationInitializationResponse model,
    DataSource ds,
  ) async {
    final id = model.deviceId.join();
    emit(DataSourceAuthorizationState.initializationResponseReceived(id));
    if (model.method != 0x01) {
      await dataSourceStorage.put(const Optional.undefined());
      emit(DataSourceAuthorizationState.failure(id));
      throw UnimplementedError('Unknown authorization method: ${model.method}');
    }

    try {
      final response = await serialNumberStorage.read(id);

      if (isClosed) return;
      response.when(
        error: (e) {
          emit(DataSourceAuthorizationState.failure(id));
          dataSourceStorage.put(const Optional.undefined());
          Future<void>.error(e);
        },
        value: (value) {
          value.when(
            undefined: () {
              emit(DataSourceAuthorizationState.noSerialNumber(id));
            },
            presented: (chain) => authorize(chain.sn, ds),
          );
        },
      );
    } catch (e) {
      await dataSourceStorage.put(const Optional.undefined());
      emit(DataSourceAuthorizationState.failure(id));

      rethrow;
    }
  }

  void authorize(SerialNumber sn, [DataSource? dataSource]) {
    final ds = dataSource ?? dataSourceStorage.data.toNullable?.dataSource;
    if (ds == null) {
      dataSourceStorage.put(const Optional.undefined());
      emit(DataSourceAuthorizationState.failure(state.id));
      throw ArgumentError.notNull('DataSource');
    }

    emit(DataSourceAuthorizationState.sendingAuthorizationRequest(state.id));

    final package = OutgoingAuthorizationRequestPackage(
      request: AuthorizationRequest(sn: sn),
    );
    ds.sendPackage(package);

    Future<void>.delayed(authorizationTimeout).then((value) {
      if (isClosed) return;
      state.maybeWhen(
        sendingAuthorizationRequest: (id) {
          dataSourceStorage.put(const Optional.undefined());
          emit(DataSourceAuthorizationState.authorizationTimeout(id));
        },
        authorized: (id) async {
          if (id == null) {
            return emit(
              DataSourceAuthorizationState.errorSavingSerialNumber(id),
            );
          }
          final chain = SerialNumberChain.now(
            id: id,
            sn: sn,
          );
          final result = await serialNumberStorage.write(chain);

          result.when(
            error: (error) {
              emit(
                DataSourceAuthorizationState.errorSavingSerialNumber(id),
              );
              Future<void>.error(error);
            },
            value: (value) {},
          );
        },
        orElse: () {},
      );
    });
  }

  @visibleForTesting
  static const kInitializationTimeout = Duration(seconds: 2);

  @visibleForTesting
  static const kAuthorizationTimeout = Duration(seconds: 2);

  @protected
  final DataSourceStorage dataSourceStorage;

  @protected
  final Duration initializationTimeout;

  @protected
  final Duration authorizationTimeout;

  @protected
  final SerialNumberStorage serialNumberStorage;
}
