import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:slsywc19/blocs/auth/auth_bloc.dart';
import 'package:slsywc19/blocs/dropdown/dropdown_bloc.dart';
import 'package:slsywc19/blocs/dropdown/dropdown_event.dart';
import 'package:slsywc19/blocs/dropdown/dropdown_state.dart';
import 'package:slsywc19/blocs/me/me_bloc.dart';
import 'package:slsywc19/blocs/me/me_state.dart';
import 'package:slsywc19/models/sywc_colors.dart';
import 'package:slsywc19/models/user.dart';
import 'package:slsywc19/network/repository/ieee_data_repository.dart';
import 'package:slsywc19/widgets/circular_btn.dart';

class MeTab extends StatefulWidget {
  @override
  _MeTabState createState() => _MeTabState();
}

class _MeTabState extends State<MeTab> {
  MeBloc _meBloc;

  List<String> _branchNames = [
    'Informatics Institute of Technology IEEE',
    'SLIIT IEEE',
    'University of Peradeniya IEEE'
  ];
  GlobalKey<FormState> _formKey;
  GlobalKey _detailsAnimated;
  GlobalKey _infoAnimated;

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey();
    _infoAnimated = GlobalKey();
    _detailsAnimated = new GlobalKey();

    _meBloc = new MeBloc(IEEEDataRepository.get(),
        BlocProvider.of<AuthBloc>(context).currentUser);

    _meBloc.viewMyDetails();
  }

  Widget _buildInnerChild(MeState snapshot) {
    if (snapshot is ViewMyDetailsState) {
      return _buildViewDetails(snapshot.currentUser);
    } else if (snapshot is EditingMyDetailsState) {
      return _buildEditDetails(snapshot.currentUser, false);
    } else if (snapshot is SavingMyDetailsState) {
      return _buildEditDetails(snapshot.currentUser, true);
    } else if (snapshot is SuccessSavingMyDetailsState) {
      Fluttertoast.showToast(
          msg: "Successfully saved details.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 1,
          backgroundColor: SYWCColors.PrimaryColor,
          textColor: Colors.white,
          fontSize: 16.0);
      return _buildViewDetails(snapshot.currentUser);
    } else if (snapshot is ErrorSavingMyDetailsState) {
      Fluttertoast.showToast(
          msg: "Error saving details, try again.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      return _buildEditDetails(snapshot.currentUser, false);
    } else {
      return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      builder: (context) => _meBloc,
      child: BlocBuilder(
          bloc: _meBloc,
          builder: (context, MeState snapshot) {
            return _buildInnerChild(snapshot);
          }),
    );
  }

  Widget _buildYourInformationSection(bool isSaving) {
    return Align(
      alignment: Alignment.center,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          CircularButton(
            color: Colors.red,
            isSelected: false,
            onPressed: () {},
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                RichText(
                  text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                          text: "Your",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.normal,
                              fontSize: 20.0)),
                      TextSpan(
                          text: " Information",
                          style: TextStyle(
                              color: SYWCColors.PrimaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEditDetails(
    CurrentUser user,
    bool isSaving,
  ) {
    return SingleChildScrollView(
      child: Container(
        margin: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              color: Colors.white,
              child: Container(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        AnimatedSwitcher(
                          key: _detailsAnimated,
                          duration: Duration(
                            milliseconds: 500,
                          ),
                          child: Stack(
                            children: <Widget>[
                              CachedNetworkImage(
                                imageUrl: user.profilePic,
                                imageBuilder: (context, provider) {
                                  return Container(
                                    height: 175.0,
                                    width: 125.0,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20.0)),
                                        image: DecorationImage(
                                            image: provider,
                                            fit: BoxFit.cover)),
                                  );
                                },
                              ),
                              Container(
                                height: 175.0,
                                width: 125.0,
                                child: Align(
                                    alignment: Alignment.bottomCenter,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: GestureDetector(
                                        onTap: (){
                                          _meBloc.iniateChoosePhoto();
                                        },
                                                                              child: Text(
                                          "CHANGE",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    )),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        Colors.transparent,
                                        Colors.transparent,
                                        Colors.black26,
                                        Colors.black45
                                      ]),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20.0)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Container(
                      width: 150.0,
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          AutoSizeText(
                            user.displayName,
                            textAlign: TextAlign.end,
                            style: TextStyle(
                              color: SYWCColors.PrimaryColor,
                              fontWeight: FontWeight.w700,
                              fontSize: 23.0,
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Container(
                              margin:
                                  const EdgeInsets.only(top: 5, bottom: 5.0),
                              height: 2.0,
                              width: 30.0,
                              color: SYWCColors.PrimaryColor,
                            ),
                          ),
                          AutoSizeText(
                            user.studentBranchName,
                            textAlign: TextAlign.end,
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                              fontSize: 15.0,
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            _buildYourInformationSection(isSaving),
            AnimatedSwitcher(
              key: _infoAnimated,
              duration: Duration(milliseconds: 200),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  !isSaving
                      ? FlatButton(
                          child: Text(
                            "Cancel",
                            style: TextStyle(color: SYWCColors.PrimaryColor),
                          ),
                          onPressed: () {
                            _meBloc.viewMyDetails();
                          },
                        )
                      : Container(),
                  !isSaving
                      ? FlatButton(
                          child: Text(
                            "Save",
                            style: TextStyle(color: SYWCColors.PrimaryColor),
                          ),
                          onPressed: () {
                            if (_formKey.currentState.validate()) {
                              _formKey.currentState.save();
                              _meBloc.saveCurrentUser(user);
                            }
                          },
                        )
                      : Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: CircularProgressIndicator(),
                        ),
                ],
              ),
            ),
            Form(
              key: _formKey,
              child: Container(
                padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    _makeEditCard(
                        "E-mail",
                        Container(
                          child: TextFormField(
                            initialValue: user.email,
                            validator: (val) {
                              return !val.contains("@") && val.length == 0
                                  ? "Enter a valid email"
                                  : null;
                            },
                            onSaved: (val) {
                              user.email = val;
                            },
                          ),
                        )),
                    _makeEditCard(
                        "Phone Number (eg. 011 111 1111)",
                        Container(
                          child: TextFormField(
                            initialValue: user.phoneNumber,
                            maxLength: 10,
                            validator: (val) {
                              return val.length == 10
                                  ? null
                                  : "Enter a valid phone number";
                            },
                            onSaved: (val) {
                              user.phoneNumber = val;
                            },
                          ),
                        )),
                    _makeInformationCard(
                        "Student Branch Name", user.studentBranchName,
                        isGrayedOut: true),
                    _makeInformationCard(
                        "IEEE Membership Number", user.ieeeMembershipNo,
                        isGrayedOut: true),
                    _makeInformationCard(
                        "Current Academic Year", "${user.currentAcademicYear}",
                        isGrayedOut: true),
                    _makeInformationCard("Previous Conference Count",
                        "${user.currentConferenceCount}",
                        isGrayedOut: true)
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildViewDetails(CurrentUser user) {
    return SingleChildScrollView(
      child: Container(
        margin: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              color: Colors.white,
              child: Container(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    AnimatedSwitcher(
                      key: _detailsAnimated,
                      duration: Duration(milliseconds: 500),
                      child: CachedNetworkImage(
                        imageUrl: user.profilePic,
                        imageBuilder: (context, provider) {
                          return Container(
                            height: 175.0,
                            width: 125.0,
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20.0)),
                                image: DecorationImage(
                                    image: provider, fit: BoxFit.cover)),
                          );
                        },
                      ),
                    ),
                    Container(
                      width: 150.0,
                      alignment: Alignment.center,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          AutoSizeText(
                            user.displayName,
                            textAlign: TextAlign.end,
                            style: TextStyle(
                              color: SYWCColors.PrimaryColor,
                              fontWeight: FontWeight.w700,
                              fontSize: 23.0,
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Container(
                              margin:
                                  const EdgeInsets.only(top: 5, bottom: 5.0),
                              height: 2.0,
                              width: 30.0,
                              color: SYWCColors.PrimaryColor,
                            ),
                          ),
                          AutoSizeText(
                            user.studentBranchName,
                            textAlign: TextAlign.end,
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                              fontSize: 15.0,
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            _buildYourInformationSection(false),
            AnimatedSwitcher(
              key: _infoAnimated,
              duration: Duration(milliseconds: 200),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Align(
                    alignment: Alignment.center,
                    child: FlatButton(
                      child: Text(
                        "Edit",
                        style: TextStyle(color: SYWCColors.PrimaryColor),
                      ),
                      onPressed: () {
                        _meBloc.editMyDetails();
                      },
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  _makeInformationCard("E-mail", "${user.email}"),
                  _makeInformationCard("Phone Number", "${user.phoneNumber}"),
                  _makeInformationCard(
                      "Student Branch Name", user.studentBranchName),
                  _makeInformationCard(
                      "IEEE Membership Number", user.ieeeMembershipNo),
                  _makeInformationCard(
                      "Current Academic Year", "${user.currentAcademicYear}"),
                  _makeInformationCard("Previous Conference Count",
                      "${user.currentConferenceCount}")
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _makeEditCard(String detailTitle, Widget child) {
    return Container(
      margin: const EdgeInsets.only(top: 10.0, bottom: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            detailTitle,
            textAlign: TextAlign.start,
            style: TextStyle(
                color: Colors.grey[400],
                fontWeight: FontWeight.normal,
                fontSize: 14.0),
          ),
          SizedBox(
            height: 7.0,
          ),
          child
        ],
      ),
    );
  }

  Widget _makeInformationCard(String detailTitle, String detail,
      {bool isGrayedOut}) {
    return Container(
      margin: const EdgeInsets.only(top: 10.0, bottom: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            detailTitle,
            textAlign: TextAlign.start,
            style: TextStyle(
                color: Colors.grey[400],
                fontWeight: FontWeight.normal,
                fontSize: 14.0),
          ),
          SizedBox(
            height: 7.0,
          ),
          Text(
            detail,
            textAlign: TextAlign.center,
            style: TextStyle(
                color: isGrayedOut == null
                    ? Colors.black
                    : isGrayedOut ? Colors.grey[400] : Colors.black,
                fontWeight: FontWeight.w500,
                fontSize: 15.0),
          )
        ],
      ),
    );
  }
}
