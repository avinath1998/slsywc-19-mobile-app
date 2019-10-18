import 'package:meta/meta.dart';

@immutable
abstract class DropdownState {}

class InitialDropdownState extends DropdownState {
  final String currentVal;

  InitialDropdownState(this.currentVal);
}

class ChangedDropdownState extends DropdownState {
  final String currentVal;

  ChangedDropdownState(this.currentVal);
}
