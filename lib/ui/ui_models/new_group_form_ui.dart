import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class NewGroupFormUI extends Equatable {
  final String title;
  final MaterialColor color;
  final int durationInSec;

  const NewGroupFormUI({
    required this.title,
    required this.color,
    required this.durationInSec,
  });

  NewGroupFormUI copyWith({
    String? title,
    MaterialColor? color,
    int? durationInSec,
  }) {
    return NewGroupFormUI(
      title: title ?? this.title,
      color: color ?? this.color,
      durationInSec: durationInSec ?? this.durationInSec,
    );
  }

  @override
  List<Object?> get props => [title, color, durationInSec];
}
