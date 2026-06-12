import 'package:flutter/material.dart';
import 'package:mi_primer_proyecto/providers/auth_provider.dart';
import 'package:mi_primer_proyecto/screens/track_detail_screen.dart';
import 'package:provider/provider.dart';
import '../services/music_service.dart';
import '../providers/favourites_provider.dart';
import '../providers/music_provider.dart';
import '../models/track.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<Track> _results = [];
  bool _isLoading = false;

  final List<Track> _mosqueraTrends = [
    Track(
      id: 'm1',
      title: 'Pasodoble Mosqueruno',
      artist: 'Banda Sinfónica',
      image: 'https://via.placeholder.com/150',
      previewUrl: '...',
    ),
    Track(
      id: 'm2',
      title: 'Programando en el SENA',
      artist: 'ADSO Beats',
      image: 'https://via.placeholder.com/150',
      previewUrl: '...',
    ),
  ];

  // 2. BORRAMOS el AudioPlayer local y el _currentPlayingId.
  // Ya no los necesitamos aquí porque viven en el MusicProvider.

  void _search(String query) async {
    setState(() => _isLoading = true);
    final results = await MusicService().searchTracks(query);
    setState(() {
      _results = results;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final favProvider = context.watch<FavouritesProvider>();

    // 3. ESCUCHAMOS al proveedor de música global
    final musicProvider = context.watch<MusicProvider>();

    final authProvider = context.watch<AuthProvider>();

    final displayList = (_results.isEmpty && authProvider.isAtMosquera)
        ? _mosqueraTrends
        : _results;

    return Scaffold(
      appBar: AppBar(
        title: const Text('SENA Beats'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(120),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  onSubmitted: _search,
                  decoration: InputDecoration(
                    hintText: 'Buscar artista o canción...',
                    prefixIcon: const Icon(Icons.music_note),
                    filled: true,
                    fillColor: Colors.white10,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                color: authProvider.isAtMosquera
                    ? Colors.green[900]
                    : Colors.orange[900],
                child: Text(
                  authProvider.isAtMosquera
                      ? "📍 Estás en Mosquera - Disfrutando tendencias locales"
                      : "🌍 Actualmente no estás en Mosquera",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: displayList.length,
              itemBuilder: (context, index) {
                final track = displayList[index];
                final isFav = favProvider.favourites.any(
                  (t) => t.id == track.id,
                );

                // 4. Verificamos si ESTA canción específica es la que está sonando globalmente
                final isCurrentTrack =
                    musicProvider.currentTrack?.id == track.id;
                final isPlaying = isCurrentTrack && musicProvider.isPlaying;

                return Semantics(
                  label: "Canción: ${track.title} de ${track.artist}",
                  button: true,
                  child: ListTile(
                    leading: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => TrackDetailScreen(track: track),
                          ),
                        );
                      },
                      child: Hero(
                        tag: 'avatar-${track.id}',
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            track.image,
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                width: 50,
                                height: 50,
                                color: Colors.grey[800],
                                child: const Icon(
                                  Icons.broken_image,
                                  color: Colors.white54,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                    title: Text(
                      track.title,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(track.artist),
                    trailing: IconButton(
                      icon: Icon(
                        isFav ? Icons.favorite : Icons.favorite_border,
                        color: Colors.red,
                      ),
                      onPressed: () => favProvider.toggleFavourite(track),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
