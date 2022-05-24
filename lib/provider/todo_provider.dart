import 'package:flutter/foundation.dart';
import 'package:flutter_sqflite/db_helper/db_helper.dart';
import 'package:flutter_sqflite/model/todo_model.dart';
import 'package:uuid/uuid.dart';

class TodoProvider extends ChangeNotifier {
  List<TodoModel> todoItem = [];

  Future<void> selectData() async {
    final dataList = await DBHelper.selectAll(DBHelper.todo);

    todoItem = dataList
        .map(
          (item) => TodoModel(
            id: item['id'],
            title: item['title'],
            description: item['description'],
            date: item['date'],
          ),
        )
        .toList();
    notifyListeners();
  }

  Future insertData(
    String title,
    String description,
    String date,
  ) async {
    final newTodo = TodoModel(
      id: const Uuid().v1(),
      title: title,
      description: description,
      date: date,
    );
    todoItem.add(newTodo);

    DBHelper.insert(
      DBHelper.todo,
      {
        'id': newTodo.id,
        'title': newTodo.title,
        'description': newTodo.description,
        'date': newTodo.date,
      },
    );
    notifyListeners();
  }

  Future updateTitle(String id, String title) async {
    DBHelper.update(
      DBHelper.todo,
      'title',
      title,
      id,
    );
    notifyListeners();
  }

  Future updateDescription(String id, String description) async {
    DBHelper.update(
      DBHelper.todo,
      'description',
      description,
      id,
    );
    notifyListeners();
  }

  Future updateDate(String id, String date) async {
    DBHelper.update(
      DBHelper.todo,
      'date',
      date,
      id,
    );
    notifyListeners();
  }

  Future deleteById(id) async {
    DBHelper.deleteById(
      DBHelper.todo,
      'id',
      id,
    );
    notifyListeners();
  }

  Future deleteTable() async {
    DBHelper.deleteTable(DBHelper.todo);
    todoItem.clear();
    notifyListeners();
  }
}
