// // BSD 3-Clause License
// // Copyright (c) 2022, GM Consult Pty Ltd

// // ignore_for_file: unused_local_variable

// import 'dart:math';
// import 'package:collection/collection.dart';

// class GMConsultTestUtils {
//   final String testName;

//   factory GMConsultTestUtils(
//       {required String testName,
//       required List<Map<String, dynamic>> results,
//       int fieldPadding = 5,
//       List<String>? fields}) {
//     fields = fields ?? [];
//     if (fields.isEmpty && results.isNotEmpty) {
//       fields.addAll(results.first.keys);
//     }
//     final fieldWidths = <String, int>{};
//     final fieldDigits = <String, int?>{};
//     for (var i = 0; i < fields.length; i++) {
//       final fieldName = fields[i];
//       fieldWidths[fieldName] = results.fieldWidth(fieldName);
//       fieldDigits[fieldName] = results.fieldDigits(fieldName);
//     }
//     final fieldsWidth = fieldWidths.values.sum;
//     var d = 0;
//     if (fieldsWidth < 80) {
//       d = ((80 - fieldsWidth) / fields.length).floor();
//     } else if (testName.length > fieldsWidth) {
//       d = ((testName.length - fieldsWidth) / fields.length).floor();
//     }
//     if (d > 0) {
//       for (final entry in fieldWidths.entries) {
//         fieldWidths[entry.key] = entry.value + d;
//       }
//     }

//     return GMConsultTestUtils._(
//         testName, results, fields, fieldWidths, fieldDigits);
//   }

//   GMConsultTestUtils._(this.testName, this.results, this.fields,
//       this._fieldWidths, this._fieldDigits);

//   final List<String> fields;

//   final Map<String, int> _fieldWidths;

//   final Map<String, int?> _fieldDigits;

//   final Iterable<Map<String, dynamic>> results;

//   void printResults() {
//     _printSeparator();
//     _printTitle();
//     _printHeaders();
//     _printSeparator();
//     _printResults();
//     _printSeparator();
//   }

//   static const _kSeparator = '-';
//   void _printSeparator() => print(''.padRight(_printWidth, _kSeparator));

//   int get _printWidth {
//     final fieldsWidth = _fieldWidths.values.sum;
//     return fieldsWidth > testName.length ? fieldsWidth : testName.length;
//   }

//   void _printTitle() {
//     print(testName.padRight(_printWidth));
//   }

//   void _printResults() {
//     for (final result in results) {
//       _printResult(result);
//     }
//   }

//   void _printResult(Map<String, dynamic> result) {
//     final value = StringBuffer();
//     for (var i = 0; i < fields.length; i++) {
//       value.write(_value(fields[i], result, i));
//     }
//     print(value.toString());
//   }

//   void _printHeaders() {
//     var i = 0;
//     final headers = StringBuffer();
//     for (final fieldName in fields) {
//       headers.write(_header(fieldName, i));
//       i++;
//     }
//     print(headers.toString());
//   }

//   String _header(String fieldName, int columnIndex) {
//     final width = _fieldWidths[fieldName] as int;
//     return columnIndex == 0
//         ? fieldName.padRight(width)
//         : fieldName.padLeft(width);
//   }

//   String _value(
//       String fieldName, Map<String, dynamic> result, int columnIndex) {
//     final width = _fieldWidths[fieldName] as int;
//     final value = result[fieldName];
//     // final leftPad = columnIndex>0? (width / 2).floor():0;
//     // final rightPad = width - leftPad;
//     var text = '';
//     if (value is double) {
//       final digits = _fieldDigits[fieldName];
//       text = (digits == null ? value.toString() : value.toStringAsFixed(digits))
//           .toPrintString();
//     } else if (value is Object) {
//       text = value.toPrintString();
//     }
//     return columnIndex == 0 ? text.padRight(width) : text.padLeft(width);
//   }
// }

// extension _ObjectValueExtension on Object {
//   String toPrintString([int? width]) =>
//       width == null ? toString() : toString().padLeft(width);
// }

// extension _IntValuesExtension on double {
//   //

//   int getFractionDigits() {
//     int integer = 0;
//     int exponent = 0;
//     if (floor() != this) {
//       do {
//         integer = (this * pow(10, exponent)).floor();
//         exponent++;
//       } while (integer == 0);
//     }
//     final e = this * pow(10, exponent);
//     return e.floor() == e
//         ? exponent
//         : e.floor() * 10 == e * 10
//             ? exponent + 1
//             : e.floor() * 100 == e * 100
//                 ? exponent + 2
//                 : exponent + 3;
//   }
// }

// extension _JsonExtension on Iterable<Map<String, dynamic>> {
// //

//   /// Returns the width of the [fieldName] field
//   int? fieldDigits(String fieldName) {
//     final digits = <int>[];
//     for (final result in this) {
//       final value = result[fieldName];
//       final d = value is double ? value.getFractionDigits() : null;
//       if (d != null) digits.add(d);
//     }
//     if (digits.isEmpty) return null;
//     digits.sort((a, b) => b.compareTo(a));
//     return digits.first;
//   }

//   /// Returns the width of the [fieldName] field
//   int fieldWidth(String fieldName, [int padding = 5]) {
//     final widths = [fieldName.length];
//     for (final result in this) {
//       final value = result[fieldName];
//       final text = value is double
//           ? value.toPrintString()
//           : value is Object
//               ? value.toPrintString()
//               : '';
//       widths.add(text.length);
//     }
//     widths.sort((a, b) => b.compareTo(a));
//     return widths.first + padding;
//   }
// }
