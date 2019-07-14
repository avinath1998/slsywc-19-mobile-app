import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:slsywc19/blocs/auth/auth_bloc.dart';
import 'package:slsywc19/blocs/points/points_bloc.dart';
import 'package:slsywc19/blocs/points/points_state.dart';
import 'package:slsywc19/blocs/prizes/prizes_bloc.dart';
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

  @override
  void initState() {
    super.initState();
    _prizesBloc = new PrizesBloc(BlocProvider.of<AuthBloc>(context).currentUser,
        IEEEDataRepository.get());
    _pointsBloc = new PointsBloc(BlocProvider.of<AuthBloc>(context).currentUser,
        IEEEDataRepository.get());
    _pointsBloc.fetchPoints();
    _prizesBloc.fetchPrizes();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      builder: (context) => _prizesBloc,
      child: RefreshIndicator(
        onRefresh: _refreshPrizes,
        child: BlocBuilder(
            bloc: _prizesBloc,
            builder: (context, PrizesState state) {
              if (state is FetchedPrizesState) {
                return makeBody(state.prizes);
              } else if (state is ErrorPrizesState) {
                return Center(
                  child: Text("An error has occured, try again later."),
                );
              } else if (state is WaitingPrizesState) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state is InitialPrizesState) {
                if (state.cachedPrizes.length != 0) {
                  return makeBody(state.cachedPrizes);
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
            }),
      ),
    );
  }

  Future<void> _refreshPrizes() async {
    print("Refreshing prizes");
    _prizesBloc.fetchPrizes();
    _pointsBloc.fetchPoints();
  }

  Widget makeBody(List<Prize> prizes) {
    return CustomScrollView(
      slivers: <Widget>[
        SliverPadding(
          padding: const EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
          sliver: SliverAppBar(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30.0))),
              snap: true,
              floating: true,
              backgroundColor: Colors.white,
              title: Container(
                  padding: const EdgeInsets.all(0.0),
                  child: BlocBuilder(
                      bloc: _pointsBloc,
                      builder: (context, state) {
                        if (state is FetchedPointsState) {
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
                                        text: '-',
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
                              child: Text(
                                  "An error has occured, try again later"));
                        } else if (state is InitialPointsState) {
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
                        } else {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      }))),
        ),
        SliverPadding(
          padding: const EdgeInsets.only(top: 10.0),
          sliver: SliverGrid(
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 200.0,
                mainAxisSpacing: 10.0,
                crossAxisSpacing: 10.0,
                childAspectRatio: 3 / 5),
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return PrizeChip(
                  prize: prizes[index],
                );
              },
              childCount: prizes.length,
            ),
          ),
        )
      ],
    );
  }
}
