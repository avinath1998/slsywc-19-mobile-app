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

  void editMyProfilePic() {
    dispatch(EditMyProfilePicEvent());
  }

  MeBloc(this.dataRepository, this.currentUser);

  @override
  MeState get initialState => InitialMeState(currentUser);

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
        yield (SuccessSavingMyDetailsState(currentUser));
      } catch (e) {
        print("ERROR UPDATING CURRENT USER DETAILS: ${e.toString()}");
        yield (ErrorSavingMyDetailsState(event.newUser));
      }
    } else if (event is EditMyProfilePicEvent) {
      yield* initiateChoosePhoto();
    }
  }

  Stream<MeState> initiateChoosePhoto() async* {
    File image = await ImagePicker.pickImage(
        source: ImageSource.camera,
        imageQuality: 60,
        maxHeight: 960,
        maxWidth: 480);
    if (image != null) {
      try {
        dataRepository.wasProfilePicBeingSaved = true;
        yield (SavingMyDetailsState(currentUser, isImageSaving: true));

        String user = await dataRepository.uploadImage(currentUser, image);
        currentUser.profilePic = user;
        yield (SuccessSavingMyDetailsState(currentUser));
        dataRepository.wasProfilePicBeingSaved = false;
        print(user);
      } catch (e) {
        yield (ErrorSavingMyDetailsState(currentUser));
        dataRepository.wasProfilePicBeingSaved = false;

        print("ERROR UPDATING CURRENT USER DETAILS: ${e.toString()}");
      }
    } else {
      print("User has cancelled uploading image");
    }
  }
}
