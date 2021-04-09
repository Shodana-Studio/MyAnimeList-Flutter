import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:myanimelist_api/myanimelist_api.dart';
import 'package:shodana_mal/providers/test_providers.dart';
import 'package:shodana_mal/providers/theme_provider.dart';
import 'package:shodana_mal/themes/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Required by FlutterConfig
  await FlutterConfig.loadEnvVariables();

  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final darkModeEnabled = useProvider(appThemeStateNotifier.state);
    return MaterialApp.router(
      routeInformationParser: BeamerRouteInformationParser(),
      routerDelegate: BeamerRouterDelegate(
        locationBuilder: SimpleLocationBuilder(
          routes: {
            '/': (context) => TestHome(title: 'Riverpod Demo'),
            '/settings': (context) => TestSettings()
          }
        )
      ),
      title: 'Flutter Demo',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: darkModeEnabled ? ThemeMode.dark : ThemeMode.light,
    );
  }
}

class TestHome extends HookWidget {
  TestHome({Key key, this.title}) : super(key: key);

  final String title;

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
            ElevatedButton(
              onPressed: () {
                context.beamToNamed('/settings');
              },
              child: Text("Settings")
            )
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

class TestSettings extends HookWidget {
  TestSettings({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final int stateNotifierState = useProvider(stateNotifierProvider.state);
    final changeNotifier = useProvider(changeNotifierProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Light Mode", style: Theme.of(context).textTheme.bodyText2,),
                DarkModeSwitch(),
                Text("Dark Mode", style: Theme.of(context).textTheme.bodyText2,),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class DarkModeSwitch extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final darkModeEnabled = context.read(appThemeStateNotifier.state);
    return Switch(
      value: darkModeEnabled,
      onChanged: (enabled) {
        if (enabled) {
          context.read(appThemeStateNotifier).setDarkTheme();
        } else {
          context.read(appThemeStateNotifier).setLightTheme();
        }
      },
    );
  }
}