import 'package:intl/intl.dart';

abstract final class DateFormatter {
  static final _dayMonth = DateFormat('d/MM', 'pt_BR');
  static final _fullDate = DateFormat('d \'de\' MMMM \'de\' yyyy', 'pt_BR');
  static final _shortDate = DateFormat('dd/MM/yyyy', 'pt_BR');
  static final _dateTime = DateFormat('dd/MM/yyyy \'às\' HH:mm', 'pt_BR');
  static final _monthYear = DateFormat('MMMM/yyyy', 'pt_BR');
  static final _dayOfWeek = DateFormat('EEEE', 'pt_BR');
  static final _shortDayMonth = DateFormat('dd MMM', 'pt_BR');

  static String dayMonth(DateTime date) => _dayMonth.format(date);
  static String fullDate(DateTime date) => _fullDate.format(date);
  static String shortDate(DateTime date) => _shortDate.format(date);
  static String dateTime(DateTime date) => _dateTime.format(date);
  static String monthYear(DateTime date) => _monthYear.format(date);
  static String dayOfWeek(DateTime date) => _dayOfWeek.format(date);
  static String shortDayMonth(DateTime date) => _shortDayMonth.format(date);

  /// "12 a 15 de junho de 2025"
  static String dateRange(DateTime start, DateTime end) {
    if (start.year == end.year && start.month == end.month) {
      final startDay = DateFormat('d', 'pt_BR').format(start);
      final endFull = DateFormat('d \'de\' MMMM \'de\' yyyy', 'pt_BR').format(end);
      return '$startDay a $endFull';
    }
    return '${fullDate(start)} a ${fullDate(end)}';
  }

  /// Tempo relativo: "há 2 horas", "há 3 dias"
  static String relative(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inSeconds < 60) return 'agora mesmo';
    if (diff.inMinutes < 60) return 'há ${diff.inMinutes} min';
    if (diff.inHours < 24) {
      return 'há ${diff.inHours} hora${diff.inHours > 1 ? 's' : ''}';
    }
    if (diff.inDays < 7) {
      return 'há ${diff.inDays} dia${diff.inDays > 1 ? 's' : ''}';
    }
    if (diff.inDays < 30) {
      final weeks = (diff.inDays / 7).floor();
      return 'há $weeks semana${weeks > 1 ? 's' : ''}';
    }
    return shortDate(date);
  }
}
