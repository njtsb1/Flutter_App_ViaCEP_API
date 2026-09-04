import 'package:flutter/material.dart';
import '../models/cep.dart';
import '../services/via_cep_service.dart';
import '../services/parse_service.dart';

class CepFormScreen extends StatefulWidget {
  final ParseService parseService;
  final Cep? cep;

  const CepFormScreen({Key? key, required this.parseService, this.cep}) : super(key: key);

  @override
  _CepFormScreenState createState() => _CepFormScreenState();
}

class _CepFormScreenState extends State<CepFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _cepController = TextEditingController();
  final _streetController = TextEditingController();
  final _complementController = TextEditingController();
  final _neighborhoodController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _ibgeController = TextEditingController();
  final _giaController = TextEditingController();
  final _dddController = TextEditingController();
  final _siafiController = TextEditingController();

  final _viaCepService = ViaCepService();
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    if (widget.cep != null) {
      final c = widget.cep!;
      _cepController.text = c.cep;
      _streetController.text = c.street;
      _complementController.text = c.complement;
      _neighborhoodController.text = c.neighborhood;
      _cityController.text = c.city;
      _stateController.text = c.state;
      _ibgeController.text = c.ibge;
      _giaController.text = c.gia;
      _dddController.text = c.ddd;
      _siafiController.text = c.siafi;
    }
  }

  @override
  void dispose() {
    _cepController.dispose();
    _streetController.dispose();
    _complementController.dispose();
    _neighborhoodController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _ibgeController.dispose();
    _giaController.dispose();
    _dddController.dispose();
    _siafiController.dispose();
    super.dispose();
  }

  Future<void> _searchAndSave() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);
    final cepCode = _cepController.text.trim();

    try {
      final existing = await widget.parseService.getCepByCode(cepCode);
      if (existing != null && widget.cep == null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('CEP already exists in Back4App')));
        setState(() => _loading = false);
        return;
      }

      final viaCep = await _viaCepService.fetchCep(cepCode);
      if (viaCep == null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('CEP not found on ViaCEP')));
        setState(() => _loading = false);
        return;
      }

      if (widget.cep != null) {
        final updated = Cep(
          objectId: widget.cep!.objectId,
          cep: _cepController.text.trim(),
          street: _streetController.text.isEmpty ? viaCep.street : _streetController.text,
          complement: _complementController.text.isEmpty ? viaCep.complement : _complementController.text,
          neighborhood: _neighborhoodController.text.isEmpty ? viaCep.neighborhood : _neighborhoodController.text,
          city: _cityController.text.isEmpty ? viaCep.city : _cityController.text,
          state: _stateController.text.isEmpty ? viaCep.state : _stateController.text,
          ibge: _ibgeController.text.isEmpty ? viaCep.ibge : _ibgeController.text,
          gia: _giaController.text.isEmpty ? viaCep.gia : _giaController.text,
          ddd: _dddController.text.isEmpty ? viaCep.ddd : _dddController.text,
          siafi: _siafiController.text.isEmpty ? viaCep.siafi : _siafiController.text,
        );
        await widget.parseService.updateCep(updated);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('CEP updated')));
      } else {
        final newCep = Cep(
          cep: viaCep.cep,
          street: viaCep.street,
          complement: viaCep.complement,
          neighborhood: viaCep.neighborhood,
          city: viaCep.city,
          state: viaCep.state,
          ibge: viaCep.ibge,
          gia: viaCep.gia,
          ddd: viaCep.ddd,
          siafi: viaCep.siafi,
        );
        await widget.parseService.createCep(newCep);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('CEP saved to Back4App')));
      }

      Navigator.of(context).pop(true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      setState(() => _loading = false);
    }
  }

  Widget _buildTextField(String label, TextEditingController controller, {TextInputType keyboardType = TextInputType.text}) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(labelText: label),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.cep != null;
    return Scaffold(
      appBar: AppBar(title: Text(isEditing ? 'Edit CEP' : 'Add CEP')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _loading
            ? Center(child: CircularProgressIndicator())
            : Form(
                key: _formKey,
                child: ListView(
                  children: [
                    TextFormField(
                      controller: _cepController,
                      decoration: InputDecoration(labelText: 'CEP'),
                      keyboardType: TextInputType.number,
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) return 'CEP is required';
                        if (!RegExp(r'^\d{5}-?\d{3}$').hasMatch(v.trim())) return 'Invalid CEP format';
                        return null;
                      },
                    ),
                    SizedBox(height: 8),
                    _buildTextField('Street', _streetController),
                    _buildTextField('Complement', _complementController),
                    _buildTextField('Neighborhood', _neighborhoodController),
                    _buildTextField('City', _cityController),
                    _buildTextField('State', _stateController),
                    _buildTextField('IBGE', _ibgeController, keyboardType: TextInputType.number),
                    _buildTextField('GIA', _giaController),
                    _buildTextField('DDD', _dddController, keyboardType: TextInputType.number),
                    _buildTextField('SIAFI', _siafiController, keyboardType: TextInputType.number),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _searchAndSave,
                      child: Text(isEditing ? 'Update CEP' : 'Fetch from ViaCEP and Save'),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
