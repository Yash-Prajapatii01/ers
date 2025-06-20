import 'package:flutter/material.dart';

class UdfOptionsModel {
  final int? editability;
  final int id;
  final String name;
  final Color? color;
  final bool? isSelected;
  final String? performing;
  final String? img;
  final String? imgUrl;

  const UdfOptionsModel({
    this.editability,
    required this.id,
    required this.name,
    this.color,
    this.isSelected,
    this.performing,
    this.img,
    this.imgUrl
  });

  /// Helper that takes a raw string like "#FF8A80;0"
  /// and returns a Flutter [Color], defaulting to transparent
  /// on null, empty, or malformed input.
  static Color parseColorString(String? raw) {
    if (raw == null || raw.trim().isEmpty) return Colors.transparent;

    final hexPart = raw.split(';').first.replaceFirst('#', '');
    try {
      switch (hexPart.length) {
        case 6:
          return Color(int.parse('0xFF$hexPart'));
        case 8:
          return Color(int.parse('0x$hexPart'));
        default:
          return Colors.transparent;
      }
    } catch (_) {
      return Colors.transparent;
    }
  }

  factory UdfOptionsModel.fromJson(Map<String, dynamic> json) {
    // Grab the raw color string from your API response.
    final rawColor = json['color'] as String?;
    // Delegate to our central helper.
    final resolvedColor = UdfOptionsModel.parseColorString(rawColor);

    return UdfOptionsModel(
      editability: json['editability'] as int? ?? 0,
      id: json['id'] as int? ?? -1,
      name: json['name'] as String? ?? '',
      isSelected: json['is_selected'] ?? false,
      color: resolvedColor,
      performing: json['performing'] as String?,
      img: json['img'] as String?,
      imgUrl: json['imgUrl'] as String?,
    );
  }
}
