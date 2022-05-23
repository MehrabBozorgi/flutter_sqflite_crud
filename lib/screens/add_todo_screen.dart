import 'package:flutter/material.dart';
import 'package:flutter_sqflite/provider/todo_provider.dart';
import 'package:provider/provider.dart';

class AddTodoScreen extends StatefulWidget {
  const AddTodoScreen({Key? key}) : super(key: key);

  @override
  State<AddTodoScreen> createState() => _AddTodoScreenState();
}

class _AddTodoScreenState extends State<AddTodoScreen> {
  final _key = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final todoProvider = Provider.of<TodoProvider>(context, listen: false);
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text('Add Todo'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _key,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(width * 0.04),
                child: TextFormField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    hintText: 'Title',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(width * 0.03),
                      borderSide: const BorderSide(color: Colors.black,width: 1),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(width * 0.03),
                      borderSide: BorderSide(color: Theme.of(context).primaryColor,width: 2),
                    ),
                    prefixIcon: const Icon(
                      Icons.edit_outlined,
                      color: Colors.black,
                    ),
                  ),
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.name,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Description is Title';
                    }
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.all(width * 0.04),
                child: TextFormField(
                  controller: _dateController,
                  decoration: InputDecoration(
                    hintText: 'Date',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(width * 0.03),
                      borderSide: const BorderSide(color: Colors.black,width: 1),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(width * 0.03),
                      borderSide: BorderSide(color: Theme.of(context).primaryColor,width: 2),
                    ),
                    prefixIcon: const Icon(
                      Icons.date_range,
                      color: Colors.black,
                    ),

                  ),
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.datetime,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Date is Empty';
                    }
                    if (value.length <= 6) {
                      return 'Check Date';
                    }
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.all(width * 0.04),
                child: TextFormField(
                  controller: _descriptionController,
                  decoration: InputDecoration(
                    hintText: 'Description',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(width * 0.03),
                      borderSide: const BorderSide(color: Colors.black,width: 1),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(width * 0.03),
                      borderSide: BorderSide(color: Theme.of(context).primaryColor,width: 2),
                    ),
                    prefixIcon: const Icon(
                      Icons.description_outlined,
                      color: Colors.black,
                    ),
                  ),
                  textInputAction: TextInputAction.done,
                  keyboardType: TextInputType.multiline,
                  maxLines: 8,
                  minLines: 4,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Description is Empty';
                    }
                  },
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  fixedSize: Size(width * 0.6, height * 0.06),
                  textStyle: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(width * 0.03),
                  ),
                ),
                onPressed: () async {
                  if (_key.currentState!.validate() == false) {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text(
                          'Error',
                          style: TextStyle(
                            color: Colors.red,
                          ),
                        ),
                        content: const Text('Check the inputs'),
                        actions: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Colors.white,
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              'Return',
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  } else {
                    await todoProvider.insertData(
                      _titleController.text,
                      _descriptionController.text,
                      _dateController.text,
                    );
                    _titleController.clear();
                    _descriptionController.clear();
                    _dateController.clear();
                    Navigator.pop(context);
                  }
                },
                child: Text('Insert'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
