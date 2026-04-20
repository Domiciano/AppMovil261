import 'package:appmovil261/features/auth/domain/usecases/signup_usecase.dart';
import 'package:appmovil261/features/signup/ui/screens/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://pmijmrkaucdwadmnnvbo.supabase.co',
    anonKey: 'sb_publishable_8tS9o_mjkvKA4z9WUvRjCg_01oNcv6y',
  );
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: SignupScreen());
  }
}
