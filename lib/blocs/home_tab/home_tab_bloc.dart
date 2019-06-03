import 'dart:async';
import 'package:bloc/bloc.dart';
import './home_tab.dart';
import 'home_tabs.dart';

class HomeTabBloc extends Bloc<HomeTabEvent, HomeTabState> {
  @override
  HomeTabState get initialState => InitialHomeTabState();

  void tabSwitched(int val) {
    switch (val) {
      case 0:
        dispatch(TabChanged(HomeTabs.TimelineTab));
        break;
      case 1:
        dispatch(TabChanged(HomeTabs.PrizeTab));
        break;
      case 2:
        dispatch(TabChanged(HomeTabs.FriendsTab));
        break;
      case 3:
        dispatch(TabChanged(HomeTabs.MeTab));
        break;
    }
  }

  @override
  Stream<HomeTabState> mapEventToState(
    HomeTabEvent event,
  ) async* {
    if (event is TabChanged) {
      yield* _switchTab(event.tab);
    }
  }

  Stream<HomeTabState> _switchTab(HomeTabs tab) async* {
    if (tab == HomeTabs.TimelineTab) {
      yield TimelineTabState();
    } else if (tab == HomeTabs.FriendsTab) {
      yield FriendsTabState();
    } else if (tab == HomeTabs.PrizeTab) {
      yield PrizeTabState();
    } else if (tab == HomeTabs.MeTab) {
      yield MeTabState();
    }
  }
}
