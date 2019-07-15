import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:slsywc19/blocs/auth/auth_bloc.dart';
import 'package:slsywc19/blocs/scan/scan_bloc.dart';
import 'package:slsywc19/blocs/scan/scan_state.dart';
import 'package:slsywc19/models/code.dart';
import 'package:slsywc19/models/user.dart';
import 'package:slsywc19/network/repository/ieee_data_repository.dart';

class ScanScreen extends StatefulWidget {
  String _code;
  CurrentUser _currentUser;

  ScanScreen(this._code, this._currentUser);

  @override
  _ScanScreenState createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  ScanBloc _scanBloc;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _scanBloc = new ScanBloc(IEEEDataRepository.get(), widget._currentUser);
    _scanBloc.submitCode(widget._code);
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return BlocProvider<ScanBloc>(
      builder: (context) => _scanBloc,
      child: Scaffold(
          appBar: AppBar(),
          body: BlocBuilder(
            bloc: _scanBloc,
            builder: (context, state) {
              print(state.toString());
              if (state is UpdatedDataState) {
                return Text("Updated ${state.code.toString()}");
              } else if (state is UpdatingDataState) {
                return CircularProgressIndicator();
              } else if (state is ErrorUpdatingDataState) {
                return Text("Error");
              } else if (state is InvalidScanState) {
                return Text("Invalid Scan");
              }
              return CircularProgressIndicator();
            },
          )),
    );
  }
}
