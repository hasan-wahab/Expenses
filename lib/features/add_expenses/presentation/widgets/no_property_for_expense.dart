import 'package:expense_app/features/widgets/no_property_added.dart';
import 'package:flutter/material.dart';

/// Kept for add-expense feature path; delegates to shared widget.
class NoPropertyForExpense extends StatelessWidget {
  const NoPropertyForExpense({super.key, required this.onPropertyAdded});

  final VoidCallback onPropertyAdded;

  @override
  Widget build(BuildContext context) {
    return NoPropertyAdded(onPropertyAdded: onPropertyAdded);
  }
}
