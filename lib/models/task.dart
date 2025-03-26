class Task {
  final String? id;
  final String title;
  final String date;
  final String task;
  final String learned;
  final String conclusion;

  Task({
    this.id,
    required this.title,
    required this.date,
    required this.task,
    required this.learned,
    required this.conclusion,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['_id'],
      title: json['title'],
      date: json['date'],
      task: json['task'],
      learned: json['learned'],
      conclusion: json['conclusion'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'date': date,
      'task': task,
      'learned': learned,
      'conclusion': conclusion,
    };
  }

  Task copyWith({
    String? id,
    String? title,
    String? date,
    String? task,
    String? learned,
    String? conclusion,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      date: date ?? this.date,
      task: task ?? this.task,
      learned: learned ?? this.learned,
      conclusion: conclusion ?? this.conclusion,
    );
  }
}