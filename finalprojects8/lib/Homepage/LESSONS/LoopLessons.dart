import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const CodeQuestApp());
}

class CodeQuestApp extends StatelessWidget {
  const CodeQuestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Python Code Runner',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        textTheme: const TextTheme(
          bodyMedium: TextStyle(fontFamily: 'Roboto', fontSize: 16),
        ),
      ),
      home: const LoopLessons(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class LoopLessons extends StatefulWidget {
  const LoopLessons({super.key});

  @override
  _LoopLessonsState createState() => _LoopLessonsState();
}

class _LoopLessonsState extends State<LoopLessons> {
  bool isLessonComplete = false;

  @override
  void initState() {
    super.initState();
    getLessonProgress();
  }

  Future<void> getLessonProgress() async {
    String userId = FirebaseAuth.instance.currentUser?.uid ?? "test_user";
    DocumentSnapshot doc =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();

    if (doc.exists) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      setState(() {
        isLessonComplete = data['lessons']?['Looplessons'] ?? false;
      });
    }
  }

  void completeLesson(String lessonName) async {
    String userId = FirebaseAuth.instance.currentUser?.uid ?? "test_user";

    FirebaseFirestore.instance.collection('users').doc(userId).set({
      'lessons': {lessonName: true}
    }, SetOptions(merge: true));

    setState(() {
      isLessonComplete = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Python LoopLessons & Runner'),
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color.fromARGB(255, 182, 190, 233), Colors.lightBlue],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Python LoopLessons Lessons',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 106, 130, 204),
                  ),
                ),
                const SizedBox(height: 10),
                ...buildLessonCards(),
                const SizedBox(height: 20),
                const Text(
                  'Loop Learning Game',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 106, 130, 204),
                  ),
                ),
                const SizedBox(height: 10),
                const LoopLearningGame(),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: ElevatedButton(
        onPressed: () {
          completeLesson("Looplessons");
          Navigator.pop(context, true);
        },
        child: const Text('Complete Lesson'),
      ),
    );
  }

  List<Widget> buildLessonCards() {
    return [
      buildLessonCard(
        title: '1. For Loop - Basic Example',
        code: '''
for i in range(5):
    print("Number:", i)
  ''',
        description:
            'A `for` loop iterates over a sequence, like a range, list, or string. Use `range(start, stop)` for numerical loops.',
        lessonKey: 'loops',
      ),
      buildLessonCard(
        title: '2. For Loop with Lists',
        code: '''
fruits = ["apple", "banana", "cherry"]
for fruit in fruits:
    print(fruit)
  ''',
        description:
            'Use a `for` loop to iterate through the elements of a list.',
        lessonKey: 'loops',
      ),
      buildLessonCard(
        title: '3. For Loop with Strings',
        code: '''
word = "Python"
for char in word:
    print(char)
  ''',
        description:
            'Strings are iterable, so you can use a `for` loop to process each character.',
        lessonKey: 'loops',
      ),
      buildLessonCard(
        title: '4. While Loop - Basic Example',
        code: '''
count = 0
while count < 5:
    print("Count:", count)
    count += 1
  ''',
        description:
            'A `while` loop runs as long as the condition is true. Use it when you don’t know the exact number of iterations.',
        lessonKey: 'loops',
      ),
      buildLessonCard(
        title: '5. Using `break` in Loops',
        code: '''
for i in range(10):
    if i == 5:
        break
    print(i)
  ''',
        description:
            'The `break` statement exits the loop prematurely when a specific condition is met.',
        lessonKey: 'loops',
      ),
      buildLessonCard(
        title: '6. Using `continue` in Loops',
        code: '''
for i in range(5):
    if i == 2:
        continue
    print(i)
  ''',
        description:
            'The `continue` statement skips the rest of the current iteration and moves to the next.',
        lessonKey: 'loops',
      ),
      buildLessonCard(
        title: '7. Nested Loops',
        code: '''
for i in range(3):
    for j in range(2):
        print(f"i={i}, j={j}")
  ''',
        description:
            'A loop inside another loop is called a nested loop. Each iteration of the outer loop triggers all iterations of the inner loop.',
        lessonKey: 'loops',
      ),
      buildLessonCard(
        title: '8. Using `else` with Loops',
        code: '''
for i in range(3):
    print(i)
else:
    print("Loop finished!")
  ''',
        description:
            'The `else` block in loops executes after the loop finishes, unless it’s terminated with a `break`.',
        lessonKey: 'loops',
      ),
      buildLessonCard(
        title: '9. Infinite Loops',
        code: '''
count = 0
while True:
    print("Running:", count)
    count += 1
    if count == 5:
        break
  ''',
        description:
            'An infinite loop continues indefinitely until terminated by a condition or a `break` statement.',
        lessonKey: 'loops',
      ),
      buildLessonCard(
        title: '10. Reversed Looping',
        code: '''
for i in reversed(range(5)):
    print(i)
  ''',
        description:
            'Use `reversed()` with an iterable to loop in reverse order.',
        lessonKey: 'loops',
      ),
    ];
  }

  Widget buildLessonCard({
    required String title,
    required String code,
    required String description,
    required String lessonKey,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 8,
      color: isLessonComplete ? Colors.green[100] : Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  title,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                if (isLessonComplete)
                  const Icon(Icons.check_circle,
                      color: Colors.green), // ✅ Show checkmark
              ],
            ),
            const SizedBox(height: 8),
            Text(description, style: const TextStyle(fontSize: 14)),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: SelectableText(
                code,
                style: const TextStyle(fontFamily: 'monospace', fontSize: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LoopLearningGame extends StatefulWidget {
  const LoopLearningGame({super.key});

  @override
  _LoopLearningGameState createState() => _LoopLearningGameState();
}

class _LoopLearningGameState extends State<LoopLearningGame> {
  final TextEditingController _codeController = TextEditingController();
  String output = '';
  String error = '';
  bool isLoading = false;
  int currentLevel = 1;
  bool isLevelComplete = false;

  final List<Map<String, String>> levels = [
    {
      'title': 'Level 1: Print Numbers',
      'description': 'Use a `for` loop to print numbers from 1 to 5.',
      'expectedOutput': '1\n2\n3\n4\n5\n',
    },
    {
      'title': 'Level 2: Sum of Numbers',
      'description':
          'Use a `for` loop to calculate the sum of numbers from 1 to 10.',
      'expectedOutput': '55',
    },
    {
      'title': 'Level 3: Print Even Numbers',
      'description': 'Use a `for` loop to print even numbers between 1 and 10.',
      'expectedOutput': '2\n4\n6\n8\n10\n',
    },
    {
      'title': 'Level 4: Reverse a String',
      'description': 'Use a `for` loop to reverse the string "Python".',
      'expectedOutput': 'nohtyP',
    },
    {
      'title': 'Level 5: While Loop',
      'description': 'Use a `while` loop to print numbers from 1 to 5.',
      'expectedOutput': '1\n2\n3\n4\n5\n',
    },
  ];

  Future<void> runCode() async {
    final code = _codeController.text;
    final Uri url = Uri.parse(
        'http://192.168.56.1:5005/run'); // Replace with your server URL

    setState(() {
      isLoading = true;
      output = '';
      error = '';
    });

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'code': code}),
      );

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        setState(() {
          output = result['output'] ?? 'No output';
          error = result['error'] ?? 'No error';
        });

        // Check if the output matches the expected output
        if (output.trim() ==
            levels[currentLevel - 1]['expectedOutput']?.trim()) {
          setState(() {
            isLevelComplete = true;
          });
        }
      } else {
        setState(() {
          error = 'Error: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        error = 'Could not connect to server: $e';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void nextLevel() {
    if (currentLevel < levels.length) {
      setState(() {
        currentLevel++;
        isLevelComplete = false;
        _codeController.clear();
        output = '';
        error = '';
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Congratulations! You completed all levels.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentChallenge = levels[currentLevel - 1];

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 8,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              currentChallenge['title']!,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              currentChallenge['description']!,
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _codeController,
              maxLines: 6,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Write your Python code here...',
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: isLoading ? null : runCode,
              child: isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('Run Code'),
            ),
            const SizedBox(height: 10),
            if (output.isNotEmpty) buildResultCard('Output', output),
            if (error.isNotEmpty) buildResultCard('Error', error),
            if (isLevelComplete)
              Column(
                children: [
                  const SizedBox(height: 10),
                  const Text(
                    'Level Complete! 🎉',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: nextLevel,
                    child: const Text('Next Level'),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget buildResultCard(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$title:',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        Container(
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(8),
          ),
          child: SelectableText(
            content,
            style: const TextStyle(fontFamily: 'monospace'),
          ),
        ),
      ],
    );
  }
}
