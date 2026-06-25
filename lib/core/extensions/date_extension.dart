import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
///  Date Extensions
extension DateExtensions on DateTime {
  ///  Display Date (e.g: 20 Jun 2026)
  String toDisplayDate() {
    return DateFormat('dd MMM yyyy').format(this);
  }

  ///  Full Date (e.g: Friday, 20 June 2026)
  String toFullDate() {
    return DateFormat('EEEE, dd MMMM yyyy').format(this);
  }

  /// Time (e.g: 02:30 PM)
  String toTime() {
    return DateFormat('hh:mm a').format(this);
  }
}
