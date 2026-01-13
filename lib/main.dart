import 'package:flutter/material.dart';
import 'api.dart';
import 'item.dart';

void main() => runApp(const LostFoundApp());

class LostFoundApp extends StatelessWidget {
  const LostFoundApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lost & Found',
      theme: ThemeData(useMaterial3: true),
      home: const ItemsListScreen(),
    );
  }
}

class ItemsListScreen extends StatefulWidget {
  const ItemsListScreen({super.key});
  @override
  State<ItemsListScreen> createState() => _ItemsListScreenState();
}

class _ItemsListScreenState extends State<ItemsListScreen> {
  late Future<List<LostFoundItem>> _future;

  @override
  void initState() {
    super.initState();
    _future = Api.getItems();
  }

  void _refresh() {
    setState(() {
      _future = Api.getItems();
    });
  }
  IconData _iconForType(String type) =>
      type == 'LOST' ? Icons.report_problem : Icons.check_circle;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Lost & Found Items"),
        actions: [
          IconButton(onPressed: _refresh, icon: const Icon(Icons.refresh)),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final added = await Navigator.push<bool>(
            context,
            MaterialPageRoute(builder: (_) => const AddItemScreen()),
          );
          if (added == true) _refresh();
        },
        icon: const Icon(Icons.add),
        label: const Text("Add"),
      ),
      body: SafeArea(
        child: FutureBuilder<List<LostFoundItem>>(
          future: _future,
          builder: (context, snap) {
            if (snap.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snap.hasError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.error_outline, size: 44),
                      const SizedBox(height: 8),
                      Text("Error: ${snap.error}", textAlign: TextAlign.center),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: _refresh,
                        child: const Text("Retry"),
                      )
                    ],
                  ),
                ),
              );
            }

            final items = snap.data ?? [];
            if (items.isEmpty) {
              return const Center(child: Text("No items yet. Tap Add."));
            }

            return ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: items.length,
              itemBuilder: (context, i) {
                final item = items[i];
                return Card(
                  child: ListTile(
                    leading: Icon(_iconForType(item.type)),
                    title: Text(item.title),
                    subtitle: Text("${item.type} • ${item.location}"),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ItemDetailsScreen(item: item),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}


class ItemDetailsScreen extends StatelessWidget {
  final LostFoundItem item;
  const ItemDetailsScreen({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    String desc = item.description.trim().isEmpty ? "(No description)" : item.description;
    return Scaffold(
      appBar: AppBar(title: const Text("Item Details")),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        item.type,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    item.title,
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  _row("Location", item.location),
                  const SizedBox(height: 8),
                  _row("Description", desc),
                  const SizedBox(height: 8),
                  _row("Contact", item.contact),
                  const SizedBox(height: 8),
                  _row("Posted at", item.createdAt),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _row(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(width: 92, child: Text("$label:", style: const TextStyle(fontWeight: FontWeight.bold))),
        Expanded(child: Text(value)),
      ],
    );
  }
}


class AddItemScreen extends StatefulWidget {
  const AddItemScreen({super.key});
  @override
  State<AddItemScreen> createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  final _formKey = GlobalKey<FormState>();
  String _type = "LOST";
  final _title = TextEditingController();
  final _desc = TextEditingController();
  final _location = TextEditingController();
  final _contact = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _title.dispose();
    _desc.dispose();
    _location.dispose();
    _contact.dispose();
    super.dispose();
  }

  String? _req(String? v) => (v == null || v.trim().isEmpty) ? "Required" : null;
  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);

    try {
      await Api.addItem(
        type: _type,
        title: _title.text.trim(),
        description: _desc.text.trim(),
        location: _location.text.trim(),
        contact: _contact.text.trim(),
      );

      if (!mounted) return;
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed: $e")),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Item")),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                DropdownButtonFormField<String>(
                  initialValue: _type,
                  items: const [
                    DropdownMenuItem(value: "LOST", child: Text("LOST")),
                    DropdownMenuItem(value: "FOUND", child: Text("FOUND")),
                  ],
                  onChanged: (v) => setState(() => _type = v ?? "LOST"),
                  decoration: const InputDecoration(
                    labelText: "Type",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),

                TextFormField(
                  controller: _title,
                  validator: _req,
                  decoration: const InputDecoration(
                    labelText: "Title",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),

                TextFormField(
                  controller: _desc,
                  decoration: const InputDecoration(
                    labelText: "Description (optional)",
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 12),

                TextFormField(
                  controller: _location,
                  validator: _req,
                  decoration: const InputDecoration(
                    labelText: "Location",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),

                TextFormField(
                  controller: _contact,
                  validator: _req,
                  decoration: const InputDecoration(
                    labelText: "Contact (phone/email)",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _loading ? null : _submit,
                    child: Text(_loading ? "Submitting..." : "Submit"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
