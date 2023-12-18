import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gids_bloc/blocs/mw1_mw2/mw1_mw2_bloc.dart';
import 'package:gids_bloc/blocs/pitch_roll/pitch_roll_bloc.dart';
import 'package:gids_bloc/blocs/telemetry_bloc.dart';
import 'package:gids_bloc/screens/telemetry_display.dart';
import 'package:gids_bloc/telemetry_page.dart';
import 'package:gids_bloc/windows_buttons.dart';
import 'package:window_manager/window_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //await Window.initialize();
  await WindowManager.instance.ensureInitialized();

  windowManager.waitUntilReadyToShow().then((_) async {
    await windowManager.setTitleBarStyle(
      TitleBarStyle.hidden,
      windowButtonVisibility: false,
    );
    await windowManager.setSize(const Size(1800, 1200));
    await windowManager.setMinimumSize(const Size(600, 400));
    await windowManager.center();
    await windowManager.show();
    await windowManager.setSkipTaskbar(false);
    //await Window.setEffect(effect: WindowEffect.aero);
  });
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FluentApp(
      theme: FluentThemeData(
        accentColor: Colors.blue,
        brightness: Brightness.dark,
      ),
      themeMode: ThemeMode.dark,
      debugShowCheckedModeBanner: false,
      title: 'NEW GIDS APP',
      home: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => PitchRollBloc()),
          BlocProvider(create: (context) => Mw1Mw2Bloc()),
        ],
        child: const MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentPage = 0;
  @override
  Widget build(BuildContext context) {
    return NavigationView(
      appBar: NavigationAppBar(
        title: DragToMoveArea(
          child: Align(
            alignment: AlignmentDirectional.centerStart,
            child: Container(
              margin: const EdgeInsets.only(left: 20),
              child: const Text(
                "New GIDS App",
                style: TextStyle(
                  fontSize: 28,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
        actions: const WindowButtons(),
        backgroundColor: Colors.teal,
        automaticallyImplyLeading: false,
      ),
      pane: NavigationPane(
        size: const NavigationPaneSize(
          openMinWidth: 250.0,
          openMaxWidth: 320.0,
        ),
        items: <NavigationPaneItem>[
          PaneItem(
            icon: const Icon(
              FluentIcons.home,
              size: 20,
            ),
            title: const Text('North South Maneuver'),
            body: const TelemetryDisplay(),
          ),
        ],
        selected: _currentPage,
        onChanged: (index) => setState(() {
          _currentPage = index;
        }),
      ),
    );
  }
}
