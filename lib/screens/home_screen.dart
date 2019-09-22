import 'package:barcode_scan/barcode_scan.dart';
import 'package:bubble_bottom_bar/bubble_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:slsywc19/blocs/auth/auth_bloc.dart';
import 'package:slsywc19/blocs/home_tab/home_tab.dart';
import 'package:slsywc19/blocs/timeline/timeline_bloc.dart';
import 'package:slsywc19/models/code.dart';
import 'package:slsywc19/models/sywc_colors.dart';
import 'package:slsywc19/models/user.dart';
import 'package:slsywc19/network/repository/ieee_data_repository.dart';
import 'package:slsywc19/screens/scan_screen.dart';
import 'package:slsywc19/utils/qr_utils.dart';

import 'home_tabs/friends_tab.dart';
import 'home_tabs/me_tab.dart';
import 'home_tabs/prizes_tabs.dart';
import 'home_tabs/timeline_tab.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  List<Widget> _bodyWidgets;
  HomeTabBloc _homeTabBloc;
  TabController _tabController;
  TimelineBloc _timelineBloc;
  String barcode;

  @override
  void initState() {
    super.initState();
    _bodyWidgets = new List();
    _homeTabBloc = new HomeTabBloc();
    _tabController = new TabController(initialIndex: 0, length: 4, vsync: this);
    _homeTabBloc.tabSwitched(0);
    _timelineBloc = new TimelineBloc(IEEEDataRepository.get(),
        BlocProvider.of<AuthBloc>(context).currentUser);
  }

  @override
  void dispose() {
    super.dispose();
    _homeTabBloc.dispose();
    _timelineBloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return MultiBlocProvider(
      providers: [
        BlocProvider<HomeTabBloc>(
          builder: (context) => _homeTabBloc,
        ),
        BlocProvider<TimelineBloc>(
          builder: (context) => _timelineBloc,
        ),
      ],
      child: Scaffold(
        appBar: _buildCustomAppBar(screenSize),
        body: _buildBody(screenSize),
        bottomNavigationBar: _buildBubbleBottomNavBar(),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            scan(BlocProvider.of<AuthBloc>(context).currentUser);
          },
          child: Icon(
            Icons.camera,
            color: Colors.white,
          ),
          backgroundColor: SYWCColors.PrimaryAccentColor,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      ),
    );
  }

  Future scan(CurrentUser userId) async {
    try {
      String barcode = await BarcodeScanner.scan();
      print(barcode);
      if (barcode.isNotEmpty) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ScanScreen(barcode, userId)),
        );
      } else {
        print("Barcode is empty");
      }
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        print("User has declined the camera permission");
        showDialogAlert("Accept the camera permission to scan.");
      } else {
        print("An unknown error has occured opening scanner");
        showDialogAlert("An error has occured, try again later.");
      }
    } on FormatException catch (e) {
      print("User has returned without scanning: ${e.toString()}");
    } catch (e) {
      print("An unknown error has occured opening scanner");
      showDialogAlert("An error has occured, try again later.");
    }
  }

  void showDialogAlert(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: Text("Something went wrong :("),
          content: Text(message),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            FlatButton(
              child: Text(
                "Close",
                style: TextStyle(color: SYWCColors.PrimaryColor),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildBody(Size screenSize) {
    return BlocBuilder(
      bloc: _homeTabBloc,
      builder: (BuildContext context, HomeTabState state) {
        if (state is TimelineTabState) {
          return TimelineTab();
        } else if (state is FriendsTabState) {
          return FriendsTab();
        } else if (state is MeTabState) {
          return MeTab();
        } else if (state is PrizeTabState) {
          return PrizesTab();
        } else {}

        return Text(state.toString());
      },
    );
  }

  Widget _buildCustomAppBar(Size screenSize) {
    return PreferredSize(
        preferredSize: Size(screenSize.width, 60),
        child: BlocBuilder(
          bloc: _homeTabBloc,
          builder: (BuildContext context, HomeTabState state) {
            if (state is TimelineTabState) {
              return AppBar(
                leading: Padding(
                  padding:
                      const EdgeInsets.only(left: 4.0, top: 4.0, bottom: 4.0),
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
                  "Timeline",
                  style: TextStyle(color: SYWCColors.PrimaryColor),
                ),
              );
            } else if (state is FriendsTabState) {
              return AppBar(
                leading: Padding(
                  padding:
                      const EdgeInsets.only(left: 4.0, top: 4.0, bottom: 4.0),
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
                  "Friends",
                  style: TextStyle(color: SYWCColors.PrimaryColor),
                ),
              );
            } else if (state is MeTabState) {
              return AppBar(
                leading: Padding(
                  padding:
                      const EdgeInsets.only(left: 4.0, top: 4.0, bottom: 4.0),
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
                  "Me",
                  style: TextStyle(color: SYWCColors.PrimaryColor),
                ),
              );
            } else if (state is PrizeTabState) {
              return AppBar(
                leading: Padding(
                  padding:
                      const EdgeInsets.only(left: 4.0, top: 4.0, bottom: 4.0),
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
                  "Prizes",
                  style: TextStyle(color: SYWCColors.PrimaryColor),
                ),
              );
            } else {
              return AppBar(
                leading: Padding(
                  padding:
                      const EdgeInsets.only(left: 4.0, top: 4.0, bottom: 4.0),
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
                  "SYWC",
                  style: TextStyle(color: SYWCColors.PrimaryColor),
                ),
              );
            }
          },
        ));
  }

  Widget _buildBubbleBottomNavBar() {
    return BlocBuilder(
        bloc: _homeTabBloc,
        builder: (context, state) {
          int currentIndex = 0;
          if (state is TimelineTabState) {
            currentIndex = 0;
          } else if (state is PrizeTabState) {
            currentIndex = 1;
          } else if (state is FriendsTabState) {
            currentIndex = 2;
          } else if (state is MeTabState) {
            currentIndex = 3;
          }
          return BubbleBottomBar(
            opacity: .2,
            currentIndex: currentIndex,
            onTap: (val) {
              print(val);
              _homeTabBloc.tabSwitched(val);
            },
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            elevation: 8,
            fabLocation: BubbleBottomBarFabLocation.end, //new
            hasNotch: true, //new
            hasInk: true, //new, gives a cute ink effect
            inkColor:
                Colors.black12, //optional, uses theme color if not specified
            items: <BubbleBottomBarItem>[
              BubbleBottomBarItem(
                  backgroundColor: SYWCColors.PrimaryColor,
                  icon: Icon(
                    Icons.access_time,
                    color: Colors.black,
                  ),
                  activeIcon: Icon(
                    Icons.access_time,
                    color: SYWCColors.PrimaryColor,
                  ),
                  title: Text("Timeline")),
              BubbleBottomBarItem(
                  backgroundColor: SYWCColors.PrimaryAccentColor,
                  icon: Icon(
                    Icons.card_giftcard,
                    color: Colors.black,
                  ),
                  activeIcon: Icon(
                    Icons.card_giftcard,
                    color: SYWCColors.PrimaryColor,
                  ),
                  title: Text("Prizes")),
              BubbleBottomBarItem(
                  backgroundColor: SYWCColors.PrimaryColor,
                  icon: Icon(
                    Icons.group,
                    color: Colors.black,
                  ),
                  activeIcon: Icon(
                    Icons.group,
                    color: SYWCColors.PrimaryColor,
                  ),
                  title: Text("Friends")),
              BubbleBottomBarItem(
                  backgroundColor: SYWCColors.PrimaryAccentColor,
                  icon: Icon(
                    Icons.person,
                    color: Colors.black,
                  ),
                  activeIcon: Icon(
                    Icons.person,
                    color: SYWCColors.PrimaryColor,
                  ),
                  title: Text("Me"))
            ],
          );
        });
  }

  Widget _buildBottomNavigationBar() {
    return Material(
        color: Colors.white,
        elevation: 2.0,
        child: TabBar(
          onTap: (val) {
            _homeTabBloc.tabSwitched(val);
          },
          unselectedLabelColor: Colors.grey,
          labelColor: SYWCColors.PrimaryColor,
          controller: _tabController,
          tabs: <Widget>[
            Tab(
              icon: Icon(Icons.access_time),
            ),
            Tab(
              icon: Icon(Icons.card_giftcard),
            ),
            Tab(
              icon: Icon(Icons.group),
            ),
            Tab(
              icon: Icon(Icons.account_circle),
            )
          ],
        ));
  }
}
