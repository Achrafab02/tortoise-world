import 'package:flutter/material.dart';

import '../../view/main.dart';

void main() {
  runApp(MaterialApp(
    title: 'Navigation Basics',
    theme: ThemeData(
      primarySwatch: Colors.blue,
      visualDensity: VisualDensity.adaptivePlatformDensity,
    ),
    home: StartPage(),
  ));
}

class StartPage extends StatefulWidget {
  const StartPage({super.key});

  @override
  _StartPageState createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Bienvenue sur Tortoise World',
          style: TextStyle(color: Colors.white),
        ),
        leading: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.help),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Instructions du jeu :'),
                      content: const Text(
                        'Bienvenue dans le monde de la tortue!\n'
                        'Le but du jeu est de déplacer la tortue sur la grille pour qu\'elle mange toutes les laitues. \n'
                        'La tortue peut se déplacer vers le haut, le bas, la gauche et la droite. \n'
                        'Elle peut également boire de l\'eau pour rester hydratée. \n'
                        'Si la tortue ne mange pas de laitue ou ne boit pas d\'eau pendant un certain temps, elle meurt. \n'
                        'Si la tortue perd toute sa santé, elle meurt. \n'
                        'Si la tortue mange toutes les laitues, elle gagne. \n'
                        'Vous pouvez écrire un code pour contrôler la tortue. \n'
                        'Le code doit être correct pour que la tortue puisse se déplacer correctement. \n'
                        'Vous pouvez exécuter le code en appuyant sur le bouton Exécuter. \n'
                        'Vous pouvez arrêter l\'exécution du code en appuyant sur le bouton Stop. ',
                        style: TextStyle(fontSize: 20, color: Colors.black, fontFamily: 'Roboto'),
                      ),
                      actions: <Widget>[
                        TextButton(
                          child: const Text('Fermer'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ],
        ),
        backgroundColor: Colors.blueGrey,
      ),
      body: Container(
        color: Colors.white,
        child: Center(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  width: 300.0,
                  height: 300.0,
                  child: Image.asset('assets/images/logo.gif'),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: SizedBox(
                      width: 300, // Définir la largeur maximale ici
                      child: TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Nom',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez entrer votre nom';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: SizedBox(
                      width: 300, // Définir la largeur maximale ici
                      child: TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Prénom',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez entrer votre prénom';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: SizedBox(
                      width: 300, // Définir la largeur maximale ici
                      child: TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Âge',
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez entrer votre âge';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                FadeTransition(
                  opacity: _animation,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState?.validate() ?? false) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const TortoiseGame()),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.blueGrey,
                    ),
                    child: const Text('Commencer'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
