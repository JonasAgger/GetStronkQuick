import 'package:cloud_firestore/cloud_firestore.dart';

class TrainingSession {
  DocumentReference reference;
  String day;
  List<Exercises> exercises;

  TrainingSession.data(this.reference, this.day, DocumentSnapshot snapshot)
  {
    this.day ??= "Monday";
    this.exercises = new List<Exercises>.generate(snapshot.data["exercises"].length,
    (int index) => Exercises.from(snapshot, index)
    );
  }

  TrainingSession(this.day, this.exercises);

  factory TrainingSession.from(DocumentSnapshot snapshot) => 
  TrainingSession.data(
    snapshot.reference,
    snapshot.data["day"],
    snapshot,
    );

  void save() {

    if (reference == null)
    {
      reference = Firestore.instance.collection("jonas").document();
    }

    Firestore.instance.runTransaction((Transaction ts) async {
      var document = await ts.get(reference);

      if (document.exists)
      {
        await ts.update(reference, toMap());
      }
      else
      {
        await ts.set(reference, toMap());
      }
    });
  }

bool exists() {
  return reference != null;
}

void delete() {
  if (reference == null)
    {
      return;
    }

    Firestore.instance.runTransaction((Transaction ts) async {
      var document = await ts.get(reference);

      if (document.exists)
      {
        await ts.delete(reference);
      }
      else
      {
        return;
      }
    });
}

  Map<String, dynamic> toMap() {
    return {
      "day": day,
      "exercises": exercises.map((f) => f.toMap()).toList()
    };
  }
}

class Exercises {
  String name;
  List<Sets> sets;

  Exercises(this.name, this.sets);

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

    Map<String, dynamic> toMap() {
    return {
      "name": name,
      "sets": sets.map((f) => f.toMap()).toList()
    };
  }
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

  Map<String, dynamic> toMap() {
    return {
      "rpe": rpe,
      "reps": reps
    };
  }
}