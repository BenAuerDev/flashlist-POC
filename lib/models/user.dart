class CustomUser {
  CustomUser(
    this.email,
    this.username,
    this.uid,
    this.imageUrl,
    this.notifications,
  );

  final String email;
  final String username;
  final String uid;
  final String? imageUrl;
  final List<dynamic> notifications;

  @override
  String toString() => username;
}
