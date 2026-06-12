import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/track.dart';
import '../providers/music_provider.dart';

class TrackDetailScreen extends StatelessWidget {
  final Track track;
  const TrackDetailScreen({super.key, required this.track});

  @override
  Widget build(BuildContext context) {
    final musicProvider = context.watch<MusicProvider>();

    return Scaffold(
      appBar: AppBar(title: Text(track.title)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Hero(
              tag: 'avatar-${track.id}',
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: Image.network(track.image, width: 300, height: 300, fit: BoxFit.cover),
              ),
            ),
            const SizedBox(height: 30),
            Text(track.title, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            Text(track.artist, style: const TextStyle(fontSize: 18, color: Colors.grey)),
            const SizedBox(height: 40),
            AnimatedScale(
              scale: musicProvider.isPlaying ? 1.2 : 1.0,
              duration: const Duration(milliseconds: 200),
              child: IconButton(
                iconSize: 80,
                icon: Icon(musicProvider.isPlaying ? Icons.pause_circle_filled : Icons.play_circle_filled),
                onPressed: () => musicProvider.playTrack(track),
              ),
            )
          ],
        ),
      ),
    );
  }
}