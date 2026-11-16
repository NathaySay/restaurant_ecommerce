const List<String> _monthNames = <String>[
  'Jan',
  'Feb',
  'Mar',
  'Apr',
  'May',
  'Jun',
  'Jul',
  'Aug',
  'Sep',
  'Oct',
  'Nov',
  'Dec',
];

/// Formats an amount in Cambodian Riel, e.g. 45000 -> "៛45,000".
String riel(int amount) {
  final String digits = amount.toString();
  final StringBuffer buffer = StringBuffer();
  for (int i = 0; i < digits.length; i++) {
    final int remaining = digits.length - i;
    buffer.write(digits[i]);
    if (remaining > 1 && remaining % 3 == 1) {
      buffer.write(',');
    }
  }
  return '៛$buffer';
}

/// Backward compatibility alias for usd.
String usd(int amount) => riel(amount);

/// Backward compatibility alias for rupiah.
String rupiah(int amount) => riel(amount);

/// Formats a timestamp like "16 Nov · 19:42".
String formatDateTime(DateTime dateTime) {
  final String hour = dateTime.hour.toString().padLeft(2, '0');
  final String minute = dateTime.minute.toString().padLeft(2, '0');
  return '${dateTime.day} ${_monthNames[dateTime.month - 1]} · $hour:$minute';
}
