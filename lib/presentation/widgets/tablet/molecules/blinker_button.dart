import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pixel_app_flutter/domain/data_source/data_source.dart';
import 'package:pixel_app_flutter/presentation/app/colors.dart';
import 'package:pixel_app_flutter/presentation/app/icons.dart';
import 'package:pixel_app_flutter/presentation/widgets/common/atoms/relay_widget.dart';

class BlinkerButton extends StatelessWidget {
  const BlinkerButton({super.key});

  @override
  Widget build(BuildContext context) {
    return RelayWidget(
      builder: (isOn) {
        return InkWell(
          onTap: () {
            context.read<LightsCubit>().toggleHazardBeam();
          },
          borderRadius: const BorderRadius.all(Radius.circular(100)),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Icon(
              PixelIcons.hazardBeam,
              size: 30,
              color: isOn ? null : AppColors.of(context).errorPastel,
            ),
          ),
        );
      },
      initiallyEnabled:
          context.read<LightsCubit>().state.hazardBeam.payload.isOn,
      switchStream: context
          .read<LightsCubit>()
          .stream
          .map((event) => event.hazardBeam.payload.isOn),
    );
  }
}
