class Complaint {
  final String id;
  final String newsId;
  final String reporterName;
  final String reason;
  final DateTime createdAt;

  Complaint({
    required this.id,
    required this.newsId,
    required this.reporterName,
    required this.reason,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'newsId': newsId,
      'reporterName': reporterName,
      'reason': reason,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Complaint.fromMap(Map<String, dynamic> map) {
    return Complaint(
      id: map['id'] as String,
      newsId: map['newsId'] as String,
      reporterName: map['reporterName'] as String,
      reason: map['reason'] as String,
      createdAt: DateTime.parse(map['createdAt'] as String),
    );
  }
}