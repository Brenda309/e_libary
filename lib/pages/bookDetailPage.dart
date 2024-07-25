import 'package:flutter/material.dart';

class BookDetailPage extends StatefulWidget {
  final Map<String, dynamic> book;

  const BookDetailPage({Key? key, required this.book}) : super(key: key);

  @override
  _BookDetailPageState createState() => _BookDetailPageState();
}

class _BookDetailPageState extends State<BookDetailPage> {
  bool isRead = false;
  late double rating;

  @override
  void initState() {
    super.initState();
    // Set default rating if none provided
    rating = widget.book['rating']?.toDouble() ?? 4.0;
  }

  void _updateRating(double newRating) {
    setState(() {
      rating = newRating;
    });
  }

  @override
  Widget build(BuildContext context) {
    final String title = widget.book['title'] ?? 'Unknown Title';
    final String author = widget.book['author'] ?? 'Unknown Author';
    final String genre = widget.book['genre'] ?? 'Unknown Genre';
    final String publishedDate = widget.book['publishedDate'] ?? 'Unknown Date';
    final String description = widget.book['description'] ?? 'No Description Available';
    final String imageUrl = widget.book['image'] ?? '';
    // final double price = widget.book['price'] ?? 0.0;

    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Details'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.grey, Colors.brown],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 4,
                        offset: Offset(2, 2),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: imageUrl.isNotEmpty
                        ? Image.network(
                      imageUrl,
                      width: 250,
                      height: 250,
                      fit: BoxFit.cover,
                    )
                        : const Icon(Icons.book, size: 100),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: Text(
                  title,
                  style: textTheme.titleLarge,
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 8),
              Center(
                child: Text(
                  author,
                  style: textTheme.titleMedium?.copyWith(color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: Chip(
                  label: Text(genre),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Published Date: $publishedDate',
                style: textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),
              Text(
                description,
                style: textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Text(
                    'Rating: ',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  ...List.generate(
                    5,
                        (index) => Icon(
                      index < rating ? Icons.star : Icons.star_border,
                      color: Colors.yellow,
                      size: 20,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Slider(
                value: rating,
                min: 0,
                max: 5,
                divisions: 5,
                label: rating.toStringAsFixed(1),
                onChanged: (value) {
                  _updateRating(value);
                },
              ),
              const SizedBox(height: 16),
              CheckboxListTile(
                title: const Text('Mark as Read'),
                value: isRead,
                onChanged: (bool? value) {
                  setState(() {
                    isRead = value ?? false;
                  });
                },
                controlAffinity: ListTileControlAffinity.leading,
                activeColor: Colors.brown,
              ),
              const SizedBox(height: 16),
              // ElevatedButton(
              //   onPressed: () {
              //     // Add action for buying the book
              //   },
              //   child: Text('BUY | \$$price'),
              //   style: ElevatedButton.styleFrom(
              //     backgroundColor: Colors.green,
              //     padding: const EdgeInsets.symmetric(vertical: 16),
              //     textStyle: const TextStyle(fontSize: 16),
              //     shape: RoundedRectangleBorder(
              //       borderRadius: BorderRadius.circular(12),
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
