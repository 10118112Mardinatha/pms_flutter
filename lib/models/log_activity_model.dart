class LogActivity {
  final int id;
  final int userId;
  final String username;
  final String activity;
  final DateTime timestamp;

  LogActivity({
    required this.id,
    required this.userId,
    required this.username,
    required this.activity,
    required this.timestamp,
  });

  factory LogActivity.fromJson(Map<String, dynamic> json) => LogActivity(
        id: json['id'],
        userId: json['userId'], // penting: ini harus ada di response
        username: json['username'],
        activity: json['activity'],
        timestamp: DateTime.parse(json['timestamp']),
      );
}
