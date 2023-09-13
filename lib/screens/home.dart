import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:todo_flutter/screens/addtask.dart';
import 'package:todo_flutter/screens/description.dart';

class home extends StatefulWidget {
  const home({super.key});

  @override
  State<home> createState() => _homeState();
}

class _homeState extends State<home> {
  String uid = '';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getuid();
  }

  getuid() {
    FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    setState(() {
      uid = user!.uid;
    });
  }

  directhem(String mail) {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        shape:
            ContinuousRectangleBorder(borderRadius: BorderRadius.circular(60)),
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                color: Colors.cyanAccent.shade100,
                image: DecorationImage(
                    image: NetworkImage(
                        "https://images.unsplash.com/photo-1483444308400-fb9510501d23?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2074&q=80"),
                    fit: BoxFit.cover),
              ),
              accountName: Text(
                "Prathamesh Mandge",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              accountEmail: Text(
                "mandge.prathamesh10@gmail.com",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            Divider(
              indent: 15,
              endIndent: 15,
              height: 30,
              thickness: 2,
              color: Colors.blue,
            ),
            Container(
              child: Column(
                children: [
                  Text("About Me", style: GoogleFonts.roboto(fontSize: 22)),
                  Container(
                    height: 220,
                    padding: EdgeInsets.all(10),
                    child: Text(
                      "I'm an enthusiastic Flutter app developer known for my creativity and adaptability. As a strong team player with a keen eye for detail, I'm dedicated to crafting exceptional mobile experiences.",
                      style: TextStyle(
                          fontSize: 18, wordSpacing: 5, letterSpacing: 2),
                    ),
                  )
                ],
              ),
            ),
            Divider(
              indent: 15,
              endIndent: 15,
              height: 30,
              thickness: 2,
              color: Colors.blue,
            ),
            RatingBar.builder(
              initialRating: 4.5,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, _) => Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: (rating) {
                print(rating);
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: Text(
          'Tasks',
          style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: Colors.amberAccent),
        ),
        actions: [
          IconButton(
              icon: Icon(Icons.logout),
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
              }),
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(12),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Color.fromARGB(255, 91, 90, 88),
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('tasks')
              .doc(uid)
              .collection('mytasks')
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              final docs = snapshot.data!.docs;
              return ListView.builder(
                physics: BouncingScrollPhysics(),
                itemCount: docs.length,
                itemBuilder: (BuildContext context, int index) {
                  var time = (docs[index]['timestamp'] as Timestamp).toDate();
                  return Container(
                    height: 80,
                    child: Card(
                      elevation: 1,
                      margin: EdgeInsets.only(bottom: 10),
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => Description(
                                title: docs[index]['title'],
                                description: docs[index]['description']),
                          ));
                        },
                        child: Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: EdgeInsets.only(left: 20),
                                height: 70,
                                width: 70,
                                child: CircleAvatar(
                                    backgroundImage: NetworkImage(
                                        "https://img.freepik.com/premium-psd/3d-illustration-todo-list-highlighting-task-management_940959-56.jpg?w=740")),
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                // crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                      margin: EdgeInsets.only(left: 20),
                                      child: Text(
                                        docs[index]['title'],
                                        style: GoogleFonts.roboto(fontSize: 18),
                                      )),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Container(
                                    child: Text(
                                        DateFormat.yMd().add_jm().format(time)),
                                  )
                                ],
                              ),
                              Container(
                                  padding: EdgeInsets.only(right: 10),
                                  child: IconButton(
                                      onPressed: () async {
                                        await FirebaseFirestore.instance
                                            .collection('tasks')
                                            .doc(uid)
                                            .collection('mytasks')
                                            .doc(docs[index]['Time'])
                                            .delete();
                                      },
                                      icon: Icon(
                                        Icons.delete,
                                        color: Colors.red.shade200,
                                      )))
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add, color: const Color.fromARGB(255, 17, 17, 17)),
          backgroundColor: Theme.of(context).primaryColor,
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => AddTask()));
          }),
    );
  }
}
