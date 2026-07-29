class PeriodFilteringUtils {
  ({DateTime startDate, DateTime endDate}) lastQuarter() {
    final now = DateTime.now();

    int currentQuarter = ((now.month - 1) ~/ 3) + 1;
    int lastQuarter = currentQuarter - 1;

    int year = now.year;

    if (lastQuarter == 0) {
      lastQuarter = 4;
      year -= 1;
    }

    int startMonth = (lastQuarter - 1) * 3 + 1;

    final startDate = DateTime(year, startMonth, 1);
    final endDate = DateTime(year, startMonth + 3, 0);
    return (startDate: startDate, endDate: endDate);
  }

  ({DateTime startDate, DateTime endDate}) thisMonth() {
    final now = DateTime.now();

    final startOfMonth = DateTime(now.year, now.month, 1);
    final endOfMonth = DateTime(now.year, now.month + 1, 0);
    return (startDate: startOfMonth, endDate: endOfMonth);
  }

  ({DateTime startDate, DateTime endDate}) customRange({
    required DateTime start,
    required DateTime end,
  }) {
    return (startDate: start, endDate: end);
  }



}
