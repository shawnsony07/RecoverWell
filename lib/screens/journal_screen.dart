import 'package:flutter/material.dart';

class JournalEntry {
  final String title;
  final String content;
  final DateTime date;
  final String mood;

  JournalEntry({
    required this.title,
    required this.content,
    required this.date,
    required this.mood,
  });
}

class JournalScreen extends StatefulWidget {
  const JournalScreen({super.key});

  @override
  State<JournalScreen> createState() => _JournalScreenState();
}

class _JournalScreenState extends State<JournalScreen> {
  final List<JournalEntry> _entries = [
    JournalEntry(
      title: 'Making Progress',
      content: 'Today was a good day. I managed to stay focused and positive.',
      date: DateTime.now().subtract(const Duration(days: 1)),
      mood: '😊',
    ),
    JournalEntry(
      title: 'New Beginnings',
      content: 'Started my morning with meditation. Feeling hopeful.',
      date: DateTime.now().subtract(const Duration(days: 2)),
      mood: '😌',
    ),
  ];

  void _addNewEntry() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('New Journal Entry'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            TextField(
              decoration: const InputDecoration(labelText: 'Content'),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: ['😊', '😐', '😔'].map((emoji) {
                return InkWell(
                  onTap: () {},
                  child: Text(emoji, style: const TextStyle(fontSize: 24)),
                );
              }).toList(),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daily Journal'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNewEntry,
        child: const Icon(Icons.add),
      ),
      body: ListView.builder(
        itemCount: _entries.length,
        padding: const EdgeInsets.all(16),
        itemBuilder: (context, index) {
          final entry = _entries[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        entry.title,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      Text(
                        entry.mood,
                        style: const TextStyle(fontSize: 24),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(entry.content),
                  const SizedBox(height: 8),
                  Text(
                    '${entry.date.day}/${entry.date.month}/${entry.date.year}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
