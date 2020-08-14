import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

// ignore: must_be_immutable
class DisplayHomeBooks extends StatefulWidget {
  DisplayHomeBooks({Key key, this.department}) : super(key: key);
  String department;


  @override
  _DisplayHomeBooksState createState() => _DisplayHomeBooksState();
}

class _DisplayHomeBooksState extends State<DisplayHomeBooks> {
  String selBook;
  var del = false;

  void _addFav() {
    Firestore.instance.collection("Favourites").document(selBook).setData(
      {
        'Name': selBook,
      },
    ).then((value) {
      Fluttertoast.showToast(
        msg: "Added " + selBook + " to favourites!",
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1,
        textColor: Colors.black,
      );
    });
  }

  void _addReading() {
    Firestore.instance.collection("Reading").document(selBook).setData(
      {
        'Name': selBook,
      },
    ).then((value) {
      Fluttertoast.showToast(
        msg: "Continue reading " + selBook + "!",
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1,
        textColor: Colors.black,
      );
    });
  }

  void _deleteBooks(){
    Firestore.instance.collection(widget.department).document(selBook).delete().then((value) {
      del = (true | del);
    });
    Firestore.instance.collection("Favourites").document(selBook).delete().then((value) {
      del = true | del;
    });
    Firestore.instance.collection("Read").document(selBook).delete().then((value) {
      del = true | del;
    });
    Firestore.instance.collection("Reading").document(selBook).delete().then((value) {
      del = true | del;
    });
    if(del){
      Fluttertoast.showToast(
        msg:"Deleted successfully",
        textColor: Colors.black,
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1,
      );
    }
  }

  void handleClick(String choice, String doc){
    switch(choice){
      case "Wishlist":
        selBook = doc;
        _addFav();
        break;
      case "Read":
        selBook = doc;
        _addReading();
        break;
      case "Delete":
        selBook = doc;
        _deleteBooks();
        break;
      default:
        break;
    }
  }

  Widget _buildList(BuildContext context, DocumentSnapshot document) {
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
              onSelected: (selected) {
                handleClick(selected, document['Name']);
              },
              itemBuilder: (BuildContext context) {
                return {'Wishlist', 'Read', 'Delete'}.map((String choice) {
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

  Widget _showBooks() {
    return StreamBuilder(
      stream: Firestore.instance.collection(widget.department).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        if (snapshot.data.documents.length == 0){
          Firestore.instance.collection("Books").document(widget.department).delete();
        }
        return ListView.builder(
            itemCount: snapshot.data.documents.length,
            itemExtent: 80.0,
            itemBuilder: (context, index) {
              return _buildList(context, snapshot.data.documents[index]);
            });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.department,
        ),
      ),
      body: _showBooks(),
    );
  }
}
