import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import '../models/cep.dart';

class ParseService {
  final String appId;
  final String clientKey;
  final String parseServerUrl;

  ParseService({
    required this.appId,
    required this.clientKey,
    required this.parseServerUrl,
  });

  Future<void> initialize() async {
    await Parse().initialize(
      appId,
      parseServerUrl,
      clientKey: clientKey,
      debug: true,
    );
  }

  Future<Cep?> getCepByCode(String cepCode) async {
    final query = QueryBuilder<ParseObject>(ParseObject('Cep'))
      ..whereEqualTo('cep', cepCode);
    final response = await query.query();

    if (response.success && response.results != null && response.results!.isNotEmpty) {
      final obj = response.results!.first as ParseObject;
      final map = <String, dynamic>{
        'objectId': obj.objectId,
        'cep': obj.get<String>('cep'),
        'logradouro': obj.get<String>('logradouro'),
        'complemento': obj.get<String>('complemento'),
        'bairro': obj.get<String>('bairro'),
        'localidade': obj.get<String>('localidade'),
        'uf': obj.get<String>('uf'),
        'ibge': obj.get<String>('ibge'),
        'gia': obj.get<String>('gia'),
        'ddd': obj.get<String>('ddd'),
        'siafi': obj.get<String>('siafi'),
      };
      return Cep.fromParse(map);
    }
    return null;
  }

  Future<Cep> createCep(Cep cep) async {
    final parseObject = ParseObject('Cep');
    final data = cep.toParseMap();
    data.forEach((key, value) => parseObject.set(key, value));

    final response = await parseObject.save();

    if (response.success && response.results != null && response.results!.isNotEmpty) {
      final saved = response.results!.first as ParseObject;
      return Cep.fromParse({
        'objectId': saved.objectId,
        'cep': saved.get<String>('cep'),
        'logradouro': saved.get<String>('logradouro'),
        'complemento': saved.get<String>('complemento'),
        'bairro': saved.get<String>('bairro'),
        'localidade': saved.get<String>('localidade'),
        'uf': saved.get<String>('uf'),
        'ibge': saved.get<String>('ibge'),
        'gia': saved.get<String>('gia'),
        'ddd': saved.get<String>('ddd'),
        'siafi': saved.get<String>('siafi'),
      });
    }

    throw Exception('Failed to save CEP to Back4App');
  }

  Future<List<Cep>> listCeps() async {
    final query = QueryBuilder<ParseObject>(ParseObject('Cep'))
      ..orderByDescending('createdAt');
    final response = await query.query();

    if (response.success && response.results != null) {
      return response.results!
          .map((e) {
            final obj = e as ParseObject;
            return Cep.fromParse({
              'objectId': obj.objectId,
              'cep': obj.get<String>('cep'),
              'logradouro': obj.get<String>('logradouro'),
              'complemento': obj.get<String>('complemento'),
              'bairro': obj.get<String>('bairro'),
              'localidade': obj.get<String>('localidade'),
              'uf': obj.get<String>('uf'),
              'ibge': obj.get<String>('ibge'),
              'gia': obj.get<String>('gia'),
              'ddd': obj.get<String>('ddd'),
              'siafi': obj.get<String>('siafi'),
            });
          })
          .toList();
    }

    return [];
  }

  Future<void> updateCep(Cep cep) async {
    if (cep.objectId == null) throw Exception('objectId is required to update');

    final parseObject = ParseObject('Cep')..objectId = cep.objectId;
    final data = cep.toParseMap();
    data.forEach((key, value) => parseObject.set(key, value));

    final response = await parseObject.save();
    if (!response.success) {
      throw Exception('Failed to update CEP');
    }
  }

  Future<void> deleteCep(String objectId) async {
    final parseObject = ParseObject('Cep')..objectId = objectId;
    final response = await parseObject.delete();
    if (!response.success) {
      throw Exception('Failed to delete CEP');
    }
  }
}
