import 'package:flutter/material.dart';

class Mood {
  final String label;
  final IconData icon;
  final Color color;

  const Mood({
    required this.label,
    required this.icon,
    required this.color,
  });
}

class MoodEntry {
  final Mood mood;
  final String? note;
  final String date;

  const MoodEntry({
    required this.mood,
    this.note,
    required this.date,
  });
} 