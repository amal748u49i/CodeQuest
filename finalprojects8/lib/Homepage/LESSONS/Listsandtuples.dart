import 'dart:convert';
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
      home: const Listsandtuples(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class Listsandtuples extends StatefulWidget {
  const Listsandtuples({super.key});

  @override
  _ListsandtuplesState createState() => _ListsandtuplesState();
}

class _ListsandtuplesState extends State<Listsandtuples> {
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
        isLessonComplete = data['lessons']?['List and Tuples'] ?? false;
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
        title: const Text('Python List and tuples & Runner'),
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
                  'Python Lists and Tuples Lessons',
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
                  'Drag-and-Drop Game',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 106, 130, 204),
                  ),
                ),
                const SizedBox(height: 10),
                const DragAndDropGame(),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: ElevatedButton(
        onPressed: () {
          completeLesson("Lists and Tuples");
          Navigator.pop(context, true);
        },
        child: const Text('Complete Lesson'),
      ),
    );
  }

  List<Widget> buildLessonCards() {
    return [
      buildLessonCard(
        title: '1. Introduction to Lists',
        code: '''
# Creating a list
fruits = ["apple", "banana", "cherry"]
print(fruits)
  ''',
        description:
            'Lists in Python are ordered, mutable, and can contain duplicate elements.',
        lessonKey: 'lists',
      ),
      buildLessonCard(
        title: '2. Accessing Elements in a List',
        code: '''
fruits = ["apple", "banana", "cherry"]
print(fruits[0])  # Output: apple
print(fruits[-1])  # Output: cherry
  ''',
        description:
            'Use indexing to access elements in a list. Negative indices start from the end.',
        lessonKey: 'lists',
      ),
      buildLessonCard(
        title: '3. Modifying Elements in a List',
        code: '''
fruits = ["apple", "banana", "cherry"]
fruits[1] = "orange"
print(fruits)
  ''',
        description:
            'Lists are mutable, so you can change their elements using indices.',
        lessonKey: 'lists',
      ),
      buildLessonCard(
        title: '4. Adding Elements to a List',
        code: '''
fruits = ["apple", "banana"]
fruits.append("cherry")
print(fruits)
  ''',
        description:
            'Use the `append()` method to add an element to the end of a list.',
        lessonKey: 'lists',
      ),
      buildLessonCard(
        title: '5. Removing Elements from a List',
        code: '''
fruits = ["apple", "banana", "cherry"]
fruits.remove("banana")
print(fruits)
  ''',
        description:
            'Use the `remove()` method to delete a specific element from a list.',
        lessonKey: 'lists',
      ),
      buildLessonCard(
        title: '6. List Slicing',
        code: '''
fruits = ["apple", "banana", "cherry", "date"]
print(fruits[1:3])  # Output: ['banana', 'cherry']
  ''',
        description:
            'Use slicing to extract a portion of a list. The syntax is `list[start:end]`.',
        lessonKey: 'lists',
      ),
      buildLessonCard(
        title: '7. Looping Through a List',
        code: '''
fruits = ["apple", "banana", "cherry"]
for fruit in fruits:
    print(fruit)
  ''',
        description: 'Use a `for` loop to iterate through elements in a list.',
        lessonKey: 'lists',
      ),
      buildLessonCard(
        title: '8. Sorting a List',
        code: '''
fruits = ["banana", "cherry", "apple"]
fruits.sort()
print(fruits)
  ''',
        description:
            'Use the `sort()` method to sort a list in ascending order.',
        lessonKey: 'lists',
      ),
      buildLessonCard(
        title: '9. List Comprehensions',
        code: '''
numbers = [x for x in range(5)]
print(numbers)
  ''',
        description:
            'List comprehensions provide a concise way to create lists.',
        lessonKey: 'lists',
      ),
      buildLessonCard(
        title: '10. Copying a List',
        code: '''
original = ["apple", "banana", "cherry"]
copy = original.copy()
print(copy)
  ''',
        description: 'Use the `copy()` method to make a duplicate of a list.',
        lessonKey: 'lists',
      ),
      buildLessonCard(
        title: '1. Introduction to Tuples',
        code: '''
# Creating a tuple
fruits = ("apple", "banana", "cherry")
print(fruits)
  ''',
        description:
            'Tuples in Python are ordered and immutable. They cannot be modified after creation.',
        lessonKey: 'tuples',
      ),
      buildLessonCard(
        title: '2. Accessing Elements in a Tuple',
        code: '''
fruits = ("apple", "banana", "cherry")
print(fruits[0])  # Output: apple
print(fruits[-1])  # Output: cherry
  ''',
        description:
            'Access elements in a tuple using indexing. Negative indices start from the end.',
        lessonKey: 'tuples',
      ),
      buildLessonCard(
        title: '3. Unpacking Tuples',
        code: '''
fruits = ("apple", "banana", "cherry")
a, b, c = fruits
print(a, b, c)
  ''',
        description:
            'Unpacking allows you to assign tuple elements to variables directly.',
        lessonKey: 'tuples',
      ),
      buildLessonCard(
        title: '4. Looping Through a Tuple',
        code: '''
fruits = ("apple", "banana", "cherry")
for fruit in fruits:
    print(fruit)
  ''',
        description: 'Use a `for` loop to iterate through elements in a tuple.',
        lessonKey: 'tuples',
      ),
      buildLessonCard(
        title: '5. Tuple Concatenation',
        code: '''
tuple1 = ("apple", "banana")
tuple2 = ("cherry", "date")
result = tuple1 + tuple2
print(result)
  ''',
        description: 'Use the `+` operator to concatenate tuples.',
        lessonKey: 'tuples',
      ),
      buildLessonCard(
        title: '6. Tuple Length',
        code: '''
fruits = ("apple", "banana", "cherry")
print(len(fruits))
  ''',
        description:
            'Use the `len()` function to find the number of elements in a tuple.',
        lessonKey: 'tuples',
      ),
      buildLessonCard(
        title: '7. Tuple Membership',
        code: '''
fruits = ("apple", "banana", "cherry")
print("banana" in fruits)  # True
  ''',
        description:
            'Use the `in` keyword to check if an element exists in a tuple.',
        lessonKey: 'tuples',
      ),
      buildLessonCard(
        title: '8. Immutable Nature of Tuples',
        code: '''
fruits = ("apple", "banana", "cherry")
# fruits[1] = "orange"  # This will raise an error
print(fruits)
  ''',
        description:
            'Tuples are immutable, meaning their elements cannot be changed after creation.',
        lessonKey: 'tuples',
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

class DragAndDropGame extends StatefulWidget {
  const DragAndDropGame({super.key});

  @override
  _DragAndDropGameState createState() => _DragAndDropGameState();
}

class _DragAndDropGameState extends State<DragAndDropGame> {
  int currentLevel = 1;
  bool isLevelComplete = false;
  List<String> codeBlocks = [];
  List<String> correctOrder = [];
  List<String> userOrder = [];

  final List<Map<String, dynamic>> levels = [
    {
      'title': 'Level 1: Create a List',
      'description': 'Drag the code blocks to create a list named `fruits`.',
      'codeBlocks': ['fruits = [', '"apple"', ', "banana"', ', "cherry"', ']'],
      'correctOrder': [
        'fruits = [',
        '"apple"',
        ', "banana"',
        ', "cherry"',
        ']'
      ],
    },
    {
      'title': 'Level 2: Access List Elements',
      'description':
          'Drag the code blocks to print the second element of the list `fruits`.',
      'codeBlocks': ['print(fruits[', '1', '])'],
      'correctOrder': ['print(fruits[', '1', '])'],
    },
    {
      'title': 'Level 3: Modify a List',
      'description':
          'Drag the code blocks to change the second element of the list `fruits` to "orange".',
      'codeBlocks': ['fruits[', '1', '] = "', 'orange', '"'],
      'correctOrder': ['fruits[', '1', '] = "', 'orange', '"'],
    },
    {
      'title': 'Level 4: Create a Tuple',
      'description': 'Drag the code blocks to create a tuple named `colors`.',
      'codeBlocks': ['colors = (', '"red"', ', "green"', ', "blue"', ')'],
      'correctOrder': ['colors = (', '"red"', ', "green"', ', "blue"', ')'],
    },
    {
      'title': 'Level 5: Tuple Unpacking',
      'description':
          'Drag the code blocks to unpack the tuple `colors` into three variables.',
      'codeBlocks': ['a, b, c =', 'colors'],
      'correctOrder': ['a, b, c =', 'colors'],
    },
    {
      'title': 'Level 6: Nested Lists',
      'description':
          'Drag the code blocks to create a nested list `matrix` with 2 rows and 3 columns.',
      'codeBlocks': ['matrix = [', '[1, 2, 3]', ', ', '[4, 5, 6]', ']'],
      'correctOrder': ['matrix = [', '[1, 2, 3]', ', ', '[4, 5, 6]', ']'],
    },
    {
      'title': 'Level 7: List Comprehensions',
      'description':
          'Drag the code blocks to create a list of squares from 1 to 5 using list comprehension.',
      'codeBlocks': ['squares = [', 'x**2', ' for x in range(1, 6)', ']'],
      'correctOrder': ['squares = [', 'x**2', ' for x in range(1, 6)', ']'],
    },
    {
      'title': 'Level 8: Tuple Concatenation',
      'description':
          'Drag the code blocks to concatenate two tuples `tuple1` and `tuple2`.',
      'codeBlocks': [
        'tuple1 = (',
        '"a"',
        ', "b"',
        ')',
        'tuple2 = (',
        '"c"',
        ', "d"',
        ')',
        'result = tuple1 + tuple2'
      ],
      'correctOrder': [
        'tuple1 = (',
        '"a"',
        ', "b"',
        ')',
        'tuple2 = (',
        '"c"',
        ', "d"',
        ')',
        'result = tuple1 + tuple2'
      ],
    },
    {
      'title': 'Level 9: Filter a List',
      'description':
          'Drag the code blocks to filter even numbers from a list using list comprehension.',
      'codeBlocks': [
        'numbers = [1, 2, 3, 4, 5, 6]',
        'evens = [',
        'x',
        ' for x in numbers if x % 2 == 0',
        ']'
      ],
      'correctOrder': [
        'numbers = [1, 2, 3, 4, 5, 6]',
        'evens = [',
        'x',
        ' for x in numbers if x % 2 == 0',
        ']'
      ],
    },
    {
      'title': 'Level 10: Dictionary Creation',
      'description':
          'Drag the code blocks to create a dictionary `student` with keys "name", "age", and "grade".',
      'codeBlocks': [
        'student = {',
        '"name": "Alice"',
        ', ',
        '"age": 20',
        ', ',
        '"grade": "A"',
        '}'
      ],
      'correctOrder': [
        'student = {',
        '"name": "Alice"',
        ', ',
        '"age": 20',
        ', ',
        '"grade": "A"',
        '}'
      ],
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadLevel();
  }

  void _loadLevel() {
    final level = levels[currentLevel - 1];
    setState(() {
      codeBlocks = List.from(level['codeBlocks']);
      correctOrder = List.from(level['correctOrder']);
      userOrder = [];
      isLevelComplete = false;
    });
    _shuffleCodeBlocks();
  }

  void _shuffleCodeBlocks() {
    setState(() {
      codeBlocks.shuffle();
    });
  }

  void _checkSolution() {
    if (userOrder.join() == correctOrder.join()) {
      setState(() {
        isLevelComplete = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Correct! 🎉 Moving to the next level.')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Try again! ❌')),
      );
    }
  }

  void _nextLevel() {
    if (currentLevel < levels.length) {
      setState(() {
        currentLevel++;
      });
      _loadLevel();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Congratulations! You completed all levels. 🏆')),
      );
    }
  }

  void _removeBlock(int index) {
    setState(() {
      userOrder.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    final level = levels[currentLevel - 1];

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 8,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              level['title'],
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              level['description'],
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),
            const SizedBox(height: 20),
            // Draggable Code Blocks
            Wrap(
              spacing: 8,
              children: codeBlocks.map((block) {
                return Draggable<String>(
                  data: block,
                  feedback: Material(
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.blue[100],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(block),
                    ),
                  ),
                  childWhenDragging: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(block),
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.blue[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(block),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            // Drop Target Area
            DragTarget<String>(
              onAcceptWithDetails: (data) {
                setState(() {
                  userOrder.add(data as String);
                });
              },
              builder: (context, candidateData, rejectedData) {
                return Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Wrap(
                    spacing: 8,
                    children: userOrder.asMap().entries.map((entry) {
                      final index = entry.key;
                      final block = entry.value;
                      return GestureDetector(
                        onTap: () => _removeBlock(index),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.blue[100],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(block),
                              const SizedBox(width: 8),
                              const Icon(Icons.close, size: 16),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _checkSolution,
              child: const Text('Check Solution'),
            ),
            if (isLevelComplete)
              ElevatedButton(
                onPressed: _nextLevel,
                child: const Text('Next Level'),
              ),
          ],
        ),
      ),
    );
  }
}

class CodeRunner extends StatefulWidget {
  const CodeRunner({super.key});

  @override
  _CodeRunnerState createState() => _CodeRunnerState();
}

class _CodeRunnerState extends State<CodeRunner> {
  final TextEditingController _codeController = TextEditingController();
  String output = '';
  String error = '';
  bool isLoading = false;

  Future<void> runCode() async {
    final code = _codeController.text;
    final Uri url =
        Uri.parse('http://192.168.56.1:5005/run'); // Replace with server URL

    setState(() {
      isLoading = true;
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

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 8,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Run Your Code',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _codeController,
              maxLines: 6,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter your Python code here...',
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: isLoading ? null : runCode,
              child: isLoading
                  ? const CircularProgressIndicator(
                      color: Colors.white,
                    )
                  : const Text('Run'),
            ),
            const SizedBox(height: 10),
            if (output.isNotEmpty) buildResultCard('Output', output),
            if (error.isNotEmpty) buildResultCard('Error', error),
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
