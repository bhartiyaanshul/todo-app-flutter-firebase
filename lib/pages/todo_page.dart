import 'package:flutter/material.dart';

class TodoViewer extends StatelessWidget {
  final Map<String, dynamic> todo;
  final Function(String id) onDelete;
  const TodoViewer({super.key, required this.todo, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: Hero(
          tag: todo['id'],
          child: Material(
            color: const Color.fromARGB(255, 224, 215, 254),
            child: InkWell(
              onTap: () => Navigator.of(context).pop(),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(todo['title'], style: const TextStyle(fontSize: 30)),
                  Text(todo['description'],
                      style: const TextStyle(fontSize: 15)),
                  IconButton(
                      icon: const Icon(Icons.delete,
                          color: Color.fromARGB(255, 185, 70, 61)),
                      onPressed: () {
                        Navigator.pop(context);
                        onDelete(todo['id']);
                      }),
                ],
              ),
            ),
          )),
    );
  }
}
