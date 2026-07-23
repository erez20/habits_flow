import 'package:dio_mini/ui/widgets/data_ticker/data_ticker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'monitor_cubit.dart';
import 'monitor_state.dart';

class MonitorWidget extends StatelessWidget {
  final int id;

  const MonitorWidget({
    super.key,
    required this.id,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8.0),
      child: Container(
        padding: EdgeInsets.all(4),
        height: 96,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: BoxBorder.all(
            width: 1,
            color: Colors.grey.shade600,
          ),
        ),
        child: Column(
          children: [
            _topRow(),
            SizedBox(height: 16),
            BlocBuilder<MonitorCubit, MonitorState>(
              builder: (context, state) {
                return DataTicker(
                  title: state.userTitle(),
                  textColor: state.color,
                  bgColor: Colors.white,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Row _topRow() {
    return Row(
      crossAxisAlignment: .center,
      children: [
        _indicator(),
        SizedBox(width: 16),
        _title(),
      ],
    );
  }

  Text _title() {
    return Text(
      "Monitor user $id",
      style: TextStyle(
        fontSize: 16,
        color: Colors.grey.shade600,
      ),
    );
  }

  Widget _indicator() {
    return BlocBuilder<MonitorCubit, MonitorState>(
      builder: (context, state) {
        return Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: state.color,
            shape: BoxShape.circle,
          ),
        );
      },
    );
  }
}
