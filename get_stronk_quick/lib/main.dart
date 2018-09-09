import 'package:flutter/material.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<MyHomePage> {
int _currentIndex = 0;

  final List<Widget> _children = [
    FirstPage(),
    SecondPage(),
    ThirdPage()
    ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: doSomething,
        currentIndex: _currentIndex,
        items: [ 
          BottomNavigationBarItem(
          icon: Icon(Icons.home),
          title: Text("Home"),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.ac_unit),
          title: Text("Bjarke"),
        ),
        BottomNavigationBarItem(
            icon: Icon(Icons.access_alarm),
            title: Text("Frederik"),
          ), 
        ],
      ), 
    );
  }

  void doSomething(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}

class FirstPage extends StatelessWidget {
  @override 
  Widget build(BuildContext context)
  {
    return Scaffold(
      appBar: AppBar(
        title: Text("First screen"),
        ),
          body: Container(color: Colors.orangeAccent)
    );
  }
}

class SecondPage extends StatelessWidget {
  @override 
  Widget build(BuildContext context)
  {
    return Scaffold(
      appBar: AppBar(
        title: Text("Second screen"),
        ),
          body: Container(color: Colors.blueAccent)
    );
  }
}

class ThirdPage extends StatelessWidget {
  @override 
  Widget build(BuildContext context)
  {
    return Scaffold(
      appBar: AppBar(
        title: Text("third screen"),
      ),
          body: Container(color: Colors.limeAccent)
    );
  }
}