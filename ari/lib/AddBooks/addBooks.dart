import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

// ignore: must_be_immutable
class AddBooks extends StatelessWidget {
  String dept, book;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _addData(){
    if(_formKey.currentState.validate()) {
      _formKey.currentState.save();
      print("$dept");
      Firestore.instance.collection("Books").document(dept).setData(
        {
          'Name': dept,
        }
      ).then((_) {
        Firestore.instance.collection(dept).document(book).setData(
          {
            'Name': book,
          }
        ).then((_){
          Fluttertoast.showToast(
            msg: "Book added successfully!",
            textColor: Colors.black,
            timeInSecForIosWeb: 1,
            toastLength: Toast.LENGTH_SHORT,
          );
          _formKey.currentState.reset();
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Book"),
      ),
      body: Column(
        children: [
          Row(
            children: [
              Container(
                width: MediaQuery.of(context).size.width * .40,
                child: Table(
                  children: [
                    TableRow(
                      children: [
                        SizedBox(
                          height: 15,
                        )
                      ],
                    ),
                    TableRow(
                      children: [
                        Text(
                          "Department",
                          style: TextStyle(fontSize: 20),
                        ),
                      ],
                    ),
                    TableRow(
                      children: [
                        SizedBox(
                          height: 23,
                        )
                      ],
                    ),
                    TableRow(
                      children: [
                        Text(
                          "Name of the book",
                          style: TextStyle(fontSize: 20),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * .60,
                child: Form(
                  key: _formKey,
                  child: Table(
                    children: [
                      TableRow(
                        children: [
                          SizedBox(
                            height: 10,
                          )
                        ],
                      ),
                      TableRow(
                        children: [
                          TextFormField(
                            validator: (input) {
                              if (input.isEmpty) {
                                return "Department cannot be empty";
                              } else {
                                dept = input;
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              hintText: "Department",
                            ),
                          ),
                        ],
                      ),
                      TableRow(
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                      TableRow(
                        children: [
                          TextFormField(
                            validator: (input) {
                              if (input.isEmpty) {
                                return "Name of book cannot be empty";
                              } else {
                                book = input;
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              hintText: "Name of book",
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          RaisedButton(
            child: Text(
              "Add",
            ),
            onPressed: _addData,
          )
        ],
      ),
    );
  }
}
