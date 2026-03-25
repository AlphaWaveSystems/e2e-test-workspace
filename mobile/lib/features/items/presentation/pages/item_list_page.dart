import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/item_provider.dart';

class ItemListPage extends StatelessWidget {
  const ItemListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Items'),
      ),
      body: Consumer<ItemProvider>(
        builder: (context, provider, _) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: TextField(
                  key: const ValueKey('search_field'),
                  decoration: const InputDecoration(
                    hintText: 'Search items...',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                  ),
                  onChanged: provider.search,
                ),
              ),
              Expanded(
                child: provider.loading
                    ? const Center(child: CircularProgressIndicator())
                    : provider.items.isEmpty
                        ? Center(
                            child: Text(
                              'No items found',
                              key: const ValueKey('empty_state'),
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          )
                        : ListView.builder(
                            key: const ValueKey('scrollable_list'),
                            itemCount: provider.items.length,
                            itemBuilder: (context, index) {
                              final item = provider.items[index];
                              return Dismissible(
                                key: ValueKey('dismissible_${item.id}'),
                                direction: DismissDirection.endToStart,
                                background: Container(
                                  color: Colors.red,
                                  alignment: Alignment.centerRight,
                                  padding: const EdgeInsets.only(right: 16),
                                  child: const Icon(
                                    Icons.delete,
                                    color: Colors.white,
                                  ),
                                ),
                                onDismissed: (_) {
                                  provider.deleteItem(item.id);
                                },
                                child: ListTile(
                                  key: ValueKey('list_item_$index'),
                                  title: Text(item.title),
                                  subtitle: Text(item.description),
                                  leading: CircleAvatar(
                                    child: Text('${item.id}'),
                                  ),
                                ),
                              );
                            },
                          ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        key: const ValueKey('fab_add'),
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Add item tapped')),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
