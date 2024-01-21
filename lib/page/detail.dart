import 'package:flutter/material.dart';
import 'package:flutter_application_1/model/lazy_load.dart';

class Detail extends StatelessWidget {
  final Lazy_load posts;

  const Detail({Key? key, required this.posts}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Page'),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Username: ${posts.username}'),
            Text('Header: ${posts.header}'),
            const SizedBox(height: 20),
            Text('Deskripsi: ${posts.deskripsi}'),
            Text('Tanggal: ${posts.tanggal}'),
            Text('Suka: ${posts.suka.toString()}'),
            const SizedBox(height: 20),
            Text('Komentar:'),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: posts.komentar.map((komentar) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Text('ID Komentar: ${komentar['idKomentar']}'),
                    Text('Nama: ${komentar['nama']}'),
                    Text('Deskripsi: ${komentar['deskripsi']}'),
                    Text('Waktu: ${komentar['waktu']}'),
                    const SizedBox(height: 10),
                  ],
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
