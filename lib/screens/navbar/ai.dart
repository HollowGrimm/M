import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:flutter/material.dart';

class AIScreen extends StatefulWidget {
  const AIScreen({super.key});

  @override
  State<AIScreen> createState() => _AIScreenState();
}

class _AIScreenState extends State<AIScreen> {
  late final OpenAI openAI;
  bool AI = false;
  String reply = '';

  double spacing = 20;
  double questionSize = 15;
  double textFieldSize = 15;
  int lines = 8;
  int char = 250;
  List<String> questions = [
    'What is your primary goal for improving your writing? (e.g., writing more clearly, enhancing creativity, achieving a specific tone or style)',
    'Who is your target audience, and how do you want your writing to impact them? (e.g., engaging readers, educating, persuading)',
    'What specific feedback or criticism have you received about your writing in the past that you want to address? (e.g., unclear ideas, writer\'s block)',
    'How do you currently approach the writing process, and what changes are you willing to make to improve? (e.g., drafting methods, editing strategies, time management)'
  ];
  List<String> userResponses = ['', '', '', ''];
  String key =
      "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";

  Future<void> handleMessage() async {
    List<String> questionList = [];
    List<String> answerList = [];
    for (int i = 0; i < 4; i++) {
      if (userResponses[i] != '') {
        questionList.add(questions[i]);
        answerList.add(userResponses[i]);
      }
    }

    String instructionPrompt =
        "You are an experienced author known for providing insightful and practical advice. The user has answered a series of questions related to their writing journey. Based on their responses, offer thoughtful advice, suggestions, and tips to help them overcome challenges, refine their skills, and achieve their writing goals. Tailor your advice to the specific details they have provided."
        "Here are the questions they are answering: \n${questionList.join('\n')}"
        "Keep your advice short, concise, and to the point.";
    String userPrompt =
        "These are the user's answers: \n${answerList.join('\n')}";

    final request = ChatCompleteText(
      messages: [
        {
          'role': Role.system.name,
          'content': instructionPrompt,
        },
        {
          'role': Role.user.name,
          'content': userPrompt,
        },
      ],
      temperature: 0.2,
      maxToken: 1500,
      model: Gpt4ChatModel(), // Verify this model name
    );

    try {
      ChatCTResponse? response =
          await openAI.onChatCompletion(request: request);
      if (response != null && response.choices.isNotEmpty) {
        setState(() {
          reply = response.choices.first.message!.content.trim();
        });
      }
    } catch (e) {
      print("Error: ${e.toString()}");
    }
  }

  @override
  void initState() {
    super.initState();

    // Initialize ChatGPT SDK
    openAI = OpenAI.instance.build(
      token: key,
      baseOption: HttpSetup(
        receiveTimeout: const Duration(seconds: 30),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
            child: SingleChildScrollView(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                  child: Text("AI Assistant",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 45,
                          fontWeight: FontWeight.bold,
                          fontFamily: "Quincento")),
                ),
                AI
                    ? Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                border: const Border.symmetric(),
                                borderRadius: BorderRadius.circular(5)),
                            child: Text(reply,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: questionSize,
                                    fontWeight: FontWeight.bold)),
                          ),
                          Center(
                            child: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  AI = false;
                                  userResponses = ['', '', '', ''];
                                });
                              },
                              child: const Text(
                                'Back',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ],
                      )
                    : Column(
                        children: [
                          const SizedBox(height: 15),
                          Text(questions[0],
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: questionSize,
                                  fontWeight: FontWeight.bold)),
                          TextField(
                            maxLines: lines,
                            maxLength: char,
                            decoration: const InputDecoration(
                                border: OutlineInputBorder()),
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: textFieldSize,
                                fontWeight: FontWeight.normal),
                            onChanged: (text) async {
                              setState(() {
                                userResponses[0] = text;
                              });
                            },
                          ),
                          SizedBox(height: spacing),
                          Text(questions[1],
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: questionSize,
                                  fontWeight: FontWeight.bold)),
                          TextField(
                            maxLines: lines,
                            maxLength: char,
                            decoration: const InputDecoration(
                                border: OutlineInputBorder()),
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: textFieldSize,
                                fontWeight: FontWeight.normal),
                            onChanged: (text) {
                              setState(() {
                                userResponses[1] = text;
                              });
                            },
                          ),
                          SizedBox(height: spacing),
                          Text(questions[2],
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: questionSize,
                                  fontWeight: FontWeight.bold)),
                          TextField(
                            maxLines: lines,
                            maxLength: char,
                            decoration: const InputDecoration(
                                border: OutlineInputBorder()),
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: textFieldSize,
                                fontWeight: FontWeight.normal),
                            onChanged: (text) {
                              setState(() {
                                userResponses[2] = text;
                              });
                            },
                          ),
                          SizedBox(height: spacing),
                          Text(questions[3],
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: questionSize,
                                  fontWeight: FontWeight.bold)),
                          TextField(
                            maxLines: lines,
                            maxLength: char,
                            decoration: const InputDecoration(
                                border: OutlineInputBorder()),
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: textFieldSize,
                                fontWeight: FontWeight.normal),
                            onChanged: (text) {
                              setState(() {
                                userResponses[3] = text;
                              });
                            },
                          ),
                          ElevatedButton(
                            onPressed: () {
                              handleMessage();
                              setState(() {
                                reply = '';
                                AI = true;
                              });
                            },
                            child: const Text(
                              'Submit',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
              ]),
        )));
  }
}
