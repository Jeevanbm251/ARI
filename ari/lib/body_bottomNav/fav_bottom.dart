import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Favourite{

  String collectionName = "Favourites";
  var colors = [Colors.blue[900], Colors.blue[600], Colors.blue[300]];

  Widget _buildList(BuildContext context, DocumentSnapshot document, index) {
    return Container(
      color: colors[index % 3],
      child: FlatButton(
        onPressed: null,
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

  Widget buildFavourite() {
    return StreamBuilder(
      stream: Firestore.instance.collection(collectionName).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Text("Loading...");
        }
        return ListView.builder(
            itemCount: snapshot.data.documents.length,
            itemExtent: 80.0,
            itemBuilder: (context, index) {
              return _buildList(context, snapshot.data.documents[index], index);
            });
      },
    );
  }
}
