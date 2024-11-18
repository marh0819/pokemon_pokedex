import 'package:flutter/material.dart';
import 'package:pokemon_pokedex/models/trivia_question.dart';
import 'package:pokemon_pokedex/services/user_service.dart';
import 'package:pokemon_pokedex/widgets/navigation_drawer_menu.dart';

class TriviaView extends StatefulWidget {
  const TriviaView({super.key});

  @override
  _TriviaViewState createState() => _TriviaViewState();
}

class _TriviaViewState extends State<TriviaView> {
  final UserService _userService = UserService();
  List<TriviaQuestion> _questions = [];
  final Map<int, String> _answers = {};
  bool _hasSubmitted = false;
  int _score = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadQuestions();
  }

  Future<void> _loadQuestions() async {
    try {
      final questions = await _userService.fetchTriviaQuestions();
      if (questions.isEmpty) {
        _showErrorDialog('No se encontraron preguntas para esta trivia.');
      } else {
        setState(() {
          _questions = questions;
          _isLoading = false;
        });
      }
    } catch (e) {
      _showErrorDialog('Error al cargar las preguntas. Intenta nuevamente.');
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _submitAnswers() {
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
        title: const Text('Trivia Finalizada'),
        content: Text('Tu puntaje es $_score/${_questions.length}'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Aceptar'),
          ),
        ],
      ),
    );
  }

  void _resetTrivia() {
    setState(() {
      _hasSubmitted = false;
      _answers.clear();
      _score = 0;
    });
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
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
      drawer: const NavigationDrawerMenu(),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _questions.isEmpty
              ? const Center(
                  child: Text(
                    'No se encontraron preguntas para esta trivia.',
                    style: TextStyle(fontSize: 18),
                  ),
                )
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
                          }),
                        ],
                      ),
                    );
                  },
                ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: _hasSubmitted || _answers.length < _questions.length
                ? null
                : _submitAnswers,
            tooltip: 'Enviar Respuestas',
            child: const Icon(Icons.check),
          ),
          const SizedBox(height: 16),
          FloatingActionButton(
            onPressed: _resetTrivia,
            tooltip: 'Reiniciar Trivia',
            child: const Icon(Icons.refresh),
          ),
        ],
      ),
    );
  }
}
