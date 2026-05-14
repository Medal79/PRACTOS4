class Author {
  final String id;
  final String username;
  final String email;

  Author({
    required this.id,
    required this.username,
    required this.email,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'email': email,
    };
  }

  factory Author.fromMap(Map<String, dynamic> map) {
    return Author(
      id: map['id'] as String,
      username: map['username'] as String,
      email: map['email'] as String,
    );
  }
}