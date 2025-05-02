import 'package:flutter/material.dart';

class Activity {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final String route;

  const Activity({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.route,
  });
} 