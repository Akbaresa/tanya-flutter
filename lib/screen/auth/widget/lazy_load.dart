import 'package:flutter/material.dart';
import 'package:flutter_application_1/controllers/pertanyaan_controller.dart';
import 'package:flutter_application_1/model/lazy_load.dart';
import 'package:flutter_application_1/page/detail.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../controllers/komentar_controller.dart';

class Lazy_loadCard extends StatefulWidget {
  const Lazy_loadCard({Key? key, required this.posts}) : super(key: key);
  final Lazy_load posts;

  @override
  _Lazy_loadCardState createState() => _Lazy_loadCardState();
}

class _Lazy_loadCardState extends State<Lazy_loadCard> {
  bool isExpanded = false;
  TextEditingController commentController = TextEditingController();
  KomentarController komentarController = Get.put(KomentarController());
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: ((context) {
              return Detail(posts: widget.posts);
            }),
          ),
        );
      },
      child: Container(
        decoration: const BoxDecoration(color: Colors.white),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const CircleAvatar(
                  backgroundImage: NetworkImage(
                    'https://images.unsplash.com/photo-1584461808942-168c6c703b64?q=80&w=1887&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
                  ),
                  radius: 20,
                ),
                const SizedBox(width: 8),
                Text(' ${widget.posts.username} ${widget.posts.tanggal}'),
              ],
            ),
            Text(widget.posts.header, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text(widget.posts.deskripsi),
            const SizedBox(height: 20),
            Row(
              children: [
                InkWell(
                  onTap: () {
                    setState(() {
                      isExpanded = !isExpanded;
                    });
                  },
                  child: Row(
                    children: [
                      Icon(Icons.thumb_up),
                      Text(' ${widget.posts.suka.toString()}'),
                    ],
                  ),
                ),
                const SizedBox(width: 20),
                InkWell(
                  onTap: () {
                    setState(() {
                      isExpanded = !isExpanded;
                    });
                  },
                  child: Row(
                    children: [
                      Icon(Icons.comment),
                      Text(' ${widget.posts.totalKomentar.toString()}'),
                    ],
                  ),
                ),
              ],
            ),
            if (isExpanded)
              ...[
                const SizedBox(height: 10),
                TextField(
                  controller: commentController,
                  decoration: const InputDecoration(
                    hintText: 'Type your comment...',
                  ),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                onPressed: () async {
                print(commentController.text);
                await komentarController.tambahKomentar(commentController.text, widget.posts.id);
                  }
                ,
                child: const Text('Submit Comment'),
              ),

                ...widget.posts.komentar.map((komentar) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${komentar['nama']}  ${komentar['waktu']}'),
                      Text('${komentar['deskripsi']}'),
                      const SizedBox(height: 10),
                    ],
                  );
                }),
              ],
          ],
        ),
      ),
    );
  }
}
