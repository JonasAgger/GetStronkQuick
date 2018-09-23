import 'package:flutter/material.dart';
import 'firebaseUtil.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:simple_coverflow/simple_coverflow.dart';
import "TrainingSession.dart";
import "LoginPage.dart";

main() async {
  
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
    if (FireStoreWrapper.isLoggedIn())
    {
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
    else
    {
      return LoginPage();
    }
    
  }

  void doSomething(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}

class FirstPage extends StatefulWidget {
  @override
    State<StatefulWidget> createState() {
      // TODO: implement createState
      return TrainingPageDay();
    }
}

class TrainingPageDay extends State<FirstPage>
{
  int _dayIndex = 0;
  int _maxIndex = 0;
  List<TrainingSession> trainingData;

  @override 
  Widget build(BuildContext context)
  {
    return Scaffold(
        body: new StreamBuilder(
            stream: Firestore.instance.collection("jonas").snapshots(),
            builder: (_, AsyncSnapshot<QuerySnapshot> snapshot) {
              var documents = snapshot.data?.documents ?? [];

              _maxIndex = snapshot.data?.documents?.length ?? 0;
              
              trainingData = documents.map((snapshot) => TrainingSession.from(snapshot)).toList();
              if (trainingData.length == 0) return Text("Loading...");
              return TrainingPage(trainingData[_dayIndex]);
            }
          ),
          // New Stuff for navigating
    bottomNavigationBar: ButtonBar(
      alignment: MainAxisAlignment.center,
      children: [
          FlatButton(child: Row(children: <Widget>[
          Icon(Icons.access_alarm), Text("Finish Training")
        ],),
        onPressed:() {
          print(_dayIndex);
          _buttonPressed();
          },),
        FlatButton(child: Row(children: <Widget>[
          Icon(Icons.access_alarm), Text("Skip Training"), 
        ],),
        onPressed:() {
          print(_dayIndex);
          _button2Pressed();
          })
      ])
    );
  }

  void _buttonPressed()
  {
    setState(() {
    if (_dayIndex + 1 >= _maxIndex) _dayIndex = 0;
    else _dayIndex++;
    });
  }

  void _button2Pressed()
  {
    FireStoreWrapper.signOut();
    Navigator.pop(context);

    // var newData = new TrainingSession("watday", [ new Exercises("dedlifte", [new Sets.data(4, 5), new Sets.data(5, 5)] ),
    // new Exercises("Bicep curls", [new Sets.data(2, 12), new Sets.data(4, 12)])]);

    // if (FireStoreWrapper.trainingSessionExists(newData)) return;
  }
}

class TrainingPage extends StatefulWidget {
  final TrainingSession allData;

  TrainingPage(this.allData);

  @override
  State<TrainingPage> createState() => TrainingPageState();
}

class TrainingPageState extends State<TrainingPage> {
  TrainingSession session;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(body: new CoverFlow(
      itemCount: widget.allData.exercises.length,
      itemBuilder: (context, index) {
        var data = widget.allData;
        return Scaffold(appBar: new AppBar(title: Text(data.exercises[index].name)),
          body: new Card(child: new Column(
          mainAxisSize: MainAxisSize.min,
          children: _buildList(data.exercises[index].sets)
          )
        ));
      },
      dismissibleItems: false,
    )
    );
  }

  List<ListTile> _buildList(List<Sets> exerciseList)
  {
    var list = new List<ListTile>();

    for(int i = 0; i < exerciseList.length; i++)
    {
      var newTile = new ListTile(title: Text("Reps: " + exerciseList[i].reps.toString()),
      subtitle: Text("Rpe: " + exerciseList[i].rpe.toString())
      );
      list.add(newTile);
    }

    return list;
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