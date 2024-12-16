import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // Import flutter_bloc
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:travel_buddy/app_state.dart';
import 'package:travel_buddy/auth/firebase_user_repository.dart';
import 'package:travel_buddy/screens/layout_screen.dart';
import 'package:travel_buddy/blocs/foursquare_bloc/foursquare_bloc.dart'; // Import your FoursquareBloc
import 'firebase_options.dart';
import 'screens/auth_form_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'screens/loading_screen.dart';
import 'theme/theme_data.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const App());
} 

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  bool _isLoading = true;
  bool _isAuthenticated = false;

  @override
  void initState() {
    super.initState();
    _checkAuthentication();
  }

  Future<void> _checkAuthentication() async {
    await Future.delayed(const Duration(milliseconds: 2500));

    final FirebaseUserRepository userRepository = FirebaseUserRepository();
    final user = await userRepository.getCurrentUser();
    if (user != null) {
      AppState.isAuthenticated = true;
      AppState.currentUser = user;
    }
    setState(() {
      _isAuthenticated = user != null;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<FoursquareBloc>(
      create: (_) => FoursquareBloc(), // Assuming FoursquareBloc requires no arguments
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        routes: {
          '/main': (context) => const LayoutScreen(),
          '/auth': (context) => const AuthFormScreen(),
        },
        title: 'Flutter Demo',
        theme: getThemeData(context),
        home: _isLoading
            ? const LoadingScreen()
            : _isAuthenticated
                ? const LayoutScreen()
                : const AuthFormScreen(),
      ),
    );
  }
}
