import 'package:flutter/material.dart';
import '../services/supabase_service.dart';
import '../models/track.dart';

class RemoteMissionsScreen extends StatefulWidget{
  const RemoteMissionsScreen({super.key});
  @override
  State<RemoteMissionsScreen> createState() => _RemoteMissionScreenState();
}

class _RemoteMissionScreenState extends State<RemoteMissionsScreen> {
  final SupabaseService _supabaseService = SupabaseService();
  late Future<List<Track>> _misionesFuture;

  @override
  void initState(){
    super.initState();
    _misionesFuture = _supabaseService.fetchMisionesRemotas();
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Text('📡 Servidor Central ShadowNet'),
        centerTitle: true,
      ),
      body: FutureBuilder<List<Track>>(
        future: _misionesFuture,
        builder: (context, snapshot) {
          // ESCENARIO 1: Los datos están viajando por la red (Cargando)
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          
          // ESCENARIO 2: Hubo un colapso en la red o el servicio falló
          if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('⚠️ Alerta: Conexión interrumpida por la IA Central.'),
            );
          }

          final misiones = snapshot.data!;

          // ESCENARIO 3: Éxito. Mostramos los datos en tiempo real de Supabase
          return ListView.builder(
            itemCount: misiones.length,
            itemBuilder: (context, index) {
              final misionesData = misiones[index];
              return ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    misionesData.image,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                ),
                title: Text(
                  misionesData.title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text('Asignado a: ${misionesData.artist}'),
                trailing: const Icon(Icons.cloud_download, color: Colors.cyan),
              );
            },
          );
        },
      ),
    );
  }
}