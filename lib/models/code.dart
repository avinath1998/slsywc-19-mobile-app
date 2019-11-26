import 'package:slsywc19/models/user.dart';

abstract class Code {}

class FriendCode extends Code {
  final String userId;
  FriendUser friend;

  FriendCode(this.userId);
}

class PointsCode extends Code {
  final int pointsEarned;

  PointsCode(this.pointsEarned);
}
