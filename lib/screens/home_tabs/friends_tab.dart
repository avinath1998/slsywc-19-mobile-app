import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:slsywc19/blocs/animating_list_notifier_bloc/animating_list_notifier_bloc.dart';
import 'package:slsywc19/blocs/animating_list_notifier_bloc/animating_list_notifier_event.dart';
import 'package:slsywc19/blocs/animating_list_notifier_bloc/animating_list_notifier_state.dart';
import 'package:slsywc19/blocs/auth/auth_bloc.dart';
import 'package:slsywc19/blocs/friends/friends_bloc.dart';
import 'package:slsywc19/blocs/friends/friends_state.dart';
import 'package:slsywc19/models/sywc_colors.dart';
import 'package:slsywc19/models/user.dart';
import 'package:slsywc19/network/repository/ieee_data_repository.dart';
import 'package:provider/provider.dart';
import 'package:slsywc19/widgets/circular_btn.dart';

class FriendsTab extends StatefulWidget {
  @override
  _FriendsTabState createState() => _FriendsTabState();
}

class _FriendsTabState extends State<FriendsTab> {
  FriendsBloc _friendsBloc;
  ScrollController _scrollController;
  AnimatingListNotifierBloc _animatingListNotifierBloc;

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
    _friendsBloc.dispose();
  }

  @override
  void initState() {
    super.initState();
    _friendsBloc = new FriendsBloc(IEEEDataRepository.get(),
        BlocProvider.of<AuthBloc>(context).currentUser);
    _scrollController = new ScrollController(
        initialScrollOffset: _friendsBloc.getCachedScrollPosition());
    _animatingListNotifierBloc = AnimatingListNotifierBloc(_scrollController);
    _animatingListNotifierBloc.initializeNotifier();
    _scrollController.addListener(() {
      _friendsBloc.cacheScrollPosition(_scrollController.offset);
    });
    _friendsBloc.openFriendsStream();
  }

  String qr =
      "{\"app_name\": \"SYWC19Apper\", \"type\": \"FriendsCode\",\"user_id\":  \"Tz43AH8xVb3nCU5HX9SS \"}";

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(
            builder: (context) => _friendsBloc,
          ),
          BlocProvider(
            builder: (context) => _animatingListNotifierBloc,
          )
        ],
        child: BlocBuilder(
          bloc: _friendsBloc,
          builder: (context, state) {
            print(state.toString());
            if (state is FetchedFriendsState) {
              return _createBody(state.friends);
            } else if (state is ErrorFetchingFriendsState) {
              return Center(
                  child: Text("An error has occured, try again later."));
            } else if (state is InitialFriendsState) {
              if (state.cachedFriends == null) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                return _createBody(state.cachedFriends);
              }
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ));
  }

  Widget _createBody(List<FriendUser> friends) {
    return Stack(
      alignment: Alignment.topCenter,
      children: <Widget>[
        CustomScrollView(
          controller: _scrollController,
          slivers: <Widget>[
            SliverPadding(
              padding: const EdgeInsets.only(top: 4.0, left: 10.0, right: 10.0),
              sliver: SliverAppBar(
                expandedHeight: 280.0,
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30.0))),
                flexibleSpace: FlexibleSpaceBar(
                  collapseMode: CollapseMode.parallax,
                  centerTitle: true,
                  background: Column(
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
                                      text: " Contact ID",
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
                      Align(
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              QrImage(
                                size: 150.0,
                                data:
                                    "{\"app_name\": \"SYWC19Apper\", \"type\": \"FriendsCode\",\"user_id\":  \" ${BlocProvider.of<AuthBloc>(context).currentUser.id} \"}",
                                gapless: true,
                                version: QrVersions.auto,
                              ),
                            ],
                          )),
                      _makeNoFriendsInfo(const EdgeInsets.only(top: 5.0)),
                    ],
                  ),
                ),
              ),
            ),
            friends.length > 0
                ? SliverGrid(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 7.0,
                        childAspectRatio: 2 / 3,
                        mainAxisSpacing: 7.0),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        FriendUser friend = friends[index];
                        return _makeLargeCard(friend);
                      },
                      childCount: friends.length,
                    ),
                  )
                : SliverFillRemaining(
                    child: Center(
                      child:
                          _makeNoFriendsInfo(const EdgeInsets.only(top: 30.0)),
                    ),
                  )
          ],
        ),
        BlocBuilder(
          bloc: _animatingListNotifierBloc,
          builder: (context, state) {
            print(state);
            return Container(
              height: 50.0,
              width: MediaQuery.of(context).size.width,
              child: AnimatedSwitcher(
                child: state is BelowTopOfListState
                    ? _makeQRButton()
                    : Container(),
                duration: const Duration(milliseconds: 200),
              ),
            );
          },
        )
      ],
    );
  }

  CircularButton _makeQRButton() {
    return CircularButton(
      color: Colors.red,
      isSelected: true,
      onPressed: () {
        _scrollController.animateTo(
          0.0,
          curve: Curves.easeOut,
          duration: const Duration(milliseconds: 300),
        );
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(
            Icons.arrow_upward,
            color: Colors.white,
            size: 20.0,
          ),
          SizedBox(
            width: 10.0,
          ),
          RichText(
            text: TextSpan(
              children: <TextSpan>[
                TextSpan(
                    text: "See your ",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.normal,
                        fontSize: 15.0)),
                TextSpan(
                    text: "Contact ID",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15.0)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _makeNoFriendsInfo(EdgeInsets padding) {
    return Container(
        padding: padding,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  RichText(
                    text: TextSpan(children: [
                      TextSpan(
                          text: 'Scan',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0,
                              color: Colors.black45)),
                      TextSpan(
                          text: ' someone\'s',
                          style: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: 16.0,
                              color: Colors.black45)),
                      TextSpan(
                          text: ' Contact ID',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0,
                              color: Colors.black45)),
                      TextSpan(
                          text: ' with ',
                          style: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: 16.0,
                              color: Colors.black45))
                    ]),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.black,
                    ),
                    padding: const EdgeInsets.all(5.0),
                    child: Icon(Icons.camera, color: Colors.white),
                  ),
                ],
              ),
              RichText(
                text: TextSpan(children: [
                  TextSpan(
                      text: 'to',
                      style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 16.0,
                          color: Colors.black45)),
                  TextSpan(
                      text: ' add them as a contact.',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                          color: Colors.black45))
                ]),
              )
            ],
          ),
        ));
  }

  Widget _makeAdditionalInfoInList(List<FriendUser> friends) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            friends.length > 0
                ? RichText(
                    text: TextSpan(children: [
                      TextSpan(
                          text: 'Swipe left',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15.0,
                              color: Colors.black45)),
                      TextSpan(
                          text: ' to delete a contact.',
                          style: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: 15.0,
                              color: Colors.black45))
                    ]),
                  )
                : Container(),
            SizedBox(
              height: 10.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  child: RichText(
                    text: TextSpan(children: [
                      TextSpan(
                          text: 'Add a',
                          style: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: 15.0,
                              color: Colors.black45)),
                      TextSpan(
                          text: ' contact ',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15.0,
                              color: Colors.black45)),
                      TextSpan(
                          text: 'by',
                          style: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: 15.0,
                              color: Colors.black45)),
                      TextSpan(
                          text: ' scanning ',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15.0,
                              color: Colors.black45)),
                      TextSpan(
                          text: 'with ',
                          style: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: 15.0,
                              color: Colors.black45)),
                    ]),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(5.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black,
                  ),
                  child: Icon(
                    Icons.camera,
                    color: Colors.white,
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Future<bool> _showDeletionDialog(FriendUser friend) async {
    // flutter defined function
    return await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: Text("Confirm Deletion"),
          content: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text('Are you sure you want to delete:'),
              Container(
                height: 20.0,
              ),
              Text(
                "${friend.displayName}? ",
                style: TextStyle(fontWeight: FontWeight.bold),
              )
            ],
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            FlatButton(
              child: Text(
                "Yes",
                style: TextStyle(color: Colors.black),
              ),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),

            FlatButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0))),
              color: SYWCColors.PrimaryColor,
              child: Text(
                "No",
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
          ],
        );
      },
    );
  }

  Widget _makeLargeCard(FriendUser friend) {
    return Card(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0))),
      child: Container(
        height: 300.0,
        foregroundDecoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
        ),
        child: Stack(
          alignment: Alignment.bottomLeft,
          children: <Widget>[
            CachedNetworkImage(
              imageBuilder: (context, provider) {
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                    image: DecorationImage(image: provider, fit: BoxFit.cover),
                  ),
                );
              },
              imageUrl: friend.photo,
              errorWidget: (context, url, error) {
                return Container(
                  padding: const EdgeInsets.all(50.0),
                  child: Center(child: Icon(Icons.error)),
                );
              },
              placeholder: (context, url) {
                return Container(
                  padding: const EdgeInsets.all(50.0),
                  child: Center(child: CircularProgressIndicator()),
                );
              },
            ),
            Container(
              width: MediaQuery.of(context).size.width / 2,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20.0),
                      bottomRight: Radius.circular(20.0)),
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black38,
                        Colors.black45,
                        Colors.black87,
                        Colors.black
                      ])),
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 3.0),
                    child: Text(
                      friend.displayName,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 17.0,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Text(friend.mobileNo,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 15.0,
                          fontWeight: FontWeight.normal)),
                  Text(friend.email,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 13.0,
                          fontWeight: FontWeight.normal)),
                ],
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: Container(
                decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.only(topRight: Radius.circular(10.0)),
                    color: Colors.red,
                    gradient: LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                        colors: [
                          Colors.black54,
                          Colors.black26,
                          Colors.transparent,
                          Colors.transparent
                        ])),
                child: GestureDetector(
                  onTap: () async {
                    if (await _showDeletionDialog(friend)) {
                      _friendsBloc.deleteFriend(friend);
                    }
                  },
                  child: Icon(
                    Icons.cancel,
                    color: Colors.white,
                    size: 30.0,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
