import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int itemCount = 0;
  QuerySnapshot _todolist;
  bool isPressed = false;
  final GlobalKey<AnimatedListState> _listKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        elevation: 4.0,
        backgroundColor: Colors.teal,
        child: Icon(Icons.playlist_add),
        onPressed: () {
          Navigator.pop(context);
          Navigator.pushNamed(context, "/addtodo");
        },
      ),
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
            IconButton(icon: Icon(Icons.home), onPressed: () {}),
            IconButton(
                icon: Icon(Icons.clear_all),
                onPressed: () {
                  _clearAll();
                })
          ],
        ),
      ),
      body: SafeArea(
        child: FutureBuilder(
          future: getItems(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.active:
              case ConnectionState.waiting:
                return LinearProgressIndicator();
              case ConnectionState.done:
                return AnimatedList(
                  key: _listKey,
                  initialItemCount: itemCount,
                  itemBuilder:
                      (BuildContext context, int index, Animation animation) {
                    final DocumentSnapshot snapshot =
                        _todolist.documents[index];
                    print(index);
                    return Dismissible(
                      key: Key(index.toString()),
                      direction: DismissDirection.endToStart,
                      onDismissed: (direction) {
                        DocumentSnapshot document = snapshot;
                        removeToDo(document.documentID);
                        Scaffold.of(context).showSnackBar(
                          SnackBar(
                            content:
                                Text(snapshot.data['event'] + " completed."),
                            action: SnackBarAction(
                              label: "UNDO",
                              onPressed: () {
                                //To undo deletion
                                undoDeletion(document.documentID);
                              },
                            ),
                          ),
                        );
                      },
                      background: Container(
                        color: Colors.red,
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 18.0),
                            child: Icon(
                              Icons.delete,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      child: Column(
                        children: <Widget>[
                          ListTile(
                            subtitle: Text(snapshot.data['event']),
                            leading: Icon(
                              Icons.list,
                              color: Colors.teal,
                            ),
                            trailing: Icon(
                              Icons.done_all,
                              color: Colors.teal,
                            ),
                            title: Text(
                              snapshot.data['title'],
                            ),
                          ),
                          Divider(
                            height: 2,
                            indent: 60.0,
                            color: Colors.blueGrey,
                          )
                        ],
                      ),
                    );
                  },
                );
            }
          },
        ),
      ),
    );
  }

  void undoDeletion(String id) async {
    await Firestore.instance.collection("todolist").document(id).updateData({
      'done': 'No',
    });
    setState(() {
      getItems();
    });
  }

  void removeToDo(String id) async {
    await Firestore.instance.collection("todolist").document(id).updateData({
      'done': 'Yes',
    });
    setState(() {
      getItems();
    });
  }

  void _clearAll() {
    for (var i = 0; i <= itemCount - 1; i++) {
      _listKey.currentState.removeItem(0,
          (BuildContext context, Animation<double> animation) {
        return Container();
      });
    }
  }

  Future<QuerySnapshot> getItems() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    FirebaseUser currentUser = await _auth.currentUser();
    print(currentUser.email);
    QuerySnapshot userEvents = await Firestore.instance
        .collection('todolist')
        .where('email', isEqualTo: currentUser.email)
        .where('done', isEqualTo: "No")
        .getDocuments();

    _todolist = userEvents;
    itemCount = 0;
    _todolist.documents.forEach((doc) {
      itemCount++;
    });
    print(itemCount.toString() + " is number of items");
    print(_todolist.documents[0].data['event']);
    return _todolist;
  }
}
