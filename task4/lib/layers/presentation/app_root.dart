import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:task4/layers/presentation/theme.dart';
import 'package:task4/layers/presentation/using_bloc/app_using_bloc.dart';
import 'package:task4/layers/presentation/using_provider/app_using_provider.dart';

import '../../main.dart';
import '../data/character_repository_impl.dart';
import '../data/source/local/local_storage.dart';
import '../data/source/network/api.dart';
import '../domain/usecase/get_all_characters.dart';

class AppRoot extends StatefulWidget {
  const AppRoot({super.key});

  @override
  State<AppRoot> createState() => _AppRootState();
}

class _AppRootState extends State<AppRoot> {
  late StateManagementOptions _currentOption;
  late GetAllCharacters _getAllCharacters;
  var themeMode = ThemeMode.light;

  @override
  void initState() {
    super.initState();
    _currentOption = StateManagementOptions.bloc;

    // Notice:
    //
    // Some state management packages are also D.I. (Dependency Injection)
    // solutions. To avoid polluting this example with unnecessary repetition,
    // we're creating the object instances here and passing them as parameters
    // to each state management's "root" widgets. Then we'll use the library's
    // specific D.I. widget to make the instance accessible to the rest of the
    // widget tree.
    //
    final api = ApiImpl();
    final localStorage = LocalStorageImpl(sharedPreferences: sharedPref);
    final repo = CharacterRepositoryImpl(api: api, localStorage: localStorage);

    _getAllCharacters = GetAllCharacters(repository: repo);
  }

  @override
  Widget build(BuildContext context) {
    const theme = CustomTheme();

    return MaterialApp(
      themeMode: themeMode,
      theme: theme.toThemeData(),
      darkTheme: theme.toThemeDataDark(),
      debugShowCheckedModeBanner: false,
      home: Builder(
        builder: (context) {
          final tt = Theme.of(context).textTheme;
          final cs = Theme.of(context).colorScheme;
          return Scaffold(
            extendBodyBehindAppBar: true,
            appBar: AppBar(
              title: Transform.translate(
                offset: const Offset(10, 0),
                child: Text(
                  "Hello Ifrah \n Welcome Back\n Let's Start",
                  style: tt.headlineLarge!.copyWith(
                    color: cs.onSurfaceVariant,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ).animate().fadeIn(delay: .8.seconds, duration: .7.seconds),
              actions: [
                // IconButton(
                //   onPressed: () {
                //     final useLight = themeMode == ThemeMode.dark ? true : false;
                //     handleBrightnessChange(useLight);
                //   },
                //   icon: const Icon(Icons.light_mode),
                // ),
                // PopupMenuButton<StateManagementOptions>(
                //   onSelected: (value) => setState(() {
                //     _currentOption = value;
                //   }),
                //   itemBuilder: (context) => [
                //     _menuEntry(StateManagementOptions.bloc, 'Bloc'),
                //     _menuEntry(StateManagementOptions.provider, 'Provider'),
                //   ],
                // ),
              ],
            ),
            body: _getAppUsing(stateManagement: _currentOption)
                .animate()
                .fadeIn(delay: 1.2.seconds, duration: .7.seconds),
          );
        },
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // _Helpers
  // ---------------------------------------------------------------------------

  Widget _getAppUsing({required StateManagementOptions stateManagement}) {
    switch (stateManagement) {
      case (StateManagementOptions.bloc):
        return AppUsingBloc(getAllCharacters: _getAllCharacters);
      // case (StateManagementOptions.cubit):
      //   return AppUsingCubit(getAllCharacters: _getAllCharacters);

      case (StateManagementOptions.provider):
        return AppUsingProvider(getAllCharacters: _getAllCharacters);

      default:
        return Container();
    }
  }

  PopupMenuItem<StateManagementOptions> _menuEntry(
    StateManagementOptions option,
    String text,
  ) {
    final isSelected = _currentOption == option;
    final textTheme = Theme.of(context)
        .textTheme
        .apply(displayColor: Theme.of(context).colorScheme.onSurface);

    return PopupMenuItem<StateManagementOptions>(
      value: option,
      child: Text(
        isSelected ? 'using $text' : 'use $text',
        style: textTheme.bodyMedium!.copyWith(
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          color: isSelected ? Colors.red : Colors.black,
        ),
      ),
    );
  }

  String getTitleToOption(StateManagementOptions option) {
    switch (option) {
      case (StateManagementOptions.bloc):
        return 'BLOC';
      // case (StateManagementOptions.cubit):
      //   return 'Cubit';
      case (StateManagementOptions.provider):
        return 'Provider';

      default:
        return '';
    }
  }

  bool get useLightMode {
    switch (themeMode) {
      case ThemeMode.system:
        return View.of(context).platformDispatcher.platformBrightness ==
            Brightness.light;
      case ThemeMode.light:
        return true;
      case ThemeMode.dark:
        return false;
    }
  }

  void handleBrightnessChange(bool useLightMode) {
    setState(() {
      themeMode = useLightMode ? ThemeMode.light : ThemeMode.dark;
    });
  }
}
