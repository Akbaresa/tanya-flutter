import 'package:flutter/material.dart';
import 'package:flutter_application_1/controllers/login_controller.dart';
import 'package:flutter_application_1/screen/auth/widget/profil.dart';
import 'package:flutter_application_1/utils/api_endpoints.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_application_1/model/lazy_load.dart';
import 'package:flutter_application_1/screen/auth/widget/lazy_load.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../controllers/pertanyaan_controller.dart';
import '../screen/auth/auth_screen.dart';

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final LoginController loginController = Get.put(LoginController());
  final PertanyaanController pertanyaanController = Get.put(PertanyaanController());
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  late ScrollController _scrollController;
  late List<Lazy_load> _loadedPosts;
  late bool _isLoading;
  late int _currentPage;
  late int _itemPerPage;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<List<Lazy_load>> fetchPosts(int currentPage, int itemPerPage) async {
    var url = Uri.parse(
        '${ApiEndPoints.baseUrl}${ApiEndPoints.authEndpoints.lazy_load}?itemPerPage=$itemPerPage&currentPage=$currentPage'
    );

    http.Response response = await http.get(url);

    if (response.statusCode == 200) {
      var getPostsData = json.decode(response.body) as List;
      var listPosts = getPostsData.map((i) => Lazy_load.fromJson(i)).toList();
      return listPosts;
    } else {
      throw Exception('Failed to load Posts');
    }
  }

  @override
  void initState() {
    super.initState();
    _loadedPosts = [];
    _isLoading = false;
    _scrollController = ScrollController()
      ..addListener(() {
        if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent) {
          _loadMoreData();
        }
      });

    _currentPage = 1;
    _itemPerPage = 5;

    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      List<Lazy_load> posts = await fetchPosts(_currentPage, _itemPerPage);
      setState(() {
        _loadedPosts.addAll(posts);
        _isLoading = false;
        _currentPage++;
      });
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      print('Error loading data: $error');
    }
  }

  Future<void> _loadMoreData() async {
    if (_isLoading) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      List<Lazy_load> morePosts = await fetchPosts(_currentPage, _itemPerPage);
      setState(() {
        _loadedPosts.addAll(morePosts);
        _isLoading = false;
        _currentPage++;
      });
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      print('Error loading more data: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pertanyaan List'),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () async {
              await loginController.logout();
            },
            child: const Text(
              'Logout',
              style: TextStyle(color: Colors.white),
            ),
          ),
          TextButton(
            onPressed: () async {
              final SharedPreferences? prefs = await _prefs;
              Get.off(ProfilScreen());
            },
            child: const Text(
              'profil',
              style: TextStyle(color: Colors.white),
            )),
          IconButton(
            onPressed: () async {
              _showAddQuestionModal(context);
            },
            icon: const Icon(
              Icons.add,
              color: Colors.white,
            ),
            tooltip: 'Tambah Pertanyaan',
          )
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: _buildListView(),
        ),
      ),
    );
  }

  Widget _buildListView() {
    return ListView.builder(
      controller: _scrollController,
      itemCount: _loadedPosts.length + (_isLoading ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == _loadedPosts.length) {
          return _buildLoadingIndicator();
        } else {
          return Column(
            children: [
              Lazy_loadCard(
                posts: _loadedPosts[index],
              ),
              const SizedBox(height: 20),
            ],
          );
        }
      },
    );
  }

  Widget _buildLoadingIndicator() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  void _showAddQuestionModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Tambah Pertanyaan',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: pertanyaanController.headerController,
                    decoration: const InputDecoration(
                      labelText: 'Header',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Header cannot be empty';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: pertanyaanController.deskripsiController,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      labelText: 'Deskripsi',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Deskripsi cannot be empty';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState?.validate() ?? false) {
                        await pertanyaanController.tambahPertanyaan();
                        print('Header: ${pertanyaanController.headerController.text}');
                        print('Deskripsi: ${pertanyaanController.deskripsiController.text}');
                        Navigator.pop(context);
                      }
                    },
                    child: const Text('Submit'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
