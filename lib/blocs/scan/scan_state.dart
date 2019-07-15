import 'package:meta/meta.dart';
import 'package:slsywc19/models/code.dart';

@immutable
abstract class ScanState {}

class InitialScanState extends ScanState {}

class InvalidScanState extends ScanState {}

class UpdatingDataState extends ScanState {}

class UpdatedDataState extends ScanState {
  final Code code;

  UpdatedDataState(this.code);
}

class ErrorUpdatingDataState extends ScanState {}
