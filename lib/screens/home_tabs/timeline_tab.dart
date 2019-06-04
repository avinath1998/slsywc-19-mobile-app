import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:slsywc19/blocs/auth/auth_bloc.dart';
import 'package:slsywc19/blocs/timeline/timeline_bloc.dart';
import 'package:slsywc19/blocs/timeline/timeline_state.dart';
import 'package:slsywc19/models/event.dart';
import 'package:slsywc19/models/sywc_colors.dart';
import 'package:slsywc19/network/repository/ieee_data_repository.dart';
import 'package:slsywc19/widgets/event_timeline.dart';
import 'package:timeline_list/timeline.dart';
import 'package:timeline_list/timeline_model.dart';
import 'package:slsywc19/widgets/circular_btn.dart';

class TimelineTab extends StatefulWidget {
  @override
  _TimelineTabState createState() => _TimelineTabState();
}

class _TimelineTabState extends State<TimelineTab> {
  TimelineBloc _timelineBloc;
  PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = new PageController(initialPage: 0);
    _timelineBloc = new TimelineBloc(IEEEDataRepository.get(),
        BlocProvider.of<AuthBloc>(context).currentUser);
    _timelineBloc.switchDay(1);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: <Widget>[
        Container(
          child: PageView.builder(
            onPageChanged: (page) {
              _timelineBloc.switchDay(page + 1);
            },
            controller: _pageController,
            itemBuilder: (context, int index) {
              return EventTimeline(
                day: index + 1,
              );
            },
            itemCount: 3,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 8.0),
          child: Container(
            child: Card(
              elevation: 5.0,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30.0))),
              child: BlocBuilder(
                bloc: _timelineBloc,
                builder: (context, TimelineState state) {
                  if (state is DayOneTimelineState) {
                    return _buildTopChips(1);
                  } else if (state is DayTwoTimelineState) {
                    return _buildTopChips(2);
                  } else if (state is DayThreeTimelineState) {
                    return _buildTopChips(3);
                  } else {
                    return _buildTopChips(1);
                  }
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTopChips(int day) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        CircularButton(
          onPressed: () {
            _timelineBloc.switchDay(1);
            _pageController.animateToPage(0,
                duration: Duration(milliseconds: 300), curve: Curves.ease);
          },
          isSelected: day == 1,
          child: Text(
            "Day 1",
            style: TextStyle(color: day == 1 ? Colors.white : Colors.black),
          ),
        ),
        CircularButton(
          onPressed: () {
            _timelineBloc.switchDay(2);
            _pageController.animateToPage(1,
                duration: Duration(milliseconds: 300), curve: Curves.ease);
          },
          isSelected: day == 2,
          child: Text(
            "Day 2",
            style: TextStyle(color: day == 2 ? Colors.white : Colors.black),
          ),
        ),
        CircularButton(
          onPressed: () {
            _timelineBloc.switchDay(3);
            _pageController.animateToPage(2,
                duration: Duration(milliseconds: 300), curve: Curves.ease);
          },
          isSelected: day == 3,
          child: Text(
            "Day 3",
            style: TextStyle(color: day == 3 ? Colors.white : Colors.black),
          ),
        )
      ],
    );
  }
}

// Expanded(
//                 child: Timeline(
//                     children: eventItems, position: TimelinePosition.Center))

// TimelineModel model = new TimelineModel(
//           Card(
//             color: SYWCColors.PrimaryColor,
//             child: Container(
//                 padding: const EdgeInsets.all(30.0),
//                 child: Text(
//                   event.title,
//                   style: TextStyle(color: Colors.white),
//                 )),
//           ),
//         );
