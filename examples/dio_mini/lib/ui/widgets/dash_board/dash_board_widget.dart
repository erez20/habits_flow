import 'package:dio_mini/ui/widgets/colored_button/fetch_user_button.dart';
import 'package:dio_mini/ui/widgets/data_ticker/data_ticker.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart' show ReadContext, BlocBuilder;

import 'dash_board_cubit.dart' show DashBoardCubit;
import 'dash_board_state.dart';

class DashBoardWidget extends StatelessWidget {
  final int maxId;

  const DashBoardWidget({
    required this.maxId,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<DashBoardCubit>();
    return Column(
      mainAxisSize: .min,
      children: [
        _ButtonsRow(maxId: maxId, pressMe: cubit.pressMe),
        SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: BlocBuilder<DashBoardCubit, DashBoardState>(
            builder: (context, state) {
              return DataTicker(title: state.userEntity.name,
                  textColor: Colors.black,
                  bgColor: state.color);
            },
          ),
        ),
      ],
    );
  }
}

class _ButtonsRow extends StatelessWidget {
  const _ButtonsRow({
    required this.maxId,
    required this.pressMe,
  });

  final int maxId;
  final void Function({required int id}) pressMe;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 96,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 16),
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: ColoredButton(
                    userId: index,

                    onTap: () => pressMe(id: index),
                    title: "$index",
                    height: 56,

                  ),
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return SizedBox(width: 20);
              },
              itemCount: maxId,

            ),
          ),
        ),
      ],
    );
  }
}
