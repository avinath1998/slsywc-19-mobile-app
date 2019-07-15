import 'package:meta/meta.dart';

@immutable
abstract class ScanEvent {}

class SubmitCodeScanEvent extends ScanEvent {
  final String barcode;

  SubmitCodeScanEvent(this.barcode);
}
