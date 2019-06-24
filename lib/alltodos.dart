import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class All extends StatefulWidget {
  @override
  _AllState createState() => _AllState();
}

class _AllState extends State<All> {
  int itemCount = 0;
  QuerySnapshot _todolist;
  bool isPressed = false;
  final GlobalKey<AnimatedListState> _listKey = GlobalKey();

  bool notNull(Object o) => o != null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            IconButton(
                icon: Icon(Icons.format_list_bulleted), onPressed: () {}),
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
                            content: Text(snapshot.data['title'] +
                                " deleted permanently."),
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
                            leading: Icon(
                              Icons.label,
                              color: Colors.teal,
                            ),
                            subtitle: Text(
                              snapshot.data['event'],
                              overflow: TextOverflow.ellipsis,
                            ),
                            trailing: Icon(
                              snapshot.data['done'] == "Yes"
                                  ? Icons.done_all
                                  : Icons.close,
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
                        ].where(notNull).toList(),
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

  void removeToDo(String id) async {
    await Firestore.instance.collection("todolist").document(id).delete();
    setState(() {
      getItems();
    });
  }

  Future<QuerySnapshot> getItems() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    FirebaseUser currentUser = await _auth.currentUser();
    print(currentUser.email);
    QuerySnapshot userEvents = await Firestore.instance
        .collection('todolist')
        .where('email', isEqualTo: currentUser.email)
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
