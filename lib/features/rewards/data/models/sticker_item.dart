import 'package:flutter/material.dart';

class StickerItem {
  final String id;
  final String name;
  final String urduName;
  final IconData icon;
  final Color color;
  final int starsRequired;
  final bool isUnlocked;

  const StickerItem({
    required this.id,
    required this.name,
    required this.urduName,
    required this.icon,
    required this.color,
    required this.starsRequired,
    this.isUnlocked = false,
  });

  StickerItem copyWith({bool? isUnlocked}) {
    return StickerItem(
      id: id,
      name: name,
      urduName: urduName,
      icon: icon,
      color: color,
      starsRequired: starsRequired,
      isUnlocked: isUnlocked ?? this.isUnlocked,
    );
  }
}
