import 'package:flutter/material.dart';

class ResourceItem {
  final String title;
  final String description;
  final String type;
  final IconData icon;

  ResourceItem({
    required this.title,
    required this.description,
    required this.type,
    required this.icon,
  });
}

class ResourcesScreen extends StatelessWidget {
  ResourcesScreen({super.key});

  final List<ResourceItem> _resources = [
    ResourceItem(
      title: 'Understanding Recovery',
      description: 'A comprehensive guide to the recovery process',
      type: 'Article',
      icon: Icons.article,
    ),
    ResourceItem(
      title: 'Support Group Directory',
      description: 'Find local and online support groups',
      type: 'Directory',
      icon: Icons.people,
    ),
    ResourceItem(
      title: 'Coping Strategies',
      description: 'Learn effective coping mechanisms',
      type: 'Video',
      icon: Icons.video_library,
    ),
    ResourceItem(
      title: 'Emergency Contacts',
      description: 'Important numbers and contacts',
      type: 'List',
      icon: Icons.phone,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Resources'),
      ),
      body: ListView.builder(
        itemCount: _resources.length,
        padding: const EdgeInsets.all(16),
        itemBuilder: (context, index) {
          final resource = _resources[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: ListTile(
              leading: CircleAvatar(
                child: Icon(resource.icon),
              ),
              title: Text(resource.title),
              subtitle: Text(resource.description),
              trailing: Chip(
                label: Text(resource.type),
              ),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: Text(resource.title),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(resource.icon, size: 48),
                        const SizedBox(height: 16),
                        Text(
                          'This is a placeholder for the ${resource.type.toLowerCase()} content. '
                          'In a real app, this would contain the actual resource material.',
                        ),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(ctx).pop(),
                        child: const Text('Close'),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
