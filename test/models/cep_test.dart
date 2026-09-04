// test/models/cep_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:cep_manager/models/cep.dart';

void main() {
  group('Cep model', () {
    final sampleJson = {
      'objectId': 'abc123',
      'cep': '01001-000',
      'logradouro': 'Main Square',
      'complemento': 'odd side',
      'bairro': 'Central',
      'localidade': 'Sao Paulo',
      'uf': 'SP',
      'ibge': '3550308',
      'gia': '1004',
      'ddd': '11',
      'siafi': '7107',
    };

    test('fromJson maps Portuguese keys to English properties', () {
      final cep = Cep.fromJson(sampleJson);

      expect(cep.objectId, 'abc123');
      expect(cep.cep, '01001-000');
      expect(cep.street, 'Main Square');
      expect(cep.complement, 'odd side');
      expect(cep.neighborhood, 'Central');
      expect(cep.city, 'Sao Paulo');
      expect(cep.state, 'SP');
      expect(cep.ibge, '3550308');
      expect(cep.gia, '1004');
      expect(cep.ddd, '11');
      expect(cep.siafi, '7107');
    });

    test('toJson returns English keys and includes objectId when present', () {
      final cep = Cep.fromJson(sampleJson);
      final json = cep.toJson();

      expect(json['objectId'], 'abc123');
      expect(json['cep'], '01001-000');
      expect(json['street'], 'Main Square');
      expect(json['city'], 'Sao Paulo');
      expect(json['state'], 'SP');
    });

    test('toParseMap returns Portuguese keys for Parse/Back4App', () {
      final cep = Cep.fromJson(sampleJson);
      final parseMap = cep.toParseMap();

      expect(parseMap['cep'], '01001-000');
      expect(parseMap['logradouro'], 'Main Square');
      expect(parseMap['localidade'], 'Sao Paulo');
      expect(parseMap['uf'], 'SP');
      expect(parseMap.containsKey('street'), isFalse);
    });

    test('copyWith creates modified copy without mutating original', () {
      final cep = Cep.fromJson(sampleJson);
      final modified = cep.copyWith(city: 'Rio de Janeiro', state: 'RJ');

      expect(modified.city, 'Rio de Janeiro');
      expect(modified.state, 'RJ');
      expect(cep.city, 'Sao Paulo');
      expect(cep.state, 'SP');
    });

    test('toString contains key fields', () {
      final cep = Cep.fromJson(sampleJson);
      final s = cep.toString();
      expect(s.contains('01001-000'), isTrue);
      expect(s.contains('Sao Paulo'), isTrue);
    });
  });
}
