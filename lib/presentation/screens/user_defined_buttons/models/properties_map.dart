import 'package:collection/collection.dart';
import 'package:flutter/widgets.dart';
import 'package:re_seedwork/re_seedwork.dart';

abstract class PropertiesMap<T> extends UnmodifiableMapView<int, T> {
  PropertiesMap(super.map);

  Y updateItem<Y extends PropertiesMap<T>>(
    int id,
    T Function(
      T? current,
    ) newObjectCallback,
  ) {
    final newMap = {...this};
    final newItem = newMap[id];

    newMap[id] = newObjectCallback(newItem);

    return builder(newMap);
  }

  Y builder<Y extends PropertiesMap<T>>(Map<int, T> items);

  Y removeEntry<Y extends PropertiesMap<T>>(int id) {
    return builder({...this}..remove(id));
  }
}

abstract class PropertyEntry<T> {
  const PropertyEntry(this.value);

  final T value;
}

class IntPropertyEntry extends PropertyEntry<int> {
  const IntPropertyEntry(super.value);
}

class OptionalIntPropertyEntry extends PropertyEntry<int?> {
  const OptionalIntPropertyEntry(super.value);
}

class ColorPropertyEntry extends PropertyEntry<Color> {
  const ColorPropertyEntry(super.value);
}

class StringPropertyEntry extends PropertyEntry<String> {
  const StringPropertyEntry(super.value);
}

class BoolPropertyEntry extends PropertyEntry<bool> {
  // ignore: avoid_positional_boolean_parameters
  const BoolPropertyEntry(super.value);
}

class OptionalStringPropertyEntry extends PropertyEntry<String?> {
  const OptionalStringPropertyEntry(super.value);
}

class SerializablePropertiesMap
    extends UnmodifiableMapView<Type, PropertyEntry<dynamic>> {
  SerializablePropertiesMap(super.map);

  SerializablePropertiesMap addProperty<T extends PropertyEntry<dynamic>>(
    T property,
  ) {
    final newMap = {...this};
    newMap[property.runtimeType] = property;
    return SerializablePropertiesMap(newMap);
  }

  T? getOptionalProperty<T extends PropertyEntry<dynamic>>() {
    return this[T] as T?;
  }

  Y? getOptionalValue<Y, T extends PropertyEntry<Y>>() {
    return getOptionalProperty<T>()?.value;
  }

  Y getValue<Y, T extends PropertyEntry<Y>>() {
    return getOptionalValue<Y, T>().checkNotNull('Value');
  }
}
