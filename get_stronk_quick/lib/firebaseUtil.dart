import 'package:cloud_firestore/cloud_firestore.dart';

class TrainingSession {
  final DocumentReference reference;
  String day;
  List<Exercises> exercises;

  TrainingSession.data(this.reference, this.day, this.exercises)
  {
    this.day ??= "Monday";
    this.exercises ??= null;
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

  Exercises.data(this.name, this.sets)
  {
    this.name ??= "Squat";
    this.sets ??= null;
  }

  factory Exercises.from(DocumentSnapshot snapshot) => 
  Exercises.data(
    snapshot.data["exercises"]["name"], 
    snapshot.data["exercises"]["sets"],
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

  factory Sets.from(DocumentSnapshot snapshot) => 
  Sets.data(
    snapshot.data["Sets"]["rpe"],
    snapshot.data["Sets"]["reps"],
    );

}