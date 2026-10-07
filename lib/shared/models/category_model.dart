import 'package:flutter/material.dart';

class CategoryModel {
  final String id;
  final String name;
  final IconData icon;
  final String imageUrl;
  final List<String> subcategories;
  final bool isPopular;
  final Color accentColor;

  const CategoryModel({
    required this.id,
    required this.name,
    required this.icon,
    required this.imageUrl,
    required this.subcategories,
    this.isPopular = false,
    this.accentColor = const Color(0xFF6C5CE7),
  });
}
