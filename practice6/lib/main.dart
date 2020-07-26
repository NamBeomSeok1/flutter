import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Repository {
  String name;
  String commitsUrl;
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<List<Repository>> _searchRepository() async {
    final res =
        await http.get('https://api.github.com/search/repositories?q=flutter');
    final searchResult = jsonDecode(res.body)['items'];

    final repositories = searchResult
        .map((items) => Repository()
          ..name = items['name']
          ..commitsUrl =
              items['commits_url'].toString().replaceAll("{/sha}", ""))
        .cast<Repository>()
        .toList();

    return repositories;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Repositories'),
      ),
      body: FutureBuilder<List<Repository>>(
          future: _searchRepository(),
          builder: (context, snapshot) {
            if (snapshot.hasData == false) {
              return LinearProgressIndicator();
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            } else {
              return Container(
                  child: ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  return ListTile(
                      title: Text(snapshot.data[index].name),
                      onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    second(snapshot.data[index].commitsUrl)),
                          ));
                },
              ));
            }
          }),
    );
  }
}

class second extends StatelessWidget {
  final String commitsUrl;
  second(this.commitsUrl);
  Future<List<String>> _searchCommit(String url) async {
    final res = await http.get(url);

    List<dynamic> commits = [];
    List<String> result = [];
    commits = jsonDecode(res.body);
    for (var i = 0; i < commits.length; i++) {
      result = jsonDecode(res.body)[i]['commit']['message'];
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Commits')),
        body: FutureBuilder(
            future: _searchCommit(commitsUrl),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Text(' no data');
              }
              return Column(children: <Widget>[
                ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    return Text(snapshot.data[index]);
                  },
                ),
              ]);
            }));
  }
}
