import 'dart:async';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:finalprojects8/Homepage/Advanced.dart';
import 'package:finalprojects8/Homepage/Intermediate.dart';
import 'package:finalprojects8/Homepage/beginner.dart';

void main() => runApp(const CodeQuestApp());

class CodeQuestApp extends StatelessWidget {
  const CodeQuestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CodeQuest',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const QuizIntroduction(),
    );
  }
}

class QuizIntroduction extends StatelessWidget {
  const QuizIntroduction({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome to CodeQuest Quiz'),
        centerTitle: true,
        backgroundColor: Colors.blue.withOpacity(0.7),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                "Welcome to the CodeQuest Quiz! This quiz will assess your Python knowledge and direct you to the appropriate learning path.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const QuizPage()),
                );
              },
              child: const Text("Start Quiz"),
            ),
          ],
        ),
      ),
    );
  }
}

class QuizPage extends StatefulWidget {
  const QuizPage({super.key});

  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  final List<Question> allQuestions = [
    Question('What does `len([1, 2, 3])` return?', ['3', '2', '1'], '3'),
    Question(
        'What is the output of `print(type([]))`?',
        ["<class 'list'>", "<class 'tuple'>", "<class 'dict'>"],
        "<class 'list'>"),
    Question('Which keyword is used to define a function in Python?',
        ['def', 'func', 'define'], 'def'),
    Question('What will `3 * 2 ** 3` evaluate to?', ['24', '18', '48'], '24'),
    Question('Which of the following is a mutable data type in Python?',
        ['List', 'Tuple', 'String'], 'List'),
    Question(
        'What does `bool([])` return?', ['False', 'True', 'None'], 'False'),
    Question('How do you get the last element of a list `lst`?',
        ['lst[-1]', 'lst[len(lst)]', 'lst[last]'], 'lst[-1]'),
    Question(
        'What is the result of `5 // 2` in Python?', ['2', '2.5', '2.0'], '2'),
    Question('What does `print("Python"[::-1])` output?',
        ['Python', 'nohtyP', 'Error'], 'nohtyP'),
    Question('Which method is used to add an element to a set?',
        ['add()', 'append()', 'insert()'], 'add()'),
    Question('What does `set([1, 2, 2, 3])` return?',
        ['{1, 2, 3}', '[1, 2, 2, 3]', '{1, 2, 2, 3}'], '{1, 2, 3}'),
    Question('Which symbol is used for single-line comments in Python?',
        ['#', '//', '--'], '#'),
    Question('What will `print(2 == "2")` return?', ['True', 'False', 'Error'],
        'False'),
    Question('Which function is used to get user input in Python?',
        ['input()', 'scan()', 'get_input()'], 'input()'),
    Question('What is the output of `print(5 % 2)`?', ['1', '2', '0'], '1'),
    Question('Which module is used to work with random numbers in Python?',
        ['random', 'math', 'numbers'], 'random'),
    Question('What does `range(5)` return?',
        ['A list', 'An iterator', 'A tuple'], 'An iterator'),
    Question('What will `print(bool(" "))` return?', ['True', 'False', 'None'],
        'True'),
    Question('How do you check the length of a dictionary `d`?',
        ['len(d)', 'size(d)', 'count(d)'], 'len(d)'),
    Question('Which operator is used for exponentiation in Python?',
        ['**', '^', 'pow'], '**'),
    Question('What does `sorted([3, 1, 2])` return?',
        ['[1, 2, 3]', '[3, 1, 2]', 'None'], '[1, 2, 3]'),
    Question('What will `print(10 / 5)` return?', ['2', '2.0', '10'], '2.0'),
    Question('Which of the following can be used as a dictionary key?',
        ['List', 'Tuple', 'Set'], 'Tuple'),
    Question('Which of the following methods removes an item from a list?',
        ['pop()', 'remove()', 'delete()'], 'pop()'),
    Question('What is the output of `print("hello".upper())`?',
        ['HELLO', 'hello', 'Error'], 'HELLO'),
    Question(
        'What is the default return value of a function that does not return anything?',
        ['None', '0', 'False'],
        'None'),
    Question(
        'How do you check if a key exists in a dictionary `d`?',
        ['"key" in d', 'd.has_key("key")', 'key_exists(d, "key")'],
        '"key" in d'),
    Question(
        'What will `print(type(None))` return?',
        ["<class 'NoneType'>", "<class 'int'>", "<class 'str'>"],
        "<class 'NoneType'>"),
    Question(
        'What is the result of `min([3, 2, 8, 5])`?', ['2', '3', '8'], '2'),
    Question('What is the output of `print("python".capitalize())`?',
        ['Python', 'PYTHON', 'python'], 'Python'),
    Question(
        'Which of the following methods can be used to read a file in Python?',
        ['read()', 'fetch()', 'scan()'],
        'read()'),
    Question('What does `print("abc" * 3)` output?',
        ['abcabcabc', 'abc3', 'Error'], 'abcabcabc'),
    Question('Which loop is used when the number of iterations is not known?',
        ['while', 'for', 'do-while'], 'while'),
    Question(
        'What will `print(type({}))` return?',
        ["<class 'dict'>", "<class 'set'>", "<class 'list'>"],
        "<class 'dict'>"),
    Question('What does `print([1, 2, 3] + [4, 5])` return?',
        ['[1, 2, 3, 4, 5]', '[5, 7, 8]', 'Error'], '[1, 2, 3, 4, 5]'),
    Question(
        'Which method is used to remove whitespace from the beginning and end of a string?',
        ['strip()', 'trim()', 'clean()'],
        'strip()'),
    Question('How do you check if a list `lst` is empty?',
        ['if not lst', 'if lst == None', 'if len(lst) == -1'], 'if not lst'),
    Question('What will `print(3 in [1, 2, 3])` return?',
        ['True', 'False', 'None'], 'True'),
    Question(
        'What is the correct syntax for a class definition?',
        ['class ClassName:', 'define ClassName:', 'new ClassName:'],
        'class ClassName:'),
    Question('Which keyword is used to inherit a class in Python?',
        ['extends', 'inherits', 'class ParentClass'], 'class ParentClass'),
    Question('What will `print(2**3**2)` return?', ['512', '64', '256'], '512'),
    Question('What is the output of `print(10 > 5 and 5 < 3)`?',
        ['True', 'False', 'None'], 'False'),
    Question('Which function is used to convert a string to an integer?',
        ['int()', 'str()', 'float()'], 'int()'),
    Question('What does `print(10 // 3)` return?', ['3', '3.33', '4'], '3'),
    Question('What will `print(bool(0))` return?', ['True', 'False', 'None'],
        'False'),
    Question('Which of the following is NOT a valid variable name in Python?',
        ['1variable', '_variable', 'var_name'], '1variable'),
    Question('Which of the following is an immutable type in Python?',
        ['String', 'List', 'Dictionary'], 'String'),
  ];

  late List<Question> selectedQuestions;
  int currentQuestionIndex = 0;
  int score = 0;

  @override
  void initState() {
    super.initState();
    selectedQuestions = allQuestions.toList()..shuffle();
    selectedQuestions = selectedQuestions.take(10).toList();
  }

  void answerQuestion(String selectedAnswer) {
    if (selectedAnswer ==
        selectedQuestions[currentQuestionIndex].correctAnswer) {
      score++;
    }

    if (currentQuestionIndex + 1 >= selectedQuestions.length) {
      _navigateToResultPage();
      return;
    }

    setState(() {
      currentQuestionIndex++;
    });
  }

  void _navigateToResultPage() async {
    double percentage = (score / selectedQuestions.length) * 100;
    String level = percentage < 50
        ? "beginner"
        : (percentage < 80 ? "intermediate" : "advanced");

    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'level': level,
          'score': score,
          'percentage': percentage,
        });
      } catch (e) {
        print("Error saving data to Firestore: $e");
      }
    }

    // Always navigate to the result page regardless of Firestore operation
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ResultPage(
            score: score,
            totalQuestions: selectedQuestions.length,
            percentage: percentage,
            level: level),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('User Level Quiz')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
                'Question ${currentQuestionIndex + 1}/${selectedQuestions.length}'),
            const SizedBox(
                height: 10), // Space between question number and text
            Text(selectedQuestions[currentQuestionIndex].questionText),
            const SizedBox(
                height: 20), // Space between question text and buttons
            ...selectedQuestions[currentQuestionIndex].options.map(
                  (option) => Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0), // Vertical spacing
                    child: ElevatedButton(
                      onPressed: () => answerQuestion(option),
                      child: Text(option),
                    ),
                  ),
                ),
          ],
        ),
      ),
    );
  }
}

class ResultPage extends StatelessWidget {
  final int score;
  final int totalQuestions;
  final double percentage;
  final String level;

  const ResultPage(
      {super.key,
      required this.score,
      required this.totalQuestions,
      required this.percentage,
      required this.level});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Quiz Result')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Your Score: $score/$totalQuestions'),
            Text('Percentage: ${percentage.toStringAsFixed(2)}%'),
            Text('Level: ${level.toUpperCase()}'),
            ElevatedButton(
              onPressed: () {
                Widget targetPage = level == "beginner"
                    ? Beginner()
                    : (level == "intermediate"
                        ? Intermediate()
                        : const Advanced());
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => targetPage));
              },
              child: const Text('Continue'),
            ),
          ],
        ),
      ),
    );
  }
}

class Question {
  final String questionText;
  final List<String> options;
  final String correctAnswer;

  Question(this.questionText, this.options, this.correctAnswer);
}
