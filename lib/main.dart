import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';

//https://flutterchina.club/get-started/codelab/#第1步-创建-flutter-app

void main() => runApp(new MyApp()); //main函数使用了(=>)符号, 这是Dart中单行函数或方法的简写。

class MyApp extends StatelessWidget {
  //该应用程序继承了 StatelessWidget，这将会使应用本身也成为一个widget。 在Flutter中，大多数东西都是widget，包括对齐(alignment)、填充(padding)和布局(layout)
  @override
  Widget build(BuildContext context) {
    //widget的主要工作是提供一个build()方法来描述如何根据其他较低级别的widget来显示自己
//    final wordPair = new WordPair.random();
    return new MaterialApp(
      title: 'Welcome to Flutter',
//      theme: new ThemeData(
//        primarySwatch: Colors.blue,
//      ),
//      home: new Scaffold(
//        //Scaffold 是 Material library 中提供的一个widget, 它提供了默认的导航栏、标题和包含主屏幕widget树的body属性。widget树可以很复杂
//        appBar: new AppBar(
//          title: new Text('Welcome to Flutter_title'),
//        ),
//        body: new Center(
//          //本示例中的body的widget树中包含了一个Center widget, Center widget又包含一个 Text 子widget。 Center widget可以将其子widget树对其到屏幕中心
////          child: new Text('hello world'),
////          child: new Text(wordPair.asPascalCase),
//          child: new RandomWords(),
//        ),
//      ),
      home: new RandomWords(),
    );
  }
}

class RandomWords extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new RandomWordsState();
  }
//  @override
//  createState() => new RandomWordsState();

}

class RandomWordsState extends State<RandomWords> {
  final _saved = new Set<WordPair>();

  //_suggestions列表以保存建议的单词对。 该变量以下划线（_）开头，在Dart语言中使用下划线前缀标识符，会强制其变成私有的
  final _suggestions = <WordPair>[];

  //biggerFont变量来增大字体大小
  final _biggerFont = const TextStyle(fontSize: 18.0);

  @override
  Widget build(BuildContext context) {
//    final wordPair = new WordPair.random();
//    return new Text(wordPair.asPascalCase);
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Startup Name ListView'),
        actions: <Widget>[
          new IconButton(icon: new Icon(Icons.list), onPressed: _pushSaved)
        ],
      ),
      body: _buildSuggestions(),
    );
  }

  //法构建显示建议单词对的ListView
  Widget _buildSuggestions() {
    return new ListView.builder(
        padding: const EdgeInsets.all(16.0),
        // 对于每个建议的单词对都会调用一次itemBuilder，然后将单词对添加到ListTile行中
        // 在偶数行，该函数会为单词对添加一个ListTile row.
        // 在奇数行，该行书湖添加一个分割线widget，来分隔相邻的词对。
        // 注意，在小屏幕上，分割线看起来可能比较吃力。
        itemBuilder: (context, i) {
          // 如果是奇数,在每一列之前，添加一个1像素高的分隔线widget
          if (i.isOdd) {
            return new Divider(color: Colors.red);
          }
          // 语法 "i ~/ 2" 表示i除以2，但返回值是整形（向下取整），比如i为：1, 2, 3, 4, 5
          // 时，结果为0, 1, 1, 2, 2， 这可以计算出ListView中减去分隔线后的实际单词对数量
          final index = i ~/ 2;
          // 如果是建议列表中最后一个单词对
          if (index >= _suggestions.length) {
            // ...接着再生成10个单词对，然后添加到建议列表
            _suggestions.addAll(generateWordPairs().take(10));
          }
          return _buildRow(_suggestions[index]);
        });
  }

  Widget _buildRow(WordPair pair) {
    final alreadySaved = _saved.contains(pair);
    return new ListTile(
      leading: new Icon(Icons.android),
      title: new Text(
        pair.asPascalCase,
        style: _biggerFont,
      ),
      //心形2状态图标
      trailing: new Icon(
        alreadySaved ? Icons.favorite : Icons.favorite_border,
        color: alreadySaved ? Colors.red : Colors.grey,
      ),
      //点击事件
      onTap: () {
        setState(() {
          if (alreadySaved) {
            _saved.remove(pair);
          } else {
            _saved.add(pair);
          }
        });
      },
    );
  }

  void _pushSaved() {
    //建立一个路由并将其推入到导航管理器栈中。此操作会切换页面以显示新路由。
    Navigator.of(context).push(new MaterialPageRoute(builder: (context) {
      final tiles = _saved.map(
            (pair) {
          return new ListTile(
            title: new Text(
              pair.asPascalCase,
              style: _biggerFont,
            ),
          );
        },
      );
      final divided = ListTile
          .divideTiles(tiles: tiles, context: context, color: Colors.green)
          .toList();
      return new Scaffold(
        appBar: new AppBar(
          title: new Text('保存的 Suggestions'),
        ),
        body: new ListView(children: divided),
      );
    }));
  }
}
