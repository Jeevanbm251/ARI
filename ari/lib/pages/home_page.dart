import 'package:ari/AddBooks/addBooks.dart';
import 'package:ari/body_bottomNav/dashboard_bottom.dart';
import 'package:ari/body_bottomNav/fav_bottom.dart';
import 'package:ari/body_bottomNav/home_bottom.dart';
import 'package:ari/services/authentication.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.auth, this.logoutCallback, this.currentIndex})
      : super(key: key);

  int currentIndex;
  final BaseAuth auth;
  final VoidCallback logoutCallback;

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();


  String title = "Home";
  var titles = ["Dashboard", "Home", "Favourites", "Notifications"];

  Home home = new Home();
  Dashboard dashBoard = new Dashboard();
  Favourite favourite = new Favourite();

  signOut() async {
    try {

      await widget.auth.signOut();
      widget.logoutCallback();
    } catch (e) {
      Fluttertoast.showToast(
        msg:e.message.toString(),
        textColor: Colors.black,
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1,
      );
    }
  }

  addBook(){
    Navigator.push(context, MaterialPageRoute(builder: (context) => AddBooks()));
  }

  Widget _setScreen() {
    switch (widget.currentIndex) {
      case 0:
        return dashBoard.buildDashboard(context, widget.auth, widget.logoutCallback);
        break;
      case 1:
        return home.buildHome(context);
        break;
      case 2:
        return favourite.buildFavourite();
        break;
      case 3:
        return Container();
        break;
      default:
        return Container();
        break;
    }
  }

  void handleClick(String choice){
    switch(choice){
      case "Add books":
        addBook();
        break;
      case "Signout":
        signOut();
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert),
            onSelected: (selected) {
              handleClick(selected);
            },
            itemBuilder: (BuildContext context) {
              return {'Add books', 'Signout'}.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: _setScreen(),
      bottomNavigationBar: _setBottomNav(),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      widget.currentIndex = index;
      title = titles[index];
    });
  }

  Widget _setBottomNav() {
    return BottomNavigationBar(
      currentIndex: widget.currentIndex,
      selectedItemColor: Colors.blue[900],
      onTap: _onItemTapped,
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.dashboard),
          title: Text("Dashboard"),
          backgroundColor: Colors.blueAccent,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          title: Text("Home"),
          backgroundColor: Colors.blueAccent,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.favorite),
          title: Text("Favourites"),
          backgroundColor: Colors.blueAccent,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.notifications),
          title: Text("Notifications"),
          backgroundColor: Colors.blueAccent,
        ),
      ],
    );
  }
}
