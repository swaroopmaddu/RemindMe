import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:remindme/googleauth.dart';

class AddToDo extends StatefulWidget {
  @override
  _AddToDoState createState() => _AddToDoState();
}

class _AddToDoState extends State<AddToDo> {
  TextEditingController _title = TextEditingController();
  TextEditingController _desc = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            IconButton(
                icon: Icon(Icons.format_list_bulleted),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, "/alltodo");
                }),
            IconButton(
                icon: Icon(Icons.home),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, "/home");
                }),
            IconButton(
                icon: Icon(Icons.keyboard_backspace),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, "/home");
                })
          ],
        ),
      ),
      body: Builder(
        builder: (context) => SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: InkWell(
                  splashColor: Colors.teal,
                  highlightColor: Colors.red,
                  child: Card(
                    elevation: 15.0,
                    child: Padding(
                      padding: const EdgeInsets.all(28.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          CircleAvatar(
                            radius: 45.0,
                            backgroundColor: Colors.teal,
                            child: Icon(
                              Icons.list,
                              size: 50,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          Text(
                            "Add new TODO",
                            style: TextStyle(
                                color: Colors.teal,
                                fontSize: 28.0,
                                fontWeight: FontWeight.w900),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          TextField(
                            controller: _title,
                            decoration: InputDecoration(
                              labelText: 'Title',
                              hintText: 'eg. Short title for your todo',
                            ),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          TextField(
                            controller: _desc,
                            decoration: InputDecoration(
                              labelText: 'Description',
                              hintText: 'Description for your todo',
                            ),
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          ButtonBar(
                            mainAxisSize: MainAxisSize.max,
                            alignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              RaisedButton.icon(
                                color: Colors.red,
                                onPressed: () {
                                  Navigator.pop(context);
                                  Navigator.pushNamed(context, "/home");
                                },
                                icon: Icon(
                                  Icons.cancel,
                                  color: Colors.white,
                                ),
                                label: Text(
                                  "Cancel",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              RaisedButton.icon(
                                color: Colors.green,
                                onPressed: () async {
                                  String title = _title.text.toString();
                                  String desc = _desc.text.toString();
                                  await Firestore.instance
                                      .collection("todolist")
                                      .document()
                                      .setData({
                                    'email': loggedinUser.email,
                                    'title': title,
                                    'event': desc,
                                    'done': "No",
                                  }).then((void i) {
                                    Scaffold.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text("Added a new To Do"),
                                      ),
                                    );
                                    setState(() {
                                      _desc.clear();
                                      _title.clear();
                                    });
                                  });
                                },
                                icon: Icon(
                                  Icons.done,
                                  color: Colors.white,
                                ),
                                label: Text(
                                  "Done",
                                  style: TextStyle(color: Colors.white),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
      ),
    );
  }
}
