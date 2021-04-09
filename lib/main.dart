import 'package:flutter/material.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:myanimelist_api/myanimelist_api.dart';
import 'package:shodana_mal/providers.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Required by FlutterConfig
  await FlutterConfig.loadEnvVariables();

  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Initialize client
    var apiKey = FlutterConfig.get('MYANIMELIST_TOKEN');
    var client = Client(apiKey != null ? apiKey : '');

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Home(
        title: 'Riverpod Demo',
        client: client,
      ),
    );
  }
}

class Home extends HookWidget {
  Home({Key key, this.title, this.client}) : super(key: key);

  final String title;
  final Client client;

  @override
  Widget build(BuildContext context) {
    final text = useProvider(textProvider);
    final future = useProvider(futureProvider);
    final stream = useProvider(streamProvider);
    final stateP = useProvider(stateProvider);

    final int stateNotifierState = useProvider(stateNotifierProvider.state);
    final changeNotifier = useProvider(changeNotifierProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(text),
            SizedBox(height: 20),
            future.when(
              data: (config) {
                return Text("Future Provider: " + config.toString());
              },
              loading: () => CircularProgressIndicator(),
              error: (err, stack) => Text("Error: " + err),
            ),
            SizedBox(height: 20),
            stream.when(
              data: (config) {
                return Text("Stream Provider: " + config.toString());
              },
              loading: () => CircularProgressIndicator(),
              error: (err, stack) => Text("Error: " + err),
            ),
            SizedBox(height: 20),
            Text("State Provider: " + stateP.state.toString()),
            SizedBox(height: 20),
            Text("StateNotifier Provider: " + stateNotifierState.toString()),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    context.read(stateNotifierProvider).add();
                  }, 
                  child: Text("add"),
                ),
                ElevatedButton(
                  onPressed: () {
                    context.read(stateNotifierProvider).subtract();
                  },
                  child: Text("subtract")
                ),
              ],
            ),
            SizedBox(height: 20),
            Text("ChangeNotifier Provider: " + changeNotifier.number.toString()),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    changeNotifier.add();
                  }, 
                  child: Text("add"),
                ),
                ElevatedButton(
                  onPressed: () {
                    changeNotifier.subtract();
                  },
                  child: Text("subtract")
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
            stateP.state++;
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title, this.client}) : super(key: key);

  final String title;
  final Client client;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() async {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
