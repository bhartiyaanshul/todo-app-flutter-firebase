import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:todo_firebase/pages/auth_services.dart';
import 'package:todo_firebase/pages/login_screen.dart';
import 'package:todo_firebase/pages/todo_details.dart';
import 'package:todo_firebase/pages/todo_page.dart';

class HomePage2 extends StatefulWidget {
  const HomePage2({super.key});

  @override
  State<HomePage2> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage2> {
  final user = FirebaseAuth.instance.currentUser;

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
        'title': title,
        "description": description,
        'createdAt': Timestamp.now(),
        'updatedAt': Timestamp.now(),
        'createdBy': user?.uid
      });
      getData();
    } catch (e) {
      print("Error: $e");
    }
  }

  Future<List<Map<String, dynamic>>> getTodos() async {
    final docRef = await todoCollectionRef
        .where('createdBy', isEqualTo: user?.uid.toString())
        .get();
    return docRef.docs.map((doc) => {...doc.data(), 'id': doc.id}).toList();
  }

  Future<Map<String, dynamic>?> getTodo(String id) async {
    final docRef = await todoCollectionRef.doc(id).get();
    return docRef.data();
  }

  Future<void> updateTodo(
      {String? id, String? title, String? description}) async {
    return todoCollectionRef.doc(id).update({
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      'updatedAt': Timestamp.now()
    });
  }

  Future<void> deleteTodo(String id) async {
    return await todoCollectionRef.doc(id).delete();
  }

  @override
  void initState() {
    if (user == null) {
      Future(() => Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const LoginScreen())));
    } else {
      getData();
    }
    getData();
    super.initState();
  }

  getData() async {
    todos = await getTodos();
    setState(() {
      isLoading = false;
    });
  }

  // Future<void> signOut() async {
  //   final loggedout = await FirebaseAuth.instance.signOut();
  // }

  void openTodoBox({String? docID}) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              content: SizedBox(
                  height: 100,
                  child: Column(
                    children: <Widget>[
                      TextField(
                        controller: titleController,
                        decoration:
                            const InputDecoration(hintText: "Enter Title"),
                      ),
                      TextField(
                        controller: descController,
                        decoration: const InputDecoration(
                            hintText: "Enter Description"),
                      )
                    ],
                  )),
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
                          await updateTodo(
                              id: docID,
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
            )).whenComplete(() {
      titleController.clear();
      descController.clear();
    });
  }

  void openDeleteBox({docID}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: const SizedBox(
            height: 30,
            child: Center(
                child: Text(
              "Are you sure?",
              style: TextStyle(fontSize: 20),
            ))),
        actions: [
          Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton(
                    onPressed: () async {
                      Navigator.of(context).pop();
                    },
                    child: const Text("No")),
                const SizedBox(width: 30),
                ElevatedButton(
                    onPressed: () async {
                      Navigator.of(context).pop();
                      toggleLoading();
                      await deleteTodo(docID);
                      getData();
                    },
                    child: const Text(
                      "Yes",
                      style: TextStyle(color: Colors.red),
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Todo App"),
        backgroundColor: const Color.fromARGB(255, 189, 172, 250),
        actions: [
          IconButton(
              onPressed: () {
                // signOut().whenComplete(() => Navigator.pushReplacement(
                //     context, MaterialPageRoute(builder: (context) => const HomePage2())));
              },
              icon: const Icon(Icons.logout))
        ],
        // automaticallyImplyLeading: false
      ),
      body: Center(
        child: isLoading
            ? const CircularProgressIndicator()
            : ListView.builder(
                itemCount: todos.length,
                itemBuilder: (context, index) {
                  final todo = todos[index];
                  return ListTile(
                    title: Text(todo['title']),
                    subtitle: Text(todo['description']),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                            onPressed: () async {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => TodoDetails(
                                          title: todo['title'],
                                          description: todo['description'],
                                          mode: Mode.edit,
                                          onSave: (titleController, descController) {
                                            print(titleController);
                                            print(descController);
                                            updateTodo(
                                                id: todo['id'],
                                                title: titleController,
                                                description: descController);
                                            getData();
                                          },
                                        )
                                  )
                              );
                            },
                            icon: const Icon(Icons.edit)),
                        IconButton(
                            onPressed: () async {
                              openDeleteBox(docID: todo['id']);
                              // toggleLoading();
                            },
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.red,
                            )),
                      ],
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TodoDetails(
                            mode: Mode.view,
                            title: todo['title'],
                            description: todo['description'],
                            onSave: (titleController, descController) {
                              print(titleController);
                              print(descController);
                              updateTodo(
                                  id: todo['id'],
                                  title: titleController,
                                  description: descController);
                              getData();
                            },
                          )
                        )
                      );
                    },
                  );
                },
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => TodoDetails(mode: Mode.add,onSave: (titleController,descController){
                    createTodo(
                      title: titleController,
                      description: descController
                    );
                    getData();
                  },)
              )
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
