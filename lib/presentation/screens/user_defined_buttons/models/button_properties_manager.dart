import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';
import 'package:pixel_app_flutter/presentation/screens/user_defined_buttons/models/button_property_input_field/button_property_input_field.dart';
import 'package:re_seedwork/re_seedwork.dart';

class ButtonPropertiesManager {
  ButtonPropertiesManager()
      : changeListeners = {},
        propertiesMap = {},
        objectInitializerCallbackMap = {};

  @visibleForTesting
  final Map<Type, void Function()> changeListeners;

  @visibleForTesting
  final Map<Type, dynamic> propertiesMap;

  @visibleForTesting
  final Map<Type, dynamic Function()> objectInitializerCallbackMap;

  void addObjectInitializer<Y>(
    Y Function() callback,
  ) {
    objectInitializerCallbackMap[Y] = callback;
  }

  void removeObjectInitializer<Y, T extends ButtonPropertyInputField<Y>>(
    Y Function() callback,
  ) {
    objectInitializerCallbackMap.remove(T);
  }

  void setValue<Y, T extends ButtonPropertyInputField<Y>>(Y value) {
    propertiesMap[T] = value;
    Future.microtask(_onChange<Y, T>);
  }

  void updateValue<Y, T extends ButtonPropertyInputField<Y>>(
    Y? Function(Y? currentValue) callback,
  ) {
    propertiesMap[T] = callback(
      (propertiesMap[T] ?? objectInitializerCallbackMap[Y]?.call()) as Y?,
    );
    Future.microtask(_onChange<Y, T>);
  }

  void removeProperty<Y, T extends ButtonPropertyInputField<Y>>() {
    propertiesMap.remove(T);
  }

  void addChangeListener<Y, T extends ButtonPropertyInputField<Y>>(
    void Function() listener,
  ) {
    changeListeners[T] = listener;
  }

  void removeChangeListener<Y, T extends ButtonPropertyInputField<Y>>() {
    changeListeners.remove(T);
  }

  void _onChange<Y, T extends ButtonPropertyInputField<Y>>() {
    changeListeners[T]?.call();
  }

  Y getValue<Y, T extends ButtonPropertyInputField<Y>>() {
    return getOptional<Y, T>().checkNotNull(T.runtimeType.toString());
  }

  Y? getOptional<Y, T extends ButtonPropertyInputField<Y>>() {
    return propertiesMap[T] as Y?;
  }
}
