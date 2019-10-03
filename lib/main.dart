import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:norris/Joke.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import 'joke_provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.red),
      home: ChangeNotifierProvider<JokeProvider>(
        builder: (_) => JokeProvider(),
        child: new List(),
      ),
    );
  }
}

class List extends StatefulWidget {
  @override
  _ListState createState() => _ListState();
}

class _ListState extends State<List> {
  @override
  void initState() {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.red));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var jokes = Provider.of<JokeProvider>(context).jokes.reversed.toList();
    bool isLoading = Provider.of<JokeProvider>(context).isLoading;
    bool hasError = Provider.of<JokeProvider>(context).error;
    return Scaffold(
      appBar: AppBar(
        title: Text("Norris"),
        centerTitle: true,
      ),
      body: jokes.length == 0
          ? (Center(
              child: Container(
                color: Colors.white,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.asset("assets/noth.png"),
                    Text("Click on the + button to load jokes")
                  ],
                ),
              ),
            ))
          : Padding(
              padding: EdgeInsets.all(10),
              child: ListView.builder(
                itemCount: jokes.length,
                itemBuilder: (context, index) {
                  Joke joke = jokes[index];
                  return Card(
                      elevation: 10,
                      child: Padding(
                        padding: EdgeInsets.all(5),
                        child: ListTile(
                          leading: CircleAvatar(
                            child: Image.network(
                              joke.iconUrl,
                              fit: BoxFit.cover,
                            ),
                          ),
                          subtitle: Text(
                            joke.value.trim(),
                          ),
                        ),
                      ));
                },
              ),
            ),
      floatingActionButton: isLoading
          ? CircularProgressIndicator()
          : Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                FloatingActionButton(
                  child: Icon(Icons.add),
                  onPressed: () {
                    Provider.of<JokeProvider>(context).fetchJokes();
                  },
                ),
                SizedBox(
                  width: 10,
                ),
                FloatingActionButton(
                  child: Icon(Icons.delete),
                  onPressed: () {
                    Provider.of<JokeProvider>(context).clearJokes();
                  },
                )
              ],
            ),
      bottomNavigationBar: hasError
          ? Card(
              color: Colors.red,
              child: Text(
                "Check your internet and try again",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            )
          : SizedBox(),
    );
  }
}
