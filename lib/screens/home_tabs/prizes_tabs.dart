import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:slsywc19/blocs/auth/auth_bloc.dart';
import 'package:slsywc19/blocs/prizes/prizes_bloc.dart';
import 'package:slsywc19/blocs/prizes/prizes_state.dart';
import 'package:slsywc19/models/prize.dart';
import 'package:slsywc19/network/repository/ieee_data_repository.dart';
import 'package:slsywc19/widgets/prize_chip.dart';

class PrizesTab extends StatefulWidget {
  @override
  _PrizesTabState createState() => _PrizesTabState();
}

class _PrizesTabState extends State<PrizesTab> {
  PrizesBloc _prizesBloc;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _prizesBloc = new PrizesBloc(BlocProvider.of<AuthBloc>(context).currentUser,
        IEEEDataRepository.get());
    _prizesBloc.openPrizesStream();
  }

  @override
  void dispose() {
    super.dispose();
    _prizesBloc.closePrizesStream();
    _prizesBloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      bloc: _prizesBloc,
      child: BlocBuilder(
        bloc: _prizesBloc,
        builder: (context, PrizesState state) {
          print(state);
          if (state is OpenedPrizesStreamState) {
            return StreamBuilder(
              stream: state.stream,
              builder: (context, AsyncSnapshot<List<Prize>> prizes) {
                if (prizes.connectionState == ConnectionState.waiting) {
                  print("Waiting for Prizes");
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (prizes.connectionState == ConnectionState.none) {
                  print("Error getting prizes");
                  return Center(
                    child: Text("An error has occured, try again later"),
                  );
                } else if (prizes.connectionState == ConnectionState.active) {
                  print("Prizes Length: ${prizes.data.length}");
                  if (prizes.data != null) {
                    return GridView.builder(
                      itemCount: prizes.data.length,
                      itemBuilder: (context, int index) {
                        return Container(
                            margin: const EdgeInsets.all(5.0),
                            child: PrizeChip(prize: prizes.data[index]));
                      },
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3),
                    );
                  } else {
                    return Text("An error has occured, try again later.");
                  }
                }
              },
            );
          } else if (state is ClosedPrizesStreamState) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is ErrorPrizesStreamState) {
            return Center(
              child: Text("An error has occured, try again later"),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
