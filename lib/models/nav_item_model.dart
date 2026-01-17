import 'package:flutter/material.dart';

class NavItemModel {
  final int id;
  final String label;
  final IconData icon;
  final IconData activeIcon;

  const NavItemModel({
    required this.id,
    required this.label,
    required this.icon,
    required this.activeIcon,
  });
}