class News {
  final String id;
  final String authorId;
  final String title;
  final String content;
  final int views;
  final DateTime publishedAt;

  News({
    required this.id,
    required this.authorId,
    required this.title,
    required this.content,
    required this.views,
    required this.publishedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'authorId': authorId,
      'title': title,
      'content': content,
      'views': views,
      'publishedAt': publishedAt.toIso8601String(),
    };
  }

  factory News.fromMap(Map<String, dynamic> map) {
    return News(
      id: map['id'] as String,
      authorId: map['authorId'] as String,
      title: map['title'] as String,
      content: map['content'] as String,
      views: map['views'] as int,
      publishedAt: DateTime.parse(map['publishedAt'] as String),
    );
  }
}