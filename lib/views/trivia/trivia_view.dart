// lib/views/trivia/trivia_view.dart

import 'package:flutter/material.dart';
import 'package:pokemon_pokedex/models/trivia_question.dart';
import 'package:pokemon_pokedex/services/user_service.dart';
import 'package:pokemon_pokedex/widgets/navigation_drawer_menu.dart';

class TriviaView extends StatefulWidget {
  const TriviaView({Key? key}) : super(key: key);

  @override
  _TriviaViewState createState() => _TriviaViewState();
}

class _TriviaViewState extends State<TriviaView> {
  final UserService _userService = UserService();
  List<TriviaQuestion> _questions = [];
  Map<int, String> _answers = {};
  int _score = 0;

  @override
  void initState() {
    super.initState();
    _loadQuestions();
  }

  Future<void> _loadQuestions() async {
    try {
      final questions = await _userService.fetchTriviaQuestions();
      setState(() {
        _questions = questions;
      });
    } catch (e) {
      print(e);
    }
  }

  void _submitAnswers() async {
    // Calcula el puntaje
    _score = 0;
    for (int i = 0; i < _questions.length; i++) {
      if (_answers[i] == _questions[i].correctAnswer) _score++;
    }

    // Enviar el puntaje del usuario (supongamos que el userId es 1)
    await _userService.submitTriviaScore(1, _score);

    // Muestra el resultado y resetea el cuestionario
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Trivia Finalizada'),
        content: Text('Tu puntaje es $_score/${_questions.length}'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _loadQuestions();
            },
            child: const Text('Aceptar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trivia Pokémon'),
      ),
      drawer: NavigationDrawerMenu(), // Incluye el NavigationDrawerMenu
      body: _questions.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _questions.length,
              itemBuilder: (context, index) {
                final question = _questions[index];
                return Card(
                  margin: const EdgeInsets.all(8),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          question.question,
                          style: const TextStyle(fontSize: 18),
                        ),
                      ),
                      ...question.options.map((option) => RadioListTile(
                            title: Text(option),
                            value: option,
                            groupValue: _answers[index],
                            onChanged: (value) {
                              setState(() {
                                _answers[index] = value!;
                              });
                            },
                          )),
                    ],
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _submitAnswers,
        child: const Icon(Icons.check),
      ),
    );
  }
}
