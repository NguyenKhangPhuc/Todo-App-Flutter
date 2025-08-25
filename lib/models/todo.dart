class Todo {
  String? id;
  String title = '';
  bool isFinished = false;
  String? userId;
  Todo({this.id, required this.title, this.isFinished = false, this.userId});

  Map<String, dynamic> toJson() {
    return {'title': title, 'isFinished': isFinished};
  }

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      id: json['_id'],
      title: json['title'],
      isFinished: json['isFinished'],
    );
  }
}
