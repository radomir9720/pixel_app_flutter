import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';
import 'package:pixel_app_flutter/domain/data_source/data_source.dart';
import 'package:provider/single_child_widget.dart';

class OverlayDataSender extends SingleChildStatelessWidget {
  const OverlayDataSender({super.key, super.child});

  @override
  Widget buildWithChild(BuildContext context, Widget? child) {
    return BlocListener<GeneralDataCubit, GeneralDataState>(
      listener: (context, state) {
        FlutterOverlayWindow.shareData(state.toMap());
      },
      child: child,
    );
  }
}
