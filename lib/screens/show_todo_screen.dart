import 'package:flutter/material.dart';
import 'package:flutter_sqflite/model/todo_model.dart';
import 'package:flutter_sqflite/provider/todo_provider.dart';
import 'package:flutter_sqflite/screens/add_todo_screen.dart';
import 'package:flutter_sqflite/screens/edit_todo_screen.dart';
import 'package:provider/provider.dart';

class ShowTodoScreen extends StatelessWidget {
  const ShowTodoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery
        .of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final todoP = Provider.of<TodoProvider>(context, listen: false);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const AddTodoScreen()),
          );
        },
      ),
      appBar: AppBar(
        title: const Text('Todo'),
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                useSafeArea: true,
                context: context,
                builder: (context) => DeleteTableDialog(todoP: todoP),
              );
            },
            icon: const Icon(
              Icons.delete_forever_outlined,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: FutureBuilder(
        future: Provider.of<TodoProvider>(context, listen: false).selectData(),
        builder: (context, snapShot) {
          if (snapShot.connectionState == ConnectionState.done) {
            return Consumer<TodoProvider>(
              builder: (context, todoProvider, child) {
                return todoProvider.todoItem.isNotEmpty
                    ? ListView.builder(
                        itemCount: todoProvider.todoItem.length,
                        itemBuilder: (context, index) {
                          final helperValue = todoProvider.todoItem[index];
                          return Dismissible(
                            key: ValueKey(helperValue.id),
                            background: const DismissBackGround(
                              color: Colors.green,
                              alignment: Alignment.centerLeft,
                              iconData: Icons.edit_outlined,
                            ),
                            secondaryBackground: const DismissBackGround(
                              color: Colors.red,
                              alignment: Alignment.centerRight,
                              iconData: Icons.delete_forever_outlined,
                            ),
                            confirmDismiss: (DismissDirection direction) async {
                              if (direction == DismissDirection.startToEnd) {
                                return Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => EditTodoScreen(
                                      id: helperValue.id,
                                      title: helperValue.title,
                                      description: helperValue.description,
                                      date: helperValue.date,
                                    ),
                                  ),
                                );
                              } else {
                                showDialog(
                                  useSafeArea: true,
                                  context: context,
                                  builder: (context) =>
                                      DeleteDialog(helperValue: helperValue),
                                );
                              }
                            },
                            child: ListViewItemWidget(
                              helperValue: helperValue,
                            ),
                          );
                        },
                      )
                    : Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.indeterminate_check_box_outlined,
                              size: width * 0.2,
                            ),
                            const Text(
                              'List is empty',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 35,
                              ),
                            ),
                          ],
                        ),
                      );
              },
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}

class ListViewItemWidget extends StatelessWidget {
  const ListViewItemWidget({
    Key? key,
    required this.helperValue,
  }) : super(key: key);

  final TodoModel helperValue;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(width * 0.03),
      ),
      color: Colors.white,
      margin: EdgeInsets.symmetric(
        horizontal: width * 0.03,
        vertical: height * 0.01,
      ),
      elevation: 3,
      child: ListTile(
        style: ListTileStyle.drawer,
        title: Text(helperValue.title),
        subtitle: Text(
          helperValue.description,
          style: TextStyle(
            color: Colors.grey[600],
          ),
        ),
        trailing: Text(
          helperValue.date,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

class DismissBackGround extends StatelessWidget {
  final Color color;
  final Alignment alignment;
  final IconData iconData;

  const DismissBackGround({
    Key? key,
    required this.color,
    required this.alignment,
    required this.iconData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Container(
      margin: EdgeInsets.all(width * 0.02),
      padding: EdgeInsets.all(width * 0.03),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(width * 0.03),
      ),
      alignment: alignment,
      child: Icon(
        iconData,
        color: Colors.white,
      ),
      height: height * 0.02,
      width: width,
    );
  }
}

class DeleteDialog extends StatelessWidget {
  const DeleteDialog({
    Key? key,
    required this.helperValue,
  }) : super(key: key);

  final TodoModel helperValue;

  @override
  Widget build(BuildContext context) {
    final todoProvider = Provider.of<TodoProvider>(context, listen: false);
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return AlertDialog(
      scrollable: true,
      title: const Text('Delete'),
      content: const Text('Do you want to delete it?'),
      actions: [
        Row(
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(width * 0.02),
                child: ElevatedButton(
                  onPressed: () {
                    todoProvider.deleteById(helperValue.id);
                    todoProvider.todoItem.remove(helperValue);
                    Navigator.pop(context);
                  },
                  child: const Text('Yes'),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(width * 0.02),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(primary: Colors.white),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'No',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
}

class DeleteTableDialog extends StatelessWidget {
  const DeleteTableDialog({
    Key? key,
    required this.todoP,
  }) : super(key: key);

  final TodoProvider todoP;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return AlertDialog(
      scrollable: true,
      title: const Text('Delete All'),
      content: const Text('Do you want to delete all data?'),
      actions: [
        Row(
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(width * 0.02),
                child: ElevatedButton(
                  onPressed: () async {
                    await todoP.deleteTable();
                    Navigator.pop(context);
                  },
                  child: const Text('Yes'),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(width * 0.02),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(primary: Colors.white),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'No',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
