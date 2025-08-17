class Todo {
  String? id;
  String title = '';
  bool isFinished = false;
  Todo({this.id, required this.title, this.isFinished = false});

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
