import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:slsywc19/blocs/auth/auth_bloc.dart';
import 'package:slsywc19/blocs/timeline/timeline_bloc.dart';
import 'package:slsywc19/blocs/timeline/timeline_state.dart';
import 'package:slsywc19/models/event.dart';
import 'package:slsywc19/models/sywc_colors.dart';
import 'package:slsywc19/network/repository/ieee_data_repository.dart';
import 'package:timeline_list/timeline.dart';
import 'package:timeline_list/timeline_model.dart';
import 'package:slsywc19/widgets/circular_btn.dart';

class TimelineTab extends StatefulWidget {
  @override
  _TimelineTabState createState() => _TimelineTabState();
}

class _TimelineTabState extends State<TimelineTab> {
  TimelineBloc _timelineBloc;

  @override
  void initState() {
    super.initState();
    _timelineBloc = new TimelineBloc(IEEEDataRepository.get(),
        BlocProvider.of<AuthBloc>(context).currentUser);
    _timelineBloc.switchDay(1);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      bloc: _timelineBloc,
      builder: (BuildContext context, TimelineState state) {
        if (state is DayOneTimelineState) {
          return _buildTimeline(events: state.events, day: 1);
        } else if (state is DayTwoTimelineState) {
          return _buildTimeline(events: state.events, day: 2);
        } else if (state is DayThreeTimelineState) {
          return _buildTimeline(events: state.events, day: 3);
        } else if (state is EventLoadingErrorState) {
          return Center(
              child: Text(
                  "An error has occured getting the timeline, try again later."));
        } else if (state is EventLoadingState) {
          return Center(child: CircularProgressIndicator());
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget _buildTimeline({List<Event> events, int day}) {
    List<TimelineModel> eventItems = new List();

    if (events != null) {
      events.forEach((event) {
        TimelineModel model = new TimelineModel(
          Card(
            color: SYWCColors.PrimaryColor,
            child: Container(
                padding: const EdgeInsets.all(30.0),
                child: Text(
                  event.title,
                  style: TextStyle(color: Colors.white),
                )),
          ),
        );
        eventItems.add(model);
      });
    }

    return Column(
      children: <Widget>[
        Container(
          child: Container(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                CircularButton(
                  onPressed: () {
                    _timelineBloc.switchDay(day);
                  },
                  isSelected: day == 1,
                  child: Text(
                    "Day 1",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                CircularButton(
                  onPressed: () {
                    _timelineBloc.switchDay(day);
                  },
                  isSelected: day == 2,
                  child: Text(
                    "Day 2",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                CircularButton(
                  onPressed: () {
                    _timelineBloc.switchDay(day);
                  },
                  isSelected: day == 3,
                  child: Text(
                    "Day 3",
                    style: TextStyle(color: Colors.black),
                  ),
                )
              ],
            ),
          ),
        ),
        events != null
            ? Expanded(
                child: Timeline(
                    children: eventItems, position: TimelinePosition.Center))
            : Container()
      ],
    );
  }
}
