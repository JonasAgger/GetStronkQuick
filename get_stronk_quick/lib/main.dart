import 'package:flutter/material.dart';
import 'firebaseUtil.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:simple_coverflow/simple_coverflow.dart';
// FirebaseUser user;


main() async {
  // user = await FirebaseAuth.instance.signInAnonymously();

  runApp(MaterialApp(
    title: "watApp",
    home: MyApp(),
    ),
  );
}

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
          body: new StreamBuilder(
            stream: Firestore.instance.collection("jonas").snapshots(),
            builder: (_, AsyncSnapshot<QuerySnapshot> snapshot) {
              var documents = snapshot.data?.documents ?? [];

              var trainingData = documents.map((snapshot) => TrainingSession.from(snapshot)).toList();


              //return Text("${trainingData[0].day}");
              //return Text("${trainingData[0].exercises}");

              return TrainingPage(trainingData);
            }
          ),
    );
  }
}

class TrainingPage extends StatefulWidget {
  final List<TrainingSession> allData;

  TrainingPage(this.allData);

  @override
  State<TrainingPage> createState() => TrainingPageState();
}

class TrainingPageState extends State<TrainingPage> {
  TrainingSession session;

  @override
  Widget build(BuildContext context) {
    return CoverFlow(
      itemCount: widget.allData.length,
      itemBuilder: (context, index) {
        var data = widget.allData[index];
        var textStyle = TextStyle(fontSize: 22.0, color: Colors.deepOrangeAccent);
        return Column(mainAxisAlignment: MainAxisAlignment.center
        ,children: [
          Text("Day: ${data.day}", style: textStyle),
          Text("Exercise: ${data.exercises[0].name}", style: textStyle),
          Text("Rpe: ${data.exercises[0].sets[0].rpe}", style: textStyle),
          Text("Reps: ${data.exercises[0].sets[0].reps}", style: textStyle),
        ]);
      }
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