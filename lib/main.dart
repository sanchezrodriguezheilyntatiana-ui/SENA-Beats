import 'package:flutter/material.dart';
import 'package:mi_primer_proyecto/providers/auth_provider.dart';
import 'package:mi_primer_proyecto/providers/favourites_provider.dart';
import 'package:mi_primer_proyecto/providers/music_provider.dart';
import 'package:mi_primer_proyecto/providers/profile_provider.dart';
import 'package:mi_primer_proyecto/screens/main_screen.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  // Asegurar los canales de flutter
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://rrmvdvtmdkqqwlrkiutv.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InJybXZkdnRtZGtxcXdscmtpdXR2Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODAwNzYxNjMsImV4cCI6MjA5NTY1MjE2M30.mtT4AqmB3QJjEBaQ33TnbgUB3cWd42GgrqF_XD4e0dI',
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => FavouritesProvider()),
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
        ChangeNotifierProvider(create: (_) => MusicProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: const SenaBeatsApp(),
    ),
  );
}

class SenaBeatsApp extends StatelessWidget {
  const SenaBeatsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<MusicProvider>(
      builder: (context, musicProvider, child) {
        return MaterialApp(
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(
              seedColor: musicProvider.themeColor,
              brightness: Brightness.dark,
            ),
          ),
          home: const MainScreen(),
        );
      },
    );
  }
}
