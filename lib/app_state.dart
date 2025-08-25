import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'
    hide EmailAuthProvider, PhoneAuthProvider;
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo_app_flutter/models/todo.dart';

class ApplicationState extends ChangeNotifier {
  ApplicationState() {
    init();
  }

  bool _isLoggedIn = false;
  bool get isLoggedIn => _isLoggedIn;
  StreamSubscription<QuerySnapshot>? _todosSubScription;
  List<Todo> _todos = [];
  List<Todo> get todos => _todos;
  Future<void> init() async {
    FirebaseUIAuth.configureProviders([EmailAuthProvider()]);

    FirebaseAuth.instance.userChanges().listen((user) {
      if (user != null) {
        _isLoggedIn = true;
        _todosSubScription = FirebaseFirestore.instance
            .collection('todos')
            .snapshots()
            .listen((snapshot) {
              _todos = [];
              for (final document in snapshot.docs) {
                print(document);
                _todos.add(
                  Todo(
                    id: document.id,
                    title: document.data()['title'],
                    isFinished: document.data()['isFinished'],
                    userId: document.data()['userId'],
                  ),
                );
                print(todos);
              }
              notifyListeners();
            });
      } else {
        _isLoggedIn = false;
        _todos = [];
        _todosSubScription?.cancel();
      }
      notifyListeners();
    });
  }

  Future<DocumentReference> addTodo(String message) {
    if (!_isLoggedIn) {
      throw Exception('Please logged in');
    }
    return FirebaseFirestore.instance.collection('todos').add(<String, dynamic>{
      'title': message,
      'isFinished': false,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      'userId': FirebaseAuth.instance.currentUser!.uid,
    });
  }

  Future<void> deleteTodo(String todoId) {
    if (!_isLoggedIn) {
      throw Exception('Please logged in');
    }
    return FirebaseFirestore.instance.collection('todos').doc(todoId).delete();
  }

  Future<void> updateTodoStatus(Todo todo) {
    if (!_isLoggedIn) {
      throw Exception('Please logged in');
    }
    return FirebaseFirestore.instance.collection('todos').doc(todo.id).update({
      'isFinished': !todo.isFinished,
    });
  }

  Future<void> deleteAllTodos() async {
    if (!_isLoggedIn) {
      throw Exception('Please logged in');
    }
    final collection = FirebaseFirestore.instance.collection('todos');
    final snapshot = await collection.get();

    final batch = FirebaseFirestore.instance.batch();
    for (final doc in snapshot.docs) {
      batch.delete(doc.reference);
    }

    await batch.commit();
  }

  Future<void> deleteFinishedTodos() async {
    if (!_isLoggedIn) {
      throw Exception('Please logged in');
    }
    final collection = FirebaseFirestore.instance
        .collection('todos')
        .where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .where('isFinished', isEqualTo: true);
    final snapshot = await collection.get();
    final batch = FirebaseFirestore.instance.batch();
    for (final doc in snapshot.docs) {
      batch.delete(doc.reference);
    }

    await batch.commit();
  }
}
