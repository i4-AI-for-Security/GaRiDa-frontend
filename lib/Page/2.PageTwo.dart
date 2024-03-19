// 본인 갤러리 화면 (2-1)
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:GaRiDa/database_helper.dart';
import './3.PageThree.dart';

class PageTwo extends StatefulWidget {
  const PageTwo({super.key});

  @override
  _PageTwoState createState() => _PageTwoState();
}

class _PageTwoState extends State<PageTwo> {
  late Future<List<Map<String, dynamic>>> _data;
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _data = _getData();
    _searchController = TextEditingController();
  }

  void _deleteItem(int itemId) async {
    await DatabaseHelper.instance.delete(itemId);
    setState(() {
      _data = _getData(); // Refresh the data after deletion
    });
  }

  Future<List<Map<String, dynamic>>> _getData() async {
    return await DatabaseHelper.instance.queryAll();
  }

  List<Map<String, dynamic>> _filteredData(
      List<Map<String, dynamic>> data, String query) {
    return data.where((item) {
      final title = item['title']; // 'title' 값 가져오기

      // null 체크를 수행하고, 소문자로 변환하여 검색
      return title != null && title.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100.0),
        child: SizedBox(
          height: 100,
          child: CupertinoNavigationBar(
            border: const Border(bottom: BorderSide.none),
            middle: const Text('My Repository'),
            leading: CupertinoButton(
              padding: const EdgeInsets.all(0.0),
              child: const Icon(Icons.settings_outlined,
                  color: CupertinoColors.black),
              onPressed: () {
                // Add your onPressed logic here
              },
            ),
            trailing: CupertinoButton(
              padding: const EdgeInsets.all(0.0),
              child: const Icon(Icons.search, color: CupertinoColors.black),
              onPressed: () {
                showSearch(
                    context: context, delegate: _DataSearch(data: _data));
              },
            ),
          ),
        ),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _data,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            List<Map<String, dynamic>> filteredData =
                _filteredData(snapshot.data!, _searchController.text);

            return ListView.builder(
              itemCount: filteredData.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(filteredData[index]['title']),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline_rounded),
                    onPressed: () {
                      _deleteItem(
                          filteredData[index]['id']); // Call delete function
                    },
                  ),
                  onTap: () {
                    // Navigate to PageThree with item data
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PageThree(
                          itemData: filteredData[index],
                        ),
                      ),
                    ).then((value) {
                      // Refresh the data when PageThree is popped
                      setState(() {
                        _data = _getData();
                      });
                    });
                  },
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFF1D5FC),
        foregroundColor: Colors.black,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const PageThree()),
          ).then((value) {
            // Refresh the data when PageThree is popped
            setState(() {
              _data = _getData();
            });
          });
        },
        shape: const CircleBorder(),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _DataSearch extends SearchDelegate<String> {
  final Future<List<Map<String, dynamic>>> data;

  _DataSearch({required this.data});

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // Build the results based on the search query
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: data,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          List<Map<String, dynamic>> filteredData =
              _filteredData(snapshot.data!, query);

          return ListView.builder(
            itemCount: filteredData.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(filteredData[index]['title']),
                onTap: () {
                  // Navigate to PageThree with item data
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PageThree(
                        itemData: filteredData[index],
                      ),
                    ),
                  ).then((value) {
                    // Handle actions after returning from PageThree
                  });
                },
              );
            },
          );
        }
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // Suggestions that are shown while typing in the search bar
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: data,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          List<Map<String, dynamic>> filteredData =
              _filteredData(snapshot.data!, query);

          return ListView.builder(
            itemCount: filteredData.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(filteredData[index]['title']),
                onTap: () {
                  // Show the selected suggestion in the search bar
                  query = filteredData[index]['title'];
                },
              );
            },
          );
        }
      },
    );
  }

  List<Map<String, dynamic>> _filteredData(
      List<Map<String, dynamic>> data, String query) {
    return data.where((item) {
      final title = item['title']; // 'title' 값 가져오기

      // null 체크를 수행하고, 소문자로 변환하여 검색
      return title != null && title.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }
}
