class TableKeys {
  static String get myDb => 'MY_EXPENSE.db';
  static String get userTable => 'USER_TABLE';
  static String get currentUserEmailTable => 'CURRENT_USER_EMAIL_TABLE';
  static String get fingerPrintTable => 'FINGER_PRINT_TABLE';
  static String get onboardingTable => 'ONBOARDING_TABLE';
  /// After Logout: force Login screen even if Firebase session still exists.
  static String get appLockTable => 'APP_LOCK_TABLE';
  static String get propertyCardTable => 'PROPERTY_CARD_TABLE';
  static String get categoryTable => 'CATEGORY_TABLE';
  static String get expensesTable => 'EXPENSES_TABLE';
}
