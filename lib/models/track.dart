class Track{
  final String id;
  final String title;
  final String artist;
  final String image;
  final String previewUrl;

  Track({required this.id, required this.title, required this.artist, required this.image, required this.previewUrl});

  // Logica para la persistencia

  Map<String, dynamic> toMap() => {'id': id, 'title': title, 'artist': artist, 'image': image, 'previewUrl' : previewUrl};

  factory Track.fromMap(Map<String, dynamic> map)=> Track(
    id: map['id'], title: map['title'], artist: map['artist'], image: map['image'], previewUrl: map['previewUrl']
  );

  // to json

  factory Track.fromJson(Map<String, dynamic> json) {
    return Track(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? 'Misión Desconocida',
      artist: json['artist'] as String? ?? 'Operador Anónimo',
      image: json['image'] as String? ?? 'https://picsum.photos/200',
      // Validamos por si en la base de datos el campo llega como null
      previewUrl: json['preview_url'] as String? ?? '', 
    );
  }
}