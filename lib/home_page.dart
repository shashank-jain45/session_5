import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_material_you/blocs/tasks/tasks_bloc.dart';
import 'package:todo_material_you/model/task.dart';
import 'package:todo_material_you/widgets/task.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late TextEditingController textInputTitleController;
  late TextEditingController textInputUserIdController;

  @override
  void initState() {
    super.initState();

    textInputTitleController = TextEditingController();
    textInputUserIdController = TextEditingController();
  }

  @override
  void dispose() {
    textInputTitleController.dispose();
    textInputUserIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int? lastId;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style:
              const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
        ),
      ),
      body: BlocBuilder<TasksBloc, TasksState>(
        builder: (context, state) {
          if (state is TasksLoaded) {
            return ListView.builder(
              itemCount: state.tasks.length,
              itemBuilder: (context, index) => GestureDetector(
                  onTap: () {
                    context.read<TasksBloc>().add(UpdateTask(
                        task: state.tasks[index].copyWith(
                            isComplete: !state.tasks[index].isComplete)));
                  },
                  child: TaskWidget(task: state.tasks[index])),
            );
          }
          if (state is TasksLoading) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return const Text("Error! No tasks Found");
          }
        },
      ),
      floatingActionButton: BlocListener<TasksBloc, TasksState>(
        listener: (context, state) {
          if (state is TasksLoaded) {
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Task was Added successfully")));
          }
        },
        child: FloatingActionButton(
          backgroundColor: const Color(0xFFf8bd47),
          foregroundColor: const Color(0xFF322a1d),
          onPressed: () async {
            await _openDialog(lastId ?? 0, context);
          },
          tooltip: 'Increment',
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  Future<Task?> _openDialog(int lastId, BuildContext blocContext) {
    textInputTitleController.text = '';
    textInputUserIdController.text = '';
    return showDialog<Task>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0XFFfeddaa),
        title: TextField(
          style: const TextStyle(color: Colors.black),
          controller: textInputTitleController,
          decoration: const InputDecoration(
              hintStyle: TextStyle(color: Colors.black),
              fillColor: Color(0XFF322a1d),
              hintText: 'Task Title',
              border: InputBorder.none),
        ),
        content: TextField(
            controller: textInputUserIdController,
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly
            ],
            decoration: const InputDecoration(
                hintText: 'User ID',
                border: InputBorder.none,
                fillColor: Color(0XFF322a1d),
                filled: true)),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.red),
              )),
          TextButton(
              onPressed: (() {
                if (textInputTitleController.text != '' &&
                    textInputUserIdController.text != '') {
                  blocContext.read<TasksBloc>().add(
                        AddTask(
                          task: Task(
                            id: 1,
                            title: textInputTitleController.text,
                            userId:
                                int.tryParse(textInputUserIdController.text) ??
                                    1,
                            isComplete: false,
                          ),
                        ),
                      );
                  Navigator.of(context).pop();
                }
              }),
              child:
                  const Text('Add', style: TextStyle(color: Color(0xFF322a1d))))
        ],
      ),
    );
  }
}
