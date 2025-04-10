import 'dart:async';

import 'package:flutter/material.dart';
import 'package:game_timer/data/timer_inherited.dart';
import 'package:game_timer/screens/form_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cronômetro de Jogos',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.purple),
        useMaterial3: true,
      ),
      home: TimerInherited(child: TimerScreen()),
    );
  }
}

class BoardGameTimerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cronômetro de Jogos',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: TimerScreen(),
    );
  }
}

class TimerScreen extends StatefulWidget {
  @override
  _TimerScreenState createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  static int _initialTimeInSeconds = 60; // em segundos i.e. 300 = 5 min
  int actualPlayer = 0;

  /*@override
  void initState() {
    super.initState();
    _initialTimeInSeconds = TimerInherited.of(context).getSharedData();
    print(_initialTimeInSeconds);
  }*/

  @override
  void initState() {
    super.initState();
    print(_initialTimeInSeconds);
  }

  int _remainingTime = _initialTimeInSeconds;
  Timer? _timer;
  bool _isRunning = false; // Indica se o cronômetro está em execução

  List<String> _players() => TimerInherited.of(context).playersList;

  void _toggleTimer() {
    if (_isRunning) {
      // Se estiver rodando, pausa o cronômetro
      _pauseTimer();
    } else {
      // Caso contrário, inicia o cronômetro
      _startTimer();
    }
  }

  void _startTimer() {
    setState(() {
      _isRunning = true;
    });

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingTime > 0) {
          _remainingTime--;
        } else {
          _timer?.cancel();
          _isRunning = false;
        }
      });
    });
  }

  void _pauseTimer() {
    _timer?.cancel();
    setState(() {
      _isRunning = false;
    });
  }

  void _setZero() {
    _timer?.cancel();
    setState(() {
      _remainingTime = _initialTimeInSeconds;
      _isRunning = false;
    });
  }

  void _resetTimer() {
    _timer?.cancel();
    setState(() {
      _remainingTime = _initialTimeInSeconds;
      _isRunning = false;
      actualPlayer++;
      if ((actualPlayer) >= _players().length) {
        actualPlayer = 0;
      }
    });
  }

  String _player() {
    List<String>? lista = TimerInherited.of(context).playersList;
    // print(lista.length);
    if (lista.length > 0) {
      if (lista[actualPlayer] != '') {
        return lista[actualPlayer];
      }
    }
    return 'Indefinido';
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        title: Text('Cronômetro de Jogos'),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Jogador atual',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            _player(),
            style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent),
          ),
          SizedBox(height: 20),
          Text(
            _formatTime(_remainingTime),
            style: TextStyle(fontSize: 64, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: _toggleTimer,
                child: Text(_isRunning
                    ? 'Pausar'
                    : 'Iniciar'), // Alterna o texto do botão
              ),
              SizedBox(width: 10),
              ElevatedButton(
                onPressed: _setZero,
                child: Text('Zerar'),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                onPressed: _resetTimer,
                child: Text('Próximo'),
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (newContext) => NameRegistrationScreen(
                    timerContext: context,
                    onUpdate: (valor) {
                      if (valor) {
                        setState(() {
                          print(TimerInherited.of(context).getSharedData());
                          _initialTimeInSeconds = TimerInherited.of(context).getSharedData();
                          _setZero();
                        });
                      }
                    },
                  )));
        },
        child: const Icon(Icons.tune),
      ),
    );
  }
}
