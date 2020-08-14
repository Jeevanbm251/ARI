import 'package:ari/display_books/home_books.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

// ignore: must_be_immutable
class DisplayDashboardBooks extends StatefulWidget {
  DisplayDashboardBooks({Key key, this.i}) : super(key: key);
  int i;
  @override
  _DisplayDashboardBooksState createState() => _DisplayDashboardBooksState();
}

class _DisplayDashboardBooksState extends State<DisplayDashboardBooks> {
  var collectionName = "";
  var collections = ["Books", "Favourites", "Read", "Reading"];

  void handleClick(String value, String doc) {
    switch (value) {
      case 'Remove':
        Firestore.instance
            .collection(collectionName)
            .document(doc)
            .delete()
            .then((value) {
          Fluttertoast.showToast(
            msg: "You removed " + doc + " successfully from favourites",
            textColor: Colors.black,
            toastLength: Toast.LENGTH_SHORT,
            timeInSecForIosWeb: 1,
          );
        });
    }
  }

  Widget _buildListFavourites(BuildContext context, DocumentSnapshot document) {
    return Row(
      children: [
        Container(
          width: MediaQuery.of(context).size.width * .90,
          child: Card(
            child: ListTile(
              title: Text(document['Name']),
            ),
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width * .1,
          child: Center(
            child: PopupMenuButton<String>(
              icon: Icon(Icons.more_vert),
              onSelected: (selected) {
                handleClick(selected, document['Name']);
              },
              itemBuilder: (BuildContext context) {
                return {'Remove'}.map((String choice) {
                  return PopupMenuItem<String>(
                    value: choice,
                    child: Text(choice),
                  );
                }).toList();
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildListRead(BuildContext context, DocumentSnapshot document) {
    return Container(
      padding: EdgeInsets.all(3),
      decoration: BoxDecoration(
          border: Border(
        top: BorderSide(width: 2, color: Colors.black),
        right: BorderSide(width: 2, color: Colors.black),
        left: BorderSide(width: 2, color: Colors.black),
        bottom: BorderSide(width: 2, color: Colors.black),
      )),
      child: ListTile(
        title: Text(
          document['Name'],
        ),
      ),
    );
  }

  void handleClickReading(String selected, String doc) {
    switch (selected) {
      case 'Remove':
        Firestore.instance
            .collection(collectionName)
            .document(doc)
            .delete()
            .then((value) {
          Fluttertoast.showToast(
            msg: "You stopped reading " + doc,
            textColor: Colors.black,
            toastLength: Toast.LENGTH_SHORT,
            timeInSecForIosWeb: 1,
          );
        });
        break;
      case "Completed Reading":
        Firestore.instance
            .collection("Read")
            .document(doc)
            .setData({'Name': doc}).then((value) {
          Fluttertoast.showToast(
            msg: "Completed reading " + doc,
            toastLength: Toast.LENGTH_SHORT,
            timeInSecForIosWeb: 1,
            textColor: Colors.black,
          );
        });
        Firestore.instance.collection("Reading").document(doc).delete();
        break;
    }
  }

  Widget _buildListReading(BuildContext context, DocumentSnapshot document) {
    return Row(
      children: [
        Container(
          width: MediaQuery.of(context).size.width * .90,
          child: Card(
            child: ListTile(
              title: Text(document['Name']),
            ),
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width * .1,
          child: Center(
            child: PopupMenuButton<String>(
              icon: Icon(Icons.more_vert),
              onSelected: (selected) {
                handleClickReading(selected, document['Name']);
              },
              itemBuilder: (BuildContext context) {
                return {'Remove', 'Completed Reading'}.map((String choice) {
                  return PopupMenuItem<String>(
                    value: choice,
                    child: Text(choice),
                  );
                }).toList();
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCompleteList(BuildContext context, DocumentSnapshot document) {
    return
        Container(
          decoration: BoxDecoration(
            border: Border(
//              top: BorderSide(width: 1, color: Colors.black),
              bottom: BorderSide(width: 1, color: Colors.black),
              left: BorderSide(width: 1, color: Colors.black),
              right: BorderSide(width: 1, color: Colors.black),
            ),
          ),
          width: double.infinity,
            child: FlatButton(
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => DisplayHomeBooks(department: document['Name'],)));
              },
              child: Text(
                document['Name'],
                style: TextStyle(color: Colors.black, fontSize: 25),
              ),
            ),
    );
  }

  Widget _showBooks() {
    return StreamBuilder(
      stream: Firestore.instance.collection(collectionName).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        return ListView.builder(
            itemCount: snapshot.data.documents.length,
            itemExtent: 80.0,
            itemBuilder: (context, index) {
              if (collectionName == "Favourites") {
                return _buildListFavourites(
                    context, snapshot.data.documents[index]);
              } else if (collectionName == "Reading") {
                return _buildListReading(
                    context, snapshot.data.documents[index]);
              } else if (collectionName == "Reading") {
                return _buildListRead(context, snapshot.data.documents[index]);
              } else {
                return _buildCompleteList(
                    context, snapshot.data.documents[index]);
              }
            });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    collectionName = collections[widget.i];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          collectionName,
        ),
      ),
      body: _showBooks(),
    );
  }
}
