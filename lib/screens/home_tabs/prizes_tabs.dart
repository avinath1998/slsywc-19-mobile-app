import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:slsywc19/blocs/auth/auth_bloc.dart';
import 'package:slsywc19/blocs/points/points_bloc.dart';
import 'package:slsywc19/blocs/points/points_state.dart';
import 'package:slsywc19/blocs/prizes/prizes_bloc.dart';
import 'package:slsywc19/blocs/prizes/prizes_event.dart';
import 'package:slsywc19/blocs/prizes/prizes_state.dart';
import 'package:slsywc19/models/prize.dart';
import 'package:slsywc19/models/sywc_colors.dart';
import 'package:slsywc19/network/repository/ieee_data_repository.dart';
import 'package:slsywc19/widgets/circular_btn.dart';
import 'package:slsywc19/widgets/prize_chip.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

class PrizesTab extends StatefulWidget {
  @override
  _PrizesTabState createState() => _PrizesTabState();
}

class _PrizesTabState extends State<PrizesTab> {
  PrizesBloc _prizesBloc;
  PointsBloc _pointsBloc;
  ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _prizesBloc = new PrizesBloc(BlocProvider.of<AuthBloc>(context).currentUser,
        IEEEDataRepository.get());
    _pointsBloc = new PointsBloc(BlocProvider.of<AuthBloc>(context).currentUser,
        IEEEDataRepository.get());
    _pointsBloc.fetchPoints();
    _scrollController = new ScrollController(
        initialScrollOffset: _prizesBloc.getPrizesListScrollPosition());
    _scrollController.addListener(() {
      _prizesBloc.cachePrizesListScrollPosition(_scrollController.offset);
    });
    // if (IEEEDataRepository.get().cachedPrizes == null) {
    //   _prizesBloc.fetchPrizes();
    // }
    _prizesBloc.openPrizesStream();
    _pointsBloc.openPointsStream();
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return makeBody();
  }

  Widget makeBody() {
    return Container(
        child: MultiBlocProvider(
            providers: [
          BlocProvider(
            builder: (context) => _pointsBloc,
          ),
          BlocProvider(
            builder: (context) => _prizesBloc,
          )
        ],
            child: BlocBuilder(
                bloc: _pointsBloc,
                builder: (context, state) {
                  if (state is FetchedPointsState) {
                    BlocProvider.of<AuthBloc>(context).currentUser.totalPoints =
                        state.points;
                    return makePrizesBlocBuilder(state.points);
                  } else if (state is WaitingFetchingPointsState) {
                    return Center(
                        child: Container(
                      child: CircularButton(
                        onPressed: () {},
                        isSelected: false,
                        child: RichText(
                          text: TextSpan(
                            children: <TextSpan>[
                              TextSpan(
                                  text: 'Your Points: ',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.normal,
                                      fontSize: 20.0)),
                              TextSpan(
                                  text: '${state.points}',
                                  style: TextStyle(
                                      color: SYWCColors.PrimaryColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20.0)),
                            ],
                          ),
                        ),
                      ),
                    ));
                  } else if (state is PointsErrorState) {
                    return Center(
                        child: Text("An error has occured, try again later"));
                  } else if (state is InitialPointsState) {
                    return makePrizesBlocBuilder(state.points);
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                })));
  }

  BlocBuilder<PrizesEvent, PrizesState> makePrizesBlocBuilder(int points) {
    return BlocBuilder(
        bloc: _prizesBloc,
        builder: (context, PrizesState state) {
          print("CURRENT STATE : ${state.toString()}");
          if (state is FetchedPrizesState) {
            return CustomScrollView(
              controller: _scrollController,
              slivers: <Widget>[
                SliverAppBar(
                  title: makePointsHeader(points),
                  snap: true,
                  backgroundColor: Colors.white,
                  floating: true,
                ),
                SliverGrid(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 10,
                      childAspectRatio: 2 / 4),
                  delegate: SliverChildBuilderDelegate((context, index) {
                    return PrizeChip(
                      prize: state.prizes[index],
                    );
                  }, childCount: state.prizes.length),
                )
              ],
            );
          } else if (state is ErrorPrizesState) {
            return Center(
              child: Text("An error has occured, try again later."),
            );
          } else if (state is WaitingPrizesState) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is InitialPrizesState) {
            if (state.cachedPrizes != null) {
              return CustomScrollView(
                controller: _scrollController,
                slivers: <Widget>[
                  SliverAppBar(
                    title: makePointsHeader(points),
                    snap: true,
                    backgroundColor: Colors.white,
                    floating: true,
                  ),
                  SliverGrid(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 10,
                        childAspectRatio: 2 / 4),
                    delegate: SliverChildBuilderDelegate((context, index) {
                      return PrizeChip(
                        prize: state.cachedPrizes[index],
                      );
                    }, childCount: state.cachedPrizes.length),
                  )
                ],
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }

  Widget makePrizesList(List<Prize> prizes, BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) {
        return PrizeChip(
          prize: prizes[index],
        );
      },
      itemCount: prizes.length,
    );
  }

  Widget makePointsHeader(int points) {
    return Center(
        child: Container(
      child: CircularButton(
        onPressed: () {},
        isSelected: false,
        child: RichText(
          text: TextSpan(
            children: <TextSpan>[
              TextSpan(
                  text: 'Your Points: ',
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.normal,
                      fontSize: 20.0)),
              TextSpan(
                  text: '${points}',
                  style: TextStyle(
                      color: SYWCColors.PrimaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0)),
            ],
          ),
        ),
      ),
    ));
  }
}
