import 'package:cloud_firestore/cloud_firestore.dart';

class TrainingSession {
  final DocumentReference reference;
  String day;
  List<Exercises> exercises;

  TrainingSession.data(this.reference, this.day, DocumentSnapshot snapshot)
  {
    this.day ??= "Monday";
    this.exercises = new List<Exercises>.generate(snapshot.data["exercises"].length,
    (int index) => Exercises.from(snapshot, index)
    );
  }

  factory TrainingSession.from(DocumentSnapshot snapshot) => 
  TrainingSession.data(
    snapshot.reference,
    snapshot.data["day"],
    snapshot,
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

  Exercises.data(this.name, int exerciseIndex, DocumentSnapshot snapshot)
  {
    this.name ??= "Squat";
    this.sets = new List<Sets>.generate(snapshot.data["exercises"][exerciseIndex]["sets"].length,
    (int index) => Sets.from(snapshot, exerciseIndex, index),
    );
  }

  factory Exercises.from(DocumentSnapshot snapshot, int index) => 
  Exercises.data(
    snapshot.data["exercises"][index]["name"], 
    index,
    snapshot,
    );
}

class Sets {
  int rpe;
  int reps;

  Sets.data(this.rpe, this.reps)
  {
    this.rpe ??= 9;
    this.reps ??= 5;
  }

  factory Sets.from(DocumentSnapshot snapshot, int exerciseIndex, int index) => 
  Sets.data(
    snapshot.data["exercises"][exerciseIndex]["sets"][index]["rpe"],
    snapshot.data["exercises"][exerciseIndex]["sets"][index]["reps"],
    );

}