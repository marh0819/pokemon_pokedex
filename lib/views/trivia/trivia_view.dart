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
  bool _hasSubmitted = false;
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
    try {
      _score = 0;
      for (int i = 0; i < _questions.length; i++) {
        if (_answers[i] == _questions[i].correctAnswer) _score++;
      }

      setState(() {
        _hasSubmitted = true;
      });

      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('Trivia Finalizada'),
          content: Text('Tu puntaje es $_score/${_questions.length}'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Aceptar'),
            ),
          ],
        ),
      );
    } catch (e) {
      print("Error al enviar puntaje: $e");
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('Error'),
          content: Text(
              'Ocurrió un error al enviar el puntaje. Intenta nuevamente.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Aceptar'),
            ),
          ],
        ),
      );
    }
  }

  void _resetTrivia() {
    setState(() {
      _hasSubmitted = false;
      _answers.clear();
      _score = 0;
      _loadQuestions();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trivia Pokémon'),
      ),
      drawer: NavigationDrawerMenu(),
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
                      ...question.options.map((option) {
                        Color optionColor = Colors.white;
                        if (_hasSubmitted) {
                          if (option == question.correctAnswer) {
                            optionColor = Colors.green.shade100;
                          } else if (_answers[index] == option) {
                            optionColor = Colors.red.shade100;
                          }
                        }

                        return Container(
                          color: optionColor,
                          child: RadioListTile(
                            title: Text(option),
                            value: option,
                            groupValue: _answers[index],
                            onChanged: _hasSubmitted
                                ? null
                                : (value) {
                                    setState(() {
                                      _answers[index] = value as String;
                                    });
                                  },
                          ),
                        );
                      }).toList(),
                    ],
                  ),
                );
              },
            ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: _hasSubmitted ? null : _submitAnswers,
            child: const Icon(Icons.check),
            tooltip: 'Enviar Respuestas',
          ),
          const SizedBox(height: 16),
          FloatingActionButton(
            onPressed: _resetTrivia,
            child: const Icon(Icons.refresh),
            tooltip: 'Reiniciar Trivia',
          ),
        ],
      ),
    );
  }
}
