import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app_flutter/api/dio_client.dart';
import 'package:todo_app_flutter/app_state.dart';
import 'package:todo_app_flutter/firebase_options.dart';
import 'package:todo_app_flutter/helpers/secure_storage.dart';
import 'package:todo_app_flutter/models/todo.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:todo_app_flutter/models/user.dart';
import 'package:todo_app_flutter/services/todoService.dart';
import 'package:todo_app_flutter/services/userService.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // DioClient.setUpInterceptor();
  // runApp(const ProviderScope(child: MyApp()));
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  FirebaseUIAuth.configureProviders([EmailAuthProvider()]);
  runApp(
    ChangeNotifierProvider(
      create: (context) => ApplicationState(),
      builder: (context, child) => const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme(
          brightness: Brightness.light,
          primary: Colors.black,
          onPrimary: Colors.white,
          secondary: Colors.black,
          onSecondary: Colors.white,
          surface: Colors.white,
          onSurface: Colors.black,
          error: Colors.red,
          onError: Colors.white,
        ),

        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme(
          brightness: Brightness.dark,
          primary: Colors.white,
          onPrimary: Colors.black,
          secondary: Colors.white,
          onSecondary: Colors.black,
          surface: Colors.black,
          onSurface: Colors.white,
          error: Colors.red,
          onError: Colors.black,
        ),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => MyLoginPage(),
        '/home': (context) => Consumer<ApplicationState>(
          builder: (context, appState, _) => MyHomePage(
            title: 'My home page',
            addTodo: (String message) => appState.addTodo(message),
            deleteTodo: (String todoId) => appState.deleteTodo(todoId),
            updateTodoStatus: (Todo todo) => appState.updateTodoStatus(todo),
            deleteAllTodos: () => appState.deleteAllTodos(),
            deleteFinishedTodos: () => appState.deleteFinishedTodos(),
            todos: appState.todos,
          ),
        ),
        '/forgot-password': (context) {
          final args =
              ModalRoute.of(context)?.settings.arguments
                  as Map<String, dynamic>;
          return ForgetPasswordPage(email: args['email']);
        },
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
    required this.title,
    required this.addTodo,
    required this.deleteTodo,
    required this.updateTodoStatus,
    required this.deleteAllTodos,
    required this.todos,
    required this.deleteFinishedTodos,
  });

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;
  final Future<DocumentReference> Function(String message) addTodo;
  final Future<void> Function(String todoId) deleteTodo;
  final Future<void> Function(Todo todo) updateTodoStatus;
  final Future<void> Function() deleteAllTodos;
  final Future<void> Function() deleteFinishedTodos;
  final List<Todo> todos;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final todoService = TodoService();
  final _inputController = TextEditingController();

  @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   fetchingTodos();
  // }
  void _onSubmit() {
    // var newTodo = await todoService.addTodo(_inputController.text);
    // setState(() {
    //   todos = [...todos, newTodo];
    // });
    // print(todos);
    widget.addTodo(_inputController.text);
  }

  void _onChangeTodoStatus(Todo todo) {
    // await todoService.updateTodoStatus(todos[index].id);
    // setState(() {
    //   todos[index].isFinished = !todos[index].isFinished;
    // });
    print(todo);
    widget.updateTodoStatus(todo);
  }

  void _onDeleteTodo(String todoId) async {
    // await todoService.deleteTodo(todos[index].id);
    // setState(() {
    //   var updatedTodos = todos.where((todo) => todo != todos[index]).toList();
    //   todos = updatedTodos;
    // });
    // print(todos);
    widget.deleteTodo(todoId);
  }

  void _deleteAll() async {
    // await todoService.deleteAllTodo();
    // setState(() {
    //   todos = [];
    // });
    widget.deleteAllTodos();
  }

  void _deleteFinished() async {
    // await todoService.deleteFinished();
    // setState(() {
    //   var updatedTodos = todos
    //       .where((todo) => todo.isFinished != true)
    //       .toList();
    //   todos = updatedTodos;
    // });
    // for (int i = 0; i < todos.length; i++) {
    //   print(todos[i].isFinished);
    // }
    widget.deleteFinishedTodos();
  }

  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.

    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.primary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(
          'Todos',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Theme.of(context).colorScheme.onPrimary,
            size: 30,
          ),
          onPressed: () async {
            await SecureStorage.removeToken();
            DioClient.setUpInterceptor();
            if (context.mounted) {
              Navigator.pop(context);
            }
          },
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            SizedBox(
              height: 50,
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: TextField(
                      controller: _inputController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'What do you want to put',
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    flex: 1,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        minimumSize: Size(0, 50),
                      ),

                      onPressed: _onSubmit,
                      child: Text(
                        'Submit',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: TodoList(
                todos: widget.todos,
                onDeleteTodo: _onDeleteTodo,
                onChangeTodoStatus: _onChangeTodoStatus,
              ),
            ),

            Center(
              child: BottomButton(
                deleteAll: _deleteAll,
                deleteFinished: _deleteFinished,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BottomButton extends StatelessWidget {
  final void Function() deleteAll;
  final void Function() deleteFinished;
  const BottomButton({
    super.key,
    required this.deleteAll,
    required this.deleteFinished,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
            ),
            onPressed: deleteAll,
            child: Text(
              'Delete All',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
            ),
            onPressed: deleteFinished,
            child: Text(
              'Delete Finished',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class TodoList extends StatelessWidget {
  final List<Todo> todos;
  final void Function(String todoId) onDeleteTodo;
  final void Function(Todo todo) onChangeTodoStatus;

  const TodoList({
    super.key,
    required this.todos,
    required this.onDeleteTodo,
    required this.onChangeTodoStatus,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: todos.length,
      itemBuilder: (context, index) {
        return ConstrainedBox(
          constraints: BoxConstraints(minHeight: 100),
          child: Card(
            elevation: 5,
            shadowColor: Theme.of(context).colorScheme.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Align(
                alignment: AlignmentGeometry.centerLeft,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(flex: 1, child: Text(todos[index].title)),

                    Expanded(
                      flex: 1,
                      child: Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(
                                  context,
                                ).colorScheme.primary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onPressed: () {
                                onChangeTodoStatus(todos[index]);
                              },
                              child: AutoSizeText(
                                todos[index].isFinished
                                    ? 'Unfinished'
                                    : 'Finished',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onPrimary,
                                ),
                                maxLines: 1,
                                minFontSize: 7,
                              ),
                            ),
                          ),

                          Container(width: 5),

                          Expanded(
                            flex: 1,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(
                                  context,
                                ).colorScheme.primary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onPressed: () {
                                onDeleteTodo(todos[index].id!);
                              },
                              child: AutoSizeText(
                                'Delete',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onPrimary,
                                ),
                                maxLines: 1,
                                minFontSize: 7,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class ForgetPasswordPage extends StatelessWidget {
  final String email;
  const ForgetPasswordPage({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    return ForgotPasswordScreen(email: email, headerMaxExtent: 200);
  }
}

class MyLoginPage extends StatefulWidget {
  const MyLoginPage({super.key});

  @override
  State<MyLoginPage> createState() => _MyLoginPageState();
}

class _MyLoginPageState extends State<MyLoginPage> {
  // final userService = UserService();
  // bool signupOrLogin = false;
  // final _userNameInputController = TextEditingController();
  // final _passwordInputController = TextEditingController();
  // final _signUpUserNameInputController = TextEditingController();
  // final _signUpPasswordInputController = TextEditingController();

  // Future<void> _login(BuildContext context) async {
  //   final newUser = User(
  //     username: _userNameInputController.text,
  //     password: _passwordInputController.text,
  //   );
  //   print(newUser);
  //   try {
  //     final token = await userService.login(newUser);
  //     if (token.isNotEmpty) {
  //       await SecureStorage.writeToken(token);
  //       DioClient.setUpInterceptor();
  //       if (context.mounted) {
  //         Navigator.pushNamed(context, '/home');
  //       }
  //     }
  //   } catch (e) {
  //     if (!context.mounted) return;
  //     ScaffoldMessenger.of(
  //       context,
  //     ).showSnackBar(SnackBar(content: Text(e.toString())));
  //   }
  // }

  // Future<void> _signUp(BuildContext context) async {
  //   final newUser = User(
  //     username: _signUpUserNameInputController.text,
  //     password: _signUpPasswordInputController.text,
  //   );
  //   try {
  //     final response = await userService.signUp(newUser);
  //     if (response == 'create successfully' && context.mounted) {
  //       setState(() {
  //         signupOrLogin = !signupOrLogin;
  //       });
  //     }
  //   } catch (e) {
  //     if (!context.mounted) return;
  //     ScaffoldMessenger.of(
  //       context,
  //     ).showSnackBar(SnackBar(content: Text(e.toString())));
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Center(
          child: Text(
            'Login',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: SignInScreen(
        actions: [
          ForgotPasswordAction((context, email) {
            Navigator.pushNamed(
              context,
              '/forgot-password',
              arguments: {'email': email},
            );
          }),
          AuthStateChangeAction((context, state) {
            final user = switch (state) {
              SignedIn state => state.user,
              UserCreated state => state.credential.user,
              _ => null,
            };
            if (user == null) {
              return;
            }
            if (state is UserCreated) {
              user.updateDisplayName(user.email!.split('@')[0]);
            }
            if (!user.emailVerified) {
              user.sendEmailVerification();
              const snackBar = SnackBar(
                content: Text(
                  'Please check your email to verify your email address',
                ),
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            }

            Navigator.pushNamed(context, '/home');
          }),
        ],
      ),
    );
  }
}

// class LoginForm extends StatelessWidget {
//   final void Function(BuildContext context) login;
//   final TextEditingController userNameInputController;
//   final TextEditingController passwordInputController;
//   LoginForm({
//     required this.login,
//     required this.userNameInputController,
//     required this.passwordInputController,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         TextField(
//           controller: userNameInputController,
//           decoration: InputDecoration(
//             border: OutlineInputBorder(),
//             labelText: 'Username',
//           ),
//         ),

//         SizedBox(height: 10),
//         TextField(
//           controller: passwordInputController,
//           decoration: InputDecoration(
//             border: OutlineInputBorder(),
//             labelText: 'Password',
//           ),
//           obscureText: true,
//         ),

//         SizedBox(height: 10),

//         Center(
//           child: SizedBox(
//             width: double.infinity,
//             child: ElevatedButton(
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Theme.of(context).colorScheme.primary,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//               ),
//               onPressed: () {
//                 login(context);
//               },
//               child: Text(
//                 'Login',
//                 style: TextStyle(
//                   color: Theme.of(context).colorScheme.onPrimary,
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }

// class SignUpForm extends StatelessWidget {
//   final Future<void> Function(BuildContext context) signUp;
//   final TextEditingController signUpUserNameInputController;
//   final TextEditingController signUpPasswordInputController;
//   const SignUpForm({
//     super.key,
//     required this.signUp,
//     required this.signUpUserNameInputController,
//     required this.signUpPasswordInputController,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         TextField(
//           controller: signUpUserNameInputController,
//           decoration: InputDecoration(
//             border: OutlineInputBorder(),
//             labelText: 'Username',
//           ),
//         ),

//         SizedBox(height: 10),
//         TextField(
//           controller: signUpPasswordInputController,
//           decoration: InputDecoration(
//             border: OutlineInputBorder(),
//             labelText: 'Password',
//           ),
//           obscureText: true,
//         ),

//         SizedBox(height: 10),

//         Center(
//           child: SizedBox(
//             width: double.infinity,
//             child: ElevatedButton(
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Theme.of(context).colorScheme.primary,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//               ),
//               onPressed: () {
//                 signUp(context);
//               },
//               child: Text(
//                 'Sign up',
//                 style: TextStyle(
//                   color: Theme.of(context).colorScheme.onPrimary,
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
