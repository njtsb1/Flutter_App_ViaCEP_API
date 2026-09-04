import 'package:flutter/material.dart';
import '../models/cep.dart';

class CepTile extends StatelessWidget {
  final Cep cep;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const CepTile({
    Key? key,
    required this.cep,
    required this.onEdit,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text('${cep.cep} - ${cep.city}/${cep.state}'),
      subtitle: Text('${cep.street} • ${cep.neighborhood}'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(icon: Icon(Icons.edit), onPressed: onEdit),
          IconButton(icon: Icon(Icons.delete), onPressed: onDelete),
        ],
      ),
    );
  }
}
