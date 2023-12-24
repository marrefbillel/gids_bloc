import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gids_bloc/blocs/mw1_mw2/mw1_mw2_bloc.dart';
import 'package:gids_bloc/blocs/pitch_roll/pitch_roll_bloc.dart';
import 'package:gids_bloc/blocs/system_mode/system_mode_bloc.dart';
import 'package:gids_bloc/blocs/telecommand/telecommand_bloc.dart';
import 'package:gids_bloc/julian_converter.dart';
import 'package:gids_bloc/screens/north_south.dart';
import 'package:gids_bloc/screens/telemetry_display.dart';
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
    await windowManager.setSize(const Size(1600, 1020));
    await windowManager.setMinimumSize(const Size(800, 600));
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
          BlocProvider(create: (context) => SystemModeBloc()),
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
            title: const Text('East West Maneuver'),
            body: const TelemetryDisplay(),
          ),
          PaneItem(
            icon: const Icon(FluentIcons.mosty_cloudy_showers_day),
            title: const Text('North South Maneuver'),
            body: BlocProvider(
              create: (context) => TelecommandBloc(),
              child: const NorthSouth(),
            ),
          ),
          PaneItem(
              icon: const Icon(FluentIcons.machine_learning),
              title: const Text('Julian Converter'),
              body: const JulianConveter()),
        ],
        selected: _currentPage,
        onChanged: (index) => setState(() {
          _currentPage = index;
        }),
      ),
    );
  }
}
