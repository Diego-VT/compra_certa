// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $CategoriasTable extends Categorias
    with TableInfo<$CategoriasTable, Categoria> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CategoriasTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nomeMeta = const VerificationMeta('nome');
  @override
  late final GeneratedColumn<String> nome = GeneratedColumn<String>(
    'nome',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoriaPaiIdMeta = const VerificationMeta(
    'categoriaPaiId',
  );
  @override
  late final GeneratedColumn<int> categoriaPaiId = GeneratedColumn<int>(
    'categoria_pai_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nivelMeta = const VerificationMeta('nivel');
  @override
  late final GeneratedColumn<int> nivel = GeneratedColumn<int>(
    'nivel',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _caminhoCompletoMeta = const VerificationMeta(
    'caminhoCompleto',
  );
  @override
  late final GeneratedColumn<String> caminhoCompleto = GeneratedColumn<String>(
    'caminho_completo',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _origemMeta = const VerificationMeta('origem');
  @override
  late final GeneratedColumn<String> origem = GeneratedColumn<String>(
    'origem',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isPadraoMeta = const VerificationMeta(
    'isPadrao',
  );
  @override
  late final GeneratedColumn<bool> isPadrao = GeneratedColumn<bool>(
    'is_padrao',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_padrao" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _ativoMeta = const VerificationMeta('ativo');
  @override
  late final GeneratedColumn<bool> ativo = GeneratedColumn<bool>(
    'ativo',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("ativo" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _criadoEmMeta = const VerificationMeta(
    'criadoEm',
  );
  @override
  late final GeneratedColumn<DateTime> criadoEm = GeneratedColumn<DateTime>(
    'criado_em',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _atualizadoEmMeta = const VerificationMeta(
    'atualizadoEm',
  );
  @override
  late final GeneratedColumn<DateTime> atualizadoEm = GeneratedColumn<DateTime>(
    'atualizado_em',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    nome,
    categoriaPaiId,
    nivel,
    caminhoCompleto,
    origem,
    isPadrao,
    ativo,
    criadoEm,
    atualizadoEm,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'categorias';
  @override
  VerificationContext validateIntegrity(
    Insertable<Categoria> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('nome')) {
      context.handle(
        _nomeMeta,
        nome.isAcceptableOrUnknown(data['nome']!, _nomeMeta),
      );
    } else if (isInserting) {
      context.missing(_nomeMeta);
    }
    if (data.containsKey('categoria_pai_id')) {
      context.handle(
        _categoriaPaiIdMeta,
        categoriaPaiId.isAcceptableOrUnknown(
          data['categoria_pai_id']!,
          _categoriaPaiIdMeta,
        ),
      );
    }
    if (data.containsKey('nivel')) {
      context.handle(
        _nivelMeta,
        nivel.isAcceptableOrUnknown(data['nivel']!, _nivelMeta),
      );
    } else if (isInserting) {
      context.missing(_nivelMeta);
    }
    if (data.containsKey('caminho_completo')) {
      context.handle(
        _caminhoCompletoMeta,
        caminhoCompleto.isAcceptableOrUnknown(
          data['caminho_completo']!,
          _caminhoCompletoMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_caminhoCompletoMeta);
    }
    if (data.containsKey('origem')) {
      context.handle(
        _origemMeta,
        origem.isAcceptableOrUnknown(data['origem']!, _origemMeta),
      );
    } else if (isInserting) {
      context.missing(_origemMeta);
    }
    if (data.containsKey('is_padrao')) {
      context.handle(
        _isPadraoMeta,
        isPadrao.isAcceptableOrUnknown(data['is_padrao']!, _isPadraoMeta),
      );
    }
    if (data.containsKey('ativo')) {
      context.handle(
        _ativoMeta,
        ativo.isAcceptableOrUnknown(data['ativo']!, _ativoMeta),
      );
    }
    if (data.containsKey('criado_em')) {
      context.handle(
        _criadoEmMeta,
        criadoEm.isAcceptableOrUnknown(data['criado_em']!, _criadoEmMeta),
      );
    }
    if (data.containsKey('atualizado_em')) {
      context.handle(
        _atualizadoEmMeta,
        atualizadoEm.isAcceptableOrUnknown(
          data['atualizado_em']!,
          _atualizadoEmMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Categoria map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Categoria(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      nome: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nome'],
      )!,
      categoriaPaiId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}categoria_pai_id'],
      ),
      nivel: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}nivel'],
      )!,
      caminhoCompleto: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}caminho_completo'],
      )!,
      origem: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}origem'],
      )!,
      isPadrao: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_padrao'],
      )!,
      ativo: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}ativo'],
      )!,
      criadoEm: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}criado_em'],
      )!,
      atualizadoEm: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}atualizado_em'],
      ),
    );
  }

  @override
  $CategoriasTable createAlias(String alias) {
    return $CategoriasTable(attachedDatabase, alias);
  }
}

class Categoria extends DataClass implements Insertable<Categoria> {
  final int id;
  final String nome;
  final int? categoriaPaiId;
  final int nivel;
  final String caminhoCompleto;
  final String origem;
  final bool isPadrao;
  final bool ativo;
  final DateTime criadoEm;
  final DateTime? atualizadoEm;
  const Categoria({
    required this.id,
    required this.nome,
    this.categoriaPaiId,
    required this.nivel,
    required this.caminhoCompleto,
    required this.origem,
    required this.isPadrao,
    required this.ativo,
    required this.criadoEm,
    this.atualizadoEm,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['nome'] = Variable<String>(nome);
    if (!nullToAbsent || categoriaPaiId != null) {
      map['categoria_pai_id'] = Variable<int>(categoriaPaiId);
    }
    map['nivel'] = Variable<int>(nivel);
    map['caminho_completo'] = Variable<String>(caminhoCompleto);
    map['origem'] = Variable<String>(origem);
    map['is_padrao'] = Variable<bool>(isPadrao);
    map['ativo'] = Variable<bool>(ativo);
    map['criado_em'] = Variable<DateTime>(criadoEm);
    if (!nullToAbsent || atualizadoEm != null) {
      map['atualizado_em'] = Variable<DateTime>(atualizadoEm);
    }
    return map;
  }

  CategoriasCompanion toCompanion(bool nullToAbsent) {
    return CategoriasCompanion(
      id: Value(id),
      nome: Value(nome),
      categoriaPaiId: categoriaPaiId == null && nullToAbsent
          ? const Value.absent()
          : Value(categoriaPaiId),
      nivel: Value(nivel),
      caminhoCompleto: Value(caminhoCompleto),
      origem: Value(origem),
      isPadrao: Value(isPadrao),
      ativo: Value(ativo),
      criadoEm: Value(criadoEm),
      atualizadoEm: atualizadoEm == null && nullToAbsent
          ? const Value.absent()
          : Value(atualizadoEm),
    );
  }

  factory Categoria.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Categoria(
      id: serializer.fromJson<int>(json['id']),
      nome: serializer.fromJson<String>(json['nome']),
      categoriaPaiId: serializer.fromJson<int?>(json['categoriaPaiId']),
      nivel: serializer.fromJson<int>(json['nivel']),
      caminhoCompleto: serializer.fromJson<String>(json['caminhoCompleto']),
      origem: serializer.fromJson<String>(json['origem']),
      isPadrao: serializer.fromJson<bool>(json['isPadrao']),
      ativo: serializer.fromJson<bool>(json['ativo']),
      criadoEm: serializer.fromJson<DateTime>(json['criadoEm']),
      atualizadoEm: serializer.fromJson<DateTime?>(json['atualizadoEm']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'nome': serializer.toJson<String>(nome),
      'categoriaPaiId': serializer.toJson<int?>(categoriaPaiId),
      'nivel': serializer.toJson<int>(nivel),
      'caminhoCompleto': serializer.toJson<String>(caminhoCompleto),
      'origem': serializer.toJson<String>(origem),
      'isPadrao': serializer.toJson<bool>(isPadrao),
      'ativo': serializer.toJson<bool>(ativo),
      'criadoEm': serializer.toJson<DateTime>(criadoEm),
      'atualizadoEm': serializer.toJson<DateTime?>(atualizadoEm),
    };
  }

  Categoria copyWith({
    int? id,
    String? nome,
    Value<int?> categoriaPaiId = const Value.absent(),
    int? nivel,
    String? caminhoCompleto,
    String? origem,
    bool? isPadrao,
    bool? ativo,
    DateTime? criadoEm,
    Value<DateTime?> atualizadoEm = const Value.absent(),
  }) => Categoria(
    id: id ?? this.id,
    nome: nome ?? this.nome,
    categoriaPaiId: categoriaPaiId.present
        ? categoriaPaiId.value
        : this.categoriaPaiId,
    nivel: nivel ?? this.nivel,
    caminhoCompleto: caminhoCompleto ?? this.caminhoCompleto,
    origem: origem ?? this.origem,
    isPadrao: isPadrao ?? this.isPadrao,
    ativo: ativo ?? this.ativo,
    criadoEm: criadoEm ?? this.criadoEm,
    atualizadoEm: atualizadoEm.present ? atualizadoEm.value : this.atualizadoEm,
  );
  Categoria copyWithCompanion(CategoriasCompanion data) {
    return Categoria(
      id: data.id.present ? data.id.value : this.id,
      nome: data.nome.present ? data.nome.value : this.nome,
      categoriaPaiId: data.categoriaPaiId.present
          ? data.categoriaPaiId.value
          : this.categoriaPaiId,
      nivel: data.nivel.present ? data.nivel.value : this.nivel,
      caminhoCompleto: data.caminhoCompleto.present
          ? data.caminhoCompleto.value
          : this.caminhoCompleto,
      origem: data.origem.present ? data.origem.value : this.origem,
      isPadrao: data.isPadrao.present ? data.isPadrao.value : this.isPadrao,
      ativo: data.ativo.present ? data.ativo.value : this.ativo,
      criadoEm: data.criadoEm.present ? data.criadoEm.value : this.criadoEm,
      atualizadoEm: data.atualizadoEm.present
          ? data.atualizadoEm.value
          : this.atualizadoEm,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Categoria(')
          ..write('id: $id, ')
          ..write('nome: $nome, ')
          ..write('categoriaPaiId: $categoriaPaiId, ')
          ..write('nivel: $nivel, ')
          ..write('caminhoCompleto: $caminhoCompleto, ')
          ..write('origem: $origem, ')
          ..write('isPadrao: $isPadrao, ')
          ..write('ativo: $ativo, ')
          ..write('criadoEm: $criadoEm, ')
          ..write('atualizadoEm: $atualizadoEm')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    nome,
    categoriaPaiId,
    nivel,
    caminhoCompleto,
    origem,
    isPadrao,
    ativo,
    criadoEm,
    atualizadoEm,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Categoria &&
          other.id == this.id &&
          other.nome == this.nome &&
          other.categoriaPaiId == this.categoriaPaiId &&
          other.nivel == this.nivel &&
          other.caminhoCompleto == this.caminhoCompleto &&
          other.origem == this.origem &&
          other.isPadrao == this.isPadrao &&
          other.ativo == this.ativo &&
          other.criadoEm == this.criadoEm &&
          other.atualizadoEm == this.atualizadoEm);
}

class CategoriasCompanion extends UpdateCompanion<Categoria> {
  final Value<int> id;
  final Value<String> nome;
  final Value<int?> categoriaPaiId;
  final Value<int> nivel;
  final Value<String> caminhoCompleto;
  final Value<String> origem;
  final Value<bool> isPadrao;
  final Value<bool> ativo;
  final Value<DateTime> criadoEm;
  final Value<DateTime?> atualizadoEm;
  const CategoriasCompanion({
    this.id = const Value.absent(),
    this.nome = const Value.absent(),
    this.categoriaPaiId = const Value.absent(),
    this.nivel = const Value.absent(),
    this.caminhoCompleto = const Value.absent(),
    this.origem = const Value.absent(),
    this.isPadrao = const Value.absent(),
    this.ativo = const Value.absent(),
    this.criadoEm = const Value.absent(),
    this.atualizadoEm = const Value.absent(),
  });
  CategoriasCompanion.insert({
    this.id = const Value.absent(),
    required String nome,
    this.categoriaPaiId = const Value.absent(),
    required int nivel,
    required String caminhoCompleto,
    required String origem,
    this.isPadrao = const Value.absent(),
    this.ativo = const Value.absent(),
    this.criadoEm = const Value.absent(),
    this.atualizadoEm = const Value.absent(),
  }) : nome = Value(nome),
       nivel = Value(nivel),
       caminhoCompleto = Value(caminhoCompleto),
       origem = Value(origem);
  static Insertable<Categoria> custom({
    Expression<int>? id,
    Expression<String>? nome,
    Expression<int>? categoriaPaiId,
    Expression<int>? nivel,
    Expression<String>? caminhoCompleto,
    Expression<String>? origem,
    Expression<bool>? isPadrao,
    Expression<bool>? ativo,
    Expression<DateTime>? criadoEm,
    Expression<DateTime>? atualizadoEm,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nome != null) 'nome': nome,
      if (categoriaPaiId != null) 'categoria_pai_id': categoriaPaiId,
      if (nivel != null) 'nivel': nivel,
      if (caminhoCompleto != null) 'caminho_completo': caminhoCompleto,
      if (origem != null) 'origem': origem,
      if (isPadrao != null) 'is_padrao': isPadrao,
      if (ativo != null) 'ativo': ativo,
      if (criadoEm != null) 'criado_em': criadoEm,
      if (atualizadoEm != null) 'atualizado_em': atualizadoEm,
    });
  }

  CategoriasCompanion copyWith({
    Value<int>? id,
    Value<String>? nome,
    Value<int?>? categoriaPaiId,
    Value<int>? nivel,
    Value<String>? caminhoCompleto,
    Value<String>? origem,
    Value<bool>? isPadrao,
    Value<bool>? ativo,
    Value<DateTime>? criadoEm,
    Value<DateTime?>? atualizadoEm,
  }) {
    return CategoriasCompanion(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      categoriaPaiId: categoriaPaiId ?? this.categoriaPaiId,
      nivel: nivel ?? this.nivel,
      caminhoCompleto: caminhoCompleto ?? this.caminhoCompleto,
      origem: origem ?? this.origem,
      isPadrao: isPadrao ?? this.isPadrao,
      ativo: ativo ?? this.ativo,
      criadoEm: criadoEm ?? this.criadoEm,
      atualizadoEm: atualizadoEm ?? this.atualizadoEm,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (nome.present) {
      map['nome'] = Variable<String>(nome.value);
    }
    if (categoriaPaiId.present) {
      map['categoria_pai_id'] = Variable<int>(categoriaPaiId.value);
    }
    if (nivel.present) {
      map['nivel'] = Variable<int>(nivel.value);
    }
    if (caminhoCompleto.present) {
      map['caminho_completo'] = Variable<String>(caminhoCompleto.value);
    }
    if (origem.present) {
      map['origem'] = Variable<String>(origem.value);
    }
    if (isPadrao.present) {
      map['is_padrao'] = Variable<bool>(isPadrao.value);
    }
    if (ativo.present) {
      map['ativo'] = Variable<bool>(ativo.value);
    }
    if (criadoEm.present) {
      map['criado_em'] = Variable<DateTime>(criadoEm.value);
    }
    if (atualizadoEm.present) {
      map['atualizado_em'] = Variable<DateTime>(atualizadoEm.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CategoriasCompanion(')
          ..write('id: $id, ')
          ..write('nome: $nome, ')
          ..write('categoriaPaiId: $categoriaPaiId, ')
          ..write('nivel: $nivel, ')
          ..write('caminhoCompleto: $caminhoCompleto, ')
          ..write('origem: $origem, ')
          ..write('isPadrao: $isPadrao, ')
          ..write('ativo: $ativo, ')
          ..write('criadoEm: $criadoEm, ')
          ..write('atualizadoEm: $atualizadoEm')
          ..write(')'))
        .toString();
  }
}

class $SeedExecutionsTable extends SeedExecutions
    with TableInfo<$SeedExecutionsTable, SeedExecution> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SeedExecutionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _seedKeyMeta = const VerificationMeta(
    'seedKey',
  );
  @override
  late final GeneratedColumn<String> seedKey = GeneratedColumn<String>(
    'seed_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _executadoEmMeta = const VerificationMeta(
    'executadoEm',
  );
  @override
  late final GeneratedColumn<DateTime> executadoEm = GeneratedColumn<DateTime>(
    'executado_em',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [seedKey, executadoEm];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'seed_executions';
  @override
  VerificationContext validateIntegrity(
    Insertable<SeedExecution> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('seed_key')) {
      context.handle(
        _seedKeyMeta,
        seedKey.isAcceptableOrUnknown(data['seed_key']!, _seedKeyMeta),
      );
    } else if (isInserting) {
      context.missing(_seedKeyMeta);
    }
    if (data.containsKey('executado_em')) {
      context.handle(
        _executadoEmMeta,
        executadoEm.isAcceptableOrUnknown(
          data['executado_em']!,
          _executadoEmMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {seedKey};
  @override
  SeedExecution map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SeedExecution(
      seedKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}seed_key'],
      )!,
      executadoEm: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}executado_em'],
      )!,
    );
  }

  @override
  $SeedExecutionsTable createAlias(String alias) {
    return $SeedExecutionsTable(attachedDatabase, alias);
  }
}

class SeedExecution extends DataClass implements Insertable<SeedExecution> {
  final String seedKey;
  final DateTime executadoEm;
  const SeedExecution({required this.seedKey, required this.executadoEm});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['seed_key'] = Variable<String>(seedKey);
    map['executado_em'] = Variable<DateTime>(executadoEm);
    return map;
  }

  SeedExecutionsCompanion toCompanion(bool nullToAbsent) {
    return SeedExecutionsCompanion(
      seedKey: Value(seedKey),
      executadoEm: Value(executadoEm),
    );
  }

  factory SeedExecution.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SeedExecution(
      seedKey: serializer.fromJson<String>(json['seedKey']),
      executadoEm: serializer.fromJson<DateTime>(json['executadoEm']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'seedKey': serializer.toJson<String>(seedKey),
      'executadoEm': serializer.toJson<DateTime>(executadoEm),
    };
  }

  SeedExecution copyWith({String? seedKey, DateTime? executadoEm}) =>
      SeedExecution(
        seedKey: seedKey ?? this.seedKey,
        executadoEm: executadoEm ?? this.executadoEm,
      );
  SeedExecution copyWithCompanion(SeedExecutionsCompanion data) {
    return SeedExecution(
      seedKey: data.seedKey.present ? data.seedKey.value : this.seedKey,
      executadoEm: data.executadoEm.present
          ? data.executadoEm.value
          : this.executadoEm,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SeedExecution(')
          ..write('seedKey: $seedKey, ')
          ..write('executadoEm: $executadoEm')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(seedKey, executadoEm);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SeedExecution &&
          other.seedKey == this.seedKey &&
          other.executadoEm == this.executadoEm);
}

class SeedExecutionsCompanion extends UpdateCompanion<SeedExecution> {
  final Value<String> seedKey;
  final Value<DateTime> executadoEm;
  final Value<int> rowid;
  const SeedExecutionsCompanion({
    this.seedKey = const Value.absent(),
    this.executadoEm = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SeedExecutionsCompanion.insert({
    required String seedKey,
    this.executadoEm = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : seedKey = Value(seedKey);
  static Insertable<SeedExecution> custom({
    Expression<String>? seedKey,
    Expression<DateTime>? executadoEm,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (seedKey != null) 'seed_key': seedKey,
      if (executadoEm != null) 'executado_em': executadoEm,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SeedExecutionsCompanion copyWith({
    Value<String>? seedKey,
    Value<DateTime>? executadoEm,
    Value<int>? rowid,
  }) {
    return SeedExecutionsCompanion(
      seedKey: seedKey ?? this.seedKey,
      executadoEm: executadoEm ?? this.executadoEm,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (seedKey.present) {
      map['seed_key'] = Variable<String>(seedKey.value);
    }
    if (executadoEm.present) {
      map['executado_em'] = Variable<DateTime>(executadoEm.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SeedExecutionsCompanion(')
          ..write('seedKey: $seedKey, ')
          ..write('executadoEm: $executadoEm, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ProdutosTable extends Produtos with TableInfo<$ProdutosTable, Produto> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProdutosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nomeMeta = const VerificationMeta('nome');
  @override
  late final GeneratedColumn<String> nome = GeneratedColumn<String>(
    'nome',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoriaIdMeta = const VerificationMeta(
    'categoriaId',
  );
  @override
  late final GeneratedColumn<int> categoriaId = GeneratedColumn<int>(
    'categoria_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES categorias (id)',
    ),
  );
  static const VerificationMeta _unidadeMedidaMeta = const VerificationMeta(
    'unidadeMedida',
  );
  @override
  late final GeneratedColumn<String> unidadeMedida = GeneratedColumn<String>(
    'unidade_medida',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _marcaMeta = const VerificationMeta('marca');
  @override
  late final GeneratedColumn<String> marca = GeneratedColumn<String>(
    'marca',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _quantidadeMinimaMeta = const VerificationMeta(
    'quantidadeMinima',
  );
  @override
  late final GeneratedColumn<double> quantidadeMinima = GeneratedColumn<double>(
    'quantidade_minima',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _quantidadeIdealMeta = const VerificationMeta(
    'quantidadeIdeal',
  );
  @override
  late final GeneratedColumn<double> quantidadeIdeal = GeneratedColumn<double>(
    'quantidade_ideal',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _observacoesMeta = const VerificationMeta(
    'observacoes',
  );
  @override
  late final GeneratedColumn<String> observacoes = GeneratedColumn<String>(
    'observacoes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isAtivoMeta = const VerificationMeta(
    'isAtivo',
  );
  @override
  late final GeneratedColumn<bool> isAtivo = GeneratedColumn<bool>(
    'is_ativo',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_ativo" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _criadoEmMeta = const VerificationMeta(
    'criadoEm',
  );
  @override
  late final GeneratedColumn<DateTime> criadoEm = GeneratedColumn<DateTime>(
    'criado_em',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _atualizadoEmMeta = const VerificationMeta(
    'atualizadoEm',
  );
  @override
  late final GeneratedColumn<DateTime> atualizadoEm = GeneratedColumn<DateTime>(
    'atualizado_em',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    nome,
    categoriaId,
    unidadeMedida,
    marca,
    quantidadeMinima,
    quantidadeIdeal,
    observacoes,
    isAtivo,
    criadoEm,
    atualizadoEm,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'produtos';
  @override
  VerificationContext validateIntegrity(
    Insertable<Produto> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('nome')) {
      context.handle(
        _nomeMeta,
        nome.isAcceptableOrUnknown(data['nome']!, _nomeMeta),
      );
    } else if (isInserting) {
      context.missing(_nomeMeta);
    }
    if (data.containsKey('categoria_id')) {
      context.handle(
        _categoriaIdMeta,
        categoriaId.isAcceptableOrUnknown(
          data['categoria_id']!,
          _categoriaIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_categoriaIdMeta);
    }
    if (data.containsKey('unidade_medida')) {
      context.handle(
        _unidadeMedidaMeta,
        unidadeMedida.isAcceptableOrUnknown(
          data['unidade_medida']!,
          _unidadeMedidaMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_unidadeMedidaMeta);
    }
    if (data.containsKey('marca')) {
      context.handle(
        _marcaMeta,
        marca.isAcceptableOrUnknown(data['marca']!, _marcaMeta),
      );
    }
    if (data.containsKey('quantidade_minima')) {
      context.handle(
        _quantidadeMinimaMeta,
        quantidadeMinima.isAcceptableOrUnknown(
          data['quantidade_minima']!,
          _quantidadeMinimaMeta,
        ),
      );
    }
    if (data.containsKey('quantidade_ideal')) {
      context.handle(
        _quantidadeIdealMeta,
        quantidadeIdeal.isAcceptableOrUnknown(
          data['quantidade_ideal']!,
          _quantidadeIdealMeta,
        ),
      );
    }
    if (data.containsKey('observacoes')) {
      context.handle(
        _observacoesMeta,
        observacoes.isAcceptableOrUnknown(
          data['observacoes']!,
          _observacoesMeta,
        ),
      );
    }
    if (data.containsKey('is_ativo')) {
      context.handle(
        _isAtivoMeta,
        isAtivo.isAcceptableOrUnknown(data['is_ativo']!, _isAtivoMeta),
      );
    }
    if (data.containsKey('criado_em')) {
      context.handle(
        _criadoEmMeta,
        criadoEm.isAcceptableOrUnknown(data['criado_em']!, _criadoEmMeta),
      );
    }
    if (data.containsKey('atualizado_em')) {
      context.handle(
        _atualizadoEmMeta,
        atualizadoEm.isAcceptableOrUnknown(
          data['atualizado_em']!,
          _atualizadoEmMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Produto map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Produto(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      nome: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nome'],
      )!,
      categoriaId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}categoria_id'],
      )!,
      unidadeMedida: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}unidade_medida'],
      )!,
      marca: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}marca'],
      ),
      quantidadeMinima: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}quantidade_minima'],
      )!,
      quantidadeIdeal: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}quantidade_ideal'],
      )!,
      observacoes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}observacoes'],
      ),
      isAtivo: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_ativo'],
      )!,
      criadoEm: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}criado_em'],
      )!,
      atualizadoEm: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}atualizado_em'],
      ),
    );
  }

  @override
  $ProdutosTable createAlias(String alias) {
    return $ProdutosTable(attachedDatabase, alias);
  }
}

class Produto extends DataClass implements Insertable<Produto> {
  final int id;
  final String nome;
  final int categoriaId;
  final String unidadeMedida;
  final String? marca;
  final double quantidadeMinima;
  final double quantidadeIdeal;
  final String? observacoes;
  final bool isAtivo;
  final DateTime criadoEm;
  final DateTime? atualizadoEm;
  const Produto({
    required this.id,
    required this.nome,
    required this.categoriaId,
    required this.unidadeMedida,
    this.marca,
    required this.quantidadeMinima,
    required this.quantidadeIdeal,
    this.observacoes,
    required this.isAtivo,
    required this.criadoEm,
    this.atualizadoEm,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['nome'] = Variable<String>(nome);
    map['categoria_id'] = Variable<int>(categoriaId);
    map['unidade_medida'] = Variable<String>(unidadeMedida);
    if (!nullToAbsent || marca != null) {
      map['marca'] = Variable<String>(marca);
    }
    map['quantidade_minima'] = Variable<double>(quantidadeMinima);
    map['quantidade_ideal'] = Variable<double>(quantidadeIdeal);
    if (!nullToAbsent || observacoes != null) {
      map['observacoes'] = Variable<String>(observacoes);
    }
    map['is_ativo'] = Variable<bool>(isAtivo);
    map['criado_em'] = Variable<DateTime>(criadoEm);
    if (!nullToAbsent || atualizadoEm != null) {
      map['atualizado_em'] = Variable<DateTime>(atualizadoEm);
    }
    return map;
  }

  ProdutosCompanion toCompanion(bool nullToAbsent) {
    return ProdutosCompanion(
      id: Value(id),
      nome: Value(nome),
      categoriaId: Value(categoriaId),
      unidadeMedida: Value(unidadeMedida),
      marca: marca == null && nullToAbsent
          ? const Value.absent()
          : Value(marca),
      quantidadeMinima: Value(quantidadeMinima),
      quantidadeIdeal: Value(quantidadeIdeal),
      observacoes: observacoes == null && nullToAbsent
          ? const Value.absent()
          : Value(observacoes),
      isAtivo: Value(isAtivo),
      criadoEm: Value(criadoEm),
      atualizadoEm: atualizadoEm == null && nullToAbsent
          ? const Value.absent()
          : Value(atualizadoEm),
    );
  }

  factory Produto.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Produto(
      id: serializer.fromJson<int>(json['id']),
      nome: serializer.fromJson<String>(json['nome']),
      categoriaId: serializer.fromJson<int>(json['categoriaId']),
      unidadeMedida: serializer.fromJson<String>(json['unidadeMedida']),
      marca: serializer.fromJson<String?>(json['marca']),
      quantidadeMinima: serializer.fromJson<double>(json['quantidadeMinima']),
      quantidadeIdeal: serializer.fromJson<double>(json['quantidadeIdeal']),
      observacoes: serializer.fromJson<String?>(json['observacoes']),
      isAtivo: serializer.fromJson<bool>(json['isAtivo']),
      criadoEm: serializer.fromJson<DateTime>(json['criadoEm']),
      atualizadoEm: serializer.fromJson<DateTime?>(json['atualizadoEm']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'nome': serializer.toJson<String>(nome),
      'categoriaId': serializer.toJson<int>(categoriaId),
      'unidadeMedida': serializer.toJson<String>(unidadeMedida),
      'marca': serializer.toJson<String?>(marca),
      'quantidadeMinima': serializer.toJson<double>(quantidadeMinima),
      'quantidadeIdeal': serializer.toJson<double>(quantidadeIdeal),
      'observacoes': serializer.toJson<String?>(observacoes),
      'isAtivo': serializer.toJson<bool>(isAtivo),
      'criadoEm': serializer.toJson<DateTime>(criadoEm),
      'atualizadoEm': serializer.toJson<DateTime?>(atualizadoEm),
    };
  }

  Produto copyWith({
    int? id,
    String? nome,
    int? categoriaId,
    String? unidadeMedida,
    Value<String?> marca = const Value.absent(),
    double? quantidadeMinima,
    double? quantidadeIdeal,
    Value<String?> observacoes = const Value.absent(),
    bool? isAtivo,
    DateTime? criadoEm,
    Value<DateTime?> atualizadoEm = const Value.absent(),
  }) => Produto(
    id: id ?? this.id,
    nome: nome ?? this.nome,
    categoriaId: categoriaId ?? this.categoriaId,
    unidadeMedida: unidadeMedida ?? this.unidadeMedida,
    marca: marca.present ? marca.value : this.marca,
    quantidadeMinima: quantidadeMinima ?? this.quantidadeMinima,
    quantidadeIdeal: quantidadeIdeal ?? this.quantidadeIdeal,
    observacoes: observacoes.present ? observacoes.value : this.observacoes,
    isAtivo: isAtivo ?? this.isAtivo,
    criadoEm: criadoEm ?? this.criadoEm,
    atualizadoEm: atualizadoEm.present ? atualizadoEm.value : this.atualizadoEm,
  );
  Produto copyWithCompanion(ProdutosCompanion data) {
    return Produto(
      id: data.id.present ? data.id.value : this.id,
      nome: data.nome.present ? data.nome.value : this.nome,
      categoriaId: data.categoriaId.present
          ? data.categoriaId.value
          : this.categoriaId,
      unidadeMedida: data.unidadeMedida.present
          ? data.unidadeMedida.value
          : this.unidadeMedida,
      marca: data.marca.present ? data.marca.value : this.marca,
      quantidadeMinima: data.quantidadeMinima.present
          ? data.quantidadeMinima.value
          : this.quantidadeMinima,
      quantidadeIdeal: data.quantidadeIdeal.present
          ? data.quantidadeIdeal.value
          : this.quantidadeIdeal,
      observacoes: data.observacoes.present
          ? data.observacoes.value
          : this.observacoes,
      isAtivo: data.isAtivo.present ? data.isAtivo.value : this.isAtivo,
      criadoEm: data.criadoEm.present ? data.criadoEm.value : this.criadoEm,
      atualizadoEm: data.atualizadoEm.present
          ? data.atualizadoEm.value
          : this.atualizadoEm,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Produto(')
          ..write('id: $id, ')
          ..write('nome: $nome, ')
          ..write('categoriaId: $categoriaId, ')
          ..write('unidadeMedida: $unidadeMedida, ')
          ..write('marca: $marca, ')
          ..write('quantidadeMinima: $quantidadeMinima, ')
          ..write('quantidadeIdeal: $quantidadeIdeal, ')
          ..write('observacoes: $observacoes, ')
          ..write('isAtivo: $isAtivo, ')
          ..write('criadoEm: $criadoEm, ')
          ..write('atualizadoEm: $atualizadoEm')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    nome,
    categoriaId,
    unidadeMedida,
    marca,
    quantidadeMinima,
    quantidadeIdeal,
    observacoes,
    isAtivo,
    criadoEm,
    atualizadoEm,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Produto &&
          other.id == this.id &&
          other.nome == this.nome &&
          other.categoriaId == this.categoriaId &&
          other.unidadeMedida == this.unidadeMedida &&
          other.marca == this.marca &&
          other.quantidadeMinima == this.quantidadeMinima &&
          other.quantidadeIdeal == this.quantidadeIdeal &&
          other.observacoes == this.observacoes &&
          other.isAtivo == this.isAtivo &&
          other.criadoEm == this.criadoEm &&
          other.atualizadoEm == this.atualizadoEm);
}

class ProdutosCompanion extends UpdateCompanion<Produto> {
  final Value<int> id;
  final Value<String> nome;
  final Value<int> categoriaId;
  final Value<String> unidadeMedida;
  final Value<String?> marca;
  final Value<double> quantidadeMinima;
  final Value<double> quantidadeIdeal;
  final Value<String?> observacoes;
  final Value<bool> isAtivo;
  final Value<DateTime> criadoEm;
  final Value<DateTime?> atualizadoEm;
  const ProdutosCompanion({
    this.id = const Value.absent(),
    this.nome = const Value.absent(),
    this.categoriaId = const Value.absent(),
    this.unidadeMedida = const Value.absent(),
    this.marca = const Value.absent(),
    this.quantidadeMinima = const Value.absent(),
    this.quantidadeIdeal = const Value.absent(),
    this.observacoes = const Value.absent(),
    this.isAtivo = const Value.absent(),
    this.criadoEm = const Value.absent(),
    this.atualizadoEm = const Value.absent(),
  });
  ProdutosCompanion.insert({
    this.id = const Value.absent(),
    required String nome,
    required int categoriaId,
    required String unidadeMedida,
    this.marca = const Value.absent(),
    this.quantidadeMinima = const Value.absent(),
    this.quantidadeIdeal = const Value.absent(),
    this.observacoes = const Value.absent(),
    this.isAtivo = const Value.absent(),
    this.criadoEm = const Value.absent(),
    this.atualizadoEm = const Value.absent(),
  }) : nome = Value(nome),
       categoriaId = Value(categoriaId),
       unidadeMedida = Value(unidadeMedida);
  static Insertable<Produto> custom({
    Expression<int>? id,
    Expression<String>? nome,
    Expression<int>? categoriaId,
    Expression<String>? unidadeMedida,
    Expression<String>? marca,
    Expression<double>? quantidadeMinima,
    Expression<double>? quantidadeIdeal,
    Expression<String>? observacoes,
    Expression<bool>? isAtivo,
    Expression<DateTime>? criadoEm,
    Expression<DateTime>? atualizadoEm,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nome != null) 'nome': nome,
      if (categoriaId != null) 'categoria_id': categoriaId,
      if (unidadeMedida != null) 'unidade_medida': unidadeMedida,
      if (marca != null) 'marca': marca,
      if (quantidadeMinima != null) 'quantidade_minima': quantidadeMinima,
      if (quantidadeIdeal != null) 'quantidade_ideal': quantidadeIdeal,
      if (observacoes != null) 'observacoes': observacoes,
      if (isAtivo != null) 'is_ativo': isAtivo,
      if (criadoEm != null) 'criado_em': criadoEm,
      if (atualizadoEm != null) 'atualizado_em': atualizadoEm,
    });
  }

  ProdutosCompanion copyWith({
    Value<int>? id,
    Value<String>? nome,
    Value<int>? categoriaId,
    Value<String>? unidadeMedida,
    Value<String?>? marca,
    Value<double>? quantidadeMinima,
    Value<double>? quantidadeIdeal,
    Value<String?>? observacoes,
    Value<bool>? isAtivo,
    Value<DateTime>? criadoEm,
    Value<DateTime?>? atualizadoEm,
  }) {
    return ProdutosCompanion(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      categoriaId: categoriaId ?? this.categoriaId,
      unidadeMedida: unidadeMedida ?? this.unidadeMedida,
      marca: marca ?? this.marca,
      quantidadeMinima: quantidadeMinima ?? this.quantidadeMinima,
      quantidadeIdeal: quantidadeIdeal ?? this.quantidadeIdeal,
      observacoes: observacoes ?? this.observacoes,
      isAtivo: isAtivo ?? this.isAtivo,
      criadoEm: criadoEm ?? this.criadoEm,
      atualizadoEm: atualizadoEm ?? this.atualizadoEm,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (nome.present) {
      map['nome'] = Variable<String>(nome.value);
    }
    if (categoriaId.present) {
      map['categoria_id'] = Variable<int>(categoriaId.value);
    }
    if (unidadeMedida.present) {
      map['unidade_medida'] = Variable<String>(unidadeMedida.value);
    }
    if (marca.present) {
      map['marca'] = Variable<String>(marca.value);
    }
    if (quantidadeMinima.present) {
      map['quantidade_minima'] = Variable<double>(quantidadeMinima.value);
    }
    if (quantidadeIdeal.present) {
      map['quantidade_ideal'] = Variable<double>(quantidadeIdeal.value);
    }
    if (observacoes.present) {
      map['observacoes'] = Variable<String>(observacoes.value);
    }
    if (isAtivo.present) {
      map['is_ativo'] = Variable<bool>(isAtivo.value);
    }
    if (criadoEm.present) {
      map['criado_em'] = Variable<DateTime>(criadoEm.value);
    }
    if (atualizadoEm.present) {
      map['atualizado_em'] = Variable<DateTime>(atualizadoEm.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProdutosCompanion(')
          ..write('id: $id, ')
          ..write('nome: $nome, ')
          ..write('categoriaId: $categoriaId, ')
          ..write('unidadeMedida: $unidadeMedida, ')
          ..write('marca: $marca, ')
          ..write('quantidadeMinima: $quantidadeMinima, ')
          ..write('quantidadeIdeal: $quantidadeIdeal, ')
          ..write('observacoes: $observacoes, ')
          ..write('isAtivo: $isAtivo, ')
          ..write('criadoEm: $criadoEm, ')
          ..write('atualizadoEm: $atualizadoEm')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $CategoriasTable categorias = $CategoriasTable(this);
  late final $SeedExecutionsTable seedExecutions = $SeedExecutionsTable(this);
  late final $ProdutosTable produtos = $ProdutosTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    categorias,
    seedExecutions,
    produtos,
  ];
}

typedef $$CategoriasTableCreateCompanionBuilder =
    CategoriasCompanion Function({
      Value<int> id,
      required String nome,
      Value<int?> categoriaPaiId,
      required int nivel,
      required String caminhoCompleto,
      required String origem,
      Value<bool> isPadrao,
      Value<bool> ativo,
      Value<DateTime> criadoEm,
      Value<DateTime?> atualizadoEm,
    });
typedef $$CategoriasTableUpdateCompanionBuilder =
    CategoriasCompanion Function({
      Value<int> id,
      Value<String> nome,
      Value<int?> categoriaPaiId,
      Value<int> nivel,
      Value<String> caminhoCompleto,
      Value<String> origem,
      Value<bool> isPadrao,
      Value<bool> ativo,
      Value<DateTime> criadoEm,
      Value<DateTime?> atualizadoEm,
    });

final class $$CategoriasTableReferences
    extends BaseReferences<_$AppDatabase, $CategoriasTable, Categoria> {
  $$CategoriasTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$ProdutosTable, List<Produto>> _produtosRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.produtos,
    aliasName: 'categorias__id__produtos__categoria_id',
  );

  $$ProdutosTableProcessedTableManager get produtosRefs {
    final manager = $$ProdutosTableTableManager(
      $_db,
      $_db.produtos,
    ).filter((f) => f.categoriaId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_produtosRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$CategoriasTableFilterComposer
    extends Composer<_$AppDatabase, $CategoriasTable> {
  $$CategoriasTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nome => $composableBuilder(
    column: $table.nome,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get categoriaPaiId => $composableBuilder(
    column: $table.categoriaPaiId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get nivel => $composableBuilder(
    column: $table.nivel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get caminhoCompleto => $composableBuilder(
    column: $table.caminhoCompleto,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get origem => $composableBuilder(
    column: $table.origem,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isPadrao => $composableBuilder(
    column: $table.isPadrao,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get ativo => $composableBuilder(
    column: $table.ativo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get criadoEm => $composableBuilder(
    column: $table.criadoEm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get atualizadoEm => $composableBuilder(
    column: $table.atualizadoEm,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> produtosRefs(
    Expression<bool> Function($$ProdutosTableFilterComposer f) f,
  ) {
    final $$ProdutosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.produtos,
      getReferencedColumn: (t) => t.categoriaId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProdutosTableFilterComposer(
            $db: $db,
            $table: $db.produtos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CategoriasTableOrderingComposer
    extends Composer<_$AppDatabase, $CategoriasTable> {
  $$CategoriasTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nome => $composableBuilder(
    column: $table.nome,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get categoriaPaiId => $composableBuilder(
    column: $table.categoriaPaiId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get nivel => $composableBuilder(
    column: $table.nivel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get caminhoCompleto => $composableBuilder(
    column: $table.caminhoCompleto,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get origem => $composableBuilder(
    column: $table.origem,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isPadrao => $composableBuilder(
    column: $table.isPadrao,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get ativo => $composableBuilder(
    column: $table.ativo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get criadoEm => $composableBuilder(
    column: $table.criadoEm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get atualizadoEm => $composableBuilder(
    column: $table.atualizadoEm,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CategoriasTableAnnotationComposer
    extends Composer<_$AppDatabase, $CategoriasTable> {
  $$CategoriasTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nome =>
      $composableBuilder(column: $table.nome, builder: (column) => column);

  GeneratedColumn<int> get categoriaPaiId => $composableBuilder(
    column: $table.categoriaPaiId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get nivel =>
      $composableBuilder(column: $table.nivel, builder: (column) => column);

  GeneratedColumn<String> get caminhoCompleto => $composableBuilder(
    column: $table.caminhoCompleto,
    builder: (column) => column,
  );

  GeneratedColumn<String> get origem =>
      $composableBuilder(column: $table.origem, builder: (column) => column);

  GeneratedColumn<bool> get isPadrao =>
      $composableBuilder(column: $table.isPadrao, builder: (column) => column);

  GeneratedColumn<bool> get ativo =>
      $composableBuilder(column: $table.ativo, builder: (column) => column);

  GeneratedColumn<DateTime> get criadoEm =>
      $composableBuilder(column: $table.criadoEm, builder: (column) => column);

  GeneratedColumn<DateTime> get atualizadoEm => $composableBuilder(
    column: $table.atualizadoEm,
    builder: (column) => column,
  );

  Expression<T> produtosRefs<T extends Object>(
    Expression<T> Function($$ProdutosTableAnnotationComposer a) f,
  ) {
    final $$ProdutosTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.produtos,
      getReferencedColumn: (t) => t.categoriaId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProdutosTableAnnotationComposer(
            $db: $db,
            $table: $db.produtos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CategoriasTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CategoriasTable,
          Categoria,
          $$CategoriasTableFilterComposer,
          $$CategoriasTableOrderingComposer,
          $$CategoriasTableAnnotationComposer,
          $$CategoriasTableCreateCompanionBuilder,
          $$CategoriasTableUpdateCompanionBuilder,
          (Categoria, $$CategoriasTableReferences),
          Categoria,
          PrefetchHooks Function({bool produtosRefs})
        > {
  $$CategoriasTableTableManager(_$AppDatabase db, $CategoriasTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CategoriasTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CategoriasTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CategoriasTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> nome = const Value.absent(),
                Value<int?> categoriaPaiId = const Value.absent(),
                Value<int> nivel = const Value.absent(),
                Value<String> caminhoCompleto = const Value.absent(),
                Value<String> origem = const Value.absent(),
                Value<bool> isPadrao = const Value.absent(),
                Value<bool> ativo = const Value.absent(),
                Value<DateTime> criadoEm = const Value.absent(),
                Value<DateTime?> atualizadoEm = const Value.absent(),
              }) => CategoriasCompanion(
                id: id,
                nome: nome,
                categoriaPaiId: categoriaPaiId,
                nivel: nivel,
                caminhoCompleto: caminhoCompleto,
                origem: origem,
                isPadrao: isPadrao,
                ativo: ativo,
                criadoEm: criadoEm,
                atualizadoEm: atualizadoEm,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String nome,
                Value<int?> categoriaPaiId = const Value.absent(),
                required int nivel,
                required String caminhoCompleto,
                required String origem,
                Value<bool> isPadrao = const Value.absent(),
                Value<bool> ativo = const Value.absent(),
                Value<DateTime> criadoEm = const Value.absent(),
                Value<DateTime?> atualizadoEm = const Value.absent(),
              }) => CategoriasCompanion.insert(
                id: id,
                nome: nome,
                categoriaPaiId: categoriaPaiId,
                nivel: nivel,
                caminhoCompleto: caminhoCompleto,
                origem: origem,
                isPadrao: isPadrao,
                ativo: ativo,
                criadoEm: criadoEm,
                atualizadoEm: atualizadoEm,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$CategoriasTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({produtosRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (produtosRefs) db.produtos],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (produtosRefs)
                    await $_getPrefetchedData<
                      Categoria,
                      $CategoriasTable,
                      Produto
                    >(
                      currentTable: table,
                      referencedTable: $$CategoriasTableReferences
                          ._produtosRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$CategoriasTableReferences(
                            db,
                            table,
                            p0,
                          ).produtosRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where(
                            (e) => e.categoriaId == item.id,
                          ),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$CategoriasTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CategoriasTable,
      Categoria,
      $$CategoriasTableFilterComposer,
      $$CategoriasTableOrderingComposer,
      $$CategoriasTableAnnotationComposer,
      $$CategoriasTableCreateCompanionBuilder,
      $$CategoriasTableUpdateCompanionBuilder,
      (Categoria, $$CategoriasTableReferences),
      Categoria,
      PrefetchHooks Function({bool produtosRefs})
    >;
typedef $$SeedExecutionsTableCreateCompanionBuilder =
    SeedExecutionsCompanion Function({
      required String seedKey,
      Value<DateTime> executadoEm,
      Value<int> rowid,
    });
typedef $$SeedExecutionsTableUpdateCompanionBuilder =
    SeedExecutionsCompanion Function({
      Value<String> seedKey,
      Value<DateTime> executadoEm,
      Value<int> rowid,
    });

class $$SeedExecutionsTableFilterComposer
    extends Composer<_$AppDatabase, $SeedExecutionsTable> {
  $$SeedExecutionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get seedKey => $composableBuilder(
    column: $table.seedKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get executadoEm => $composableBuilder(
    column: $table.executadoEm,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SeedExecutionsTableOrderingComposer
    extends Composer<_$AppDatabase, $SeedExecutionsTable> {
  $$SeedExecutionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get seedKey => $composableBuilder(
    column: $table.seedKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get executadoEm => $composableBuilder(
    column: $table.executadoEm,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SeedExecutionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SeedExecutionsTable> {
  $$SeedExecutionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get seedKey =>
      $composableBuilder(column: $table.seedKey, builder: (column) => column);

  GeneratedColumn<DateTime> get executadoEm => $composableBuilder(
    column: $table.executadoEm,
    builder: (column) => column,
  );
}

class $$SeedExecutionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SeedExecutionsTable,
          SeedExecution,
          $$SeedExecutionsTableFilterComposer,
          $$SeedExecutionsTableOrderingComposer,
          $$SeedExecutionsTableAnnotationComposer,
          $$SeedExecutionsTableCreateCompanionBuilder,
          $$SeedExecutionsTableUpdateCompanionBuilder,
          (
            SeedExecution,
            BaseReferences<_$AppDatabase, $SeedExecutionsTable, SeedExecution>,
          ),
          SeedExecution,
          PrefetchHooks Function()
        > {
  $$SeedExecutionsTableTableManager(
    _$AppDatabase db,
    $SeedExecutionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SeedExecutionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SeedExecutionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SeedExecutionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> seedKey = const Value.absent(),
                Value<DateTime> executadoEm = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SeedExecutionsCompanion(
                seedKey: seedKey,
                executadoEm: executadoEm,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String seedKey,
                Value<DateTime> executadoEm = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SeedExecutionsCompanion.insert(
                seedKey: seedKey,
                executadoEm: executadoEm,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SeedExecutionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SeedExecutionsTable,
      SeedExecution,
      $$SeedExecutionsTableFilterComposer,
      $$SeedExecutionsTableOrderingComposer,
      $$SeedExecutionsTableAnnotationComposer,
      $$SeedExecutionsTableCreateCompanionBuilder,
      $$SeedExecutionsTableUpdateCompanionBuilder,
      (
        SeedExecution,
        BaseReferences<_$AppDatabase, $SeedExecutionsTable, SeedExecution>,
      ),
      SeedExecution,
      PrefetchHooks Function()
    >;
typedef $$ProdutosTableCreateCompanionBuilder =
    ProdutosCompanion Function({
      Value<int> id,
      required String nome,
      required int categoriaId,
      required String unidadeMedida,
      Value<String?> marca,
      Value<double> quantidadeMinima,
      Value<double> quantidadeIdeal,
      Value<String?> observacoes,
      Value<bool> isAtivo,
      Value<DateTime> criadoEm,
      Value<DateTime?> atualizadoEm,
    });
typedef $$ProdutosTableUpdateCompanionBuilder =
    ProdutosCompanion Function({
      Value<int> id,
      Value<String> nome,
      Value<int> categoriaId,
      Value<String> unidadeMedida,
      Value<String?> marca,
      Value<double> quantidadeMinima,
      Value<double> quantidadeIdeal,
      Value<String?> observacoes,
      Value<bool> isAtivo,
      Value<DateTime> criadoEm,
      Value<DateTime?> atualizadoEm,
    });

final class $$ProdutosTableReferences
    extends BaseReferences<_$AppDatabase, $ProdutosTable, Produto> {
  $$ProdutosTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CategoriasTable _categoriaIdTable(_$AppDatabase db) =>
      db.categorias.createAlias('produtos__categoria_id__categorias__id');

  $$CategoriasTableProcessedTableManager get categoriaId {
    final $_column = $_itemColumn<int>('categoria_id')!;

    final manager = $$CategoriasTableTableManager(
      $_db,
      $_db.categorias,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_categoriaIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ProdutosTableFilterComposer
    extends Composer<_$AppDatabase, $ProdutosTable> {
  $$ProdutosTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nome => $composableBuilder(
    column: $table.nome,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get unidadeMedida => $composableBuilder(
    column: $table.unidadeMedida,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get marca => $composableBuilder(
    column: $table.marca,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get quantidadeMinima => $composableBuilder(
    column: $table.quantidadeMinima,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get quantidadeIdeal => $composableBuilder(
    column: $table.quantidadeIdeal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get observacoes => $composableBuilder(
    column: $table.observacoes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isAtivo => $composableBuilder(
    column: $table.isAtivo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get criadoEm => $composableBuilder(
    column: $table.criadoEm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get atualizadoEm => $composableBuilder(
    column: $table.atualizadoEm,
    builder: (column) => ColumnFilters(column),
  );

  $$CategoriasTableFilterComposer get categoriaId {
    final $$CategoriasTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoriaId,
      referencedTable: $db.categorias,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriasTableFilterComposer(
            $db: $db,
            $table: $db.categorias,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ProdutosTableOrderingComposer
    extends Composer<_$AppDatabase, $ProdutosTable> {
  $$ProdutosTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nome => $composableBuilder(
    column: $table.nome,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get unidadeMedida => $composableBuilder(
    column: $table.unidadeMedida,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get marca => $composableBuilder(
    column: $table.marca,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get quantidadeMinima => $composableBuilder(
    column: $table.quantidadeMinima,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get quantidadeIdeal => $composableBuilder(
    column: $table.quantidadeIdeal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get observacoes => $composableBuilder(
    column: $table.observacoes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isAtivo => $composableBuilder(
    column: $table.isAtivo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get criadoEm => $composableBuilder(
    column: $table.criadoEm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get atualizadoEm => $composableBuilder(
    column: $table.atualizadoEm,
    builder: (column) => ColumnOrderings(column),
  );

  $$CategoriasTableOrderingComposer get categoriaId {
    final $$CategoriasTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoriaId,
      referencedTable: $db.categorias,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriasTableOrderingComposer(
            $db: $db,
            $table: $db.categorias,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ProdutosTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProdutosTable> {
  $$ProdutosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nome =>
      $composableBuilder(column: $table.nome, builder: (column) => column);

  GeneratedColumn<String> get unidadeMedida => $composableBuilder(
    column: $table.unidadeMedida,
    builder: (column) => column,
  );

  GeneratedColumn<String> get marca =>
      $composableBuilder(column: $table.marca, builder: (column) => column);

  GeneratedColumn<double> get quantidadeMinima => $composableBuilder(
    column: $table.quantidadeMinima,
    builder: (column) => column,
  );

  GeneratedColumn<double> get quantidadeIdeal => $composableBuilder(
    column: $table.quantidadeIdeal,
    builder: (column) => column,
  );

  GeneratedColumn<String> get observacoes => $composableBuilder(
    column: $table.observacoes,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isAtivo =>
      $composableBuilder(column: $table.isAtivo, builder: (column) => column);

  GeneratedColumn<DateTime> get criadoEm =>
      $composableBuilder(column: $table.criadoEm, builder: (column) => column);

  GeneratedColumn<DateTime> get atualizadoEm => $composableBuilder(
    column: $table.atualizadoEm,
    builder: (column) => column,
  );

  $$CategoriasTableAnnotationComposer get categoriaId {
    final $$CategoriasTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoriaId,
      referencedTable: $db.categorias,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriasTableAnnotationComposer(
            $db: $db,
            $table: $db.categorias,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ProdutosTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProdutosTable,
          Produto,
          $$ProdutosTableFilterComposer,
          $$ProdutosTableOrderingComposer,
          $$ProdutosTableAnnotationComposer,
          $$ProdutosTableCreateCompanionBuilder,
          $$ProdutosTableUpdateCompanionBuilder,
          (Produto, $$ProdutosTableReferences),
          Produto,
          PrefetchHooks Function({bool categoriaId})
        > {
  $$ProdutosTableTableManager(_$AppDatabase db, $ProdutosTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProdutosTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProdutosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProdutosTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> nome = const Value.absent(),
                Value<int> categoriaId = const Value.absent(),
                Value<String> unidadeMedida = const Value.absent(),
                Value<String?> marca = const Value.absent(),
                Value<double> quantidadeMinima = const Value.absent(),
                Value<double> quantidadeIdeal = const Value.absent(),
                Value<String?> observacoes = const Value.absent(),
                Value<bool> isAtivo = const Value.absent(),
                Value<DateTime> criadoEm = const Value.absent(),
                Value<DateTime?> atualizadoEm = const Value.absent(),
              }) => ProdutosCompanion(
                id: id,
                nome: nome,
                categoriaId: categoriaId,
                unidadeMedida: unidadeMedida,
                marca: marca,
                quantidadeMinima: quantidadeMinima,
                quantidadeIdeal: quantidadeIdeal,
                observacoes: observacoes,
                isAtivo: isAtivo,
                criadoEm: criadoEm,
                atualizadoEm: atualizadoEm,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String nome,
                required int categoriaId,
                required String unidadeMedida,
                Value<String?> marca = const Value.absent(),
                Value<double> quantidadeMinima = const Value.absent(),
                Value<double> quantidadeIdeal = const Value.absent(),
                Value<String?> observacoes = const Value.absent(),
                Value<bool> isAtivo = const Value.absent(),
                Value<DateTime> criadoEm = const Value.absent(),
                Value<DateTime?> atualizadoEm = const Value.absent(),
              }) => ProdutosCompanion.insert(
                id: id,
                nome: nome,
                categoriaId: categoriaId,
                unidadeMedida: unidadeMedida,
                marca: marca,
                quantidadeMinima: quantidadeMinima,
                quantidadeIdeal: quantidadeIdeal,
                observacoes: observacoes,
                isAtivo: isAtivo,
                criadoEm: criadoEm,
                atualizadoEm: atualizadoEm,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ProdutosTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({categoriaId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (categoriaId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.categoriaId,
                                referencedTable: $$ProdutosTableReferences
                                    ._categoriaIdTable(db),
                                referencedColumn: $$ProdutosTableReferences
                                    ._categoriaIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ProdutosTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ProdutosTable,
      Produto,
      $$ProdutosTableFilterComposer,
      $$ProdutosTableOrderingComposer,
      $$ProdutosTableAnnotationComposer,
      $$ProdutosTableCreateCompanionBuilder,
      $$ProdutosTableUpdateCompanionBuilder,
      (Produto, $$ProdutosTableReferences),
      Produto,
      PrefetchHooks Function({bool categoriaId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$CategoriasTableTableManager get categorias =>
      $$CategoriasTableTableManager(_db, _db.categorias);
  $$SeedExecutionsTableTableManager get seedExecutions =>
      $$SeedExecutionsTableTableManager(_db, _db.seedExecutions);
  $$ProdutosTableTableManager get produtos =>
      $$ProdutosTableTableManager(_db, _db.produtos);
}
