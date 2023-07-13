class InstagramNotification {
  final String name;
  final String profilePic;
  final String content;
  final String postImage;
  final String timeAgo;

  InstagramNotification(
      this.name, this.profilePic, this.content, this.postImage, this.timeAgo);

  factory InstagramNotification.fromJson(Map<String, dynamic> json) {
    return new InstagramNotification(json['name'], json['profilePic'],
        json['content'], json['postImage'], json['timeAgo']);
  }
}
