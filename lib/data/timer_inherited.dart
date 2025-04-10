import 'package:flutter/material.dart';

class TimerInherited extends InheritedWidget {
  int _sharedData = 60;

  TimerInherited({
    super.key,
    required Widget child,
  }) : super(child: child);

  final List<String> playersList = [
    /*'João',
    'Gilberto',
    'Amaral'*/
    /*Task('Aprender Flutter', 'lib/assets/images/dash.png', 3),
    Task('Andar de bike', 'lib/assets/images/bike.jpeg', 2),
    Task('Meditar', 'lib/assets/images/meditar.jpeg', 5),
    Task('Ler', 'lib/assets/images/livro.jpg', 4),
    Task('Jogar', 'lib/assets/images/jogar.jpg', 1),*/
  ];

  // Getter para obter os dados compartilhados
  int getSharedData() {
    return _sharedData;
  }

  // Setter para atualizar os dados compartilhados
  void setSharedData(int newData) {
    _sharedData = newData;
  }

  void newPlayer(String name) {
    playersList.add(name);
  }

  static TimerInherited of(BuildContext context) {
    final TimerInherited? result = context.dependOnInheritedWidgetOfExactType<TimerInherited>();
    assert(result != null, 'No TimerInherited found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(TimerInherited old) {
    return old.playersList.length != playersList.length;
  }
}
