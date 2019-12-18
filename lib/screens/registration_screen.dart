import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:slsywc19/blocs/auth/auth_bloc.dart';
import 'package:slsywc19/blocs/registration/registration.dart';
import 'package:slsywc19/blocs/registration/registration_bloc.dart';
import 'package:slsywc19/models/sywc_colors.dart';
import 'package:slsywc19/models/user.dart';
import 'package:slsywc19/network/repository/ieee_data_repository.dart';
import 'package:slsywc19/widgets/circular_btn.dart';

class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  RegistrationBloc _registrationBloc;
  GlobalKey<FormState> _formKey;
  TextEditingController _ieeeNumberController,
      _attendedController,
      _academicYearController,
      _phoneNumberController,
      _studentBranchController;

  @override
  void initState() {
    super.initState();
    _registrationBloc = RegistrationBloc(IEEEDataRepository.get());
    _formKey = GlobalKey();
    _ieeeNumberController = TextEditingController();
    _attendedController = TextEditingController();
    _academicYearController = TextEditingController();
    _phoneNumberController = TextEditingController();
    _studentBranchController = TextEditingController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _ieeeNumberController.dispose();
    _attendedController.dispose();
    _academicYearController.dispose();
    _phoneNumberController.dispose();
    _studentBranchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: 4.0, top: 4.0, bottom: 4.0),
          child: DecoratedBox(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  'assets/images/appbar_icon.png',
                ),
              ),
              // ...
            ),
          ),
        ),
        backgroundColor: Colors.white,
        title: Text(
          "Register",
          style: TextStyle(color: SYWCColors.PrimaryColor),
        ),
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text("Tell us some information about yourself.",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                              color: SYWCColors.PrimaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 26.0))),
                  SizedBox(
                    height: 10.0,
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 20.0),
                    padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        border: Border.all(
                            color: SYWCColors.PrimaryColor,
                            style: BorderStyle.solid,
                            width: 3.0)),
                    child: TextFormField(
                      controller: _ieeeNumberController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          labelText: 'IEEE Number (Optional)',
                          icon: Icon(Icons.person)),
                      validator: (value) {
                        return null;
                      },
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 20.0),
                    padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        border: Border.all(
                            color: SYWCColors.PrimaryColor,
                            style: BorderStyle.solid,
                            width: 3.0)),
                    child: TextFormField(
                      controller: _attendedController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        icon: Icon(Icons.confirmation_number),
                        border: InputBorder.none,
                        labelText: "# of SYWC's Attended",
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Enter the number of SWYC's attended";
                        }
                        return null;
                      },
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 20.0),
                    padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        border: Border.all(
                            color: SYWCColors.PrimaryColor,
                            style: BorderStyle.solid,
                            width: 3.0)),
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      controller: _academicYearController,
                      decoration: InputDecoration(
                        icon: Icon(Icons.school),
                        border: InputBorder.none,
                        labelText: 'University Academic Year',
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Enter your University Academic Year';
                        }
                        return null;
                      },
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 20.0),
                    padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        border: Border.all(
                            color: SYWCColors.PrimaryColor,
                            style: BorderStyle.solid,
                            width: 3.0)),
                    child: TextFormField(
                      keyboardType: TextInputType.phone,
                      controller: _phoneNumberController,
                      maxLength: 10,
                      decoration: InputDecoration(
                        icon: Icon(Icons.phone),
                        border: InputBorder.none,
                        labelText: 'Phone Number (076XXXXXXX)',
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Enter your Phone Number';
                        }
                        return null;
                      },
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 20.0),
                    padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        border: Border.all(
                            color: SYWCColors.PrimaryColor,
                            style: BorderStyle.solid,
                            width: 3.0)),
                    child: TextFormField(
                      controller: _studentBranchController,
                      decoration: InputDecoration(
                        icon: Icon(Icons.person),
                        border: InputBorder.none,
                        labelText: 'IEEE Student Branch Institution',
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Enter your IEEE Student Institution';
                        }
                        return null;
                      },
                    ),
                  ),
                  Container(
                      margin: const EdgeInsets.only(top: 20.0),
                      child: BlocBuilder(
                        bloc: _registrationBloc,
                        builder: (context, state) {
                          if (state is RegistrationSuccessfulState) {
                            BlocProvider.of<AuthBloc>(context).signIn();
                            return CircularProgressIndicator();
                          } else if (state is RegistrationErrorState) {
                            return Column(
                              children: <Widget>[
                                Text(
                                    "An error has occured registering you, try again."),
                                SizedBox(
                                  height: 3.0,
                                ),
                                RaisedButton(
                                  onPressed: () {},
                                  child: Container(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Text("Register",
                                        style: TextStyle(
                                          color: Colors.white,
                                        )),
                                  ),
                                  color: SYWCColors.PrimaryColor,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20.0))),
                                )
                              ],
                            );
                          } else if (state is RegistrationWaitingState) {
                            return CircularProgressIndicator();
                          } else {
                            return RaisedButton(
                              onPressed: () async {
                                if (_formKey.currentState.validate()) {
                                  CurrentUser signedInUser =
                                      await BlocProvider.of<AuthBloc>(context)
                                          .authService
                                          .getCurrentUser();
                                  if (signedInUser != null) {
                                    CurrentUser user = CurrentUser();
                                    user.id = signedInUser.id;
                                    user.ieeeMembershipNo =
                                        _ieeeNumberController.text;
                                    if (_ieeeNumberController.text == "") {
                                      user.ieeeMembershipNo = "";
                                    }
                                    user.currentConferenceCount =
                                        int.parse(_attendedController.text);
                                    user.currentAcademicYear =
                                        int.parse(_academicYearController.text);
                                    user.profilePic = signedInUser.profilePic;
                                    user.phoneNumber =
                                        _phoneNumberController.text;
                                    user.totalPoints = 0;
                                    user.displayName = signedInUser.displayName;
                                    user.email = signedInUser.email;
                                    user.studentBranchName =
                                        _studentBranchController.text;
                                    _registrationBloc.registerUser(user);
                                  } else {
                                    Fluttertoast.showToast(
                                        msg:
                                            "Registration has failed, try again later",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.BOTTOM,
                                        timeInSecForIos: 1,
                                        backgroundColor: Colors.red,
                                        textColor: Colors.white,
                                        fontSize: 16.0);
                                  }
                                }
                              },
                              child: Container(
                                padding: const EdgeInsets.all(10.0),
                                child: Text("Register",
                                    style: TextStyle(
                                      color: Colors.white,
                                    )),
                              ),
                              color: SYWCColors.PrimaryColor,
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20.0))),
                            );
                          }
                        },
                      ))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
