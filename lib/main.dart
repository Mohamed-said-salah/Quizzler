import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:vibration/vibration.dart';
import 'quizBrain.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

// todo applying the alert things
// todo making the score keeper expanding with more answers and questions

QuizBrain quizBrain = QuizBrain();

void main() => runApp(Quizzler());

class Quizzler extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.grey[900],
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: QuizPage(),
          ),
        ),
      ),
    );
  }
}

class QuizPage extends StatefulWidget {
  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  void playSound() {
    final player = AudioCache();
    player.play('ding.wav');
  }

  void nextQuestion() {
    if (counter < quizBrain.questionBank.length - 1) {
      counter++;
    }
  }

  Alert summaryAlert(Color c) {
    return Alert(
        style: AlertStyle(
            alertBorder: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
              side: BorderSide(color: c),
            ),
            overlayColor: Colors.black,
            descTextAlign: TextAlign.start,
            alertAlignment: Alignment.center,
            titleStyle: TextStyle(color: c),
            backgroundColor: Colors.grey[900],
            isOverlayTapDismiss: true,
            descStyle: TextStyle(
              color: Colors.white,
              fontSize: 20,
            )),
        context: context,
        title: 'Summary!',
        desc:
            "Toatal Score: $totalCorrect/$totalQuestions\nCorrect Answers: $totalCorrect.\nWrong Answers: $totalWrong.",
        buttons: [
          DialogButton(
              color: c,
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                'Go Back!',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ))
        ]);
  }

  Alert createAlert({AlertType theType, String t, String d, Color c}) {
    return Alert(
      closeFunction: () {
        setState(() {
          counter = 0;
          scoreKeeper = [];
          Navigator.pop(context);
        });
      },
      style: AlertStyle(
          backgroundColor: Colors.grey[900],
          descStyle: TextStyle(color: Colors.white),
          titleStyle: TextStyle(color: Colors.white),
          descTextAlign: TextAlign.center,
          isOverlayTapDismiss: false,
          alertBorder: RoundedRectangleBorder(
              side: BorderSide(color: c),
              borderRadius: BorderRadius.circular(15.0))),
      context: context,
      type: theType,
      title: t,
      desc: d,
      buttons: [
        DialogButton(
          color: c,
          child: Text(
            'Try Again!',
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () {
            setState(() {
              counter = 0;
              scoreKeeper = [];
              totalCorrect = 0;
              totalWrong = 0;
              Navigator.pop(context);
            });
          },
          width: 120,
        ),
        DialogButton(
          color: Colors.grey[700],
          child: Text(
            'Summary!',
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () {
            summaryAlert(c).show();
          },
          width: 120,
        ),
      ],
    );
  }

  Icon createTrueIcon() {
    return Icon(
      Icons.check,
      color: Colors.green,
    );
  }

  Icon createFalseIcon() {
    return Icon(
      Icons.close,
      color: Colors.red,
    );
  }

  List<Icon> scoreKeeper = [];

  int counter = 0;
  int totalQuestions = quizBrain.questionBank.length;
  int totalCorrect = 0;
  int totalWrong = 0;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: Center(
            child: Text(
              quizBrain.questionBank[counter].questionText,
              style:
                  TextStyle(color: Colors.white, fontSize: 25.0, height: 1.5),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: Container(
            height: 60.0,
            color: Colors.green,
            child: TextButton(
              onPressed: () {
                if (quizBrain.questionBank[counter].questionAnswer == true) {
                  playSound();
                  setState(() {
                    scoreKeeper.add(createTrueIcon());
                  });
                  totalCorrect++;
                } else {
                  Vibration.vibrate(duration: 200);
                  setState(() {
                    scoreKeeper.add(createFalseIcon());
                  });
                  totalWrong++;
                }
                if (counter < quizBrain.questionBank.length - 1) {
                  nextQuestion();
                } else {
                  if (totalCorrect < (totalQuestions / 2)) {
                    createAlert(
                            theType: AlertType.error,
                            t: 'Failed!',
                            d: 'Your Correct Answers are less than a half',
                            c: Colors.red)
                        .show();
                    Vibration.vibrate(duration: 200);
                  } else {
                    createAlert(
                            theType: AlertType.success,
                            t: 'Done!',
                            d: 'You have finished all of the questions with most of them right!',
                            c: Colors.green)
                        .show();
                  }
                }
              },
              child: Text(
                'True',
                style: TextStyle(color: Colors.white, fontSize: 20.0),
              ),
            ),
          ),
        ), // True Button
        Padding(
          padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
          child: Container(
            height: 60.0,
            color: Colors.red,
            child: TextButton(
              onPressed: () {
                if (quizBrain.questionBank[counter].questionAnswer == false) {
                  playSound();
                  setState(() {
                    scoreKeeper.add(createTrueIcon());
                  });
                  totalCorrect++;
                } else {
                  Vibration.vibrate(duration: 200);
                  setState(() {
                    scoreKeeper.add(createFalseIcon());
                  });
                  totalWrong++;
                }
                if (counter < quizBrain.questionBank.length - 1) {
                  nextQuestion();
                } else {
                  if (totalCorrect < (totalQuestions / 2)) {
                    createAlert(
                            theType: AlertType.error,
                            t: 'Failed!',
                            d: 'Your Correct Answers are less than a half',
                            c: Colors.red)
                        .show();
                    Vibration.vibrate(duration: 200);
                  } else {
                    createAlert(
                            theType: AlertType.success,
                            t: 'Done!',
                            d: 'You have finished all of the questions with the of them right!',
                            c: Colors.green)
                        .show();
                  }
                }
              },
              child: Text(
                'False',
                style: TextStyle(color: Colors.white, fontSize: 20.0),
              ),
            ),
          ),
        ), // False Button
        Row(
          children: scoreKeeper,
        ),
      ],
    );
  }
}

// 'You can lead a cow down stairs but not up stairs.', 'false'
// 'Approximately one quarter of human bones are in the feet.', 'true'
// 'A slug\'s blood is green.', 'true'
// it is clear that their will be some differents

//? why the sound is not appearing
//! is it a sources problem

// finished to me right now




