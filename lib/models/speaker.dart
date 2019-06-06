class Speaker {
  String id;
  String name;
  String desc;
  String image;
  Map<String, dynamic> socialLinks;

  static Speaker fromMap(Map<String, dynamic> map, String id) {
    Speaker speaker = new Speaker();
    speaker.id = id;
    speaker.name = map['name'];
    speaker.desc = map['desc'];
    speaker.image = map['image'];
    speaker.socialLinks = map['socialLinks'];
    return speaker;
  }
}
