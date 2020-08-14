import 'package:ari/display_books/dashboard_books.dart';
import 'package:ari/services/authentication.dart';
import 'package:flutter/material.dart';

class Dashboard {
  var list = ["Available books", "WishList", "Completed reading", "Reading"];
  BuildContext context;
  BaseAuth auth;
  VoidCallback logoutCallback;

  Widget buildLeftButton(int i) {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        border: Border(
          right: BorderSide(width: 2, color: Colors.black),
          bottom: BorderSide(width: 2, color: Colors.black),
        ),
      ),
      child: FlatButton(
        child: Center(
          child: Text(
            list[i],
            style: TextStyle(color: Colors.black, fontSize: 25,),
            textAlign: TextAlign.center,
          ),
        ),
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => DisplayDashboardBooks(i: i)));
        }
      ),
    );
  }

  Widget buildRightButton(int i) {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(width: 2, color: Colors.black),
        ),
      ),
      child: FlatButton(
        child: Center(
          child: Text(
            list[i],
            style: TextStyle(color: Colors.black, fontSize: 25,),
            textAlign: TextAlign.center,
          ),
        ),
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => DisplayDashboardBooks(i: i)));
          },
      ),
    );
  }

  Widget buildBottomRightButton(int i) {
    return Container(
      height: 120,
      child: FlatButton(
        child: Center(
          child: Text(
            list[i],
            style: TextStyle(color: Colors.black, fontSize: 25,),
            textAlign: TextAlign.center,
          ),
        ),
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => DisplayDashboardBooks(i: i)));
        },
      ),
    );
  }

  Widget buildBottomLeftButton(int i) {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        border: Border(
          right: BorderSide(width: 2, color: Colors.black),
//          bottom: BorderSide(width: 2, color: Colors.black),
        ),
      ),
      child: FlatButton(
        child: Center(
          child: Text(
            list[i],
            style: TextStyle(color: Colors.black, fontSize: 25,),
            textAlign: TextAlign.center,
          ),
        ),
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => DisplayDashboardBooks(i: i)));
        },
      ),
    );
  }

  Widget buildDashboard(BuildContext context, BaseAuth auth, VoidCallback logoutCallback) {
    this.context = context;
    this.logoutCallback = logoutCallback;
    this.auth = auth;
    return Column(
      children: [
        Text(
          "Dashboard",
          style: TextStyle(color: Colors.black, fontSize: 30),
        ),
        SizedBox(
          height: 5,
        ),
        Row(
          children: [
            Container(
              width: MediaQuery.of(context).size.width * .5,
              child: Table(
                children: [
                  TableRow(
                    children: [
                      buildLeftButton(0),
                    ],
                  ),
                  TableRow(
                    children: [
                      buildBottomLeftButton(2),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width * .5,
              child: Table(
                children: [
                  TableRow(
                    children: [
                      buildRightButton(1),
                    ],
                  ),
                  TableRow(
                    children: [
                      buildBottomRightButton(3),
                    ],
                  ),
                ],
              ),
            )
          ],
        )
      ],
    );
  }
}
