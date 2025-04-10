import 'package:flutter/material.dart';
import 'package:game_timer/data/timer_inherited.dart';

// void main() => runApp(NameRegistrationApp());

/*class NameRegistrationApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cadastro de Nomes',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: NameRegistrationScreen(),
    );
  }
}*/

class NameRegistrationScreen extends StatefulWidget {
  final Function(bool) onUpdate;

  const NameRegistrationScreen({Key? key, required this.timerContext, required this.onUpdate}) : super(key: key);

  final BuildContext timerContext;

  @override
  _NameRegistrationScreenState createState() => _NameRegistrationScreenState();
}

class _NameRegistrationScreenState extends State<NameRegistrationScreen> {
  late int _time;
  late List<String> _names;

  @override
  void initState() {
    super.initState();
    //_time = TimerInherited.of(widget.timerContext).timeInSecond;
    _names = TimerInherited.of(widget.timerContext).playersList;
  }

  //final List<String> _names = TimerInherited.of(widget.timerContext).playersList; // Lista para armazenar os nomes cadastrados
  final TextEditingController _timeController = TextEditingController(); // Controlador do campo de texto
  final TextEditingController _nameController = TextEditingController(); // Controlador do campo de texto

  void _setTime() {
    //print(TimerInherited.of(widget.timerContext).playersList.length);
    final time = _timeController.text.trim();
    if (time != null && !time.isEmpty) {
      if (int.parse(time) > 0 || int.parse(time) < 11) {
        //TimerInherited.of(widget.timerContext).timeInSecond = int.parse(time) * 60;
        TimerInherited.of(widget.timerContext).setSharedData(int.parse(time) * 60);
        //print(TimerInherited.of(widget.timerContext).getSharedData());
        widget.onUpdate(true);
      } else {
        TimerInherited.of(widget.timerContext).setSharedData(60);
        widget.onUpdate(true);
      }
    }
  }

  void _addName() {
    //print(TimerInherited.of(widget.timerContext).playersList.length);
    final name = _nameController.text.trim();
    if (name.isNotEmpty) {
      setState(() {
        //_names.add(name); // Adiciona o nome à lista
        TimerInherited.of(widget.timerContext).newPlayer(name);
        widget.onUpdate(true);
        //print(TimerInherited.of(context).playersList);
      });
      _nameController.clear(); // Limpa o campo de texto para o próximo cadastro
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cronômetro de Jogos'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tempo de cada jogador:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _timeController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Text(
                  'minuto(s)',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _setTime,
                  child: Text('Salvar'),
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Nome',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _addName,
                  child: Text('Adicionar'),
                ),
              ],
            ),
            SizedBox(height: 20),
            Text(
              'Jogadores ou times:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _names.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: CircleAvatar(
                      child: Text((index + 1).toString()), // Índice do nome
                    ),
                    title: Text(_names[index]),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
