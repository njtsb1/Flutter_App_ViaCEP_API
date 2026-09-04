class Cep {
  final String? objectId;
  final String cep;
  final String street;
  final String complement;
  final String neighborhood;
  final String city;
  final String state;
  final String ibge;
  final String gia;
  final String ddd;
  final String siafi;

  Cep({
    this.objectId,
    required this.cep,
    required this.street,
    required this.complement,
    required this.neighborhood,
    required this.city,
    required this.state,
    required this.ibge,
    required this.gia,
    required this.ddd,
    required this.siafi,
  });

  factory Cep.fromJson(Map<String, dynamic> json) {
    return Cep(
      objectId: json['objectId'] as String?,
      cep: (json['cep'] as String?) ?? '',
      street: (json['logradouro'] as String?) ?? '',
      complement: (json['complemento'] as String?) ?? '',
      neighborhood: (json['bairro'] as String?) ?? '',
      city: (json['localidade'] as String?) ?? '',
      state: (json['uf'] as String?) ?? '',
      ibge: (json['ibge'] as String?) ?? '',
      gia: (json['gia'] as String?) ?? '',
      ddd: (json['ddd'] as String?) ?? '',
      siafi: (json['siafi'] as String?) ?? '',
    );
  }

  factory Cep.fromParse(Map<String, dynamic> parseObject) {
    return Cep(
      objectId: parseObject['objectId'] as String?,
      cep: (parseObject['cep'] as String?) ?? '',
      street: (parseObject['logradouro'] as String?) ?? '',
      complement: (parseObject['complemento'] as String?) ?? '',
      neighborhood: (parseObject['bairro'] as String?) ?? '',
      city: (parseObject['localidade'] as String?) ?? '',
      state: (parseObject['uf'] as String?) ?? '',
      ibge: (parseObject['ibge'] as String?) ?? '',
      gia: (parseObject['gia'] as String?) ?? '',
      ddd: (parseObject['ddd'] as String?) ?? '',
      siafi: (parseObject['siafi'] as String?) ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (objectId != null) 'objectId': objectId,
      'cep': cep,
      'street': street,
      'complement': complement,
      'neighborhood': neighborhood,
      'city': city,
      'state': state,
      'ibge': ibge,
      'gia': gia,
      'ddd': ddd,
      'siafi': siafi,
    };
  }

  Map<String, dynamic> toParseMap() {
    return {
      'cep': cep,
      'logradouro': street,
      'complemento': complement,
      'bairro': neighborhood,
      'localidade': city,
      'uf': state,
      'ibge': ibge,
      'gia': gia,
      'ddd': ddd,
      'siafi': siafi,
    };
  }

  Cep copyWith({
    String? objectId,
    String? cep,
    String? street,
    String? complement,
    String? neighborhood,
    String? city,
    String? state,
    String? ibge,
    String? gia,
    String? ddd,
    String? siafi,
  }) {
    return Cep(
      objectId: objectId ?? this.objectId,
      cep: cep ?? this.cep,
      street: street ?? this.street,
      complement: complement ?? this.complement,
      neighborhood: neighborhood ?? this.neighborhood,
      city: city ?? this.city,
      state: state ?? this.state,
      ibge: ibge ?? this.ibge,
      gia: gia ?? this.gia,
      ddd: ddd ?? this.ddd,
      siafi: siafi ?? this.siafi,
    );
  }

  @override
  String toString() {
    return 'Cep(objectId: $objectId, cep: $cep, city: $city, state: $state)';
  }
}
