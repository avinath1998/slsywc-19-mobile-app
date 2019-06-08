class Prize {
  String id;
  String title;
  String image;
  int value;
}

class UserPrize extends Prize {
  bool isRedeemed;

  static fromMap(Map<String, dynamic> map, String id) {
    UserPrize prize = new UserPrize();
    prize.id = id;
    prize.title = map['title'];
    prize.image = map['image'];
    prize.value = map['value'];
    prize.isRedeemed = map['isRedeemed'];
    return prize;
  }
}
