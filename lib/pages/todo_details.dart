
import 'package:flutter/material.dart';
enum Mode{
  add,
  edit,
  view
}

class TodoDetails extends StatefulWidget {

  Mode mode;
  final String? title;
  final String? description;
  final Function? onSave;
  TodoDetails({super.key,this.onSave, required this.mode,this.title,this.description});

  @override
  State<TodoDetails> createState() => _TodoDetailsState();
}

class _TodoDetailsState extends State<TodoDetails> {
  TextEditingController titleController = TextEditingController();

  TextEditingController descController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.mode.name.toUpperCase()} TODO"),
        backgroundColor: const Color.fromARGB(255, 189, 172, 250),
        actions: [
          widget.mode == Mode.view ? IconButton(
            onPressed: (){
              widget.onSave!(titleController.text, descController.text);
              setState(() {
                widget.mode =  Mode.edit;
              });
            }, 
            icon: const Icon(Icons.edit)) :
          TextButton.icon(
            onPressed: (){
              widget.onSave!(titleController.text, descController.text);
              return Navigator.pop(context);
            }, 
            icon: widget.mode == Mode.edit ? const Icon(Icons.edit) : const Icon(Icons.save), 
            label: Text('${widget.mode.name.toUpperCase()}'))
        ],
      ),
      // body: editTodoWidget(),
      body: editTodoWidget()
    );
  }

  // changingWidget(){
  //   return widget.mode == Mode.view ? viewTodoWidget() : editTodoWidget();
  // }

  // viewTodoWidget(){
  //   return Padding(
  //     padding: const EdgeInsets.all(20),
  //     child: Center(
  //       child: Column(
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         children: [
  //           Text('${widget.title}' , style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),),
  //           const SizedBox(height: 10,),
  //           Text(widget.description ?? "", style: const TextStyle(fontSize: 16),),
  //           const SizedBox(height: 10,),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  editTodoWidget(){
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextField(
            readOnly: widget.mode == Mode.view ? true : false,
            controller: titleController = TextEditingController(text: widget.title),
            style: widget.mode == Mode.view ? const TextStyle(fontSize: 30, fontWeight: FontWeight.bold) : null,
            decoration: widget.mode == Mode.view ? 
              const InputDecoration(
                border: InputBorder.none
              ):
              const InputDecoration(
                labelText: "Title",
                border: OutlineInputBorder()
              ), 
          ),
          const SizedBox(height: 10,),
          TextField(
            maxLines: 5,
            readOnly: widget.mode == Mode.view ? true : false,
            controller: descController = TextEditingController(text: widget.description),
            style: widget.mode == Mode.view ? const TextStyle(fontSize: 20) : null,
            decoration:  widget.mode == Mode.view ? 
              const InputDecoration(
                border: InputBorder.none
              ):
              const InputDecoration(
              labelText: "Description",
              border: OutlineInputBorder()
            ),
          ),
          const SizedBox(height: 10,),
        ],
      ),
    );
  }

  // addTodoWidget(){
  //   return Padding(
  //     padding: const EdgeInsets.all(20),
  //     child: Column(
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       children: [
  //         TextField(
  //           controller: titleController,
  //           decoration: const InputDecoration(
  //             labelText: "Title",
  //             border: OutlineInputBorder()
  //           ),
  //         ),
  //         const SizedBox(height: 10,),
  //         TextField(
  //           maxLines: 5,
  //           controller: descController,
  //           decoration: const InputDecoration(
  //             labelText: "Description",
  //             border: OutlineInputBorder()
  //           ),
  //         ),
  //         const SizedBox(height: 10,),
  //       ],
  //     ),
  //   );
  // }
}

