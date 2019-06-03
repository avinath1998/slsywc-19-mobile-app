import 'package:slsywc19/blocs/home_tab/home_tabs.dart';
import 'package:meta/meta.dart';

@immutable
abstract class HomeTabEvent {}

class TabChanged extends HomeTabEvent {
  final HomeTabs tab;

  TabChanged(this.tab);
}
