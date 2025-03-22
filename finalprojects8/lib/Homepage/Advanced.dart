import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:finalprojects8/Homepage/login_register.dart';
import 'package:finalprojects8/Homepage/Intermediate.dart';
import 'package:finalprojects8/Homepage/beginner.dart';

void main() {
  runApp(const MaterialApp(
    home: Advanced(),
  ));
}

class Advanced extends StatefulWidget {
  const Advanced({super.key});

  @override
  _AdvancedState createState() => _AdvancedState();
}

class _AdvancedState extends State<Advanced> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late User _currentUser;
  List<bool> levelCompletion = List.generate(20, (index) => false);
  bool isIntermediateUnlocked = false;
  bool isAdvancedUnlocked = false;
  int currentLevel = 1;

  @override
  void initState() {
    super.initState();
    _currentUser = FirebaseAuth.instance.currentUser!;
    checkIntermediateUnlocked();
    checkAdvancedUnlocked();
    fetchLevelProgress();
  }

  void checkIntermediateUnlocked() async {
    try {
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(_currentUser.uid).get();

      if (userDoc.exists && userDoc.data() != null) {
        bool unlocked = userDoc['IntermediateUnlocked'] ?? false;

        setState(() {
          isIntermediateUnlocked = unlocked;
        });
      }
    } catch (e) {
      print("Error checking intermediateUnlocked: $e");
    }
  }

  void checkAdvancedUnlocked() async {
    try {
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(_currentUser.uid).get();

      if (userDoc.exists && userDoc.data() != null) {
        bool unlock = userDoc['AdvancedUnlocked'] ?? false;

        setState(() {
          isAdvancedUnlocked = unlock;
        });
      }
    } catch (e) {
      print("Error checking advancedUnlocked: $e");
    }
  }

  void fetchLevelProgress() async {
    try {
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(_currentUser.uid).get();

      if (userDoc.exists && userDoc.data() != null) {
        Map<String, dynamic>? levels = userDoc['levels'];
        if (levels != null) {
          for (int i = 0; i < 20; i++) {
            levelCompletion[i] = levels['level${i + 1}'] ?? false;
          }
        }
      }

      setState(() {});
    } catch (e) {
      print("Error fetching level progress: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Advanced',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginRegister()),
              );
            },
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text(
                'Navigation',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              title: const Text('Beginner'),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => Beginner()),
                );
              },
            ),
            ListTile(
              title: const Text('Intermediate'),
              enabled: isIntermediateUnlocked,
              onTap: isIntermediateUnlocked
                  ? () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => Intermediate()),
                      );
                    }
                  : null,
            ),
            ListTile(
              title: const Text('Advanced'),
              enabled: isAdvancedUnlocked,
              onTap: isAdvancedUnlocked
                  ? () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Advanced()),
                      );
                    }
                  : null,
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'lib/images/py_machine.jpg',
              fit: BoxFit.cover,
            ),
          ),
          Column(
            children: [
              Expanded(
                child: LevelSelectionPage(
                  levelCompletion: levelCompletion,
                  onLevelSelected: (level) {
                    setState(() {
                      currentLevel = level;
                    });
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LevelPage(
                          level: level,
                          question: _getQuestionForLevel(level),
                          expectedOutput: _getExpectedOutputForLevel(level),
                          onLevelComplete: () {
                            setState(() {
                              levelCompletion[level - 1] = true;
                              _updateLevelProgress(
                                  level); // Save level in Firestore
                            });
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _getQuestionForLevel(int level) {
    // List of questions for each level
    final questions = [
      "Level 1: Fibonacci Sequence\n\n"
          "Write a Python function to generate the first 10 numbers in the Fibonacci sequence. (Expected Output: [0, 1, 1, 2, 3, 5, 8, 13, 21, 34])",
      "Level 2: Prime Numbers\n\n"
          "Write a Python function to find all prime numbers less than 20. (Expected Output: [2, 3, 5, 7, 11, 13, 17, 19])",
      "Level 3: Palindrome Check\n\n"
          "Write a Python function to check if the string 'racecar' is a palindrome. (Expected Output: True)",
      "Level 4: Reverse a List\n\n"
          "Write a Python function to reverse the list [1, 2, 3, 4, 5] without using built-in functions. (Expected Output: [5, 4, 3, 2, 1])",
      "Level 5: Factorial Calculation\n\n"
          "Write a Python function to calculate the factorial of 5. (Expected Output: 120)",
      "Level 6: Sum of Digits\n\n"
          "Write a Python function to calculate the sum of digits of the number 12345. (Expected Output: 15)",
      "Level 7: Largest Number in a List\n\n"
          "Write a Python function to find the largest number in the list [4, 2, 9, 7, 5]. (Expected Output: 9)",
      "Level 8: Count Vowels in a String\n\n"
          "Write a Python function to count the number of vowels in the string 'Hello World'. (Expected Output: 3)",
      "Level 9: Binary Search\n\n"
          "Write a Python function to perform a binary search for the number 7 in the sorted list [1, 3, 5, 7, 9, 11]. (Expected Output: 3)",
      "Level 10: Remove Duplicates from a List\n\n"
          "Write a Python function to remove duplicates from the list [1, 2, 2, 3, 4, 4, 5]. (Expected Output: [1, 2, 3, 4, 5])",
      "Level 11: Check for Anagrams\n\n"
          "Write a Python function to check if 'listen' and 'silent' are anagrams. (Expected Output: True)",
      "Level 12: Find the Second Largest Number\n\n"
          "Write a Python function to find the second largest number in the list [10, 20, 4, 45, 99, 99]. (Expected Output: 45)",
      "Level 13: Check for Perfect Number\n\n"
          "Write a Python function to check if 28 is a perfect number. (Expected Output: True)",
      "Level 14: Generate Multiplication Table\n\n"
          "Write a Python function to generate the multiplication table of 5 up to 10. (Expected Output: 5 x 1 = 5, 5 x 2 = 10, ..., 5 x 10 = 50)",
      "Level 15: Find the Longest Word\n\n"
          "Write a Python function to find the longest word in the list ['apple', 'banana', 'cherry', 'date']. (Expected Output: 'banana')",
      "Level 16: Count Words in a String\n\n"
          "Write a Python function to count the number of words in the string 'Python is fun'. (Expected Output: 3)",
      "Level 17: Check for Leap Year\n\n"
          "Write a Python function to check if the year 2024 is a leap year. (Expected Output: True)",
      "Level 18: Find the GCD of Two Numbers\n\n"
          "Write a Python function to find the GCD of 56 and 98. (Expected Output: 14)",
      "Level 19: Convert Celsius to Fahrenheit\n\n"
          "Write a Python function to convert 25 degrees Celsius to Fahrenheit. (Expected Output: 77.0)",
      "Level 20: Find the Missing Number\n\n"
          "Write a Python function to find the missing number in the list [1, 2, 3, 4, 6, 7, 8, 9, 10]. (Expected Output: 5)",
    ];

    return questions[level - 1];
  }

  String _getExpectedOutputForLevel(int level) {
    // Define expected outputs for each level
    final expectedOutputs = [
      "[0, 1, 1, 2, 3, 5, 8, 13, 21, 34]", // Level 1
      "[2, 3, 5, 7, 11, 13, 17, 19]", // Level 2
      "True", // Level 3
      "[5, 4, 3, 2, 1]", // Level 4
      "120", // Level 5
      "15", // Level 6
      "9", // Level 7
      "3", // Level 8
      "3", // Level 9
      "[1, 2, 3, 4, 5]", // Level 10
      "True", // Level 11
      "45", // Level 12
      "True", // Level 13
      "5 x 1 = 5\n5 x 2 = 10\n...\n5 x 10 = 50", // Level 14
      "'banana'", // Level 15
      "3", // Level 16
      "True", // Level 17
      "14", // Level 18
      "77.0", // Level 19
      "5", // Level 20
    ];

    return expectedOutputs[level - 1];
  }

  void _updateLevelProgress(int level) async {
    try {
      await _firestore.collection('users').doc(_currentUser.uid).set({
        'levels': {
          'level$level': true, // Save the current level as completed
        }
      }, SetOptions(merge: true));

      print("Level $level progress saved successfully.");
    } catch (e) {
      print("Error saving level progress: $e");
    }
  }
}

class LevelSelectionPage extends StatelessWidget {
  final List<bool> levelCompletion;
  final Function(int) onLevelSelected;

  const LevelSelectionPage({
    super.key,
    required this.levelCompletion,
    required this.onLevelSelected,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 5, // Fewer buttons per row
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 5, // Wider buttons
      ),
      itemCount: 20,
      itemBuilder: (context, index) {
        final level = index + 1;
        final isCompleted = levelCompletion[index];
        final isUnlocked = index == 0 || levelCompletion[index - 1];

        return ElevatedButton(
          onPressed: isUnlocked ? () => onLevelSelected(level) : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: isCompleted
                ? const Color.fromARGB(255, 161, 232, 139)
                : isUnlocked
                    ? const Color.fromARGB(255, 232, 229, 229)
                    : const Color.fromARGB(255, 231, 217, 217),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            minimumSize: const Size(120, 120), // Larger buttons
          ),
          child: Text(
            'Level $level',
            style: TextStyle(
              fontSize: 18,
              color: isCompleted
                  ? const Color.fromARGB(255, 16, 15, 15)
                  : const Color.fromARGB(255, 24, 15, 15),
              fontWeight: FontWeight.normal,
            ),
          ),
        );
      },
    );
  }
}

class LevelPage extends StatefulWidget {
  final int level;
  final String question;
  final String expectedOutput;
  final VoidCallback onLevelComplete;

  const LevelPage({
    super.key,
    required this.level,
    required this.question,
    required this.expectedOutput,
    required this.onLevelComplete,
  });

  @override
  _LevelPageState createState() => _LevelPageState();
}

class _LevelPageState extends State<LevelPage> {
  final TextEditingController _codeController = TextEditingController();
  String output = '';
  String error = '';
  bool isLoading = false;
  bool isLevelCompleted = false; // Track if the level is completed

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
        if (output.trim() == widget.expectedOutput.trim()) {
          widget.onLevelComplete();
          setState(() {
            isLevelCompleted = true; // Mark level as completed
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Congratulations! Level completed.')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Incorrect. Try again.')),
          );
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

  void goToNextLevel() {
    Navigator.pop(context); // Close the current level page
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Level ${widget.level}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.question,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
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
            if (isLevelCompleted) // Show "Next Lesson" button if level is completed
              Center(
                child: ElevatedButton(
                  onPressed: goToNextLevel,
                  child: const Text('Next Lesson'),
                ),
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
