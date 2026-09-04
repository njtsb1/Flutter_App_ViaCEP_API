import 'package:flutter_test/flutter_test.dart';
import 'package:cep_manager/models/cep.dart';
import 'services/fake_parse_service.dart';

void main() {
  group('FakeParseService flows', () {
    late FakeParseService service;

    setUp(() {
      service = FakeParseService();
    });

    test('create, list, get by code, update and delete', () async {
      await service.initialize();

      final cepToCreate = Cep(
        cep: '12345-678',
        street: 'Test Street',
        complement: 'Apt 1',
        neighborhood: 'Testhood',
        city: 'Test City',
        state: 'TS',
        ibge: '0000000',
        gia: '',
        ddd: '00',
        siafi: '0000',
      );

      final created = await service.createCep(cepToCreate);
      expect(created.objectId, isNotNull);
      expect(created.cep, '12345-678');

      final list1 = await service.listCeps();
      expect(list1.length, 1);
      expect(list1.first.cep, '12345-678');

      final fetched = await service.getCepByCode('12345-678');
      expect(fetched, isNotNull);
      expect(fetched!.cep, '12345-678');

      final updated = created.copyWith(street: 'Updated Street');
      await service.updateCep(updated);
      final fetchedAfterUpdate = await service.getCepByCode('12345-678');
      expect(fetchedAfterUpdate!.street, 'Updated Street');

      await service.deleteCep(created.objectId!);
      final listAfterDelete = await service.listCeps();
      expect(listAfterDelete, isEmpty);
    });

    test('getCepByCode returns null when not found', () async {
      final result = await service.getCepByCode('00000-000');
      expect(result, isNull);
    });

    test('update throws when objectId missing or not found', () async {
      final cep = Cep(
        objectId: null,
        cep: '99999-999',
        street: 'S',
        complement: '',
        neighborhood: '',
        city: '',
        state: '',
        ibge: '',
        gia: '',
        ddd: '',
        siafi: '',
      );

      expect(() => service.updateCep(cep), throwsA(isA<Exception>()));
    });

    test('delete throws when not found', () async {
      expect(() => service.deleteCep('non-existent-id'), throwsA(isA<Exception>()));
    });
  });
}
