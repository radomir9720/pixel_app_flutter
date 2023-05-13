import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pixel_app_flutter/domain/data_source/data_source.dart';
import 'package:pixel_app_flutter/l10n/l10n.dart';
import 'package:pixel_app_flutter/presentation/app/colors.dart';

class UpdateButton extends StatelessWidget {
  const UpdateButton({super.key, required this.updateIds});

  @protected
  final List<DataSourceParameterId> updateIds;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: kToolbarHeight,
      child: InkWell(
        child: DecoratedBox(
          decoration: ShapeDecoration(
            shape: RoundedRectangleBorder(
              side: BorderSide(
                color: AppColors.of(context).border,
              ),
            ),
          ),
          child: Center(
            child: Text(
              context.l10n.updateButtonCaption,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
        ),
        onTap: () {
          context.read<OutgoingPackagesCubit>().getValues(updateIds);
        },
      ),
    );
  }
}
