import 'dart:convert';

import 'package:slsywc19/exceptions/code_parsing_exception.dart';
import 'package:slsywc19/models/code.dart';

class QrUtils {
  static Code getQrData(String qrcode) {
    print("Retrieved for processing");
    try {
      final data = json.decode(qrcode);
      print("Processed json raw data");
      if (data != null && data.isNotEmpty) {
        if (data['app_name'] != null) {
          if (data['app_name'] == "IEEEHidden") {
            if (data["type"] != null && data["type"] == "PointsCode") {
              if (data['points_earned'] != null) {
                return new PointsCode(data["points_earned"]);
              } else {
                throw CodeParsingException(
                    "Invalid Code, points_earned not found");
              }
            } else if (data["type"] != null && data["type"] == "FriendsCode") {
              if (data['user_id'] != null) {
                return new FriendCode(data["user_id"]);
              } else {
                throw CodeParsingException("Invalid Code, user id not found");
              }
            } else {
              throw CodeParsingException(
                  "Invalid Code, data type not found or invalid");
            }
          } else {
            throw CodeParsingException("Invalid Code, app_name is invalid");
          }
        } else {
          throw CodeParsingException("Invalid Code, app_name not found");
        }
      }
    } catch (e) {
      throw CodeParsingException(e.toString());
    }
    return null;
  }
}
