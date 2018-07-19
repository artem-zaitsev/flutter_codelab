import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';

class RandomWordWidget extends StatefulWidget {
  @override
  _RandomWordWidgetState createState() => _RandomWordWidgetState();
}

class _RandomWordWidgetState extends State<RandomWordWidget> {
  final List<WordPair> _pairs = generateWordPairs().take(100).toList();
  final Set<WordPair> _savedPairs = Set();
  final TextStyle _textStyle = TextStyle(fontSize: 18.0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("RandomWords"),
        actions: <Widget>[
          // Add 3 lines from here...
          new IconButton(icon: const Icon(Icons.list), onPressed: _pushSaved),
        ],
      ),
      body: Material(
        child: _buildPairs(),
      ),
    );
  }

  void _pushSaved() {
    Navigator.of(context).push(
      new MaterialPageRoute<void>(
        // Add 20 lines from here...
        builder: (BuildContext context) {
          final Iterable<ListTile> tiles = _savedPairs.map(
            (WordPair pair) {
              return ListTile(
                title: Text(
                  pair.asPascalCase,
                  style: _textStyle,
                ),
              );
            },
          );
          final List<Widget> divided = ListTile
              .divideTiles(
                context: context,
                tiles: tiles,
              )
              .toList();

          return Scaffold(
            appBar: AppBar(
              title: const Text('Saved Suggestions'),
            ),
            body: ListView(children: divided),
          );
        },
      ),
    );
  }

  Widget _buildPairs() {
    return ListView.builder(
      padding: EdgeInsets.all(16.0),
      itemBuilder: (BuildContext context, int i) {
        if (i.isOdd) return const Divider();

        final index = i ~/ 2;
        if (index >= _pairs.length) {
          return null; //_pairs.addAll(generateWordPairs().take(10));
        }
        return _buildWord(_pairs[index]);
      },
    );
  }

  Widget _buildWord(WordPair pair) {
    final bool isSaved = _savedPairs.contains(pair);

    return InkWell(
      onTap: () => print('${pair.asPascalCase}'),
      highlightColor: Theme.of(context).highlightColor,
      splashColor: Theme.of(context).highlightColor,
      borderRadius: BorderRadius.circular(4.0),
      child: ListTile(
        title: Text(
          pair.asPascalCase,
          style: _textStyle,
        ),
        trailing: InkResponse(
          onTap: () {
            print('liked $isSaved');
            setState(() {
              isSaved ? _savedPairs.remove(pair) : _savedPairs.add(pair);
            });
          },
          highlightColor: Theme.of(context).highlightColor,
          splashColor: Theme.of(context).highlightColor,
          borderRadius: BorderRadius.circular(4.0),
          child: Icon(
            isSaved ? Icons.favorite : Icons.favorite_border,
            color: isSaved ? Colors.red : null,
          ),
        ),
      ),
    );
  }
}
