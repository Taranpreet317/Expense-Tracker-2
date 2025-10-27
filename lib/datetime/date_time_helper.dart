// convert DateTime object to formatted string
String convertDateTimeToString(DateTime dateTime) {
  // year in the fomat YYYY-MM-DD
  String year = dateTime.year.toString();

  // month in the format MM
  String month = dateTime.month.toString();
  if (month.length == 1) {
    month = '0$month';
  }
  // day in the format DD
  String day = dateTime.day.toString();
  if (day.length == 1) {
    day = '0$day';
  }
  // final format YYYY-MM-DD
  String yyyymmdd = year + month + day;
  return yyyymmdd;
}
