import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_material_you/blocs/tasks/tasks_bloc.dart';
import 'package:todo_material_you/home_page.dart';
import 'package:todo_material_you/repositories/task_repository.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'IRIS-To-Do-App',
      theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0XFFceef86),
              background: const Color(0XFF201a1a),
              brightness: Brightness.dark)),
      home: MultiBlocProvider(
        providers: [
          BlocProvider(
              create: (context) => TasksBloc(
                    TaskRepository(),
                  )..add(const LoadTask()))
        ],
        child: const MyHomePage(title: 'Your Tasks'),
      ),
    );
  }
}
