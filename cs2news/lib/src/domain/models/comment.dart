class Comment {
  final String id;
  final String newsId;
  final String authorId;
  final String text;
  final DateTime createdAt;

  Comment({
    required this.id,
    required this.newsId,
    required this.authorId,
    required this.text,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'newsId': newsId,
      'authorId': authorId,
      'text': text,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Comment.fromMap(Map<String, dynamic> map) {
    return Comment(
      id: map['id'] as String,
      newsId: map['newsId'] as String,
      authorId: map['authorId'] as String,
      text: map['text'] as String,
      createdAt: DateTime.parse(map['createdAt'] as String),
    );
  }
}