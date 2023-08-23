import 'dart:collection';

import 'package:pixel_app_flutter/domain/user_defined_buttons/user_defined_buttons.dart';
import 'package:re_seedwork/re_seedwork.dart';

abstract class UserDefinedButtonsStorage
    extends ValueStore<UnmodifiableListView<UserDefinedButton>> {
  Future<Result<WriteUserDefinedButtonsStorageError, void>> append(
    UserDefinedButton button,
  );

  Future<Result<DeleteByIdUserDefinedButtonsStorageError, void>> deleteById(
    int id,
  );

  Future<Result<ReadUserDefinedButtonsStorageError, List<UserDefinedButton>>>
      read();
}

enum WriteUserDefinedButtonsStorageError { unknown }

enum ReadUserDefinedButtonsStorageError { unknown }

enum DeleteByIdUserDefinedButtonsStorageError { notFound, unknown }
