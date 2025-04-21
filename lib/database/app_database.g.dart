// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $UsersTable extends Users with TableInfo<$UsersTable, User> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UsersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _usernameMeta =
      const VerificationMeta('username');
  @override
  late final GeneratedColumn<String> username = GeneratedColumn<String>(
      'username', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 4, maxTextLength: 32),
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _passwordMeta =
      const VerificationMeta('password');
  @override
  late final GeneratedColumn<String> password = GeneratedColumn<String>(
      'password', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _roleMeta = const VerificationMeta('role');
  @override
  late final GeneratedColumn<String> role = GeneratedColumn<String>(
      'role', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('kasir'));
  @override
  List<GeneratedColumn> get $columns => [id, username, password, role];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'users';
  @override
  VerificationContext validateIntegrity(Insertable<User> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('username')) {
      context.handle(_usernameMeta,
          username.isAcceptableOrUnknown(data['username']!, _usernameMeta));
    } else if (isInserting) {
      context.missing(_usernameMeta);
    }
    if (data.containsKey('password')) {
      context.handle(_passwordMeta,
          password.isAcceptableOrUnknown(data['password']!, _passwordMeta));
    } else if (isInserting) {
      context.missing(_passwordMeta);
    }
    if (data.containsKey('role')) {
      context.handle(
          _roleMeta, role.isAcceptableOrUnknown(data['role']!, _roleMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  User map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return User(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      username: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}username'])!,
      password: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}password'])!,
      role: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}role'])!,
    );
  }

  @override
  $UsersTable createAlias(String alias) {
    return $UsersTable(attachedDatabase, alias);
  }
}

class User extends DataClass implements Insertable<User> {
  final int id;
  final String username;
  final String password;
  final String role;
  const User(
      {required this.id,
      required this.username,
      required this.password,
      required this.role});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['username'] = Variable<String>(username);
    map['password'] = Variable<String>(password);
    map['role'] = Variable<String>(role);
    return map;
  }

  UsersCompanion toCompanion(bool nullToAbsent) {
    return UsersCompanion(
      id: Value(id),
      username: Value(username),
      password: Value(password),
      role: Value(role),
    );
  }

  factory User.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return User(
      id: serializer.fromJson<int>(json['id']),
      username: serializer.fromJson<String>(json['username']),
      password: serializer.fromJson<String>(json['password']),
      role: serializer.fromJson<String>(json['role']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'username': serializer.toJson<String>(username),
      'password': serializer.toJson<String>(password),
      'role': serializer.toJson<String>(role),
    };
  }

  User copyWith({int? id, String? username, String? password, String? role}) =>
      User(
        id: id ?? this.id,
        username: username ?? this.username,
        password: password ?? this.password,
        role: role ?? this.role,
      );
  User copyWithCompanion(UsersCompanion data) {
    return User(
      id: data.id.present ? data.id.value : this.id,
      username: data.username.present ? data.username.value : this.username,
      password: data.password.present ? data.password.value : this.password,
      role: data.role.present ? data.role.value : this.role,
    );
  }

  @override
  String toString() {
    return (StringBuffer('User(')
          ..write('id: $id, ')
          ..write('username: $username, ')
          ..write('password: $password, ')
          ..write('role: $role')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, username, password, role);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is User &&
          other.id == this.id &&
          other.username == this.username &&
          other.password == this.password &&
          other.role == this.role);
}

class UsersCompanion extends UpdateCompanion<User> {
  final Value<int> id;
  final Value<String> username;
  final Value<String> password;
  final Value<String> role;
  const UsersCompanion({
    this.id = const Value.absent(),
    this.username = const Value.absent(),
    this.password = const Value.absent(),
    this.role = const Value.absent(),
  });
  UsersCompanion.insert({
    this.id = const Value.absent(),
    required String username,
    required String password,
    this.role = const Value.absent(),
  })  : username = Value(username),
        password = Value(password);
  static Insertable<User> custom({
    Expression<int>? id,
    Expression<String>? username,
    Expression<String>? password,
    Expression<String>? role,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (username != null) 'username': username,
      if (password != null) 'password': password,
      if (role != null) 'role': role,
    });
  }

  UsersCompanion copyWith(
      {Value<int>? id,
      Value<String>? username,
      Value<String>? password,
      Value<String>? role}) {
    return UsersCompanion(
      id: id ?? this.id,
      username: username ?? this.username,
      password: password ?? this.password,
      role: role ?? this.role,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (username.present) {
      map['username'] = Variable<String>(username.value);
    }
    if (password.present) {
      map['password'] = Variable<String>(password.value);
    }
    if (role.present) {
      map['role'] = Variable<String>(role.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UsersCompanion(')
          ..write('id: $id, ')
          ..write('username: $username, ')
          ..write('password: $password, ')
          ..write('role: $role')
          ..write(')'))
        .toString();
  }
}

class $SuppliersTable extends Suppliers
    with TableInfo<$SuppliersTable, Supplier> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SuppliersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _kodeSupplierMeta =
      const VerificationMeta('kodeSupplier');
  @override
  late final GeneratedColumn<String> kodeSupplier = GeneratedColumn<String>(
      'kode_supplier', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 20),
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _namaSupplierMeta =
      const VerificationMeta('namaSupplier');
  @override
  late final GeneratedColumn<String> namaSupplier = GeneratedColumn<String>(
      'nama_supplier', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 50),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _alamatMeta = const VerificationMeta('alamat');
  @override
  late final GeneratedColumn<String> alamat = GeneratedColumn<String>(
      'alamat', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _teleponMeta =
      const VerificationMeta('telepon');
  @override
  late final GeneratedColumn<String> telepon = GeneratedColumn<String>(
      'telepon', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _keteranganMeta =
      const VerificationMeta('keterangan');
  @override
  late final GeneratedColumn<String> keterangan = GeneratedColumn<String>(
      'keterangan', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, kodeSupplier, namaSupplier, alamat, telepon, keterangan];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'suppliers';
  @override
  VerificationContext validateIntegrity(Insertable<Supplier> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('kode_supplier')) {
      context.handle(
          _kodeSupplierMeta,
          kodeSupplier.isAcceptableOrUnknown(
              data['kode_supplier']!, _kodeSupplierMeta));
    } else if (isInserting) {
      context.missing(_kodeSupplierMeta);
    }
    if (data.containsKey('nama_supplier')) {
      context.handle(
          _namaSupplierMeta,
          namaSupplier.isAcceptableOrUnknown(
              data['nama_supplier']!, _namaSupplierMeta));
    } else if (isInserting) {
      context.missing(_namaSupplierMeta);
    }
    if (data.containsKey('alamat')) {
      context.handle(_alamatMeta,
          alamat.isAcceptableOrUnknown(data['alamat']!, _alamatMeta));
    }
    if (data.containsKey('telepon')) {
      context.handle(_teleponMeta,
          telepon.isAcceptableOrUnknown(data['telepon']!, _teleponMeta));
    }
    if (data.containsKey('keterangan')) {
      context.handle(
          _keteranganMeta,
          keterangan.isAcceptableOrUnknown(
              data['keterangan']!, _keteranganMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Supplier map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Supplier(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      kodeSupplier: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}kode_supplier'])!,
      namaSupplier: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}nama_supplier'])!,
      alamat: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}alamat']),
      telepon: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}telepon']),
      keterangan: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}keterangan']),
    );
  }

  @override
  $SuppliersTable createAlias(String alias) {
    return $SuppliersTable(attachedDatabase, alias);
  }
}

class Supplier extends DataClass implements Insertable<Supplier> {
  final int id;
  final String kodeSupplier;
  final String namaSupplier;
  final String? alamat;
  final String? telepon;
  final String? keterangan;
  const Supplier(
      {required this.id,
      required this.kodeSupplier,
      required this.namaSupplier,
      this.alamat,
      this.telepon,
      this.keterangan});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['kode_supplier'] = Variable<String>(kodeSupplier);
    map['nama_supplier'] = Variable<String>(namaSupplier);
    if (!nullToAbsent || alamat != null) {
      map['alamat'] = Variable<String>(alamat);
    }
    if (!nullToAbsent || telepon != null) {
      map['telepon'] = Variable<String>(telepon);
    }
    if (!nullToAbsent || keterangan != null) {
      map['keterangan'] = Variable<String>(keterangan);
    }
    return map;
  }

  SuppliersCompanion toCompanion(bool nullToAbsent) {
    return SuppliersCompanion(
      id: Value(id),
      kodeSupplier: Value(kodeSupplier),
      namaSupplier: Value(namaSupplier),
      alamat:
          alamat == null && nullToAbsent ? const Value.absent() : Value(alamat),
      telepon: telepon == null && nullToAbsent
          ? const Value.absent()
          : Value(telepon),
      keterangan: keterangan == null && nullToAbsent
          ? const Value.absent()
          : Value(keterangan),
    );
  }

  factory Supplier.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Supplier(
      id: serializer.fromJson<int>(json['id']),
      kodeSupplier: serializer.fromJson<String>(json['kodeSupplier']),
      namaSupplier: serializer.fromJson<String>(json['namaSupplier']),
      alamat: serializer.fromJson<String?>(json['alamat']),
      telepon: serializer.fromJson<String?>(json['telepon']),
      keterangan: serializer.fromJson<String?>(json['keterangan']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'kodeSupplier': serializer.toJson<String>(kodeSupplier),
      'namaSupplier': serializer.toJson<String>(namaSupplier),
      'alamat': serializer.toJson<String?>(alamat),
      'telepon': serializer.toJson<String?>(telepon),
      'keterangan': serializer.toJson<String?>(keterangan),
    };
  }

  Supplier copyWith(
          {int? id,
          String? kodeSupplier,
          String? namaSupplier,
          Value<String?> alamat = const Value.absent(),
          Value<String?> telepon = const Value.absent(),
          Value<String?> keterangan = const Value.absent()}) =>
      Supplier(
        id: id ?? this.id,
        kodeSupplier: kodeSupplier ?? this.kodeSupplier,
        namaSupplier: namaSupplier ?? this.namaSupplier,
        alamat: alamat.present ? alamat.value : this.alamat,
        telepon: telepon.present ? telepon.value : this.telepon,
        keterangan: keterangan.present ? keterangan.value : this.keterangan,
      );
  Supplier copyWithCompanion(SuppliersCompanion data) {
    return Supplier(
      id: data.id.present ? data.id.value : this.id,
      kodeSupplier: data.kodeSupplier.present
          ? data.kodeSupplier.value
          : this.kodeSupplier,
      namaSupplier: data.namaSupplier.present
          ? data.namaSupplier.value
          : this.namaSupplier,
      alamat: data.alamat.present ? data.alamat.value : this.alamat,
      telepon: data.telepon.present ? data.telepon.value : this.telepon,
      keterangan:
          data.keterangan.present ? data.keterangan.value : this.keterangan,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Supplier(')
          ..write('id: $id, ')
          ..write('kodeSupplier: $kodeSupplier, ')
          ..write('namaSupplier: $namaSupplier, ')
          ..write('alamat: $alamat, ')
          ..write('telepon: $telepon, ')
          ..write('keterangan: $keterangan')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, kodeSupplier, namaSupplier, alamat, telepon, keterangan);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Supplier &&
          other.id == this.id &&
          other.kodeSupplier == this.kodeSupplier &&
          other.namaSupplier == this.namaSupplier &&
          other.alamat == this.alamat &&
          other.telepon == this.telepon &&
          other.keterangan == this.keterangan);
}

class SuppliersCompanion extends UpdateCompanion<Supplier> {
  final Value<int> id;
  final Value<String> kodeSupplier;
  final Value<String> namaSupplier;
  final Value<String?> alamat;
  final Value<String?> telepon;
  final Value<String?> keterangan;
  const SuppliersCompanion({
    this.id = const Value.absent(),
    this.kodeSupplier = const Value.absent(),
    this.namaSupplier = const Value.absent(),
    this.alamat = const Value.absent(),
    this.telepon = const Value.absent(),
    this.keterangan = const Value.absent(),
  });
  SuppliersCompanion.insert({
    this.id = const Value.absent(),
    required String kodeSupplier,
    required String namaSupplier,
    this.alamat = const Value.absent(),
    this.telepon = const Value.absent(),
    this.keterangan = const Value.absent(),
  })  : kodeSupplier = Value(kodeSupplier),
        namaSupplier = Value(namaSupplier);
  static Insertable<Supplier> custom({
    Expression<int>? id,
    Expression<String>? kodeSupplier,
    Expression<String>? namaSupplier,
    Expression<String>? alamat,
    Expression<String>? telepon,
    Expression<String>? keterangan,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (kodeSupplier != null) 'kode_supplier': kodeSupplier,
      if (namaSupplier != null) 'nama_supplier': namaSupplier,
      if (alamat != null) 'alamat': alamat,
      if (telepon != null) 'telepon': telepon,
      if (keterangan != null) 'keterangan': keterangan,
    });
  }

  SuppliersCompanion copyWith(
      {Value<int>? id,
      Value<String>? kodeSupplier,
      Value<String>? namaSupplier,
      Value<String?>? alamat,
      Value<String?>? telepon,
      Value<String?>? keterangan}) {
    return SuppliersCompanion(
      id: id ?? this.id,
      kodeSupplier: kodeSupplier ?? this.kodeSupplier,
      namaSupplier: namaSupplier ?? this.namaSupplier,
      alamat: alamat ?? this.alamat,
      telepon: telepon ?? this.telepon,
      keterangan: keterangan ?? this.keterangan,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (kodeSupplier.present) {
      map['kode_supplier'] = Variable<String>(kodeSupplier.value);
    }
    if (namaSupplier.present) {
      map['nama_supplier'] = Variable<String>(namaSupplier.value);
    }
    if (alamat.present) {
      map['alamat'] = Variable<String>(alamat.value);
    }
    if (telepon.present) {
      map['telepon'] = Variable<String>(telepon.value);
    }
    if (keterangan.present) {
      map['keterangan'] = Variable<String>(keterangan.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SuppliersCompanion(')
          ..write('id: $id, ')
          ..write('kodeSupplier: $kodeSupplier, ')
          ..write('namaSupplier: $namaSupplier, ')
          ..write('alamat: $alamat, ')
          ..write('telepon: $telepon, ')
          ..write('keterangan: $keterangan')
          ..write(')'))
        .toString();
  }
}

class $DoctorsTable extends Doctors with TableInfo<$DoctorsTable, Doctor> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DoctorsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _kodeDoctorMeta =
      const VerificationMeta('kodeDoctor');
  @override
  late final GeneratedColumn<String> kodeDoctor = GeneratedColumn<String>(
      'kode_doctor', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 20),
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _namaDoctorMeta =
      const VerificationMeta('namaDoctor');
  @override
  late final GeneratedColumn<String> namaDoctor = GeneratedColumn<String>(
      'nama_doctor', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 50),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _alamatMeta = const VerificationMeta('alamat');
  @override
  late final GeneratedColumn<String> alamat = GeneratedColumn<String>(
      'alamat', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _teleponMeta =
      const VerificationMeta('telepon');
  @override
  late final GeneratedColumn<String> telepon = GeneratedColumn<String>(
      'telepon', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _nilaipenjualanMeta =
      const VerificationMeta('nilaipenjualan');
  @override
  late final GeneratedColumn<int> nilaipenjualan = GeneratedColumn<int>(
      'nilaipenjualan', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, kodeDoctor, namaDoctor, alamat, telepon, nilaipenjualan];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'doctors';
  @override
  VerificationContext validateIntegrity(Insertable<Doctor> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('kode_doctor')) {
      context.handle(
          _kodeDoctorMeta,
          kodeDoctor.isAcceptableOrUnknown(
              data['kode_doctor']!, _kodeDoctorMeta));
    } else if (isInserting) {
      context.missing(_kodeDoctorMeta);
    }
    if (data.containsKey('nama_doctor')) {
      context.handle(
          _namaDoctorMeta,
          namaDoctor.isAcceptableOrUnknown(
              data['nama_doctor']!, _namaDoctorMeta));
    } else if (isInserting) {
      context.missing(_namaDoctorMeta);
    }
    if (data.containsKey('alamat')) {
      context.handle(_alamatMeta,
          alamat.isAcceptableOrUnknown(data['alamat']!, _alamatMeta));
    }
    if (data.containsKey('telepon')) {
      context.handle(_teleponMeta,
          telepon.isAcceptableOrUnknown(data['telepon']!, _teleponMeta));
    }
    if (data.containsKey('nilaipenjualan')) {
      context.handle(
          _nilaipenjualanMeta,
          nilaipenjualan.isAcceptableOrUnknown(
              data['nilaipenjualan']!, _nilaipenjualanMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Doctor map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Doctor(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      kodeDoctor: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}kode_doctor'])!,
      namaDoctor: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}nama_doctor'])!,
      alamat: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}alamat']),
      telepon: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}telepon']),
      nilaipenjualan: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}nilaipenjualan']),
    );
  }

  @override
  $DoctorsTable createAlias(String alias) {
    return $DoctorsTable(attachedDatabase, alias);
  }
}

class Doctor extends DataClass implements Insertable<Doctor> {
  final int id;
  final String kodeDoctor;
  final String namaDoctor;
  final String? alamat;
  final String? telepon;
  final int? nilaipenjualan;
  const Doctor(
      {required this.id,
      required this.kodeDoctor,
      required this.namaDoctor,
      this.alamat,
      this.telepon,
      this.nilaipenjualan});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['kode_doctor'] = Variable<String>(kodeDoctor);
    map['nama_doctor'] = Variable<String>(namaDoctor);
    if (!nullToAbsent || alamat != null) {
      map['alamat'] = Variable<String>(alamat);
    }
    if (!nullToAbsent || telepon != null) {
      map['telepon'] = Variable<String>(telepon);
    }
    if (!nullToAbsent || nilaipenjualan != null) {
      map['nilaipenjualan'] = Variable<int>(nilaipenjualan);
    }
    return map;
  }

  DoctorsCompanion toCompanion(bool nullToAbsent) {
    return DoctorsCompanion(
      id: Value(id),
      kodeDoctor: Value(kodeDoctor),
      namaDoctor: Value(namaDoctor),
      alamat:
          alamat == null && nullToAbsent ? const Value.absent() : Value(alamat),
      telepon: telepon == null && nullToAbsent
          ? const Value.absent()
          : Value(telepon),
      nilaipenjualan: nilaipenjualan == null && nullToAbsent
          ? const Value.absent()
          : Value(nilaipenjualan),
    );
  }

  factory Doctor.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Doctor(
      id: serializer.fromJson<int>(json['id']),
      kodeDoctor: serializer.fromJson<String>(json['kodeDoctor']),
      namaDoctor: serializer.fromJson<String>(json['namaDoctor']),
      alamat: serializer.fromJson<String?>(json['alamat']),
      telepon: serializer.fromJson<String?>(json['telepon']),
      nilaipenjualan: serializer.fromJson<int?>(json['nilaipenjualan']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'kodeDoctor': serializer.toJson<String>(kodeDoctor),
      'namaDoctor': serializer.toJson<String>(namaDoctor),
      'alamat': serializer.toJson<String?>(alamat),
      'telepon': serializer.toJson<String?>(telepon),
      'nilaipenjualan': serializer.toJson<int?>(nilaipenjualan),
    };
  }

  Doctor copyWith(
          {int? id,
          String? kodeDoctor,
          String? namaDoctor,
          Value<String?> alamat = const Value.absent(),
          Value<String?> telepon = const Value.absent(),
          Value<int?> nilaipenjualan = const Value.absent()}) =>
      Doctor(
        id: id ?? this.id,
        kodeDoctor: kodeDoctor ?? this.kodeDoctor,
        namaDoctor: namaDoctor ?? this.namaDoctor,
        alamat: alamat.present ? alamat.value : this.alamat,
        telepon: telepon.present ? telepon.value : this.telepon,
        nilaipenjualan:
            nilaipenjualan.present ? nilaipenjualan.value : this.nilaipenjualan,
      );
  Doctor copyWithCompanion(DoctorsCompanion data) {
    return Doctor(
      id: data.id.present ? data.id.value : this.id,
      kodeDoctor:
          data.kodeDoctor.present ? data.kodeDoctor.value : this.kodeDoctor,
      namaDoctor:
          data.namaDoctor.present ? data.namaDoctor.value : this.namaDoctor,
      alamat: data.alamat.present ? data.alamat.value : this.alamat,
      telepon: data.telepon.present ? data.telepon.value : this.telepon,
      nilaipenjualan: data.nilaipenjualan.present
          ? data.nilaipenjualan.value
          : this.nilaipenjualan,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Doctor(')
          ..write('id: $id, ')
          ..write('kodeDoctor: $kodeDoctor, ')
          ..write('namaDoctor: $namaDoctor, ')
          ..write('alamat: $alamat, ')
          ..write('telepon: $telepon, ')
          ..write('nilaipenjualan: $nilaipenjualan')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, kodeDoctor, namaDoctor, alamat, telepon, nilaipenjualan);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Doctor &&
          other.id == this.id &&
          other.kodeDoctor == this.kodeDoctor &&
          other.namaDoctor == this.namaDoctor &&
          other.alamat == this.alamat &&
          other.telepon == this.telepon &&
          other.nilaipenjualan == this.nilaipenjualan);
}

class DoctorsCompanion extends UpdateCompanion<Doctor> {
  final Value<int> id;
  final Value<String> kodeDoctor;
  final Value<String> namaDoctor;
  final Value<String?> alamat;
  final Value<String?> telepon;
  final Value<int?> nilaipenjualan;
  const DoctorsCompanion({
    this.id = const Value.absent(),
    this.kodeDoctor = const Value.absent(),
    this.namaDoctor = const Value.absent(),
    this.alamat = const Value.absent(),
    this.telepon = const Value.absent(),
    this.nilaipenjualan = const Value.absent(),
  });
  DoctorsCompanion.insert({
    this.id = const Value.absent(),
    required String kodeDoctor,
    required String namaDoctor,
    this.alamat = const Value.absent(),
    this.telepon = const Value.absent(),
    this.nilaipenjualan = const Value.absent(),
  })  : kodeDoctor = Value(kodeDoctor),
        namaDoctor = Value(namaDoctor);
  static Insertable<Doctor> custom({
    Expression<int>? id,
    Expression<String>? kodeDoctor,
    Expression<String>? namaDoctor,
    Expression<String>? alamat,
    Expression<String>? telepon,
    Expression<int>? nilaipenjualan,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (kodeDoctor != null) 'kode_doctor': kodeDoctor,
      if (namaDoctor != null) 'nama_doctor': namaDoctor,
      if (alamat != null) 'alamat': alamat,
      if (telepon != null) 'telepon': telepon,
      if (nilaipenjualan != null) 'nilaipenjualan': nilaipenjualan,
    });
  }

  DoctorsCompanion copyWith(
      {Value<int>? id,
      Value<String>? kodeDoctor,
      Value<String>? namaDoctor,
      Value<String?>? alamat,
      Value<String?>? telepon,
      Value<int?>? nilaipenjualan}) {
    return DoctorsCompanion(
      id: id ?? this.id,
      kodeDoctor: kodeDoctor ?? this.kodeDoctor,
      namaDoctor: namaDoctor ?? this.namaDoctor,
      alamat: alamat ?? this.alamat,
      telepon: telepon ?? this.telepon,
      nilaipenjualan: nilaipenjualan ?? this.nilaipenjualan,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (kodeDoctor.present) {
      map['kode_doctor'] = Variable<String>(kodeDoctor.value);
    }
    if (namaDoctor.present) {
      map['nama_doctor'] = Variable<String>(namaDoctor.value);
    }
    if (alamat.present) {
      map['alamat'] = Variable<String>(alamat.value);
    }
    if (telepon.present) {
      map['telepon'] = Variable<String>(telepon.value);
    }
    if (nilaipenjualan.present) {
      map['nilaipenjualan'] = Variable<int>(nilaipenjualan.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DoctorsCompanion(')
          ..write('id: $id, ')
          ..write('kodeDoctor: $kodeDoctor, ')
          ..write('namaDoctor: $namaDoctor, ')
          ..write('alamat: $alamat, ')
          ..write('telepon: $telepon, ')
          ..write('nilaipenjualan: $nilaipenjualan')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $UsersTable users = $UsersTable(this);
  late final $SuppliersTable suppliers = $SuppliersTable(this);
  late final $DoctorsTable doctors = $DoctorsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [users, suppliers, doctors];
}

typedef $$UsersTableCreateCompanionBuilder = UsersCompanion Function({
  Value<int> id,
  required String username,
  required String password,
  Value<String> role,
});
typedef $$UsersTableUpdateCompanionBuilder = UsersCompanion Function({
  Value<int> id,
  Value<String> username,
  Value<String> password,
  Value<String> role,
});

class $$UsersTableFilterComposer extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get username => $composableBuilder(
      column: $table.username, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get password => $composableBuilder(
      column: $table.password, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get role => $composableBuilder(
      column: $table.role, builder: (column) => ColumnFilters(column));
}

class $$UsersTableOrderingComposer
    extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get username => $composableBuilder(
      column: $table.username, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get password => $composableBuilder(
      column: $table.password, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get role => $composableBuilder(
      column: $table.role, builder: (column) => ColumnOrderings(column));
}

class $$UsersTableAnnotationComposer
    extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get username =>
      $composableBuilder(column: $table.username, builder: (column) => column);

  GeneratedColumn<String> get password =>
      $composableBuilder(column: $table.password, builder: (column) => column);

  GeneratedColumn<String> get role =>
      $composableBuilder(column: $table.role, builder: (column) => column);
}

class $$UsersTableTableManager extends RootTableManager<
    _$AppDatabase,
    $UsersTable,
    User,
    $$UsersTableFilterComposer,
    $$UsersTableOrderingComposer,
    $$UsersTableAnnotationComposer,
    $$UsersTableCreateCompanionBuilder,
    $$UsersTableUpdateCompanionBuilder,
    (User, BaseReferences<_$AppDatabase, $UsersTable, User>),
    User,
    PrefetchHooks Function()> {
  $$UsersTableTableManager(_$AppDatabase db, $UsersTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UsersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UsersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UsersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> username = const Value.absent(),
            Value<String> password = const Value.absent(),
            Value<String> role = const Value.absent(),
          }) =>
              UsersCompanion(
            id: id,
            username: username,
            password: password,
            role: role,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String username,
            required String password,
            Value<String> role = const Value.absent(),
          }) =>
              UsersCompanion.insert(
            id: id,
            username: username,
            password: password,
            role: role,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$UsersTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $UsersTable,
    User,
    $$UsersTableFilterComposer,
    $$UsersTableOrderingComposer,
    $$UsersTableAnnotationComposer,
    $$UsersTableCreateCompanionBuilder,
    $$UsersTableUpdateCompanionBuilder,
    (User, BaseReferences<_$AppDatabase, $UsersTable, User>),
    User,
    PrefetchHooks Function()>;
typedef $$SuppliersTableCreateCompanionBuilder = SuppliersCompanion Function({
  Value<int> id,
  required String kodeSupplier,
  required String namaSupplier,
  Value<String?> alamat,
  Value<String?> telepon,
  Value<String?> keterangan,
});
typedef $$SuppliersTableUpdateCompanionBuilder = SuppliersCompanion Function({
  Value<int> id,
  Value<String> kodeSupplier,
  Value<String> namaSupplier,
  Value<String?> alamat,
  Value<String?> telepon,
  Value<String?> keterangan,
});

class $$SuppliersTableFilterComposer
    extends Composer<_$AppDatabase, $SuppliersTable> {
  $$SuppliersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get kodeSupplier => $composableBuilder(
      column: $table.kodeSupplier, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get namaSupplier => $composableBuilder(
      column: $table.namaSupplier, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get alamat => $composableBuilder(
      column: $table.alamat, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get telepon => $composableBuilder(
      column: $table.telepon, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get keterangan => $composableBuilder(
      column: $table.keterangan, builder: (column) => ColumnFilters(column));
}

class $$SuppliersTableOrderingComposer
    extends Composer<_$AppDatabase, $SuppliersTable> {
  $$SuppliersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get kodeSupplier => $composableBuilder(
      column: $table.kodeSupplier,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get namaSupplier => $composableBuilder(
      column: $table.namaSupplier,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get alamat => $composableBuilder(
      column: $table.alamat, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get telepon => $composableBuilder(
      column: $table.telepon, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get keterangan => $composableBuilder(
      column: $table.keterangan, builder: (column) => ColumnOrderings(column));
}

class $$SuppliersTableAnnotationComposer
    extends Composer<_$AppDatabase, $SuppliersTable> {
  $$SuppliersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get kodeSupplier => $composableBuilder(
      column: $table.kodeSupplier, builder: (column) => column);

  GeneratedColumn<String> get namaSupplier => $composableBuilder(
      column: $table.namaSupplier, builder: (column) => column);

  GeneratedColumn<String> get alamat =>
      $composableBuilder(column: $table.alamat, builder: (column) => column);

  GeneratedColumn<String> get telepon =>
      $composableBuilder(column: $table.telepon, builder: (column) => column);

  GeneratedColumn<String> get keterangan => $composableBuilder(
      column: $table.keterangan, builder: (column) => column);
}

class $$SuppliersTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SuppliersTable,
    Supplier,
    $$SuppliersTableFilterComposer,
    $$SuppliersTableOrderingComposer,
    $$SuppliersTableAnnotationComposer,
    $$SuppliersTableCreateCompanionBuilder,
    $$SuppliersTableUpdateCompanionBuilder,
    (Supplier, BaseReferences<_$AppDatabase, $SuppliersTable, Supplier>),
    Supplier,
    PrefetchHooks Function()> {
  $$SuppliersTableTableManager(_$AppDatabase db, $SuppliersTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SuppliersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SuppliersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SuppliersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> kodeSupplier = const Value.absent(),
            Value<String> namaSupplier = const Value.absent(),
            Value<String?> alamat = const Value.absent(),
            Value<String?> telepon = const Value.absent(),
            Value<String?> keterangan = const Value.absent(),
          }) =>
              SuppliersCompanion(
            id: id,
            kodeSupplier: kodeSupplier,
            namaSupplier: namaSupplier,
            alamat: alamat,
            telepon: telepon,
            keterangan: keterangan,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String kodeSupplier,
            required String namaSupplier,
            Value<String?> alamat = const Value.absent(),
            Value<String?> telepon = const Value.absent(),
            Value<String?> keterangan = const Value.absent(),
          }) =>
              SuppliersCompanion.insert(
            id: id,
            kodeSupplier: kodeSupplier,
            namaSupplier: namaSupplier,
            alamat: alamat,
            telepon: telepon,
            keterangan: keterangan,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$SuppliersTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SuppliersTable,
    Supplier,
    $$SuppliersTableFilterComposer,
    $$SuppliersTableOrderingComposer,
    $$SuppliersTableAnnotationComposer,
    $$SuppliersTableCreateCompanionBuilder,
    $$SuppliersTableUpdateCompanionBuilder,
    (Supplier, BaseReferences<_$AppDatabase, $SuppliersTable, Supplier>),
    Supplier,
    PrefetchHooks Function()>;
typedef $$DoctorsTableCreateCompanionBuilder = DoctorsCompanion Function({
  Value<int> id,
  required String kodeDoctor,
  required String namaDoctor,
  Value<String?> alamat,
  Value<String?> telepon,
  Value<int?> nilaipenjualan,
});
typedef $$DoctorsTableUpdateCompanionBuilder = DoctorsCompanion Function({
  Value<int> id,
  Value<String> kodeDoctor,
  Value<String> namaDoctor,
  Value<String?> alamat,
  Value<String?> telepon,
  Value<int?> nilaipenjualan,
});

class $$DoctorsTableFilterComposer
    extends Composer<_$AppDatabase, $DoctorsTable> {
  $$DoctorsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get kodeDoctor => $composableBuilder(
      column: $table.kodeDoctor, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get namaDoctor => $composableBuilder(
      column: $table.namaDoctor, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get alamat => $composableBuilder(
      column: $table.alamat, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get telepon => $composableBuilder(
      column: $table.telepon, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get nilaipenjualan => $composableBuilder(
      column: $table.nilaipenjualan,
      builder: (column) => ColumnFilters(column));
}

class $$DoctorsTableOrderingComposer
    extends Composer<_$AppDatabase, $DoctorsTable> {
  $$DoctorsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get kodeDoctor => $composableBuilder(
      column: $table.kodeDoctor, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get namaDoctor => $composableBuilder(
      column: $table.namaDoctor, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get alamat => $composableBuilder(
      column: $table.alamat, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get telepon => $composableBuilder(
      column: $table.telepon, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get nilaipenjualan => $composableBuilder(
      column: $table.nilaipenjualan,
      builder: (column) => ColumnOrderings(column));
}

class $$DoctorsTableAnnotationComposer
    extends Composer<_$AppDatabase, $DoctorsTable> {
  $$DoctorsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get kodeDoctor => $composableBuilder(
      column: $table.kodeDoctor, builder: (column) => column);

  GeneratedColumn<String> get namaDoctor => $composableBuilder(
      column: $table.namaDoctor, builder: (column) => column);

  GeneratedColumn<String> get alamat =>
      $composableBuilder(column: $table.alamat, builder: (column) => column);

  GeneratedColumn<String> get telepon =>
      $composableBuilder(column: $table.telepon, builder: (column) => column);

  GeneratedColumn<int> get nilaipenjualan => $composableBuilder(
      column: $table.nilaipenjualan, builder: (column) => column);
}

class $$DoctorsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $DoctorsTable,
    Doctor,
    $$DoctorsTableFilterComposer,
    $$DoctorsTableOrderingComposer,
    $$DoctorsTableAnnotationComposer,
    $$DoctorsTableCreateCompanionBuilder,
    $$DoctorsTableUpdateCompanionBuilder,
    (Doctor, BaseReferences<_$AppDatabase, $DoctorsTable, Doctor>),
    Doctor,
    PrefetchHooks Function()> {
  $$DoctorsTableTableManager(_$AppDatabase db, $DoctorsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DoctorsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DoctorsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DoctorsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> kodeDoctor = const Value.absent(),
            Value<String> namaDoctor = const Value.absent(),
            Value<String?> alamat = const Value.absent(),
            Value<String?> telepon = const Value.absent(),
            Value<int?> nilaipenjualan = const Value.absent(),
          }) =>
              DoctorsCompanion(
            id: id,
            kodeDoctor: kodeDoctor,
            namaDoctor: namaDoctor,
            alamat: alamat,
            telepon: telepon,
            nilaipenjualan: nilaipenjualan,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String kodeDoctor,
            required String namaDoctor,
            Value<String?> alamat = const Value.absent(),
            Value<String?> telepon = const Value.absent(),
            Value<int?> nilaipenjualan = const Value.absent(),
          }) =>
              DoctorsCompanion.insert(
            id: id,
            kodeDoctor: kodeDoctor,
            namaDoctor: namaDoctor,
            alamat: alamat,
            telepon: telepon,
            nilaipenjualan: nilaipenjualan,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$DoctorsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $DoctorsTable,
    Doctor,
    $$DoctorsTableFilterComposer,
    $$DoctorsTableOrderingComposer,
    $$DoctorsTableAnnotationComposer,
    $$DoctorsTableCreateCompanionBuilder,
    $$DoctorsTableUpdateCompanionBuilder,
    (Doctor, BaseReferences<_$AppDatabase, $DoctorsTable, Doctor>),
    Doctor,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$UsersTableTableManager get users =>
      $$UsersTableTableManager(_db, _db.users);
  $$SuppliersTableTableManager get suppliers =>
      $$SuppliersTableTableManager(_db, _db.suppliers);
  $$DoctorsTableTableManager get doctors =>
      $$DoctorsTableTableManager(_db, _db.doctors);
}
