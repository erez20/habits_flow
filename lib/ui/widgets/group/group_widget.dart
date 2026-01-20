import 'dart:math';

import 'package:flutter/material.dart';
import 'package:habits_flow/domain/entities/group_entity.dart';

class GroupWidget extends StatelessWidget {
  final GroupEntity entity;

  const GroupWidget({required this.entity, super.key});

  @override
  Widget build(BuildContext context) {
    final randoinInt = Random().nextInt(1000);
    return Text ("$randoinInt: $entity");
  }
}
