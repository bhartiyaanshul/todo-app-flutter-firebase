import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService{

  final CollectionReference todos = FirebaseFirestore.instance.collection('todos');
  Future<void> addTodo(String todo, String desc) async {
    await todos.add({
      'title': todo,
      'description': desc,
      'timestamp': Timestamp.now(),
    });
  }

  Stream<QuerySnapshot> getTodos(){
    return todos.orderBy('timestamp',descending: true).snapshots();
  }

  Future<void> updateTodo(String docID, String todo, String desc) {
    return todos.doc(docID).update({
      'title': todo,
      'description': desc,
      'timestamp': Timestamp.now(),
    });
  }

  Future<void> deleteTodo(String docID) {
    return todos.doc(docID).delete();
  } 
}