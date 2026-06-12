import 'package:flutter/material.dart';
import 'package:mi_primer_proyecto/providers/auth_provider.dart';
import 'package:mi_primer_proyecto/screens/remote_missions_screen.dart';
import 'package:mi_primer_proyecto/screens/search_screen.dart';
import 'package:mi_primer_proyecto/screens/favourites_screen.dart';
import 'package:mi_primer_proyecto/screens/profile_screen.dart';
import 'package:mi_primer_proyecto/widgets/MiniPlayer.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  // Lista de pantallas para navegar
  final List<Widget> _pages = [
    const SearchScreen(),
    const FavouritesScreen(),
    const ProfileScreen(),
    const RemoteMissionsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    // Escuchamos el estado de autenticación

    final authProvider = context.watch<AuthProvider>();

    if (!authProvider.isAuthenticated) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.lock_outline,
                size: 100,
                color: Colors.deepPurple,
              ),
              const SizedBox(height: 20),
              const Text(
                "SENA Beats Protegido",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                child: Text(
                  "Por seguridad, necesitamos validar tu identidad para continuar.",
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton.icon(
                onPressed: () => authProvider.authenticate(),
                icon: const Icon(Icons.fingerprint),
                label: const Text("Desbloquear con Huella"),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 15,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const MiniPlayer(),
          BottomNavigationBar(
            type: BottomNavigationBarType
                .fixed, 
            backgroundColor: Theme.of(
              context,
            ).colorScheme.surface, 
            selectedItemColor: Theme.of(
              context,
            ).colorScheme.primary,
            unselectedItemColor: Colors.grey,
            currentIndex: _currentIndex,
            onTap: (index) => setState(() => _currentIndex = index),
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.search),
                label: "Buscar",
              ),
              BottomNavigationBarItem(icon: Icon(Icons.web), label: "Misiones"),
              BottomNavigationBarItem(
                icon: Icon(Icons.favorite),
                label: "Favoritos",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Perfil',
              ),
            ],
          ),
        ],
      ),
    );
  }
}
