import 'package:cloud_firestore/cloud_firestore.dart';

class TrainingSession {
  final DocumentReference reference;
  String day;
  List<Exercises> exercises;

  TrainingSession.data(this.reference, this.day, this.exercises)
  {
    this.day ??= "Monday";
    this.exercises ??= [
      Exercises(), 
      Exercises()
    ];
  }

  factory TrainingSession.from(DocumentSnapshot snapshot) => 
  TrainingSession.data(
    snapshot.reference,
    snapshot.data["day"],
    snapshot.data["exercises"],
    );

  void save() {
    reference.setData(toMap());
  }

  Map<String, dynamic> toMap() {
    return {
      "day": day,
      "exercises": [
        "harro", "harro2"
      ]
    };
  }
}

class Exercises {
  String name;
  List<Sets> sets;
}

class Sets {
  int rpe;
  int reps;
}