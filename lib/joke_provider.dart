import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:norris/Joke.dart';

class JokeProvider with ChangeNotifier {
  List<Joke> _jokes = [];
  bool loading = false;
  bool error = false;

  List<Joke> get jokes {
    return [..._jokes];
  }

  bool get isLoading {
    return loading;
  }

  bool get isError {
    return error;
  }

  void clearJokes() {
    _jokes.clear();
    notifyListeners();
  }

  void fetchJokes() async {
    loading = true;
    notifyListeners();

    try {
      var response = await http.get("https://api.chucknorris.io/jokes/random");
      if (response.statusCode == 200) {
        _jokes.add(Joke.fromMap(json.decode(response.body)));
        loading = false;
        error = false;
        notifyListeners();
      }
    } catch (_) {
      loading = false;
      error = true;
      notifyListeners();
    }
  }
}
