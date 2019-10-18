import 'dart:async';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:slsywc19/models/user.dart';
import 'package:slsywc19/network/repository/ieee_data_repository.dart';
import './me.dart';

class MeBloc extends Bloc<MeEvent, MeState> {
  final IEEEDataRepository dataRepository;
  CurrentUser currentUser;

  void viewMyDetails() {
    dispatch(ViewMyDetailsEvent());
  }

  void saveCurrentUser(CurrentUser newUser) {
    dispatch(SaveMyDetailsEvent(newUser));
  }

  void editMyDetails() {
    dispatch(EditMyDetailsEvent());
  }

  MeBloc(this.dataRepository, this.currentUser);

  @override
  MeState get initialState => InitialMeState();

  @override
  Stream<MeState> mapEventToState(
    MeEvent event,
  ) async* {
    if (event is ViewMyDetailsEvent) {
      yield (ViewMyDetailsState(currentUser));
    } else if (event is EditMyDetailsEvent) {
      yield (EditingMyDetailsState(currentUser));
    } else if (event is SaveMyDetailsEvent) {
      yield (SavingMyDetailsState(event.newUser));
      try {
        currentUser = await dataRepository.updateCurrentUser(event.newUser);
        print("NEWWW : ${currentUser.studentBranchName}");
        yield (SuccessSavingMyDetailsState(currentUser));
      } catch (e) {
        print("ERROR UPDATING CURRENT USER DETAILS: ${e.toString()}");
        yield (ErrorSavingMyDetailsState(event.newUser));
      }
    }
  }

  void iniateChoosePhoto() async {
    File image = await ImagePicker.pickImage(source: ImageSource.camera);
    try {} catch (e) {
      await dataRepository.uploadImage(image);
    }
  }
}
