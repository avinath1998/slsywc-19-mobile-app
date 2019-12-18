class Speaker {
  String id;
  String name;
  String desc;
  String image;
  Map<dynamic, dynamic> socialLinks;

  static Speaker fromMap(Map<String, dynamic> map, String id) {
    Speaker speaker = new Speaker();
    speaker.id = id;
    speaker.name = map['name'];
    speaker.desc = map['desc'];
    speaker.image = map['imageUrl'];
    speaker.socialLinks = map['socialLinks'];
    return speaker;
  }
}
