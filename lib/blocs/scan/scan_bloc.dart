import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:slsywc19/models/code.dart';
import 'package:slsywc19/models/user.dart';
import 'package:slsywc19/network/repository/ieee_data_repository.dart';
import 'package:slsywc19/utils/qr_utils.dart';
import './scan.dart';
import 'package:slsywc19/exceptions/data_fetch_exception.dart';
import 'package:slsywc19/exceptions/code_parsing_exception.dart';

class ScanBloc extends Bloc<ScanEvent, ScanState> {
  IEEEDataRepository dataRepository;
  CurrentUser user;

  ScanBloc(this.dataRepository, this.user);

  @override
  ScanState get initialState => InitialScanState();

  @override
  Stream<ScanState> mapEventToState(
    ScanEvent event,
  ) async* {
    if (event is SubmitCodeScanEvent) {
      yield* _submitCode(event.barcode);
    }
  }

  void submitCode(String code) {
    dispatch(SubmitCodeScanEvent(code));
  }

  Stream<ScanState> _submitCode(String qrcode) async* {
    print("Submitting code for processing: ${qrcode}");
    try {
      Code code = QrUtils.getQrData(qrcode);
      print("Code has been retrieved: ${code.toString()}");
      if (code != null) {
        if (code is FriendCode) {
          print("Updating a Friends Code");
          yield UpdatingDataState();
          try {
            FriendUser newFriend =
                await dataRepository.addFriend(user.id, code.userId);
            code.friend = newFriend;
            print("Successfully updated users friends");

            yield UpdatedDataState(code);
          } on DataFetchException catch (e) {
            print("Error updating user friends: " + e.msg);
            yield ErrorUpdatingDataState();
          }
        } else if (code is PointsCode) {
          print("Updating a points Code");
          yield UpdatingDataState();
          try {
            await dataRepository.updatePoints(code.pointsEarned, user.id);
            print("Successfully updated users poitns");
            yield UpdatedDataState(code);
          } on DataFetchException catch (e) {
            print("Error updating user points");
            yield ErrorUpdatingDataState();
          }
        }
      } else {
        print("Code is null, cannot be processed");
        yield ErrorUpdatingDataState();
      }
    } on CodeParsingException catch (e) {
      print("Error parsing json code: ${e.msg}");
      yield InvalidScanState();
    }
  }
}
