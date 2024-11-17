import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(WiseWordPage());
}

class WiseWordPage extends StatelessWidget {
  const WiseWordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Namer App',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 255, 187, 217)),
          textTheme: const TextTheme(
            bodyLarge: TextStyle(color: Color.fromARGB(221, 111, 0, 255)),
            titleMedium: TextStyle(color: Color.fromARGB(255, 30, 0, 114)),
          ),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  var current = WordPair.random();
  var history = <WordPair>[];

  void getNext() {
    history.add(current);
    current = WordPair.random();
    notifyListeners();
  }

  void clearHistory() {
    history.clear();
    notifyListeners();
  }

  var favorites = <WordPair>[];
  void toggleFavorite() {
    if (favorites.contains(current)) {
      favorites.remove(current);
    } else {
      favorites.add(current);
    }
    notifyListeners();
  }

  void removeFavorite(WordPair word) {
    favorites.remove(word);
    notifyListeners();
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (selectedIndex) {
      case 0:
        page = GeneratorPage();
        break;
      case 1:
        page = FavoritesPage();
        break;
      case 2:
        page = HistoryPage();
        break;
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }

    return Scaffold(
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            selectedIndex = index;
          });
        },
        selectedIndex: selectedIndex,
        destinations: [
          NavigationDestination(
            selectedIcon: Icon(Icons.generating_tokens),
            icon: Icon(Icons.generating_tokens_outlined),
            label: 'Words',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.favorite),
            icon: Icon(Icons.favorite_outline),
            label: "Favorite",
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.history),
            icon: Icon(Icons.history_outlined),
            label: "History",
          ),

        ],
      ),
      body: Container(child: page),
    );
  }
}

class GeneratorPage extends StatelessWidget {
  const GeneratorPage({super.key});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var pair = appState.current;

    IconData icon = appState.favorites.contains(pair) ? Icons.favorite : Icons.favorite_border;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          BigCard(pair: pair),
          const SizedBox(height: 10),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  appState.toggleFavorite();
                },
                icon: Icon(icon),
                label: const Text('Like'),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  appState.getNext();
                },
                child: const Text('Next'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class BigCard extends StatelessWidget {
  const BigCard({super.key, required this.pair});

  final WordPair pair;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
    );

    return Card(
      color: theme.colorScheme.primary,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Text(
          pair.asLowerCase,
          style: style,
          semanticsLabel: "${pair.first} ${pair.second}",
        ),
      ),
    );
  }
}

class FavoritesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    return Container(
      color: const Color.fromARGB(255, 237, 237, 237),
      child: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white, // Background putih
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 3,
                    blurRadius: 6,
                    offset: Offset(0, 3), // Shadow
                  ),
                ],
              ),
              child: Text(
                'Your Favorite Words',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Arial',
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Text(
              'You have ${appState.favorites.length} favorite words.',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          ...appState.favorites.map(
            (word) => Container(
              margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white, // Background putih pada setiap item
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 3,
                    blurRadius: 6,
                    offset: Offset(0, 3), // Shadow
                  ),
                ],
              ),
              child: ListTile(
                title: Text(word.asLowerCase),
                textColor: Theme.of(context).primaryColor,
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("It's ${word.asLowerCase}!")),
                  );
                },
                onLongPress: () {
                  appState.removeFavorite(word);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("${word.asLowerCase} removed from favorites!")),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class HistoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    return Container(
      color: const Color.fromARGB(255, 237, 237, 237),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white, // Background putih
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 3,
                    blurRadius: 6,
                    offset: Offset(0, 3), // Shadow
                  ),
                ],
              ),
              child: Text(
                'Generated Words History',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Arial',
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Words That Already Shown:',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                ElevatedButton(
                  onPressed: () {
                    appState.clearHistory();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("History Deleted!")),
                    );
                  },
                  child: const Text("Delete History"),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              children: appState.history.map(
                (word) => Container(
                  margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white, // Background putih pada setiap item
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 3,
                        blurRadius: 6,
                        offset: Offset(0, 3), // Shadow
                      ),
                    ],
                  ),
                  child: ListTile(
                    title: Text(word.asLowerCase),
                    textColor: Theme.of(context).primaryColor,
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("${word.asLowerCase}!")),
                      );
                    },
                  ),
                ),
              ).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

