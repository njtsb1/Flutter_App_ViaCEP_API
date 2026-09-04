import 'package:flutter/material.dart';
import '../models/cep.dart';
import '../services/parse_service.dart';
import '../widgets/cep_tile.dart';
import 'cep_form_screen.dart';

class CepListScreen extends StatefulWidget {
  final ParseService parseService;

  const CepListScreen({Key? key, required this.parseService}) : super(key: key);

  @override
  _CepListScreenState createState() => _CepListScreenState();
}

class _CepListScreenState extends State<CepListScreen> {
  late Future<List<Cep>> _futureCeps;

  @override
  void initState() {
    super.initState();
    _loadCeps();
  }

  void _loadCeps() {
    setState(() {
      _futureCeps = widget.parseService.listCeps();
    });
  }

  Future<void> _deleteCep(String objectId) async {
    try {
      await widget.parseService.deleteCep(objectId);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('CEP deleted')));
      _loadCeps();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Delete failed: $e')));
    }
  }

  void _openForm({Cep? cep}) async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => CepFormScreen(parseService: widget.parseService, cep: cep),
      ),
    );

    if (result == true) {
      _loadCeps();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('CEP Manager'),
      ),
      body: FutureBuilder<List<Cep>>(
        future: _futureCeps,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final ceps = snapshot.data ?? [];
          if (ceps.isEmpty) {
            return Center(child: Text('No CEPs saved yet'));
          }
          return RefreshIndicator(
            onRefresh: () async {
              _loadCeps();
              await _futureCeps;
            },
            child: ListView.builder(
              itemCount: ceps.length,
              itemBuilder: (context, index) {
                final cep = ceps[index];
                return CepTile(
                  cep: cep,
                  onEdit: () => _openForm(cep: cep),
                  onDelete: () {
                    if (cep.objectId != null) _deleteCep(cep.objectId!);
                  },
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openForm(),
        child: Icon(Icons.add),
      ),
    );
  }
}
