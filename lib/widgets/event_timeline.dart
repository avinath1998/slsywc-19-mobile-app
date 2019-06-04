import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:slsywc19/blocs/auth/auth_bloc.dart';
import 'package:slsywc19/blocs/events/events_bloc.dart';
import 'package:slsywc19/blocs/events/events_state.dart';
import 'package:slsywc19/models/event.dart';
import 'package:slsywc19/models/sywc_colors.dart';
import 'package:slsywc19/network/repository/ieee_data_repository.dart';
import 'package:slsywc19/utils/double_holder.dart';
import 'package:timeline_list/timeline.dart';
import 'package:timeline_list/timeline_model.dart';
import 'package:cached_network_image/cached_network_image.dart';

class EventTimeline extends StatefulWidget {
  final int day;
  final DoubleHolder offset = new DoubleHolder();

  EventTimeline({Key key, @required this.day}) : super(key: key);

  @override
  _EventTimelineState createState() => _EventTimelineState();
}

class _EventTimelineState extends State<EventTimeline> {
  EventsBloc _eventsBloc;
  ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _eventsBloc = new EventsBloc(IEEEDataRepository.get(),
        BlocProvider.of<AuthBloc>(context).currentUser);
    _eventsBloc.fetchEvents(widget.day);
    _scrollController =
        new ScrollController(initialScrollOffset: widget.offset.value);
    _scrollController.addListener(() {
      widget.offset.value = _scrollController.offset;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _eventsBloc.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: BlocProvider(
        bloc: _eventsBloc,
        child: BlocBuilder(
          bloc: _eventsBloc,
          builder: (context, EventsState state) {
            if (state is SuccessFetchingEventsState) {
              return _buildTimeline(state.fetchedEvents);
            } else if (state is ErrorFetchingEventsState) {
              return Center(
                child: Text("An error has occured, try again later."),
              );
            } else if (state is LoadingFetchingEventsState) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildTimeline(List<Event> events) {
    List<TimelineModel> eventItems = new List();
    int x = 0;
    events.forEach((event) {
      x++;
      TimelineModel model = new TimelineModel(
        Card(
          color: x % 2 == 0 ? SYWCColors.PrimaryColor : Colors.white,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          child: Container(
              padding: const EdgeInsets.only(
                  top: 30.0, left: 30.0, right: 30.0, bottom: 20.0),
              child: Column(
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.only(bottom: 10.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                      child: CachedNetworkImage(
                        imageUrl: event.image,
                        placeholder: (context, url) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CircularProgressIndicator(),
                          );
                        },
                        errorWidget: (context, url, error) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(Icons.error),
                          );
                        },
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 3.0),
                        child: Text(
                          event.title,
                          textAlign: TextAlign.end,
                          style: TextStyle(
                              color: x % 2 == 0 ? Colors.white : Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Text(
                        "3:30pm - 4:00pm",
                        textAlign: TextAlign.end,
                        style: TextStyle(
                            color: x % 2 == 0 ? Colors.white : Colors.black,
                            fontWeight: FontWeight.normal),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Text(
                        event.location,
                        textAlign: TextAlign.end,
                        style: TextStyle(
                            color: x % 2 == 0 ? Colors.white : Colors.black,
                            fontWeight: FontWeight.normal),
                      ),
                    ],
                  ),
                ],
              )),
        ),
        iconBackground: SYWCColors.PrimaryColor,
      );
      eventItems.add(model);
    });
    return Scrollbar(
      child: Timeline(
        controller: _scrollController,
        children: eventItems,
        position: TimelinePosition.Left,
      ),
    );
  }
}