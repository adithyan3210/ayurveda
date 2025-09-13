import 'package:flutter_modular/flutter_modular.dart';
import '../screens/splash_page.dart';
import '../screens/login_screen.dart';
import '../screens/home_screen.dart';
import 'screens/register_screen.dart';

class Routes extends Module {
  static const String splashScreen = '/';
  static const String loginScreen = '/login';
  static const String homeScreen = '/home';
  static const String registerScreen = '/register';

  @override
  void binds(i) {}
  @override
  void routes(r) {
    r.child(
      Modular.initialRoute,
      child: (context) => const SplashScreen(),
      transition: TransitionType.fadeIn,
    );
    r.child(
      loginScreen,
      child: (context) => const LoginScreen(),
      transition: TransitionType.rightToLeft,
    );
    r.child(
      homeScreen,
      child: (context) => const HomeScreen(),
      transition: TransitionType.rightToLeft,
    );
    r.child(
      registerScreen,
      child: (context) => const RegisterScreen(
        
      ),
      transition: TransitionType.rightToLeft,
    );
  }
}
