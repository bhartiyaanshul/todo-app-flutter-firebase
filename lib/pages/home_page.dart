import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:todo_firebase/pages/todo_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLoading = true;
  List<Map<String, dynamic>> todos = [];
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descController = TextEditingController();

  final todoCollectionRef = FirebaseFirestore.instance.collection("todos");

  void toggleLoading() {
    setState(() {
      isLoading = !isLoading;
    });
  }

  Future<void> createTodo({
    required String title,
    required String description,
  }) async {
    try {
      await todoCollectionRef.add({
        "title": title,
        "description": description,
        "createdAt": Timestamp.now(),
        "updatedAt": Timestamp.now(),
      });
    } catch (e) {
      print("Error: $e");
    }
  }

  Future<List<Map<String, dynamic>>> getTodos() async {
    final docsRef = await todoCollectionRef.get();
    return docsRef.docs.map((doc) => {...doc.data(), "id": doc.id}).toList();
  }

  Future<Map<String, dynamic>?> getTodo(String id) async {
    final docRef = await todoCollectionRef.doc(id).get();
    return docRef.data();
  }

  Future<void> updateTodo(
    String id, {
    String? title,
    String? description,
  }) async {
    return todoCollectionRef.doc(id).update(
      {
        if (title != null) "title": title,
        if (description != null) "description": description,
        "updatedAt": Timestamp.now(),
      },
    );
  }

  Future<void> deleteTodo(String id) async {
    return await todoCollectionRef.doc(id).delete();
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    todos = await getTodos();
    setState(() {
      isLoading = false;
    });
  }

  void openTodoBox({String? docID}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        // backgroundColor: Colors.transparent,
        content: SizedBox(
          height: 100,
          child: Column(
            children: <Widget>[
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  hintText: 'Enter Todo',
                ),
              ),
              TextField(
                controller: descController,
                decoration: const InputDecoration(
                  hintText: 'Enter Description',
                ),
              ),
            ],
          ),
        ),
        actions: [
          Center(
            child: ElevatedButton(
                onPressed: () async {
                  Navigator.of(context).pop();
                  toggleLoading();
                  if (docID == null) {
                    await createTodo(
                        title: titleController.text,
                        description: descController.text);
                  } else {
                    await updateTodo(docID,
                        title: titleController.text,
                        description: descController.text);
                  }
                  getData();
                  titleController.clear();
                  descController.clear();
                },
                child: Text("${docID == null ? "Add" : "Update"} Todo")),
          )
        ],
      ),
    ).whenComplete(() {
      titleController.clear();
      descController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 189, 172, 250),
        title: const Text('Todo App'),
      ),
      body: Center(
          child: isLoading
              ? const CircularProgressIndicator()
              : ListView.builder(
                  itemCount: todos.length,
                  itemBuilder: (context, index) {
                    final todo = todos[index];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        tileColor: const Color.fromARGB(255, 224, 215, 254),
                        title: Text(todo['title']),
                        subtitle: Text(todo['description']),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              onPressed: () {
                                titleController.text = todo['title'];
                                descController.text = todo['description'];
                                openTodoBox(docID: todo['id']);
                              },
                              icon: const Icon(
                                Icons.edit,
                              ),
                            ),
                            IconButton(
                              onPressed: () async {
                                toggleLoading();
                                await deleteTodo(todo['id']);
                                getData();
                              },
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TodoViewer(
                                  todo: todo,
                                  onDelete: (String id) async {
                                    toggleLoading();
                                    await deleteTodo(id);
                                    getData();
                                  }),
                            ),
                          );
                        },
                      ),
                    );
                  },
                )),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 189, 172, 250),
        onPressed: openTodoBox,
        child: const Icon(Icons.add),
      ),
    );
  }
}
