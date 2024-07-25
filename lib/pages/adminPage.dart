import 'package:flutter/material.dart';
import '../SQLHelper.dart';



class AdminPage extends StatefulWidget {
  const AdminPage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<AdminPage> {
  List<Map<String, dynamic>> _books = [];
  bool _isLoading = true;

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _authorController = TextEditingController();
  final TextEditingController _publishedTimeController = TextEditingController();
  final TextEditingController _genreController = TextEditingController();
  final TextEditingController _imageController = TextEditingController();

  void _refreshBooks() async {
    final data = await SQLHelper.getItems();
    setState(() {
      _books = data;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _refreshBooks();
  }

  void _showForm(int? id) async {
    if (id != null) {
      final existingBook = _books.firstWhere((element) => element['id'] == id);
      _titleController.text = existingBook['title'];
      _descriptionController.text = existingBook['description'];
      _authorController.text = existingBook['author'];
      _publishedTimeController.text = existingBook['published_time'];
      _genreController.text = existingBook['genre'];
      _imageController.text = existingBook['image'];
    } else {
      _titleController.clear();
      _descriptionController.clear();
      _authorController.clear();
      _publishedTimeController.clear();
      _genreController.clear();
      _imageController.clear();
    }

    showModalBottomSheet(
      context: context,
      elevation: 5,
      isScrollControlled: true,
      builder: (_) => Container(
        padding: EdgeInsets.only(
          top: 15,
          left: 15,
          right: 15,
          bottom: MediaQuery.of(context).viewInsets.bottom + 120,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(hintText: 'Title'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(hintText: 'Description'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _authorController,
              decoration: const InputDecoration(hintText: 'Author'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _publishedTimeController,
              decoration: const InputDecoration(hintText: 'Published Time'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _genreController,
              decoration: const InputDecoration(hintText: 'Genre'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _imageController,
              decoration: const InputDecoration(hintText: 'Image URL'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                if (id == null) {
                  await _addItem();
                } else {
                  await _updateItem(id);
                }

                Navigator.of(context).pop();
              },
              child: Text(id == null ? 'Create New' : 'Update'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _addItem() async {
    await SQLHelper.createItem(
      _titleController.text,
      _descriptionController.text,
      _authorController.text,
      _publishedTimeController.text,
      _genreController.text,
      _imageController.text,
    );
    _refreshBooks();
  }

  Future<void> _updateItem(int id) async {
    await SQLHelper.updateItem(
      id,
      _titleController.text,
      _descriptionController.text,
      _authorController.text,
      _publishedTimeController.text,
      _genreController.text,
      _imageController.text,
    );
    _refreshBooks();
  }

  void _deleteItem(int id) async {
    await SQLHelper.deleteItem(id);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Successfully deleted a book!')),
    );
    _refreshBooks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Book Page'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.grey, Colors.green],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: _books.length,
        itemBuilder: (context, index) => Card(
          color: Colors.green[600],
          margin: const EdgeInsets.all(15),
          child: ListTile(
            leading: _books[index]['image'] != null
                ? Image.network(
              _books[index]['image'],
              width: 50,
              height: 50,
              fit: BoxFit.cover,
            )
                : const Icon(Icons.book),
            title: Text(_books[index]['title']),
            subtitle: Text(_books[index]['author']),
            trailing: SizedBox(
              width: 100,
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () => _showForm(_books[index]['id']),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => _deleteItem(_books[index]['id']),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => _showForm(null),
      ),
    );
  }
}