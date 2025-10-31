class DateUtilsX {
  static String formatYmd(DateTime d) {
    final y = d.year.toString().padLeft(4, '0');
    final m = d.month.toString().padLeft(2, '0');
    final day = d.day.toString().padLeft(2, '0');
    return '$y-$m-$day';
  }

  static String formatDayMonthNameYear(DateTime d) {
    const monthNames = <String>[
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    final day = d.day.toString().padLeft(2, '0');
    final month = monthNames[d.month - 1];
    return '$day $month ${d.year}';
  }
}
