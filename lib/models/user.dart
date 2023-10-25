class CustomUser {
  final String email;
  final String username;
  final String uid;
  final String? imageUrl;
  final List<dynamic> notifications;

  CustomUser(
    this.email,
    this.username,
    this.uid,
    this.imageUrl,
    this.notifications,
  );
}
