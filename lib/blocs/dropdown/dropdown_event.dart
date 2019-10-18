import 'package:meta/meta.dart';

@immutable
abstract class DropdownEvent {}

class OnChangeEvent extends DropdownEvent {
  final String changedVal;

  OnChangeEvent(this.changedVal);
}
