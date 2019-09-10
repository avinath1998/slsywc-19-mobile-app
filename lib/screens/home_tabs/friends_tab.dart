import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:slsywc19/blocs/auth/auth_bloc.dart';
import 'package:slsywc19/blocs/friends/friends_bloc.dart';
import 'package:slsywc19/blocs/friends/friends_state.dart';
import 'package:slsywc19/models/sywc_colors.dart';
import 'package:slsywc19/models/user.dart';
import 'package:slsywc19/network/repository/ieee_data_repository.dart';
import 'package:provider/provider.dart';

class FriendsTab extends StatefulWidget {
  @override
  _FriendsTabState createState() => _FriendsTabState();
}

class _FriendsTabState extends State<FriendsTab> {
  FriendsBloc _friendsBloc;

  @override
  void initState() {
    super.initState();
    _friendsBloc = new FriendsBloc(IEEEDataRepository.get(),
        BlocProvider.of<AuthBloc>(context).currentUser);
    if (IEEEDataRepository.get().cachedFriends == null) {
      _friendsBloc.fetchFriends();
    }
  }

  @override
  Widget build(BuildContext context) {
    String qr =
        "{\"app_name\": \"SYWC19Apper\", \"type\": \"FriendsCode\",\"user_id\":  \"Tz43AH8xVb3nCU5HX9SS \"}";
    return _buildFriendsBody();
  }

  Widget _buildFriendsBody() {
    return RefreshIndicator(
      onRefresh: () async {
        _friendsBloc.fetchFriends();
      },
      child: BlocProvider(
          builder: (context) => _friendsBloc,
          child: BlocBuilder(
            bloc: _friendsBloc,
            builder: (context, state) {
              print(state.toString());
              if (state is OpenedFriendsState) {
                return _createStreamingBody(state.friendsStream);
              } else if (state is FetchedFriendsState) {
                return _createBody(state.friends);
              } else if (state is WaitingFetchingFriendsState) {
                return Center(
                  child: CircularProgressIndicator(),
                );
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
          )),
    );
  }

  Widget _createBody(List<FriendUser> friends) {
    return CustomScrollView(
      slivers: <Widget>[
        SliverPadding(
          padding: const EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
          sliver: SliverAppBar(
              snap: true,
              floating: true,
              expandedHeight: 100.0,
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30.0))),
              title: Center(
                  child: Container(
                      child: Text("QR Code here",
                          style: TextStyle(color: Colors.black))))),
        ),
        friends.length > 0
            ? SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  if (index == friends.length) {
                    return _makeAdditionalInfoInList(friends);
                  } else {
                    FriendUser friend = friends[index];
                    return _makeCard(friend);
                  }
                }, childCount: friends.length),
              )
            : SliverFillRemaining(
                child: Center(
                  child: _makeNoFriendsInfo(),
                ),
              )
      ],
    );
  }

  Widget _makeNoFriendsInfo() {
    return Container(
        padding: const EdgeInsets.only(top: 30.0),
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
          title: Text("Confirm deletion?"),
          content:
              Text('Are you sure you want to delete ${friend.displayName}? '),
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

  Widget _makeCard(FriendUser friend) {
    return Dismissible(
      confirmDismiss: (direction) async {
        bool x = await _showDeletionDialog(friend);
        return x;
      },
      background: Container(
          decoration: BoxDecoration(),
          child: Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                Icons.delete,
                size: 30.0,
              ),
            ),
          )),
      key: Key(friend.id),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        print("Dismissed");
        _friendsBloc.deleteFriend(friend);
      },
      child: Card(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Flexible(
                flex: 3,
                child: Container(
                  child: Center(
                    child: SizedBox(
                      height: 80.0,
                      width: 80.0,
                      child: CachedNetworkImage(
                        imageBuilder: (context, provider) {
                          return Container(
                            width: 80.0,
                            height: 80.0,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image: provider,
                              ),
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
                    ),
                  ),
                ),
              ),
              Flexible(
                flex: 4,
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 3.0),
                        child: Text(
                          friend.displayName,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 17.0,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Text(friend.mobileNo,
                          style: TextStyle(
                              color: Colors.black87,
                              fontSize: 15.0,
                              fontWeight: FontWeight.normal)),
                      Text(friend.email,
                          style: TextStyle(
                              color: Colors.black54,
                              fontSize: 13.0,
                              fontWeight: FontWeight.normal)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _createStreamingBody(Stream<List<FriendUser>> friendsStream) {
    return StreamBuilder<List<FriendUser>>(
      stream: friendsStream,
      builder: (BuildContext context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          return ListView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (context, index) {
              return _makeCard(snapshot.data[index]);
            },
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}

class Lister extends StatefulWidget {
  @override
  _ListerState createState() => _ListerState();
}

class _ListerState extends State<Lister> {
  @override
  Widget build(BuildContext context) {
    var users = Provider.of<List<FriendUser>>(context);
    print(users);
    return ListView.builder(
      itemCount: 9,
      itemBuilder: (context, index) {
        return Text("we");
      },
    );
  }
}