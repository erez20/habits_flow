import 'package:flutter/material.dart';

extension ColorSyncExtension on String {
  /// Converts a Hex String from DB/Server to a Flutter Color.
  Color toColor() {
    String hex = replaceAll('#', '');
    if (hex.length == 6) hex = 'FF$hex';

    // Using int.parse is still the standard for String -> int conversion
    return Color(int.parse(hex, radix: 16));
  }
}

extension ColorToStringExtension on Color {
  /// Converts a Flutter Color to a Hex String using the modern API.
  String fromColor({bool includeAlpha = false}) {
    // .value is replaced by .toARGB32()
    final int argb = toARGB32();

    String hex = argb.toRadixString(16).toUpperCase().padLeft(8, '0');

    return includeAlpha ? hex : hex.substring(2);
  }
}

/*
class TaskEntity {
  final String title;
  final Color color;

  TaskEntity({required this.title, required this.color});

  Map<String, dynamic> toJson() => {
    'title': title,
    // Store as "RRGGBB" string
    'color_hex': color.fromColor(),
  };

  factory TaskEntity.fromJson(Map<String, dynamic> json) => TaskEntity(
    title: json['title'],
    // Convert "RRGGBB" string back to Color
    color: (json['color_hex'] as String).toColor(),
  );
}
 */