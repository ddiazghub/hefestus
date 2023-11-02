import 'package:cloud_firestore/cloud_firestore.dart';

class Converters {
  static DateTime localTime(Timestamp time) => time.toDate();
  static Timestamp timestamp(DateTime datetime) => Timestamp.fromDate(datetime);
}
