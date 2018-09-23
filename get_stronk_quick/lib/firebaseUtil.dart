import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "TrainingSession.dart";

class FireStoreWrapper
{
  static FirebaseUser user;

  static void logIn(String email, String password)
  {
    var futureUser = FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);

    futureUser.then((loggedInFireBaseUser) => user = loggedInFireBaseUser);
  }

  static void signUp(String email, String password)
  {
    FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password).then((firebaseuser) => print("user Created: " + firebaseuser.uid));
  }

  static void signOut()
  {
    FirebaseAuth.instance.signOut();
    user = null;
  }

  static bool isLoggedIn()
  {
    return user != null;
  }


  static void saveTrainingSession(TrainingSession session)
  {
    if (session.reference == null)
      {
        session.reference = Firestore.instance.collection("jonas").document();
      }

      Firestore.instance.runTransaction((Transaction ts) async {
        var document = await ts.get(session.reference);

        if (document.exists)
        {
          await ts.update(session.reference, session.toMap());
        }
        else
        {
          await ts.set(session.reference, session.toMap());
        }
      });
  }

  static bool trainingSessionExists(TrainingSession session)
  {
    return session.reference != null;
  }

  static void deleteTrainingSession(TrainingSession session) {
  if (session.reference == null)
    {
      return;
    }

    Firestore.instance.runTransaction((Transaction ts) async {
      var document = await ts.get(session.reference);

      if (document.exists)
      {
        await ts.delete(session.reference);
      }
      else
      {
        return;
      }
    });
  }
}