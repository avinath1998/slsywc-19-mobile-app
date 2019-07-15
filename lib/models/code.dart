abstract class Code {}

class FriendCode extends Code {
  final String userId;

  FriendCode(this.userId);
}

class PointsCode extends Code {
  final int pointsEarned;

  PointsCode(this.pointsEarned);
}
