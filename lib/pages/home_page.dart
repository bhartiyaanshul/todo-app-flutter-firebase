import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:todo_firebase/services/firestore.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final FirestoreService firestoreService = FirestoreService();

  final TextEditingController titleController = TextEditingController();
  final TextEditingController descController = TextEditingController();

  void openTodoBox({String? docID}){
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
              onPressed: (){
                if(docID == null){
                  firestoreService.addTodo(titleController.text, descController.text);
                }
                else{
                  firestoreService.updateTodo(docID, titleController.text, descController.text);
                }
                
                titleController.clear();
                descController.clear();
                Navigator.of(context).pop();
              }, 
              child: const Text("Add Todo")
            ),
          )
        ],
      ),
    );
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 133, 196, 249),
        title: const Text('Todo App'),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 133, 196, 249),
        onPressed: openTodoBox,
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: firestoreService.getTodos(),
        builder: (context, snapshot){
          if(snapshot.hasData){
            List todoList = snapshot.data!.docs;
            return ListView.builder(
              itemCount: todoList.length,
              itemBuilder: (context, index){
                DocumentSnapshot todo = todoList[index];
                String docID = todo.id;

                Map<String, dynamic> todoData = 
                  todo.data() as Map<String, dynamic>;
                String title = todoData['title'];
                String desc = todoData['description'];

                return Hero(
                  tag: docID,
                  
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    padding: const EdgeInsets.all(10),
                    color: Color.fromARGB(255, 224, 219, 219),
                    child: ListTile(
                      title: Text(title),
                      subtitle: Text(desc),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () => openTodoBox(docID: docID),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () => firestoreService.deleteTodo(docID),
                          ),
                        ],
                      )
                    ),
                  ),
                );
              },
            );
          }
          else{
            return (
              const Text('No TODOs yet!')
            );
          }
        },
      ),
    );
  }


}