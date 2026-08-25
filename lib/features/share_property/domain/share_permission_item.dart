import 'package:expense_app/core/constant/const_text/share_property_text.dart';
import 'package:flutter/material.dart';

class SharePermissionItem {
  final String id;
  final String title;
  final String subtitle;
  final IconData icon;
  final bool required;

  const SharePermissionItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
    this.required = false,
  });

  static const String viewSummary = 'viewSummary';
  static const String addExpense = 'addExpense';
  static const String edit = 'edit';
  static const String deleteProperty = 'deleteProperty';

  static const List<SharePermissionItem> all = [
    SharePermissionItem(
      id: viewSummary,
      title: SharePropertyText.viewSummaryTitle,
      subtitle: SharePropertyText.viewSummarySubtitle,
      icon: Icons.bar_chart_rounded,
      required: true,
    ),
    SharePermissionItem(
      id: addExpense,
      title: SharePropertyText.addExpenseTitle,
      subtitle: SharePropertyText.addExpenseSubtitle,
      icon: Icons.add_rounded,
    ),
    SharePermissionItem(
      id: edit,
      title: SharePropertyText.editTitle,
      subtitle: SharePropertyText.editSubtitle,
      icon: Icons.edit_outlined,
    ),
    SharePermissionItem(
      id: deleteProperty,
      title: SharePropertyText.deleteTitle,
      subtitle: SharePropertyText.deleteSubtitle,
      icon: Icons.delete_outline,
    ),
  ];
}
