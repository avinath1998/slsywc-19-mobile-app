import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

class Prize {
  Prize(
      {@required this.id,
      @required this.title,
      @required this.image,
      @required this.value,
      @required this.isRedeemed});

  String id;
  String title;
  String image;
  int value;
  bool isRedeemed;
}

class UserPrize extends Prize {
  UserPrize(
      {@required id,
      @required title,
      @required image,
      @required value,
      @required isRedeemed})
      : super(
            id: id,
            title: title,
            image: image,
            value: value,
            isRedeemed: isRedeemed);

  factory UserPrize.fromMap(Map<String, dynamic> map, String id) {
    UserPrize prize = new UserPrize(
        id: id,
        title: map['title'],
        image: map['image'],
        value: map['value'],
        isRedeemed: map['isRedeemed']);
    return prize;
  }

  @override
  bool operator ==(Object other) {
    if (other is UserPrize) {
      if (other.id == this.id) {
        if (other.image == this.image) {
          if (other.isRedeemed == this.isRedeemed) {
            if (other.title == this.title) {
              if (other.value == this.value) {
                return true;
              }
            }
          }
        }
      }
    }
    return false;
  }
}
