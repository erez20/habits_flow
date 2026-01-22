import 'package:fimber/fimber.dart';
import 'package:flutter/material.dart';
import 'package:habits_flow/domain/entities/group_entity.dart';

class GroupWidget extends StatelessWidget {
  final GroupEntity entity;

  const GroupWidget({required this.entity, super.key});

  @override
  Widget build(BuildContext context) {
    Fimber.d("build group widget ${entity.toString()}");

    return Text ("$entity\n");
  }
}
