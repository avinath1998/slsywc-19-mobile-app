import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:slsywc19/blocs/auth/auth_bloc.dart';
import 'package:slsywc19/blocs/timeline/timeline_bloc.dart';
import 'package:slsywc19/blocs/timeline/timeline_state.dart';
import 'package:slsywc19/models/event.dart';
import 'package:slsywc19/models/sywc_colors.dart';
import 'package:slsywc19/network/repository/ieee_data_repository.dart';
import 'package:slsywc19/utils/int_holder.dart';
import 'package:slsywc19/widgets/event_timeline.dart';
import 'package:timeline_list/timeline.dart';
import 'package:timeline_list/timeline_model.dart';
import 'package:slsywc19/widgets/circular_btn.dart';

class TimelineTab extends StatefulWidget {
  final IntHolder dayHolder = new IntHolder();

  @override
  _TimelineTabState createState() => _TimelineTabState();
}

class _TimelineTabState extends State<TimelineTab> {
  PageController _pageController;

  @override
  void initState() {
    super.initState();
    print("${BlocProvider.of<TimelineBloc>(context).currentPage}: PAGE");
    _pageController = new PageController(
        initialPage: BlocProvider.of<TimelineBloc>(context).currentPage);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: <Widget>[
        Container(
          child: PageView.builder(
            onPageChanged: (page) {
              BlocProvider.of<TimelineBloc>(context).currentPage = page;
              BlocProvider.of<TimelineBloc>(context).switchDay(page + 1);
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
                bloc: BlocProvider.of<TimelineBloc>(context),
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
            BlocProvider.of<TimelineBloc>(context).switchDay(1);
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
            BlocProvider.of<TimelineBloc>(context).switchDay(2);
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
            BlocProvider.of<TimelineBloc>(context).switchDay(3);
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
