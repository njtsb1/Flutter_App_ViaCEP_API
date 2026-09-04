import 'package:cep_manager/models/cep.dart';
import 'package:uuid/uuid.dart';

class FakeParseService {
  final Map<String, Cep> _store = {};
  final _uuid = Uuid();

  Future<void> initialize() async {
    return;
  }

  Future<Cep?> getCepByCode(String cepCode) async {
    try {
      return _store.values.firstWhere((c) => c.cep == cepCode);
    } catch (_) {
      return null;
    }
  }

  Future<Cep> createCep(Cep cep) async {
    final id = _uuid.v4();
    final saved = cep.copyWith(objectId: id);
    _store[id] = saved;
    return saved;
  }

  Future<List<Cep>> listCeps() async {
    final list = _store.values.toList();
    list.sort((a, b) {
      final aId = a.objectId ?? '';
      final bId = b.objectId ?? '';
      return bId.compareTo(aId);
    });
    return list;
  }

  Future<void> updateCep(Cep cep) async {
    if (cep.objectId == null) throw Exception('objectId is required to update');
    if (!_store.containsKey(cep.objectId)) throw Exception('Not found');
    _store[cep.objectId!] = cep;
  }

  Future<void> deleteCep(String objectId) async {
    if (!_store.containsKey(objectId)) throw Exception('Not found');
    _store.remove(objectId);
  }
}
