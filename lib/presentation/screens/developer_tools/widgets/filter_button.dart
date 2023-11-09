import 'package:auto_route/auto_route.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pixel_app_flutter/domain/developer_tools/developer_tools.dart';
import 'package:pixel_app_flutter/presentation/routes/main_router.dart';

class FilterButton extends StatelessWidget {
  const FilterButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        context.router.push(const RequestsExchangeLogsFilterFlow());
      },
      icon: Stack(
        clipBehavior: Clip.none,
        children: [
          const Icon(Icons.filter_list_alt),
          BlocSelector<RequestsExchangeLogsFilterCubit,
              RequestsExchangeLogsFilterState, int>(
            selector: (state) {
              return [
                state.direction.length,
                state.parameterId.length,
                state.requestType.length,
              ].sum;
            },
            builder: (context, count) {
              return Positioned(
                right: -5,
                top: -5,
                child: Badge(
                  isLabelVisible: count > 0,
                  label: Text(count.toString()),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
