import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AddTask extends StatefulWidget {
  const AddTask({super.key});

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  TextEditingController titlecontroller = TextEditingController();
  TextEditingController descriptioncontroller = TextEditingController();

  addtasktofirebase() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    String uid = user!.uid;
    var time = DateTime.now();
    await FirebaseFirestore.instance
        .collection('tasks')
        .doc(uid)
        .collection('mytasks')
        .doc(time.toString())
        .set({
      'title': titlecontroller.text,
      'description': descriptioncontroller.text,
      'Time': time.toString(),
      'timestamp': time
    });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("Added Successfully"),
      duration: Duration(seconds: 2),
    ));
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('New Task')),
      body: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            Container(
              child: TextField(
                controller: titlecontroller,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                  label: Text("Enter Tittle"),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              child: TextField(
                controller: descriptioncontroller,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                  label: Text("Enter Description"),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                    style: ButtonStyle(backgroundColor:
                        MaterialStateProperty.resolveWith<Color>(
                            (Set<MaterialState> states) {
                      if (states.contains(MaterialState.pressed))
                        return const Color.fromARGB(255, 226, 168, 236);
                      return Theme.of(context).primaryColor;
                    })),
                    onPressed: () {
                      addtasktofirebase();
                    },
                    child: Text(
                      "Add Task",
                      style: GoogleFonts.roboto(
                        fontSize: 18,
                      ),
                    ))),
          ],
        ),
      ),
    );
  }
}
