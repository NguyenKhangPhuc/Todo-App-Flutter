import 'package:todo_app_flutter/api/dio_client.dart';
import 'package:todo_app_flutter/models/todo.dart';

class TodoService {
  final _dio = DioClient.dio;

  Future<List<Todo>> fetchTodos() async {
    final response = await _dio.get('/todos');
    final List<dynamic> data = response.data;
    return data.map((json) => Todo.fromJson(json)).toList();
  }

  Future<Todo> addTodo(String text) async {
    var newTodo = Todo(title: text);
    print(newTodo);
    final response = await _dio.post('/todos', data: newTodo.toJson());
    print('This is data ${response.data}');
    return Todo.fromJson(response.data);
  }

  Future<void> updateTodoStatus(String? id) async {
    final response = await _dio.put('/todos/$id');
    print('This is data ${response.data}');
  }

  Future<void> deleteTodo(String? id) async {
    await _dio.delete('/todos/$id');
  }

  Future<void> deleteAllTodo() async {
    await _dio.delete('/todos');
  }

  Future<void> deleteFinished() async {
    await _dio.delete('/todos/delete-finished');
  }
}
