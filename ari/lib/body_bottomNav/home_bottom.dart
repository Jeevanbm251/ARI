import 'package:ari/display_books/home_books.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Home {
  var colors = [Colors.blue[900], Colors.blue[600], Colors.blue[300]];

  Widget _buildList(BuildContext context, DocumentSnapshot document, index) {
    return Container(
      color: colors[index % 3],
      child: FlatButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      DisplayHomeBooks(department: document['Name'])));
        },
        child: Text(
          document['Name'],
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.black,
          ),
        ),
      ),
    );
  }

  Widget buildHome(BuildContext context) {
    return StreamBuilder(
      stream: Firestore.instance.collection('Books').snapshots(),
      //print an integer every 2secs, 10 times
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        return ListView.builder(
          itemExtent: 80.0,
          itemCount: snapshot.data.documents.length,
          itemBuilder: (context, index) {
            return _buildList(context, snapshot.data.documents[index], index);
          },
        );
      }
      );
  }
}
