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
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _aktifMeta = const VerificationMeta('aktif');
  @override
  late final GeneratedColumn<bool> aktif = GeneratedColumn<bool>(
      'aktif', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("aktif" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _avatarMeta = const VerificationMeta('avatar');
  @override
  late final GeneratedColumn<String> avatar = GeneratedColumn<String>(
      'avatar', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, username, password, role, aktif, avatar];
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
    } else if (isInserting) {
      context.missing(_roleMeta);
    }
    if (data.containsKey('aktif')) {
      context.handle(
          _aktifMeta, aktif.isAcceptableOrUnknown(data['aktif']!, _aktifMeta));
    }
    if (data.containsKey('avatar')) {
      context.handle(_avatarMeta,
          avatar.isAcceptableOrUnknown(data['avatar']!, _avatarMeta));
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
      aktif: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}aktif'])!,
      avatar: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}avatar']),
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
  final bool aktif;
  final String? avatar;
  const User(
      {required this.id,
      required this.username,
      required this.password,
      required this.role,
      required this.aktif,
      this.avatar});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['username'] = Variable<String>(username);
    map['password'] = Variable<String>(password);
    map['role'] = Variable<String>(role);
    map['aktif'] = Variable<bool>(aktif);
    if (!nullToAbsent || avatar != null) {
      map['avatar'] = Variable<String>(avatar);
    }
    return map;
  }

  UsersCompanion toCompanion(bool nullToAbsent) {
    return UsersCompanion(
      id: Value(id),
      username: Value(username),
      password: Value(password),
      role: Value(role),
      aktif: Value(aktif),
      avatar:
          avatar == null && nullToAbsent ? const Value.absent() : Value(avatar),
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
      aktif: serializer.fromJson<bool>(json['aktif']),
      avatar: serializer.fromJson<String?>(json['avatar']),
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
      'aktif': serializer.toJson<bool>(aktif),
      'avatar': serializer.toJson<String?>(avatar),
    };
  }

  User copyWith(
          {int? id,
          String? username,
          String? password,
          String? role,
          bool? aktif,
          Value<String?> avatar = const Value.absent()}) =>
      User(
        id: id ?? this.id,
        username: username ?? this.username,
        password: password ?? this.password,
        role: role ?? this.role,
        aktif: aktif ?? this.aktif,
        avatar: avatar.present ? avatar.value : this.avatar,
      );
  User copyWithCompanion(UsersCompanion data) {
    return User(
      id: data.id.present ? data.id.value : this.id,
      username: data.username.present ? data.username.value : this.username,
      password: data.password.present ? data.password.value : this.password,
      role: data.role.present ? data.role.value : this.role,
      aktif: data.aktif.present ? data.aktif.value : this.aktif,
      avatar: data.avatar.present ? data.avatar.value : this.avatar,
    );
  }

  @override
  String toString() {
    return (StringBuffer('User(')
          ..write('id: $id, ')
          ..write('username: $username, ')
          ..write('password: $password, ')
          ..write('role: $role, ')
          ..write('aktif: $aktif, ')
          ..write('avatar: $avatar')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, username, password, role, aktif, avatar);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is User &&
          other.id == this.id &&
          other.username == this.username &&
          other.password == this.password &&
          other.role == this.role &&
          other.aktif == this.aktif &&
          other.avatar == this.avatar);
}

class UsersCompanion extends UpdateCompanion<User> {
  final Value<int> id;
  final Value<String> username;
  final Value<String> password;
  final Value<String> role;
  final Value<bool> aktif;
  final Value<String?> avatar;
  const UsersCompanion({
    this.id = const Value.absent(),
    this.username = const Value.absent(),
    this.password = const Value.absent(),
    this.role = const Value.absent(),
    this.aktif = const Value.absent(),
    this.avatar = const Value.absent(),
  });
  UsersCompanion.insert({
    this.id = const Value.absent(),
    required String username,
    required String password,
    required String role,
    this.aktif = const Value.absent(),
    this.avatar = const Value.absent(),
  })  : username = Value(username),
        password = Value(password),
        role = Value(role);
  static Insertable<User> custom({
    Expression<int>? id,
    Expression<String>? username,
    Expression<String>? password,
    Expression<String>? role,
    Expression<bool>? aktif,
    Expression<String>? avatar,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (username != null) 'username': username,
      if (password != null) 'password': password,
      if (role != null) 'role': role,
      if (aktif != null) 'aktif': aktif,
      if (avatar != null) 'avatar': avatar,
    });
  }

  UsersCompanion copyWith(
      {Value<int>? id,
      Value<String>? username,
      Value<String>? password,
      Value<String>? role,
      Value<bool>? aktif,
      Value<String?>? avatar}) {
    return UsersCompanion(
      id: id ?? this.id,
      username: username ?? this.username,
      password: password ?? this.password,
      role: role ?? this.role,
      aktif: aktif ?? this.aktif,
      avatar: avatar ?? this.avatar,
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
    if (aktif.present) {
      map['aktif'] = Variable<bool>(aktif.value);
    }
    if (avatar.present) {
      map['avatar'] = Variable<String>(avatar.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UsersCompanion(')
          ..write('id: $id, ')
          ..write('username: $username, ')
          ..write('password: $password, ')
          ..write('role: $role, ')
          ..write('aktif: $aktif, ')
          ..write('avatar: $avatar')
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
      requiredDuringInsert: true);
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

class $BarangsTable extends Barangs with TableInfo<$BarangsTable, Barang> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BarangsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _kodeBarangMeta =
      const VerificationMeta('kodeBarang');
  @override
  late final GeneratedColumn<String> kodeBarang = GeneratedColumn<String>(
      'kode_barang', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 20),
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _namaBarangMeta =
      const VerificationMeta('namaBarang');
  @override
  late final GeneratedColumn<String> namaBarang = GeneratedColumn<String>(
      'nama_barang', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _kelompokMeta =
      const VerificationMeta('kelompok');
  @override
  late final GeneratedColumn<String> kelompok = GeneratedColumn<String>(
      'kelompok', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _satuanMeta = const VerificationMeta('satuan');
  @override
  late final GeneratedColumn<String> satuan = GeneratedColumn<String>(
      'satuan', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _noRakMeta = const VerificationMeta('noRak');
  @override
  late final GeneratedColumn<String> noRak = GeneratedColumn<String>(
      'no_rak', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _stokAktualMeta =
      const VerificationMeta('stokAktual');
  @override
  late final GeneratedColumn<int> stokAktual = GeneratedColumn<int>(
      'stok_aktual', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _hargaBeliMeta =
      const VerificationMeta('hargaBeli');
  @override
  late final GeneratedColumn<int> hargaBeli = GeneratedColumn<int>(
      'harga_beli', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _hargaJualMeta =
      const VerificationMeta('hargaJual');
  @override
  late final GeneratedColumn<int> hargaJual = GeneratedColumn<int>(
      'harga_jual', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _jualDisc1Meta =
      const VerificationMeta('jualDisc1');
  @override
  late final GeneratedColumn<int> jualDisc1 = GeneratedColumn<int>(
      'jual_disc1', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _jualDisc2Meta =
      const VerificationMeta('jualDisc2');
  @override
  late final GeneratedColumn<int> jualDisc2 = GeneratedColumn<int>(
      'jual_disc2', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _jualDisc3Meta =
      const VerificationMeta('jualDisc3');
  @override
  late final GeneratedColumn<int> jualDisc3 = GeneratedColumn<int>(
      'jual_disc3', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _jualDisc4Meta =
      const VerificationMeta('jualDisc4');
  @override
  late final GeneratedColumn<int> jualDisc4 = GeneratedColumn<int>(
      'jual_disc4', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        kodeBarang,
        namaBarang,
        kelompok,
        satuan,
        noRak,
        stokAktual,
        hargaBeli,
        hargaJual,
        jualDisc1,
        jualDisc2,
        jualDisc3,
        jualDisc4
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'barangs';
  @override
  VerificationContext validateIntegrity(Insertable<Barang> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('kode_barang')) {
      context.handle(
          _kodeBarangMeta,
          kodeBarang.isAcceptableOrUnknown(
              data['kode_barang']!, _kodeBarangMeta));
    } else if (isInserting) {
      context.missing(_kodeBarangMeta);
    }
    if (data.containsKey('nama_barang')) {
      context.handle(
          _namaBarangMeta,
          namaBarang.isAcceptableOrUnknown(
              data['nama_barang']!, _namaBarangMeta));
    } else if (isInserting) {
      context.missing(_namaBarangMeta);
    }
    if (data.containsKey('kelompok')) {
      context.handle(_kelompokMeta,
          kelompok.isAcceptableOrUnknown(data['kelompok']!, _kelompokMeta));
    } else if (isInserting) {
      context.missing(_kelompokMeta);
    }
    if (data.containsKey('satuan')) {
      context.handle(_satuanMeta,
          satuan.isAcceptableOrUnknown(data['satuan']!, _satuanMeta));
    } else if (isInserting) {
      context.missing(_satuanMeta);
    }
    if (data.containsKey('no_rak')) {
      context.handle(
          _noRakMeta, noRak.isAcceptableOrUnknown(data['no_rak']!, _noRakMeta));
    } else if (isInserting) {
      context.missing(_noRakMeta);
    }
    if (data.containsKey('stok_aktual')) {
      context.handle(
          _stokAktualMeta,
          stokAktual.isAcceptableOrUnknown(
              data['stok_aktual']!, _stokAktualMeta));
    }
    if (data.containsKey('harga_beli')) {
      context.handle(_hargaBeliMeta,
          hargaBeli.isAcceptableOrUnknown(data['harga_beli']!, _hargaBeliMeta));
    }
    if (data.containsKey('harga_jual')) {
      context.handle(_hargaJualMeta,
          hargaJual.isAcceptableOrUnknown(data['harga_jual']!, _hargaJualMeta));
    }
    if (data.containsKey('jual_disc1')) {
      context.handle(_jualDisc1Meta,
          jualDisc1.isAcceptableOrUnknown(data['jual_disc1']!, _jualDisc1Meta));
    }
    if (data.containsKey('jual_disc2')) {
      context.handle(_jualDisc2Meta,
          jualDisc2.isAcceptableOrUnknown(data['jual_disc2']!, _jualDisc2Meta));
    }
    if (data.containsKey('jual_disc3')) {
      context.handle(_jualDisc3Meta,
          jualDisc3.isAcceptableOrUnknown(data['jual_disc3']!, _jualDisc3Meta));
    }
    if (data.containsKey('jual_disc4')) {
      context.handle(_jualDisc4Meta,
          jualDisc4.isAcceptableOrUnknown(data['jual_disc4']!, _jualDisc4Meta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Barang map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Barang(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      kodeBarang: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}kode_barang'])!,
      namaBarang: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}nama_barang'])!,
      kelompok: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}kelompok'])!,
      satuan: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}satuan'])!,
      noRak: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}no_rak'])!,
      stokAktual: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}stok_aktual'])!,
      hargaBeli: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}harga_beli'])!,
      hargaJual: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}harga_jual'])!,
      jualDisc1: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}jual_disc1']),
      jualDisc2: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}jual_disc2']),
      jualDisc3: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}jual_disc3']),
      jualDisc4: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}jual_disc4']),
    );
  }

  @override
  $BarangsTable createAlias(String alias) {
    return $BarangsTable(attachedDatabase, alias);
  }
}

class Barang extends DataClass implements Insertable<Barang> {
  final int id;
  final String kodeBarang;
  final String namaBarang;
  final String kelompok;
  final String satuan;
  final String noRak;
  final int stokAktual;
  final int hargaBeli;
  final int hargaJual;
  final int? jualDisc1;
  final int? jualDisc2;
  final int? jualDisc3;
  final int? jualDisc4;
  const Barang(
      {required this.id,
      required this.kodeBarang,
      required this.namaBarang,
      required this.kelompok,
      required this.satuan,
      required this.noRak,
      required this.stokAktual,
      required this.hargaBeli,
      required this.hargaJual,
      this.jualDisc1,
      this.jualDisc2,
      this.jualDisc3,
      this.jualDisc4});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['kode_barang'] = Variable<String>(kodeBarang);
    map['nama_barang'] = Variable<String>(namaBarang);
    map['kelompok'] = Variable<String>(kelompok);
    map['satuan'] = Variable<String>(satuan);
    map['no_rak'] = Variable<String>(noRak);
    map['stok_aktual'] = Variable<int>(stokAktual);
    map['harga_beli'] = Variable<int>(hargaBeli);
    map['harga_jual'] = Variable<int>(hargaJual);
    if (!nullToAbsent || jualDisc1 != null) {
      map['jual_disc1'] = Variable<int>(jualDisc1);
    }
    if (!nullToAbsent || jualDisc2 != null) {
      map['jual_disc2'] = Variable<int>(jualDisc2);
    }
    if (!nullToAbsent || jualDisc3 != null) {
      map['jual_disc3'] = Variable<int>(jualDisc3);
    }
    if (!nullToAbsent || jualDisc4 != null) {
      map['jual_disc4'] = Variable<int>(jualDisc4);
    }
    return map;
  }

  BarangsCompanion toCompanion(bool nullToAbsent) {
    return BarangsCompanion(
      id: Value(id),
      kodeBarang: Value(kodeBarang),
      namaBarang: Value(namaBarang),
      kelompok: Value(kelompok),
      satuan: Value(satuan),
      noRak: Value(noRak),
      stokAktual: Value(stokAktual),
      hargaBeli: Value(hargaBeli),
      hargaJual: Value(hargaJual),
      jualDisc1: jualDisc1 == null && nullToAbsent
          ? const Value.absent()
          : Value(jualDisc1),
      jualDisc2: jualDisc2 == null && nullToAbsent
          ? const Value.absent()
          : Value(jualDisc2),
      jualDisc3: jualDisc3 == null && nullToAbsent
          ? const Value.absent()
          : Value(jualDisc3),
      jualDisc4: jualDisc4 == null && nullToAbsent
          ? const Value.absent()
          : Value(jualDisc4),
    );
  }

  factory Barang.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Barang(
      id: serializer.fromJson<int>(json['id']),
      kodeBarang: serializer.fromJson<String>(json['kodeBarang']),
      namaBarang: serializer.fromJson<String>(json['namaBarang']),
      kelompok: serializer.fromJson<String>(json['kelompok']),
      satuan: serializer.fromJson<String>(json['satuan']),
      noRak: serializer.fromJson<String>(json['noRak']),
      stokAktual: serializer.fromJson<int>(json['stokAktual']),
      hargaBeli: serializer.fromJson<int>(json['hargaBeli']),
      hargaJual: serializer.fromJson<int>(json['hargaJual']),
      jualDisc1: serializer.fromJson<int?>(json['jualDisc1']),
      jualDisc2: serializer.fromJson<int?>(json['jualDisc2']),
      jualDisc3: serializer.fromJson<int?>(json['jualDisc3']),
      jualDisc4: serializer.fromJson<int?>(json['jualDisc4']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'kodeBarang': serializer.toJson<String>(kodeBarang),
      'namaBarang': serializer.toJson<String>(namaBarang),
      'kelompok': serializer.toJson<String>(kelompok),
      'satuan': serializer.toJson<String>(satuan),
      'noRak': serializer.toJson<String>(noRak),
      'stokAktual': serializer.toJson<int>(stokAktual),
      'hargaBeli': serializer.toJson<int>(hargaBeli),
      'hargaJual': serializer.toJson<int>(hargaJual),
      'jualDisc1': serializer.toJson<int?>(jualDisc1),
      'jualDisc2': serializer.toJson<int?>(jualDisc2),
      'jualDisc3': serializer.toJson<int?>(jualDisc3),
      'jualDisc4': serializer.toJson<int?>(jualDisc4),
    };
  }

  Barang copyWith(
          {int? id,
          String? kodeBarang,
          String? namaBarang,
          String? kelompok,
          String? satuan,
          String? noRak,
          int? stokAktual,
          int? hargaBeli,
          int? hargaJual,
          Value<int?> jualDisc1 = const Value.absent(),
          Value<int?> jualDisc2 = const Value.absent(),
          Value<int?> jualDisc3 = const Value.absent(),
          Value<int?> jualDisc4 = const Value.absent()}) =>
      Barang(
        id: id ?? this.id,
        kodeBarang: kodeBarang ?? this.kodeBarang,
        namaBarang: namaBarang ?? this.namaBarang,
        kelompok: kelompok ?? this.kelompok,
        satuan: satuan ?? this.satuan,
        noRak: noRak ?? this.noRak,
        stokAktual: stokAktual ?? this.stokAktual,
        hargaBeli: hargaBeli ?? this.hargaBeli,
        hargaJual: hargaJual ?? this.hargaJual,
        jualDisc1: jualDisc1.present ? jualDisc1.value : this.jualDisc1,
        jualDisc2: jualDisc2.present ? jualDisc2.value : this.jualDisc2,
        jualDisc3: jualDisc3.present ? jualDisc3.value : this.jualDisc3,
        jualDisc4: jualDisc4.present ? jualDisc4.value : this.jualDisc4,
      );
  Barang copyWithCompanion(BarangsCompanion data) {
    return Barang(
      id: data.id.present ? data.id.value : this.id,
      kodeBarang:
          data.kodeBarang.present ? data.kodeBarang.value : this.kodeBarang,
      namaBarang:
          data.namaBarang.present ? data.namaBarang.value : this.namaBarang,
      kelompok: data.kelompok.present ? data.kelompok.value : this.kelompok,
      satuan: data.satuan.present ? data.satuan.value : this.satuan,
      noRak: data.noRak.present ? data.noRak.value : this.noRak,
      stokAktual:
          data.stokAktual.present ? data.stokAktual.value : this.stokAktual,
      hargaBeli: data.hargaBeli.present ? data.hargaBeli.value : this.hargaBeli,
      hargaJual: data.hargaJual.present ? data.hargaJual.value : this.hargaJual,
      jualDisc1: data.jualDisc1.present ? data.jualDisc1.value : this.jualDisc1,
      jualDisc2: data.jualDisc2.present ? data.jualDisc2.value : this.jualDisc2,
      jualDisc3: data.jualDisc3.present ? data.jualDisc3.value : this.jualDisc3,
      jualDisc4: data.jualDisc4.present ? data.jualDisc4.value : this.jualDisc4,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Barang(')
          ..write('id: $id, ')
          ..write('kodeBarang: $kodeBarang, ')
          ..write('namaBarang: $namaBarang, ')
          ..write('kelompok: $kelompok, ')
          ..write('satuan: $satuan, ')
          ..write('noRak: $noRak, ')
          ..write('stokAktual: $stokAktual, ')
          ..write('hargaBeli: $hargaBeli, ')
          ..write('hargaJual: $hargaJual, ')
          ..write('jualDisc1: $jualDisc1, ')
          ..write('jualDisc2: $jualDisc2, ')
          ..write('jualDisc3: $jualDisc3, ')
          ..write('jualDisc4: $jualDisc4')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      kodeBarang,
      namaBarang,
      kelompok,
      satuan,
      noRak,
      stokAktual,
      hargaBeli,
      hargaJual,
      jualDisc1,
      jualDisc2,
      jualDisc3,
      jualDisc4);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Barang &&
          other.id == this.id &&
          other.kodeBarang == this.kodeBarang &&
          other.namaBarang == this.namaBarang &&
          other.kelompok == this.kelompok &&
          other.satuan == this.satuan &&
          other.noRak == this.noRak &&
          other.stokAktual == this.stokAktual &&
          other.hargaBeli == this.hargaBeli &&
          other.hargaJual == this.hargaJual &&
          other.jualDisc1 == this.jualDisc1 &&
          other.jualDisc2 == this.jualDisc2 &&
          other.jualDisc3 == this.jualDisc3 &&
          other.jualDisc4 == this.jualDisc4);
}

class BarangsCompanion extends UpdateCompanion<Barang> {
  final Value<int> id;
  final Value<String> kodeBarang;
  final Value<String> namaBarang;
  final Value<String> kelompok;
  final Value<String> satuan;
  final Value<String> noRak;
  final Value<int> stokAktual;
  final Value<int> hargaBeli;
  final Value<int> hargaJual;
  final Value<int?> jualDisc1;
  final Value<int?> jualDisc2;
  final Value<int?> jualDisc3;
  final Value<int?> jualDisc4;
  const BarangsCompanion({
    this.id = const Value.absent(),
    this.kodeBarang = const Value.absent(),
    this.namaBarang = const Value.absent(),
    this.kelompok = const Value.absent(),
    this.satuan = const Value.absent(),
    this.noRak = const Value.absent(),
    this.stokAktual = const Value.absent(),
    this.hargaBeli = const Value.absent(),
    this.hargaJual = const Value.absent(),
    this.jualDisc1 = const Value.absent(),
    this.jualDisc2 = const Value.absent(),
    this.jualDisc3 = const Value.absent(),
    this.jualDisc4 = const Value.absent(),
  });
  BarangsCompanion.insert({
    this.id = const Value.absent(),
    required String kodeBarang,
    required String namaBarang,
    required String kelompok,
    required String satuan,
    required String noRak,
    this.stokAktual = const Value.absent(),
    this.hargaBeli = const Value.absent(),
    this.hargaJual = const Value.absent(),
    this.jualDisc1 = const Value.absent(),
    this.jualDisc2 = const Value.absent(),
    this.jualDisc3 = const Value.absent(),
    this.jualDisc4 = const Value.absent(),
  })  : kodeBarang = Value(kodeBarang),
        namaBarang = Value(namaBarang),
        kelompok = Value(kelompok),
        satuan = Value(satuan),
        noRak = Value(noRak);
  static Insertable<Barang> custom({
    Expression<int>? id,
    Expression<String>? kodeBarang,
    Expression<String>? namaBarang,
    Expression<String>? kelompok,
    Expression<String>? satuan,
    Expression<String>? noRak,
    Expression<int>? stokAktual,
    Expression<int>? hargaBeli,
    Expression<int>? hargaJual,
    Expression<int>? jualDisc1,
    Expression<int>? jualDisc2,
    Expression<int>? jualDisc3,
    Expression<int>? jualDisc4,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (kodeBarang != null) 'kode_barang': kodeBarang,
      if (namaBarang != null) 'nama_barang': namaBarang,
      if (kelompok != null) 'kelompok': kelompok,
      if (satuan != null) 'satuan': satuan,
      if (noRak != null) 'no_rak': noRak,
      if (stokAktual != null) 'stok_aktual': stokAktual,
      if (hargaBeli != null) 'harga_beli': hargaBeli,
      if (hargaJual != null) 'harga_jual': hargaJual,
      if (jualDisc1 != null) 'jual_disc1': jualDisc1,
      if (jualDisc2 != null) 'jual_disc2': jualDisc2,
      if (jualDisc3 != null) 'jual_disc3': jualDisc3,
      if (jualDisc4 != null) 'jual_disc4': jualDisc4,
    });
  }

  BarangsCompanion copyWith(
      {Value<int>? id,
      Value<String>? kodeBarang,
      Value<String>? namaBarang,
      Value<String>? kelompok,
      Value<String>? satuan,
      Value<String>? noRak,
      Value<int>? stokAktual,
      Value<int>? hargaBeli,
      Value<int>? hargaJual,
      Value<int?>? jualDisc1,
      Value<int?>? jualDisc2,
      Value<int?>? jualDisc3,
      Value<int?>? jualDisc4}) {
    return BarangsCompanion(
      id: id ?? this.id,
      kodeBarang: kodeBarang ?? this.kodeBarang,
      namaBarang: namaBarang ?? this.namaBarang,
      kelompok: kelompok ?? this.kelompok,
      satuan: satuan ?? this.satuan,
      noRak: noRak ?? this.noRak,
      stokAktual: stokAktual ?? this.stokAktual,
      hargaBeli: hargaBeli ?? this.hargaBeli,
      hargaJual: hargaJual ?? this.hargaJual,
      jualDisc1: jualDisc1 ?? this.jualDisc1,
      jualDisc2: jualDisc2 ?? this.jualDisc2,
      jualDisc3: jualDisc3 ?? this.jualDisc3,
      jualDisc4: jualDisc4 ?? this.jualDisc4,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (kodeBarang.present) {
      map['kode_barang'] = Variable<String>(kodeBarang.value);
    }
    if (namaBarang.present) {
      map['nama_barang'] = Variable<String>(namaBarang.value);
    }
    if (kelompok.present) {
      map['kelompok'] = Variable<String>(kelompok.value);
    }
    if (satuan.present) {
      map['satuan'] = Variable<String>(satuan.value);
    }
    if (noRak.present) {
      map['no_rak'] = Variable<String>(noRak.value);
    }
    if (stokAktual.present) {
      map['stok_aktual'] = Variable<int>(stokAktual.value);
    }
    if (hargaBeli.present) {
      map['harga_beli'] = Variable<int>(hargaBeli.value);
    }
    if (hargaJual.present) {
      map['harga_jual'] = Variable<int>(hargaJual.value);
    }
    if (jualDisc1.present) {
      map['jual_disc1'] = Variable<int>(jualDisc1.value);
    }
    if (jualDisc2.present) {
      map['jual_disc2'] = Variable<int>(jualDisc2.value);
    }
    if (jualDisc3.present) {
      map['jual_disc3'] = Variable<int>(jualDisc3.value);
    }
    if (jualDisc4.present) {
      map['jual_disc4'] = Variable<int>(jualDisc4.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BarangsCompanion(')
          ..write('id: $id, ')
          ..write('kodeBarang: $kodeBarang, ')
          ..write('namaBarang: $namaBarang, ')
          ..write('kelompok: $kelompok, ')
          ..write('satuan: $satuan, ')
          ..write('noRak: $noRak, ')
          ..write('stokAktual: $stokAktual, ')
          ..write('hargaBeli: $hargaBeli, ')
          ..write('hargaJual: $hargaJual, ')
          ..write('jualDisc1: $jualDisc1, ')
          ..write('jualDisc2: $jualDisc2, ')
          ..write('jualDisc3: $jualDisc3, ')
          ..write('jualDisc4: $jualDisc4')
          ..write(')'))
        .toString();
  }
}

class $PenjualansTable extends Penjualans
    with TableInfo<$PenjualansTable, Penjualan> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PenjualansTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _noFakturMeta =
      const VerificationMeta('noFaktur');
  @override
  late final GeneratedColumn<String> noFaktur = GeneratedColumn<String>(
      'no_faktur', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _kodeBarangMeta =
      const VerificationMeta('kodeBarang');
  @override
  late final GeneratedColumn<String> kodeBarang = GeneratedColumn<String>(
      'kode_barang', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 20),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _namaBarangMeta =
      const VerificationMeta('namaBarang');
  @override
  late final GeneratedColumn<String> namaBarang = GeneratedColumn<String>(
      'nama_barang', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _tanggalBeliMeta =
      const VerificationMeta('tanggalBeli');
  @override
  late final GeneratedColumn<DateTime> tanggalBeli = GeneratedColumn<DateTime>(
      'tanggal_beli', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _expiredMeta =
      const VerificationMeta('expired');
  @override
  late final GeneratedColumn<DateTime> expired = GeneratedColumn<DateTime>(
      'expired', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _kelompokMeta =
      const VerificationMeta('kelompok');
  @override
  late final GeneratedColumn<String> kelompok = GeneratedColumn<String>(
      'kelompok', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _satuanMeta = const VerificationMeta('satuan');
  @override
  late final GeneratedColumn<String> satuan = GeneratedColumn<String>(
      'satuan', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _hargaBeliMeta =
      const VerificationMeta('hargaBeli');
  @override
  late final GeneratedColumn<int> hargaBeli = GeneratedColumn<int>(
      'harga_beli', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _hargaJualMeta =
      const VerificationMeta('hargaJual');
  @override
  late final GeneratedColumn<int> hargaJual = GeneratedColumn<int>(
      'harga_jual', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _jualDisconMeta =
      const VerificationMeta('jualDiscon');
  @override
  late final GeneratedColumn<int> jualDiscon = GeneratedColumn<int>(
      'jual_discon', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _jumlahJualMeta =
      const VerificationMeta('jumlahJual');
  @override
  late final GeneratedColumn<int> jumlahJual = GeneratedColumn<int>(
      'jumlah_jual', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _totalHargaSebelumDiscMeta =
      const VerificationMeta('totalHargaSebelumDisc');
  @override
  late final GeneratedColumn<int> totalHargaSebelumDisc = GeneratedColumn<int>(
      'total_harga_sebelum_disc', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _totalHargaSetelahDiscMeta =
      const VerificationMeta('totalHargaSetelahDisc');
  @override
  late final GeneratedColumn<int> totalHargaSetelahDisc = GeneratedColumn<int>(
      'total_harga_setelah_disc', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _totalDiscMeta =
      const VerificationMeta('totalDisc');
  @override
  late final GeneratedColumn<int> totalDisc = GeneratedColumn<int>(
      'total_disc', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        noFaktur,
        kodeBarang,
        namaBarang,
        tanggalBeli,
        expired,
        kelompok,
        satuan,
        hargaBeli,
        hargaJual,
        jualDiscon,
        jumlahJual,
        totalHargaSebelumDisc,
        totalHargaSetelahDisc,
        totalDisc
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'penjualans';
  @override
  VerificationContext validateIntegrity(Insertable<Penjualan> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('no_faktur')) {
      context.handle(_noFakturMeta,
          noFaktur.isAcceptableOrUnknown(data['no_faktur']!, _noFakturMeta));
    } else if (isInserting) {
      context.missing(_noFakturMeta);
    }
    if (data.containsKey('kode_barang')) {
      context.handle(
          _kodeBarangMeta,
          kodeBarang.isAcceptableOrUnknown(
              data['kode_barang']!, _kodeBarangMeta));
    } else if (isInserting) {
      context.missing(_kodeBarangMeta);
    }
    if (data.containsKey('nama_barang')) {
      context.handle(
          _namaBarangMeta,
          namaBarang.isAcceptableOrUnknown(
              data['nama_barang']!, _namaBarangMeta));
    } else if (isInserting) {
      context.missing(_namaBarangMeta);
    }
    if (data.containsKey('tanggal_beli')) {
      context.handle(
          _tanggalBeliMeta,
          tanggalBeli.isAcceptableOrUnknown(
              data['tanggal_beli']!, _tanggalBeliMeta));
    } else if (isInserting) {
      context.missing(_tanggalBeliMeta);
    }
    if (data.containsKey('expired')) {
      context.handle(_expiredMeta,
          expired.isAcceptableOrUnknown(data['expired']!, _expiredMeta));
    } else if (isInserting) {
      context.missing(_expiredMeta);
    }
    if (data.containsKey('kelompok')) {
      context.handle(_kelompokMeta,
          kelompok.isAcceptableOrUnknown(data['kelompok']!, _kelompokMeta));
    } else if (isInserting) {
      context.missing(_kelompokMeta);
    }
    if (data.containsKey('satuan')) {
      context.handle(_satuanMeta,
          satuan.isAcceptableOrUnknown(data['satuan']!, _satuanMeta));
    } else if (isInserting) {
      context.missing(_satuanMeta);
    }
    if (data.containsKey('harga_beli')) {
      context.handle(_hargaBeliMeta,
          hargaBeli.isAcceptableOrUnknown(data['harga_beli']!, _hargaBeliMeta));
    }
    if (data.containsKey('harga_jual')) {
      context.handle(_hargaJualMeta,
          hargaJual.isAcceptableOrUnknown(data['harga_jual']!, _hargaJualMeta));
    }
    if (data.containsKey('jual_discon')) {
      context.handle(
          _jualDisconMeta,
          jualDiscon.isAcceptableOrUnknown(
              data['jual_discon']!, _jualDisconMeta));
    }
    if (data.containsKey('jumlah_jual')) {
      context.handle(
          _jumlahJualMeta,
          jumlahJual.isAcceptableOrUnknown(
              data['jumlah_jual']!, _jumlahJualMeta));
    }
    if (data.containsKey('total_harga_sebelum_disc')) {
      context.handle(
          _totalHargaSebelumDiscMeta,
          totalHargaSebelumDisc.isAcceptableOrUnknown(
              data['total_harga_sebelum_disc']!, _totalHargaSebelumDiscMeta));
    }
    if (data.containsKey('total_harga_setelah_disc')) {
      context.handle(
          _totalHargaSetelahDiscMeta,
          totalHargaSetelahDisc.isAcceptableOrUnknown(
              data['total_harga_setelah_disc']!, _totalHargaSetelahDiscMeta));
    }
    if (data.containsKey('total_disc')) {
      context.handle(_totalDiscMeta,
          totalDisc.isAcceptableOrUnknown(data['total_disc']!, _totalDiscMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Penjualan map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Penjualan(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      noFaktur: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}no_faktur'])!,
      kodeBarang: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}kode_barang'])!,
      namaBarang: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}nama_barang'])!,
      tanggalBeli: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}tanggal_beli'])!,
      expired: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}expired'])!,
      kelompok: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}kelompok'])!,
      satuan: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}satuan'])!,
      hargaBeli: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}harga_beli'])!,
      hargaJual: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}harga_jual'])!,
      jualDiscon: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}jual_discon']),
      jumlahJual: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}jumlah_jual']),
      totalHargaSebelumDisc: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}total_harga_sebelum_disc']),
      totalHargaSetelahDisc: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}total_harga_setelah_disc']),
      totalDisc: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}total_disc']),
    );
  }

  @override
  $PenjualansTable createAlias(String alias) {
    return $PenjualansTable(attachedDatabase, alias);
  }
}

class Penjualan extends DataClass implements Insertable<Penjualan> {
  final int id;
  final String noFaktur;
  final String kodeBarang;
  final String namaBarang;
  final DateTime tanggalBeli;
  final DateTime expired;
  final String kelompok;
  final String satuan;
  final int hargaBeli;
  final int hargaJual;
  final int? jualDiscon;
  final int? jumlahJual;
  final int? totalHargaSebelumDisc;
  final int? totalHargaSetelahDisc;
  final int? totalDisc;
  const Penjualan(
      {required this.id,
      required this.noFaktur,
      required this.kodeBarang,
      required this.namaBarang,
      required this.tanggalBeli,
      required this.expired,
      required this.kelompok,
      required this.satuan,
      required this.hargaBeli,
      required this.hargaJual,
      this.jualDiscon,
      this.jumlahJual,
      this.totalHargaSebelumDisc,
      this.totalHargaSetelahDisc,
      this.totalDisc});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['no_faktur'] = Variable<String>(noFaktur);
    map['kode_barang'] = Variable<String>(kodeBarang);
    map['nama_barang'] = Variable<String>(namaBarang);
    map['tanggal_beli'] = Variable<DateTime>(tanggalBeli);
    map['expired'] = Variable<DateTime>(expired);
    map['kelompok'] = Variable<String>(kelompok);
    map['satuan'] = Variable<String>(satuan);
    map['harga_beli'] = Variable<int>(hargaBeli);
    map['harga_jual'] = Variable<int>(hargaJual);
    if (!nullToAbsent || jualDiscon != null) {
      map['jual_discon'] = Variable<int>(jualDiscon);
    }
    if (!nullToAbsent || jumlahJual != null) {
      map['jumlah_jual'] = Variable<int>(jumlahJual);
    }
    if (!nullToAbsent || totalHargaSebelumDisc != null) {
      map['total_harga_sebelum_disc'] = Variable<int>(totalHargaSebelumDisc);
    }
    if (!nullToAbsent || totalHargaSetelahDisc != null) {
      map['total_harga_setelah_disc'] = Variable<int>(totalHargaSetelahDisc);
    }
    if (!nullToAbsent || totalDisc != null) {
      map['total_disc'] = Variable<int>(totalDisc);
    }
    return map;
  }

  PenjualansCompanion toCompanion(bool nullToAbsent) {
    return PenjualansCompanion(
      id: Value(id),
      noFaktur: Value(noFaktur),
      kodeBarang: Value(kodeBarang),
      namaBarang: Value(namaBarang),
      tanggalBeli: Value(tanggalBeli),
      expired: Value(expired),
      kelompok: Value(kelompok),
      satuan: Value(satuan),
      hargaBeli: Value(hargaBeli),
      hargaJual: Value(hargaJual),
      jualDiscon: jualDiscon == null && nullToAbsent
          ? const Value.absent()
          : Value(jualDiscon),
      jumlahJual: jumlahJual == null && nullToAbsent
          ? const Value.absent()
          : Value(jumlahJual),
      totalHargaSebelumDisc: totalHargaSebelumDisc == null && nullToAbsent
          ? const Value.absent()
          : Value(totalHargaSebelumDisc),
      totalHargaSetelahDisc: totalHargaSetelahDisc == null && nullToAbsent
          ? const Value.absent()
          : Value(totalHargaSetelahDisc),
      totalDisc: totalDisc == null && nullToAbsent
          ? const Value.absent()
          : Value(totalDisc),
    );
  }

  factory Penjualan.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Penjualan(
      id: serializer.fromJson<int>(json['id']),
      noFaktur: serializer.fromJson<String>(json['noFaktur']),
      kodeBarang: serializer.fromJson<String>(json['kodeBarang']),
      namaBarang: serializer.fromJson<String>(json['namaBarang']),
      tanggalBeli: serializer.fromJson<DateTime>(json['tanggalBeli']),
      expired: serializer.fromJson<DateTime>(json['expired']),
      kelompok: serializer.fromJson<String>(json['kelompok']),
      satuan: serializer.fromJson<String>(json['satuan']),
      hargaBeli: serializer.fromJson<int>(json['hargaBeli']),
      hargaJual: serializer.fromJson<int>(json['hargaJual']),
      jualDiscon: serializer.fromJson<int?>(json['jualDiscon']),
      jumlahJual: serializer.fromJson<int?>(json['jumlahJual']),
      totalHargaSebelumDisc:
          serializer.fromJson<int?>(json['totalHargaSebelumDisc']),
      totalHargaSetelahDisc:
          serializer.fromJson<int?>(json['totalHargaSetelahDisc']),
      totalDisc: serializer.fromJson<int?>(json['totalDisc']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'noFaktur': serializer.toJson<String>(noFaktur),
      'kodeBarang': serializer.toJson<String>(kodeBarang),
      'namaBarang': serializer.toJson<String>(namaBarang),
      'tanggalBeli': serializer.toJson<DateTime>(tanggalBeli),
      'expired': serializer.toJson<DateTime>(expired),
      'kelompok': serializer.toJson<String>(kelompok),
      'satuan': serializer.toJson<String>(satuan),
      'hargaBeli': serializer.toJson<int>(hargaBeli),
      'hargaJual': serializer.toJson<int>(hargaJual),
      'jualDiscon': serializer.toJson<int?>(jualDiscon),
      'jumlahJual': serializer.toJson<int?>(jumlahJual),
      'totalHargaSebelumDisc': serializer.toJson<int?>(totalHargaSebelumDisc),
      'totalHargaSetelahDisc': serializer.toJson<int?>(totalHargaSetelahDisc),
      'totalDisc': serializer.toJson<int?>(totalDisc),
    };
  }

  Penjualan copyWith(
          {int? id,
          String? noFaktur,
          String? kodeBarang,
          String? namaBarang,
          DateTime? tanggalBeli,
          DateTime? expired,
          String? kelompok,
          String? satuan,
          int? hargaBeli,
          int? hargaJual,
          Value<int?> jualDiscon = const Value.absent(),
          Value<int?> jumlahJual = const Value.absent(),
          Value<int?> totalHargaSebelumDisc = const Value.absent(),
          Value<int?> totalHargaSetelahDisc = const Value.absent(),
          Value<int?> totalDisc = const Value.absent()}) =>
      Penjualan(
        id: id ?? this.id,
        noFaktur: noFaktur ?? this.noFaktur,
        kodeBarang: kodeBarang ?? this.kodeBarang,
        namaBarang: namaBarang ?? this.namaBarang,
        tanggalBeli: tanggalBeli ?? this.tanggalBeli,
        expired: expired ?? this.expired,
        kelompok: kelompok ?? this.kelompok,
        satuan: satuan ?? this.satuan,
        hargaBeli: hargaBeli ?? this.hargaBeli,
        hargaJual: hargaJual ?? this.hargaJual,
        jualDiscon: jualDiscon.present ? jualDiscon.value : this.jualDiscon,
        jumlahJual: jumlahJual.present ? jumlahJual.value : this.jumlahJual,
        totalHargaSebelumDisc: totalHargaSebelumDisc.present
            ? totalHargaSebelumDisc.value
            : this.totalHargaSebelumDisc,
        totalHargaSetelahDisc: totalHargaSetelahDisc.present
            ? totalHargaSetelahDisc.value
            : this.totalHargaSetelahDisc,
        totalDisc: totalDisc.present ? totalDisc.value : this.totalDisc,
      );
  Penjualan copyWithCompanion(PenjualansCompanion data) {
    return Penjualan(
      id: data.id.present ? data.id.value : this.id,
      noFaktur: data.noFaktur.present ? data.noFaktur.value : this.noFaktur,
      kodeBarang:
          data.kodeBarang.present ? data.kodeBarang.value : this.kodeBarang,
      namaBarang:
          data.namaBarang.present ? data.namaBarang.value : this.namaBarang,
      tanggalBeli:
          data.tanggalBeli.present ? data.tanggalBeli.value : this.tanggalBeli,
      expired: data.expired.present ? data.expired.value : this.expired,
      kelompok: data.kelompok.present ? data.kelompok.value : this.kelompok,
      satuan: data.satuan.present ? data.satuan.value : this.satuan,
      hargaBeli: data.hargaBeli.present ? data.hargaBeli.value : this.hargaBeli,
      hargaJual: data.hargaJual.present ? data.hargaJual.value : this.hargaJual,
      jualDiscon:
          data.jualDiscon.present ? data.jualDiscon.value : this.jualDiscon,
      jumlahJual:
          data.jumlahJual.present ? data.jumlahJual.value : this.jumlahJual,
      totalHargaSebelumDisc: data.totalHargaSebelumDisc.present
          ? data.totalHargaSebelumDisc.value
          : this.totalHargaSebelumDisc,
      totalHargaSetelahDisc: data.totalHargaSetelahDisc.present
          ? data.totalHargaSetelahDisc.value
          : this.totalHargaSetelahDisc,
      totalDisc: data.totalDisc.present ? data.totalDisc.value : this.totalDisc,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Penjualan(')
          ..write('id: $id, ')
          ..write('noFaktur: $noFaktur, ')
          ..write('kodeBarang: $kodeBarang, ')
          ..write('namaBarang: $namaBarang, ')
          ..write('tanggalBeli: $tanggalBeli, ')
          ..write('expired: $expired, ')
          ..write('kelompok: $kelompok, ')
          ..write('satuan: $satuan, ')
          ..write('hargaBeli: $hargaBeli, ')
          ..write('hargaJual: $hargaJual, ')
          ..write('jualDiscon: $jualDiscon, ')
          ..write('jumlahJual: $jumlahJual, ')
          ..write('totalHargaSebelumDisc: $totalHargaSebelumDisc, ')
          ..write('totalHargaSetelahDisc: $totalHargaSetelahDisc, ')
          ..write('totalDisc: $totalDisc')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      noFaktur,
      kodeBarang,
      namaBarang,
      tanggalBeli,
      expired,
      kelompok,
      satuan,
      hargaBeli,
      hargaJual,
      jualDiscon,
      jumlahJual,
      totalHargaSebelumDisc,
      totalHargaSetelahDisc,
      totalDisc);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Penjualan &&
          other.id == this.id &&
          other.noFaktur == this.noFaktur &&
          other.kodeBarang == this.kodeBarang &&
          other.namaBarang == this.namaBarang &&
          other.tanggalBeli == this.tanggalBeli &&
          other.expired == this.expired &&
          other.kelompok == this.kelompok &&
          other.satuan == this.satuan &&
          other.hargaBeli == this.hargaBeli &&
          other.hargaJual == this.hargaJual &&
          other.jualDiscon == this.jualDiscon &&
          other.jumlahJual == this.jumlahJual &&
          other.totalHargaSebelumDisc == this.totalHargaSebelumDisc &&
          other.totalHargaSetelahDisc == this.totalHargaSetelahDisc &&
          other.totalDisc == this.totalDisc);
}

class PenjualansCompanion extends UpdateCompanion<Penjualan> {
  final Value<int> id;
  final Value<String> noFaktur;
  final Value<String> kodeBarang;
  final Value<String> namaBarang;
  final Value<DateTime> tanggalBeli;
  final Value<DateTime> expired;
  final Value<String> kelompok;
  final Value<String> satuan;
  final Value<int> hargaBeli;
  final Value<int> hargaJual;
  final Value<int?> jualDiscon;
  final Value<int?> jumlahJual;
  final Value<int?> totalHargaSebelumDisc;
  final Value<int?> totalHargaSetelahDisc;
  final Value<int?> totalDisc;
  const PenjualansCompanion({
    this.id = const Value.absent(),
    this.noFaktur = const Value.absent(),
    this.kodeBarang = const Value.absent(),
    this.namaBarang = const Value.absent(),
    this.tanggalBeli = const Value.absent(),
    this.expired = const Value.absent(),
    this.kelompok = const Value.absent(),
    this.satuan = const Value.absent(),
    this.hargaBeli = const Value.absent(),
    this.hargaJual = const Value.absent(),
    this.jualDiscon = const Value.absent(),
    this.jumlahJual = const Value.absent(),
    this.totalHargaSebelumDisc = const Value.absent(),
    this.totalHargaSetelahDisc = const Value.absent(),
    this.totalDisc = const Value.absent(),
  });
  PenjualansCompanion.insert({
    this.id = const Value.absent(),
    required String noFaktur,
    required String kodeBarang,
    required String namaBarang,
    required DateTime tanggalBeli,
    required DateTime expired,
    required String kelompok,
    required String satuan,
    this.hargaBeli = const Value.absent(),
    this.hargaJual = const Value.absent(),
    this.jualDiscon = const Value.absent(),
    this.jumlahJual = const Value.absent(),
    this.totalHargaSebelumDisc = const Value.absent(),
    this.totalHargaSetelahDisc = const Value.absent(),
    this.totalDisc = const Value.absent(),
  })  : noFaktur = Value(noFaktur),
        kodeBarang = Value(kodeBarang),
        namaBarang = Value(namaBarang),
        tanggalBeli = Value(tanggalBeli),
        expired = Value(expired),
        kelompok = Value(kelompok),
        satuan = Value(satuan);
  static Insertable<Penjualan> custom({
    Expression<int>? id,
    Expression<String>? noFaktur,
    Expression<String>? kodeBarang,
    Expression<String>? namaBarang,
    Expression<DateTime>? tanggalBeli,
    Expression<DateTime>? expired,
    Expression<String>? kelompok,
    Expression<String>? satuan,
    Expression<int>? hargaBeli,
    Expression<int>? hargaJual,
    Expression<int>? jualDiscon,
    Expression<int>? jumlahJual,
    Expression<int>? totalHargaSebelumDisc,
    Expression<int>? totalHargaSetelahDisc,
    Expression<int>? totalDisc,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (noFaktur != null) 'no_faktur': noFaktur,
      if (kodeBarang != null) 'kode_barang': kodeBarang,
      if (namaBarang != null) 'nama_barang': namaBarang,
      if (tanggalBeli != null) 'tanggal_beli': tanggalBeli,
      if (expired != null) 'expired': expired,
      if (kelompok != null) 'kelompok': kelompok,
      if (satuan != null) 'satuan': satuan,
      if (hargaBeli != null) 'harga_beli': hargaBeli,
      if (hargaJual != null) 'harga_jual': hargaJual,
      if (jualDiscon != null) 'jual_discon': jualDiscon,
      if (jumlahJual != null) 'jumlah_jual': jumlahJual,
      if (totalHargaSebelumDisc != null)
        'total_harga_sebelum_disc': totalHargaSebelumDisc,
      if (totalHargaSetelahDisc != null)
        'total_harga_setelah_disc': totalHargaSetelahDisc,
      if (totalDisc != null) 'total_disc': totalDisc,
    });
  }

  PenjualansCompanion copyWith(
      {Value<int>? id,
      Value<String>? noFaktur,
      Value<String>? kodeBarang,
      Value<String>? namaBarang,
      Value<DateTime>? tanggalBeli,
      Value<DateTime>? expired,
      Value<String>? kelompok,
      Value<String>? satuan,
      Value<int>? hargaBeli,
      Value<int>? hargaJual,
      Value<int?>? jualDiscon,
      Value<int?>? jumlahJual,
      Value<int?>? totalHargaSebelumDisc,
      Value<int?>? totalHargaSetelahDisc,
      Value<int?>? totalDisc}) {
    return PenjualansCompanion(
      id: id ?? this.id,
      noFaktur: noFaktur ?? this.noFaktur,
      kodeBarang: kodeBarang ?? this.kodeBarang,
      namaBarang: namaBarang ?? this.namaBarang,
      tanggalBeli: tanggalBeli ?? this.tanggalBeli,
      expired: expired ?? this.expired,
      kelompok: kelompok ?? this.kelompok,
      satuan: satuan ?? this.satuan,
      hargaBeli: hargaBeli ?? this.hargaBeli,
      hargaJual: hargaJual ?? this.hargaJual,
      jualDiscon: jualDiscon ?? this.jualDiscon,
      jumlahJual: jumlahJual ?? this.jumlahJual,
      totalHargaSebelumDisc:
          totalHargaSebelumDisc ?? this.totalHargaSebelumDisc,
      totalHargaSetelahDisc:
          totalHargaSetelahDisc ?? this.totalHargaSetelahDisc,
      totalDisc: totalDisc ?? this.totalDisc,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (noFaktur.present) {
      map['no_faktur'] = Variable<String>(noFaktur.value);
    }
    if (kodeBarang.present) {
      map['kode_barang'] = Variable<String>(kodeBarang.value);
    }
    if (namaBarang.present) {
      map['nama_barang'] = Variable<String>(namaBarang.value);
    }
    if (tanggalBeli.present) {
      map['tanggal_beli'] = Variable<DateTime>(tanggalBeli.value);
    }
    if (expired.present) {
      map['expired'] = Variable<DateTime>(expired.value);
    }
    if (kelompok.present) {
      map['kelompok'] = Variable<String>(kelompok.value);
    }
    if (satuan.present) {
      map['satuan'] = Variable<String>(satuan.value);
    }
    if (hargaBeli.present) {
      map['harga_beli'] = Variable<int>(hargaBeli.value);
    }
    if (hargaJual.present) {
      map['harga_jual'] = Variable<int>(hargaJual.value);
    }
    if (jualDiscon.present) {
      map['jual_discon'] = Variable<int>(jualDiscon.value);
    }
    if (jumlahJual.present) {
      map['jumlah_jual'] = Variable<int>(jumlahJual.value);
    }
    if (totalHargaSebelumDisc.present) {
      map['total_harga_sebelum_disc'] =
          Variable<int>(totalHargaSebelumDisc.value);
    }
    if (totalHargaSetelahDisc.present) {
      map['total_harga_setelah_disc'] =
          Variable<int>(totalHargaSetelahDisc.value);
    }
    if (totalDisc.present) {
      map['total_disc'] = Variable<int>(totalDisc.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PenjualansCompanion(')
          ..write('id: $id, ')
          ..write('noFaktur: $noFaktur, ')
          ..write('kodeBarang: $kodeBarang, ')
          ..write('namaBarang: $namaBarang, ')
          ..write('tanggalBeli: $tanggalBeli, ')
          ..write('expired: $expired, ')
          ..write('kelompok: $kelompok, ')
          ..write('satuan: $satuan, ')
          ..write('hargaBeli: $hargaBeli, ')
          ..write('hargaJual: $hargaJual, ')
          ..write('jualDiscon: $jualDiscon, ')
          ..write('jumlahJual: $jumlahJual, ')
          ..write('totalHargaSebelumDisc: $totalHargaSebelumDisc, ')
          ..write('totalHargaSetelahDisc: $totalHargaSetelahDisc, ')
          ..write('totalDisc: $totalDisc')
          ..write(')'))
        .toString();
  }
}

class $PenjualanstmpTable extends Penjualanstmp
    with TableInfo<$PenjualanstmpTable, PenjualanstmpData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PenjualanstmpTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _kodeBarangMeta =
      const VerificationMeta('kodeBarang');
  @override
  late final GeneratedColumn<String> kodeBarang = GeneratedColumn<String>(
      'kode_barang', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 20),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _namaBarangMeta =
      const VerificationMeta('namaBarang');
  @override
  late final GeneratedColumn<String> namaBarang = GeneratedColumn<String>(
      'nama_barang', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _kelompokMeta =
      const VerificationMeta('kelompok');
  @override
  late final GeneratedColumn<String> kelompok = GeneratedColumn<String>(
      'kelompok', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _satuanMeta = const VerificationMeta('satuan');
  @override
  late final GeneratedColumn<String> satuan = GeneratedColumn<String>(
      'satuan', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _hargaBeliMeta =
      const VerificationMeta('hargaBeli');
  @override
  late final GeneratedColumn<int> hargaBeli = GeneratedColumn<int>(
      'harga_beli', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _hargaJualMeta =
      const VerificationMeta('hargaJual');
  @override
  late final GeneratedColumn<int> hargaJual = GeneratedColumn<int>(
      'harga_jual', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _jualDisconMeta =
      const VerificationMeta('jualDiscon');
  @override
  late final GeneratedColumn<int> jualDiscon = GeneratedColumn<int>(
      'jual_discon', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _jumlahJualMeta =
      const VerificationMeta('jumlahJual');
  @override
  late final GeneratedColumn<int> jumlahJual = GeneratedColumn<int>(
      'jumlah_jual', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _totalHargaSebelumDiscMeta =
      const VerificationMeta('totalHargaSebelumDisc');
  @override
  late final GeneratedColumn<int> totalHargaSebelumDisc = GeneratedColumn<int>(
      'total_harga_sebelum_disc', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _totalHargaSetelahDiscMeta =
      const VerificationMeta('totalHargaSetelahDisc');
  @override
  late final GeneratedColumn<int> totalHargaSetelahDisc = GeneratedColumn<int>(
      'total_harga_setelah_disc', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _totalDiscMeta =
      const VerificationMeta('totalDisc');
  @override
  late final GeneratedColumn<int> totalDisc = GeneratedColumn<int>(
      'total_disc', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        kodeBarang,
        namaBarang,
        kelompok,
        satuan,
        hargaBeli,
        hargaJual,
        jualDiscon,
        jumlahJual,
        totalHargaSebelumDisc,
        totalHargaSetelahDisc,
        totalDisc
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'penjualanstmp';
  @override
  VerificationContext validateIntegrity(Insertable<PenjualanstmpData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('kode_barang')) {
      context.handle(
          _kodeBarangMeta,
          kodeBarang.isAcceptableOrUnknown(
              data['kode_barang']!, _kodeBarangMeta));
    } else if (isInserting) {
      context.missing(_kodeBarangMeta);
    }
    if (data.containsKey('nama_barang')) {
      context.handle(
          _namaBarangMeta,
          namaBarang.isAcceptableOrUnknown(
              data['nama_barang']!, _namaBarangMeta));
    } else if (isInserting) {
      context.missing(_namaBarangMeta);
    }
    if (data.containsKey('kelompok')) {
      context.handle(_kelompokMeta,
          kelompok.isAcceptableOrUnknown(data['kelompok']!, _kelompokMeta));
    } else if (isInserting) {
      context.missing(_kelompokMeta);
    }
    if (data.containsKey('satuan')) {
      context.handle(_satuanMeta,
          satuan.isAcceptableOrUnknown(data['satuan']!, _satuanMeta));
    } else if (isInserting) {
      context.missing(_satuanMeta);
    }
    if (data.containsKey('harga_beli')) {
      context.handle(_hargaBeliMeta,
          hargaBeli.isAcceptableOrUnknown(data['harga_beli']!, _hargaBeliMeta));
    }
    if (data.containsKey('harga_jual')) {
      context.handle(_hargaJualMeta,
          hargaJual.isAcceptableOrUnknown(data['harga_jual']!, _hargaJualMeta));
    }
    if (data.containsKey('jual_discon')) {
      context.handle(
          _jualDisconMeta,
          jualDiscon.isAcceptableOrUnknown(
              data['jual_discon']!, _jualDisconMeta));
    }
    if (data.containsKey('jumlah_jual')) {
      context.handle(
          _jumlahJualMeta,
          jumlahJual.isAcceptableOrUnknown(
              data['jumlah_jual']!, _jumlahJualMeta));
    }
    if (data.containsKey('total_harga_sebelum_disc')) {
      context.handle(
          _totalHargaSebelumDiscMeta,
          totalHargaSebelumDisc.isAcceptableOrUnknown(
              data['total_harga_sebelum_disc']!, _totalHargaSebelumDiscMeta));
    }
    if (data.containsKey('total_harga_setelah_disc')) {
      context.handle(
          _totalHargaSetelahDiscMeta,
          totalHargaSetelahDisc.isAcceptableOrUnknown(
              data['total_harga_setelah_disc']!, _totalHargaSetelahDiscMeta));
    }
    if (data.containsKey('total_disc')) {
      context.handle(_totalDiscMeta,
          totalDisc.isAcceptableOrUnknown(data['total_disc']!, _totalDiscMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PenjualanstmpData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PenjualanstmpData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      kodeBarang: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}kode_barang'])!,
      namaBarang: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}nama_barang'])!,
      kelompok: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}kelompok'])!,
      satuan: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}satuan'])!,
      hargaBeli: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}harga_beli'])!,
      hargaJual: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}harga_jual'])!,
      jualDiscon: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}jual_discon']),
      jumlahJual: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}jumlah_jual']),
      totalHargaSebelumDisc: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}total_harga_sebelum_disc']),
      totalHargaSetelahDisc: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}total_harga_setelah_disc']),
      totalDisc: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}total_disc']),
    );
  }

  @override
  $PenjualanstmpTable createAlias(String alias) {
    return $PenjualanstmpTable(attachedDatabase, alias);
  }
}

class PenjualanstmpData extends DataClass
    implements Insertable<PenjualanstmpData> {
  final int id;
  final String kodeBarang;
  final String namaBarang;
  final String kelompok;
  final String satuan;
  final int hargaBeli;
  final int hargaJual;
  final int? jualDiscon;
  final int? jumlahJual;
  final int? totalHargaSebelumDisc;
  final int? totalHargaSetelahDisc;
  final int? totalDisc;
  const PenjualanstmpData(
      {required this.id,
      required this.kodeBarang,
      required this.namaBarang,
      required this.kelompok,
      required this.satuan,
      required this.hargaBeli,
      required this.hargaJual,
      this.jualDiscon,
      this.jumlahJual,
      this.totalHargaSebelumDisc,
      this.totalHargaSetelahDisc,
      this.totalDisc});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['kode_barang'] = Variable<String>(kodeBarang);
    map['nama_barang'] = Variable<String>(namaBarang);
    map['kelompok'] = Variable<String>(kelompok);
    map['satuan'] = Variable<String>(satuan);
    map['harga_beli'] = Variable<int>(hargaBeli);
    map['harga_jual'] = Variable<int>(hargaJual);
    if (!nullToAbsent || jualDiscon != null) {
      map['jual_discon'] = Variable<int>(jualDiscon);
    }
    if (!nullToAbsent || jumlahJual != null) {
      map['jumlah_jual'] = Variable<int>(jumlahJual);
    }
    if (!nullToAbsent || totalHargaSebelumDisc != null) {
      map['total_harga_sebelum_disc'] = Variable<int>(totalHargaSebelumDisc);
    }
    if (!nullToAbsent || totalHargaSetelahDisc != null) {
      map['total_harga_setelah_disc'] = Variable<int>(totalHargaSetelahDisc);
    }
    if (!nullToAbsent || totalDisc != null) {
      map['total_disc'] = Variable<int>(totalDisc);
    }
    return map;
  }

  PenjualanstmpCompanion toCompanion(bool nullToAbsent) {
    return PenjualanstmpCompanion(
      id: Value(id),
      kodeBarang: Value(kodeBarang),
      namaBarang: Value(namaBarang),
      kelompok: Value(kelompok),
      satuan: Value(satuan),
      hargaBeli: Value(hargaBeli),
      hargaJual: Value(hargaJual),
      jualDiscon: jualDiscon == null && nullToAbsent
          ? const Value.absent()
          : Value(jualDiscon),
      jumlahJual: jumlahJual == null && nullToAbsent
          ? const Value.absent()
          : Value(jumlahJual),
      totalHargaSebelumDisc: totalHargaSebelumDisc == null && nullToAbsent
          ? const Value.absent()
          : Value(totalHargaSebelumDisc),
      totalHargaSetelahDisc: totalHargaSetelahDisc == null && nullToAbsent
          ? const Value.absent()
          : Value(totalHargaSetelahDisc),
      totalDisc: totalDisc == null && nullToAbsent
          ? const Value.absent()
          : Value(totalDisc),
    );
  }

  factory PenjualanstmpData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PenjualanstmpData(
      id: serializer.fromJson<int>(json['id']),
      kodeBarang: serializer.fromJson<String>(json['kodeBarang']),
      namaBarang: serializer.fromJson<String>(json['namaBarang']),
      kelompok: serializer.fromJson<String>(json['kelompok']),
      satuan: serializer.fromJson<String>(json['satuan']),
      hargaBeli: serializer.fromJson<int>(json['hargaBeli']),
      hargaJual: serializer.fromJson<int>(json['hargaJual']),
      jualDiscon: serializer.fromJson<int?>(json['jualDiscon']),
      jumlahJual: serializer.fromJson<int?>(json['jumlahJual']),
      totalHargaSebelumDisc:
          serializer.fromJson<int?>(json['totalHargaSebelumDisc']),
      totalHargaSetelahDisc:
          serializer.fromJson<int?>(json['totalHargaSetelahDisc']),
      totalDisc: serializer.fromJson<int?>(json['totalDisc']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'kodeBarang': serializer.toJson<String>(kodeBarang),
      'namaBarang': serializer.toJson<String>(namaBarang),
      'kelompok': serializer.toJson<String>(kelompok),
      'satuan': serializer.toJson<String>(satuan),
      'hargaBeli': serializer.toJson<int>(hargaBeli),
      'hargaJual': serializer.toJson<int>(hargaJual),
      'jualDiscon': serializer.toJson<int?>(jualDiscon),
      'jumlahJual': serializer.toJson<int?>(jumlahJual),
      'totalHargaSebelumDisc': serializer.toJson<int?>(totalHargaSebelumDisc),
      'totalHargaSetelahDisc': serializer.toJson<int?>(totalHargaSetelahDisc),
      'totalDisc': serializer.toJson<int?>(totalDisc),
    };
  }

  PenjualanstmpData copyWith(
          {int? id,
          String? kodeBarang,
          String? namaBarang,
          String? kelompok,
          String? satuan,
          int? hargaBeli,
          int? hargaJual,
          Value<int?> jualDiscon = const Value.absent(),
          Value<int?> jumlahJual = const Value.absent(),
          Value<int?> totalHargaSebelumDisc = const Value.absent(),
          Value<int?> totalHargaSetelahDisc = const Value.absent(),
          Value<int?> totalDisc = const Value.absent()}) =>
      PenjualanstmpData(
        id: id ?? this.id,
        kodeBarang: kodeBarang ?? this.kodeBarang,
        namaBarang: namaBarang ?? this.namaBarang,
        kelompok: kelompok ?? this.kelompok,
        satuan: satuan ?? this.satuan,
        hargaBeli: hargaBeli ?? this.hargaBeli,
        hargaJual: hargaJual ?? this.hargaJual,
        jualDiscon: jualDiscon.present ? jualDiscon.value : this.jualDiscon,
        jumlahJual: jumlahJual.present ? jumlahJual.value : this.jumlahJual,
        totalHargaSebelumDisc: totalHargaSebelumDisc.present
            ? totalHargaSebelumDisc.value
            : this.totalHargaSebelumDisc,
        totalHargaSetelahDisc: totalHargaSetelahDisc.present
            ? totalHargaSetelahDisc.value
            : this.totalHargaSetelahDisc,
        totalDisc: totalDisc.present ? totalDisc.value : this.totalDisc,
      );
  PenjualanstmpData copyWithCompanion(PenjualanstmpCompanion data) {
    return PenjualanstmpData(
      id: data.id.present ? data.id.value : this.id,
      kodeBarang:
          data.kodeBarang.present ? data.kodeBarang.value : this.kodeBarang,
      namaBarang:
          data.namaBarang.present ? data.namaBarang.value : this.namaBarang,
      kelompok: data.kelompok.present ? data.kelompok.value : this.kelompok,
      satuan: data.satuan.present ? data.satuan.value : this.satuan,
      hargaBeli: data.hargaBeli.present ? data.hargaBeli.value : this.hargaBeli,
      hargaJual: data.hargaJual.present ? data.hargaJual.value : this.hargaJual,
      jualDiscon:
          data.jualDiscon.present ? data.jualDiscon.value : this.jualDiscon,
      jumlahJual:
          data.jumlahJual.present ? data.jumlahJual.value : this.jumlahJual,
      totalHargaSebelumDisc: data.totalHargaSebelumDisc.present
          ? data.totalHargaSebelumDisc.value
          : this.totalHargaSebelumDisc,
      totalHargaSetelahDisc: data.totalHargaSetelahDisc.present
          ? data.totalHargaSetelahDisc.value
          : this.totalHargaSetelahDisc,
      totalDisc: data.totalDisc.present ? data.totalDisc.value : this.totalDisc,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PenjualanstmpData(')
          ..write('id: $id, ')
          ..write('kodeBarang: $kodeBarang, ')
          ..write('namaBarang: $namaBarang, ')
          ..write('kelompok: $kelompok, ')
          ..write('satuan: $satuan, ')
          ..write('hargaBeli: $hargaBeli, ')
          ..write('hargaJual: $hargaJual, ')
          ..write('jualDiscon: $jualDiscon, ')
          ..write('jumlahJual: $jumlahJual, ')
          ..write('totalHargaSebelumDisc: $totalHargaSebelumDisc, ')
          ..write('totalHargaSetelahDisc: $totalHargaSetelahDisc, ')
          ..write('totalDisc: $totalDisc')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      kodeBarang,
      namaBarang,
      kelompok,
      satuan,
      hargaBeli,
      hargaJual,
      jualDiscon,
      jumlahJual,
      totalHargaSebelumDisc,
      totalHargaSetelahDisc,
      totalDisc);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PenjualanstmpData &&
          other.id == this.id &&
          other.kodeBarang == this.kodeBarang &&
          other.namaBarang == this.namaBarang &&
          other.kelompok == this.kelompok &&
          other.satuan == this.satuan &&
          other.hargaBeli == this.hargaBeli &&
          other.hargaJual == this.hargaJual &&
          other.jualDiscon == this.jualDiscon &&
          other.jumlahJual == this.jumlahJual &&
          other.totalHargaSebelumDisc == this.totalHargaSebelumDisc &&
          other.totalHargaSetelahDisc == this.totalHargaSetelahDisc &&
          other.totalDisc == this.totalDisc);
}

class PenjualanstmpCompanion extends UpdateCompanion<PenjualanstmpData> {
  final Value<int> id;
  final Value<String> kodeBarang;
  final Value<String> namaBarang;
  final Value<String> kelompok;
  final Value<String> satuan;
  final Value<int> hargaBeli;
  final Value<int> hargaJual;
  final Value<int?> jualDiscon;
  final Value<int?> jumlahJual;
  final Value<int?> totalHargaSebelumDisc;
  final Value<int?> totalHargaSetelahDisc;
  final Value<int?> totalDisc;
  const PenjualanstmpCompanion({
    this.id = const Value.absent(),
    this.kodeBarang = const Value.absent(),
    this.namaBarang = const Value.absent(),
    this.kelompok = const Value.absent(),
    this.satuan = const Value.absent(),
    this.hargaBeli = const Value.absent(),
    this.hargaJual = const Value.absent(),
    this.jualDiscon = const Value.absent(),
    this.jumlahJual = const Value.absent(),
    this.totalHargaSebelumDisc = const Value.absent(),
    this.totalHargaSetelahDisc = const Value.absent(),
    this.totalDisc = const Value.absent(),
  });
  PenjualanstmpCompanion.insert({
    this.id = const Value.absent(),
    required String kodeBarang,
    required String namaBarang,
    required String kelompok,
    required String satuan,
    this.hargaBeli = const Value.absent(),
    this.hargaJual = const Value.absent(),
    this.jualDiscon = const Value.absent(),
    this.jumlahJual = const Value.absent(),
    this.totalHargaSebelumDisc = const Value.absent(),
    this.totalHargaSetelahDisc = const Value.absent(),
    this.totalDisc = const Value.absent(),
  })  : kodeBarang = Value(kodeBarang),
        namaBarang = Value(namaBarang),
        kelompok = Value(kelompok),
        satuan = Value(satuan);
  static Insertable<PenjualanstmpData> custom({
    Expression<int>? id,
    Expression<String>? kodeBarang,
    Expression<String>? namaBarang,
    Expression<String>? kelompok,
    Expression<String>? satuan,
    Expression<int>? hargaBeli,
    Expression<int>? hargaJual,
    Expression<int>? jualDiscon,
    Expression<int>? jumlahJual,
    Expression<int>? totalHargaSebelumDisc,
    Expression<int>? totalHargaSetelahDisc,
    Expression<int>? totalDisc,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (kodeBarang != null) 'kode_barang': kodeBarang,
      if (namaBarang != null) 'nama_barang': namaBarang,
      if (kelompok != null) 'kelompok': kelompok,
      if (satuan != null) 'satuan': satuan,
      if (hargaBeli != null) 'harga_beli': hargaBeli,
      if (hargaJual != null) 'harga_jual': hargaJual,
      if (jualDiscon != null) 'jual_discon': jualDiscon,
      if (jumlahJual != null) 'jumlah_jual': jumlahJual,
      if (totalHargaSebelumDisc != null)
        'total_harga_sebelum_disc': totalHargaSebelumDisc,
      if (totalHargaSetelahDisc != null)
        'total_harga_setelah_disc': totalHargaSetelahDisc,
      if (totalDisc != null) 'total_disc': totalDisc,
    });
  }

  PenjualanstmpCompanion copyWith(
      {Value<int>? id,
      Value<String>? kodeBarang,
      Value<String>? namaBarang,
      Value<String>? kelompok,
      Value<String>? satuan,
      Value<int>? hargaBeli,
      Value<int>? hargaJual,
      Value<int?>? jualDiscon,
      Value<int?>? jumlahJual,
      Value<int?>? totalHargaSebelumDisc,
      Value<int?>? totalHargaSetelahDisc,
      Value<int?>? totalDisc}) {
    return PenjualanstmpCompanion(
      id: id ?? this.id,
      kodeBarang: kodeBarang ?? this.kodeBarang,
      namaBarang: namaBarang ?? this.namaBarang,
      kelompok: kelompok ?? this.kelompok,
      satuan: satuan ?? this.satuan,
      hargaBeli: hargaBeli ?? this.hargaBeli,
      hargaJual: hargaJual ?? this.hargaJual,
      jualDiscon: jualDiscon ?? this.jualDiscon,
      jumlahJual: jumlahJual ?? this.jumlahJual,
      totalHargaSebelumDisc:
          totalHargaSebelumDisc ?? this.totalHargaSebelumDisc,
      totalHargaSetelahDisc:
          totalHargaSetelahDisc ?? this.totalHargaSetelahDisc,
      totalDisc: totalDisc ?? this.totalDisc,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (kodeBarang.present) {
      map['kode_barang'] = Variable<String>(kodeBarang.value);
    }
    if (namaBarang.present) {
      map['nama_barang'] = Variable<String>(namaBarang.value);
    }
    if (kelompok.present) {
      map['kelompok'] = Variable<String>(kelompok.value);
    }
    if (satuan.present) {
      map['satuan'] = Variable<String>(satuan.value);
    }
    if (hargaBeli.present) {
      map['harga_beli'] = Variable<int>(hargaBeli.value);
    }
    if (hargaJual.present) {
      map['harga_jual'] = Variable<int>(hargaJual.value);
    }
    if (jualDiscon.present) {
      map['jual_discon'] = Variable<int>(jualDiscon.value);
    }
    if (jumlahJual.present) {
      map['jumlah_jual'] = Variable<int>(jumlahJual.value);
    }
    if (totalHargaSebelumDisc.present) {
      map['total_harga_sebelum_disc'] =
          Variable<int>(totalHargaSebelumDisc.value);
    }
    if (totalHargaSetelahDisc.present) {
      map['total_harga_setelah_disc'] =
          Variable<int>(totalHargaSetelahDisc.value);
    }
    if (totalDisc.present) {
      map['total_disc'] = Variable<int>(totalDisc.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PenjualanstmpCompanion(')
          ..write('id: $id, ')
          ..write('kodeBarang: $kodeBarang, ')
          ..write('namaBarang: $namaBarang, ')
          ..write('kelompok: $kelompok, ')
          ..write('satuan: $satuan, ')
          ..write('hargaBeli: $hargaBeli, ')
          ..write('hargaJual: $hargaJual, ')
          ..write('jualDiscon: $jualDiscon, ')
          ..write('jumlahJual: $jumlahJual, ')
          ..write('totalHargaSebelumDisc: $totalHargaSebelumDisc, ')
          ..write('totalHargaSetelahDisc: $totalHargaSetelahDisc, ')
          ..write('totalDisc: $totalDisc')
          ..write(')'))
        .toString();
  }
}

class $PembeliansTable extends Pembelians
    with TableInfo<$PembeliansTable, Pembelian> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PembeliansTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _noFakturMeta =
      const VerificationMeta('noFaktur');
  @override
  late final GeneratedColumn<String> noFaktur = GeneratedColumn<String>(
      'no_faktur', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _kodeSupplierMeta =
      const VerificationMeta('kodeSupplier');
  @override
  late final GeneratedColumn<String> kodeSupplier = GeneratedColumn<String>(
      'kode_supplier', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 20),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _namaSuppliersMeta =
      const VerificationMeta('namaSuppliers');
  @override
  late final GeneratedColumn<String> namaSuppliers = GeneratedColumn<String>(
      'nama_suppliers', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _kodeBarangMeta =
      const VerificationMeta('kodeBarang');
  @override
  late final GeneratedColumn<String> kodeBarang = GeneratedColumn<String>(
      'kode_barang', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 20),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _namaBarangMeta =
      const VerificationMeta('namaBarang');
  @override
  late final GeneratedColumn<String> namaBarang = GeneratedColumn<String>(
      'nama_barang', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _tanggalBeliMeta =
      const VerificationMeta('tanggalBeli');
  @override
  late final GeneratedColumn<DateTime> tanggalBeli = GeneratedColumn<DateTime>(
      'tanggal_beli', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _expiredMeta =
      const VerificationMeta('expired');
  @override
  late final GeneratedColumn<DateTime> expired = GeneratedColumn<DateTime>(
      'expired', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _kelompokMeta =
      const VerificationMeta('kelompok');
  @override
  late final GeneratedColumn<String> kelompok = GeneratedColumn<String>(
      'kelompok', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _satuanMeta = const VerificationMeta('satuan');
  @override
  late final GeneratedColumn<String> satuan = GeneratedColumn<String>(
      'satuan', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _hargaBeliMeta =
      const VerificationMeta('hargaBeli');
  @override
  late final GeneratedColumn<int> hargaBeli = GeneratedColumn<int>(
      'harga_beli', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _hargaJualMeta =
      const VerificationMeta('hargaJual');
  @override
  late final GeneratedColumn<int> hargaJual = GeneratedColumn<int>(
      'harga_jual', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _jualDisc1Meta =
      const VerificationMeta('jualDisc1');
  @override
  late final GeneratedColumn<int> jualDisc1 = GeneratedColumn<int>(
      'jual_disc1', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _jualDisc2Meta =
      const VerificationMeta('jualDisc2');
  @override
  late final GeneratedColumn<int> jualDisc2 = GeneratedColumn<int>(
      'jual_disc2', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _jualDisc3Meta =
      const VerificationMeta('jualDisc3');
  @override
  late final GeneratedColumn<int> jualDisc3 = GeneratedColumn<int>(
      'jual_disc3', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _jualDisc4Meta =
      const VerificationMeta('jualDisc4');
  @override
  late final GeneratedColumn<int> jualDisc4 = GeneratedColumn<int>(
      'jual_disc4', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _ppnMeta = const VerificationMeta('ppn');
  @override
  late final GeneratedColumn<int> ppn = GeneratedColumn<int>(
      'ppn', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _jumlahBeliMeta =
      const VerificationMeta('jumlahBeli');
  @override
  late final GeneratedColumn<int> jumlahBeli = GeneratedColumn<int>(
      'jumlah_beli', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _totalHargaMeta =
      const VerificationMeta('totalHarga');
  @override
  late final GeneratedColumn<int> totalHarga = GeneratedColumn<int>(
      'total_harga', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        noFaktur,
        kodeSupplier,
        namaSuppliers,
        kodeBarang,
        namaBarang,
        tanggalBeli,
        expired,
        kelompok,
        satuan,
        hargaBeli,
        hargaJual,
        jualDisc1,
        jualDisc2,
        jualDisc3,
        jualDisc4,
        ppn,
        jumlahBeli,
        totalHarga
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'pembelians';
  @override
  VerificationContext validateIntegrity(Insertable<Pembelian> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('no_faktur')) {
      context.handle(_noFakturMeta,
          noFaktur.isAcceptableOrUnknown(data['no_faktur']!, _noFakturMeta));
    } else if (isInserting) {
      context.missing(_noFakturMeta);
    }
    if (data.containsKey('kode_supplier')) {
      context.handle(
          _kodeSupplierMeta,
          kodeSupplier.isAcceptableOrUnknown(
              data['kode_supplier']!, _kodeSupplierMeta));
    } else if (isInserting) {
      context.missing(_kodeSupplierMeta);
    }
    if (data.containsKey('nama_suppliers')) {
      context.handle(
          _namaSuppliersMeta,
          namaSuppliers.isAcceptableOrUnknown(
              data['nama_suppliers']!, _namaSuppliersMeta));
    } else if (isInserting) {
      context.missing(_namaSuppliersMeta);
    }
    if (data.containsKey('kode_barang')) {
      context.handle(
          _kodeBarangMeta,
          kodeBarang.isAcceptableOrUnknown(
              data['kode_barang']!, _kodeBarangMeta));
    } else if (isInserting) {
      context.missing(_kodeBarangMeta);
    }
    if (data.containsKey('nama_barang')) {
      context.handle(
          _namaBarangMeta,
          namaBarang.isAcceptableOrUnknown(
              data['nama_barang']!, _namaBarangMeta));
    } else if (isInserting) {
      context.missing(_namaBarangMeta);
    }
    if (data.containsKey('tanggal_beli')) {
      context.handle(
          _tanggalBeliMeta,
          tanggalBeli.isAcceptableOrUnknown(
              data['tanggal_beli']!, _tanggalBeliMeta));
    } else if (isInserting) {
      context.missing(_tanggalBeliMeta);
    }
    if (data.containsKey('expired')) {
      context.handle(_expiredMeta,
          expired.isAcceptableOrUnknown(data['expired']!, _expiredMeta));
    } else if (isInserting) {
      context.missing(_expiredMeta);
    }
    if (data.containsKey('kelompok')) {
      context.handle(_kelompokMeta,
          kelompok.isAcceptableOrUnknown(data['kelompok']!, _kelompokMeta));
    } else if (isInserting) {
      context.missing(_kelompokMeta);
    }
    if (data.containsKey('satuan')) {
      context.handle(_satuanMeta,
          satuan.isAcceptableOrUnknown(data['satuan']!, _satuanMeta));
    } else if (isInserting) {
      context.missing(_satuanMeta);
    }
    if (data.containsKey('harga_beli')) {
      context.handle(_hargaBeliMeta,
          hargaBeli.isAcceptableOrUnknown(data['harga_beli']!, _hargaBeliMeta));
    }
    if (data.containsKey('harga_jual')) {
      context.handle(_hargaJualMeta,
          hargaJual.isAcceptableOrUnknown(data['harga_jual']!, _hargaJualMeta));
    }
    if (data.containsKey('jual_disc1')) {
      context.handle(_jualDisc1Meta,
          jualDisc1.isAcceptableOrUnknown(data['jual_disc1']!, _jualDisc1Meta));
    }
    if (data.containsKey('jual_disc2')) {
      context.handle(_jualDisc2Meta,
          jualDisc2.isAcceptableOrUnknown(data['jual_disc2']!, _jualDisc2Meta));
    }
    if (data.containsKey('jual_disc3')) {
      context.handle(_jualDisc3Meta,
          jualDisc3.isAcceptableOrUnknown(data['jual_disc3']!, _jualDisc3Meta));
    }
    if (data.containsKey('jual_disc4')) {
      context.handle(_jualDisc4Meta,
          jualDisc4.isAcceptableOrUnknown(data['jual_disc4']!, _jualDisc4Meta));
    }
    if (data.containsKey('ppn')) {
      context.handle(
          _ppnMeta, ppn.isAcceptableOrUnknown(data['ppn']!, _ppnMeta));
    }
    if (data.containsKey('jumlah_beli')) {
      context.handle(
          _jumlahBeliMeta,
          jumlahBeli.isAcceptableOrUnknown(
              data['jumlah_beli']!, _jumlahBeliMeta));
    }
    if (data.containsKey('total_harga')) {
      context.handle(
          _totalHargaMeta,
          totalHarga.isAcceptableOrUnknown(
              data['total_harga']!, _totalHargaMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Pembelian map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Pembelian(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      noFaktur: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}no_faktur'])!,
      kodeSupplier: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}kode_supplier'])!,
      namaSuppliers: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}nama_suppliers'])!,
      kodeBarang: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}kode_barang'])!,
      namaBarang: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}nama_barang'])!,
      tanggalBeli: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}tanggal_beli'])!,
      expired: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}expired'])!,
      kelompok: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}kelompok'])!,
      satuan: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}satuan'])!,
      hargaBeli: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}harga_beli'])!,
      hargaJual: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}harga_jual'])!,
      jualDisc1: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}jual_disc1']),
      jualDisc2: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}jual_disc2']),
      jualDisc3: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}jual_disc3']),
      jualDisc4: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}jual_disc4']),
      ppn: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}ppn']),
      jumlahBeli: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}jumlah_beli']),
      totalHarga: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}total_harga']),
    );
  }

  @override
  $PembeliansTable createAlias(String alias) {
    return $PembeliansTable(attachedDatabase, alias);
  }
}

class Pembelian extends DataClass implements Insertable<Pembelian> {
  final int id;
  final String noFaktur;
  final String kodeSupplier;
  final String namaSuppliers;
  final String kodeBarang;
  final String namaBarang;
  final DateTime tanggalBeli;
  final DateTime expired;
  final String kelompok;
  final String satuan;
  final int hargaBeli;
  final int hargaJual;
  final int? jualDisc1;
  final int? jualDisc2;
  final int? jualDisc3;
  final int? jualDisc4;
  final int? ppn;
  final int? jumlahBeli;
  final int? totalHarga;
  const Pembelian(
      {required this.id,
      required this.noFaktur,
      required this.kodeSupplier,
      required this.namaSuppliers,
      required this.kodeBarang,
      required this.namaBarang,
      required this.tanggalBeli,
      required this.expired,
      required this.kelompok,
      required this.satuan,
      required this.hargaBeli,
      required this.hargaJual,
      this.jualDisc1,
      this.jualDisc2,
      this.jualDisc3,
      this.jualDisc4,
      this.ppn,
      this.jumlahBeli,
      this.totalHarga});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['no_faktur'] = Variable<String>(noFaktur);
    map['kode_supplier'] = Variable<String>(kodeSupplier);
    map['nama_suppliers'] = Variable<String>(namaSuppliers);
    map['kode_barang'] = Variable<String>(kodeBarang);
    map['nama_barang'] = Variable<String>(namaBarang);
    map['tanggal_beli'] = Variable<DateTime>(tanggalBeli);
    map['expired'] = Variable<DateTime>(expired);
    map['kelompok'] = Variable<String>(kelompok);
    map['satuan'] = Variable<String>(satuan);
    map['harga_beli'] = Variable<int>(hargaBeli);
    map['harga_jual'] = Variable<int>(hargaJual);
    if (!nullToAbsent || jualDisc1 != null) {
      map['jual_disc1'] = Variable<int>(jualDisc1);
    }
    if (!nullToAbsent || jualDisc2 != null) {
      map['jual_disc2'] = Variable<int>(jualDisc2);
    }
    if (!nullToAbsent || jualDisc3 != null) {
      map['jual_disc3'] = Variable<int>(jualDisc3);
    }
    if (!nullToAbsent || jualDisc4 != null) {
      map['jual_disc4'] = Variable<int>(jualDisc4);
    }
    if (!nullToAbsent || ppn != null) {
      map['ppn'] = Variable<int>(ppn);
    }
    if (!nullToAbsent || jumlahBeli != null) {
      map['jumlah_beli'] = Variable<int>(jumlahBeli);
    }
    if (!nullToAbsent || totalHarga != null) {
      map['total_harga'] = Variable<int>(totalHarga);
    }
    return map;
  }

  PembeliansCompanion toCompanion(bool nullToAbsent) {
    return PembeliansCompanion(
      id: Value(id),
      noFaktur: Value(noFaktur),
      kodeSupplier: Value(kodeSupplier),
      namaSuppliers: Value(namaSuppliers),
      kodeBarang: Value(kodeBarang),
      namaBarang: Value(namaBarang),
      tanggalBeli: Value(tanggalBeli),
      expired: Value(expired),
      kelompok: Value(kelompok),
      satuan: Value(satuan),
      hargaBeli: Value(hargaBeli),
      hargaJual: Value(hargaJual),
      jualDisc1: jualDisc1 == null && nullToAbsent
          ? const Value.absent()
          : Value(jualDisc1),
      jualDisc2: jualDisc2 == null && nullToAbsent
          ? const Value.absent()
          : Value(jualDisc2),
      jualDisc3: jualDisc3 == null && nullToAbsent
          ? const Value.absent()
          : Value(jualDisc3),
      jualDisc4: jualDisc4 == null && nullToAbsent
          ? const Value.absent()
          : Value(jualDisc4),
      ppn: ppn == null && nullToAbsent ? const Value.absent() : Value(ppn),
      jumlahBeli: jumlahBeli == null && nullToAbsent
          ? const Value.absent()
          : Value(jumlahBeli),
      totalHarga: totalHarga == null && nullToAbsent
          ? const Value.absent()
          : Value(totalHarga),
    );
  }

  factory Pembelian.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Pembelian(
      id: serializer.fromJson<int>(json['id']),
      noFaktur: serializer.fromJson<String>(json['noFaktur']),
      kodeSupplier: serializer.fromJson<String>(json['kodeSupplier']),
      namaSuppliers: serializer.fromJson<String>(json['namaSuppliers']),
      kodeBarang: serializer.fromJson<String>(json['kodeBarang']),
      namaBarang: serializer.fromJson<String>(json['namaBarang']),
      tanggalBeli: serializer.fromJson<DateTime>(json['tanggalBeli']),
      expired: serializer.fromJson<DateTime>(json['expired']),
      kelompok: serializer.fromJson<String>(json['kelompok']),
      satuan: serializer.fromJson<String>(json['satuan']),
      hargaBeli: serializer.fromJson<int>(json['hargaBeli']),
      hargaJual: serializer.fromJson<int>(json['hargaJual']),
      jualDisc1: serializer.fromJson<int?>(json['jualDisc1']),
      jualDisc2: serializer.fromJson<int?>(json['jualDisc2']),
      jualDisc3: serializer.fromJson<int?>(json['jualDisc3']),
      jualDisc4: serializer.fromJson<int?>(json['jualDisc4']),
      ppn: serializer.fromJson<int?>(json['ppn']),
      jumlahBeli: serializer.fromJson<int?>(json['jumlahBeli']),
      totalHarga: serializer.fromJson<int?>(json['totalHarga']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'noFaktur': serializer.toJson<String>(noFaktur),
      'kodeSupplier': serializer.toJson<String>(kodeSupplier),
      'namaSuppliers': serializer.toJson<String>(namaSuppliers),
      'kodeBarang': serializer.toJson<String>(kodeBarang),
      'namaBarang': serializer.toJson<String>(namaBarang),
      'tanggalBeli': serializer.toJson<DateTime>(tanggalBeli),
      'expired': serializer.toJson<DateTime>(expired),
      'kelompok': serializer.toJson<String>(kelompok),
      'satuan': serializer.toJson<String>(satuan),
      'hargaBeli': serializer.toJson<int>(hargaBeli),
      'hargaJual': serializer.toJson<int>(hargaJual),
      'jualDisc1': serializer.toJson<int?>(jualDisc1),
      'jualDisc2': serializer.toJson<int?>(jualDisc2),
      'jualDisc3': serializer.toJson<int?>(jualDisc3),
      'jualDisc4': serializer.toJson<int?>(jualDisc4),
      'ppn': serializer.toJson<int?>(ppn),
      'jumlahBeli': serializer.toJson<int?>(jumlahBeli),
      'totalHarga': serializer.toJson<int?>(totalHarga),
    };
  }

  Pembelian copyWith(
          {int? id,
          String? noFaktur,
          String? kodeSupplier,
          String? namaSuppliers,
          String? kodeBarang,
          String? namaBarang,
          DateTime? tanggalBeli,
          DateTime? expired,
          String? kelompok,
          String? satuan,
          int? hargaBeli,
          int? hargaJual,
          Value<int?> jualDisc1 = const Value.absent(),
          Value<int?> jualDisc2 = const Value.absent(),
          Value<int?> jualDisc3 = const Value.absent(),
          Value<int?> jualDisc4 = const Value.absent(),
          Value<int?> ppn = const Value.absent(),
          Value<int?> jumlahBeli = const Value.absent(),
          Value<int?> totalHarga = const Value.absent()}) =>
      Pembelian(
        id: id ?? this.id,
        noFaktur: noFaktur ?? this.noFaktur,
        kodeSupplier: kodeSupplier ?? this.kodeSupplier,
        namaSuppliers: namaSuppliers ?? this.namaSuppliers,
        kodeBarang: kodeBarang ?? this.kodeBarang,
        namaBarang: namaBarang ?? this.namaBarang,
        tanggalBeli: tanggalBeli ?? this.tanggalBeli,
        expired: expired ?? this.expired,
        kelompok: kelompok ?? this.kelompok,
        satuan: satuan ?? this.satuan,
        hargaBeli: hargaBeli ?? this.hargaBeli,
        hargaJual: hargaJual ?? this.hargaJual,
        jualDisc1: jualDisc1.present ? jualDisc1.value : this.jualDisc1,
        jualDisc2: jualDisc2.present ? jualDisc2.value : this.jualDisc2,
        jualDisc3: jualDisc3.present ? jualDisc3.value : this.jualDisc3,
        jualDisc4: jualDisc4.present ? jualDisc4.value : this.jualDisc4,
        ppn: ppn.present ? ppn.value : this.ppn,
        jumlahBeli: jumlahBeli.present ? jumlahBeli.value : this.jumlahBeli,
        totalHarga: totalHarga.present ? totalHarga.value : this.totalHarga,
      );
  Pembelian copyWithCompanion(PembeliansCompanion data) {
    return Pembelian(
      id: data.id.present ? data.id.value : this.id,
      noFaktur: data.noFaktur.present ? data.noFaktur.value : this.noFaktur,
      kodeSupplier: data.kodeSupplier.present
          ? data.kodeSupplier.value
          : this.kodeSupplier,
      namaSuppliers: data.namaSuppliers.present
          ? data.namaSuppliers.value
          : this.namaSuppliers,
      kodeBarang:
          data.kodeBarang.present ? data.kodeBarang.value : this.kodeBarang,
      namaBarang:
          data.namaBarang.present ? data.namaBarang.value : this.namaBarang,
      tanggalBeli:
          data.tanggalBeli.present ? data.tanggalBeli.value : this.tanggalBeli,
      expired: data.expired.present ? data.expired.value : this.expired,
      kelompok: data.kelompok.present ? data.kelompok.value : this.kelompok,
      satuan: data.satuan.present ? data.satuan.value : this.satuan,
      hargaBeli: data.hargaBeli.present ? data.hargaBeli.value : this.hargaBeli,
      hargaJual: data.hargaJual.present ? data.hargaJual.value : this.hargaJual,
      jualDisc1: data.jualDisc1.present ? data.jualDisc1.value : this.jualDisc1,
      jualDisc2: data.jualDisc2.present ? data.jualDisc2.value : this.jualDisc2,
      jualDisc3: data.jualDisc3.present ? data.jualDisc3.value : this.jualDisc3,
      jualDisc4: data.jualDisc4.present ? data.jualDisc4.value : this.jualDisc4,
      ppn: data.ppn.present ? data.ppn.value : this.ppn,
      jumlahBeli:
          data.jumlahBeli.present ? data.jumlahBeli.value : this.jumlahBeli,
      totalHarga:
          data.totalHarga.present ? data.totalHarga.value : this.totalHarga,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Pembelian(')
          ..write('id: $id, ')
          ..write('noFaktur: $noFaktur, ')
          ..write('kodeSupplier: $kodeSupplier, ')
          ..write('namaSuppliers: $namaSuppliers, ')
          ..write('kodeBarang: $kodeBarang, ')
          ..write('namaBarang: $namaBarang, ')
          ..write('tanggalBeli: $tanggalBeli, ')
          ..write('expired: $expired, ')
          ..write('kelompok: $kelompok, ')
          ..write('satuan: $satuan, ')
          ..write('hargaBeli: $hargaBeli, ')
          ..write('hargaJual: $hargaJual, ')
          ..write('jualDisc1: $jualDisc1, ')
          ..write('jualDisc2: $jualDisc2, ')
          ..write('jualDisc3: $jualDisc3, ')
          ..write('jualDisc4: $jualDisc4, ')
          ..write('ppn: $ppn, ')
          ..write('jumlahBeli: $jumlahBeli, ')
          ..write('totalHarga: $totalHarga')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      noFaktur,
      kodeSupplier,
      namaSuppliers,
      kodeBarang,
      namaBarang,
      tanggalBeli,
      expired,
      kelompok,
      satuan,
      hargaBeli,
      hargaJual,
      jualDisc1,
      jualDisc2,
      jualDisc3,
      jualDisc4,
      ppn,
      jumlahBeli,
      totalHarga);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Pembelian &&
          other.id == this.id &&
          other.noFaktur == this.noFaktur &&
          other.kodeSupplier == this.kodeSupplier &&
          other.namaSuppliers == this.namaSuppliers &&
          other.kodeBarang == this.kodeBarang &&
          other.namaBarang == this.namaBarang &&
          other.tanggalBeli == this.tanggalBeli &&
          other.expired == this.expired &&
          other.kelompok == this.kelompok &&
          other.satuan == this.satuan &&
          other.hargaBeli == this.hargaBeli &&
          other.hargaJual == this.hargaJual &&
          other.jualDisc1 == this.jualDisc1 &&
          other.jualDisc2 == this.jualDisc2 &&
          other.jualDisc3 == this.jualDisc3 &&
          other.jualDisc4 == this.jualDisc4 &&
          other.ppn == this.ppn &&
          other.jumlahBeli == this.jumlahBeli &&
          other.totalHarga == this.totalHarga);
}

class PembeliansCompanion extends UpdateCompanion<Pembelian> {
  final Value<int> id;
  final Value<String> noFaktur;
  final Value<String> kodeSupplier;
  final Value<String> namaSuppliers;
  final Value<String> kodeBarang;
  final Value<String> namaBarang;
  final Value<DateTime> tanggalBeli;
  final Value<DateTime> expired;
  final Value<String> kelompok;
  final Value<String> satuan;
  final Value<int> hargaBeli;
  final Value<int> hargaJual;
  final Value<int?> jualDisc1;
  final Value<int?> jualDisc2;
  final Value<int?> jualDisc3;
  final Value<int?> jualDisc4;
  final Value<int?> ppn;
  final Value<int?> jumlahBeli;
  final Value<int?> totalHarga;
  const PembeliansCompanion({
    this.id = const Value.absent(),
    this.noFaktur = const Value.absent(),
    this.kodeSupplier = const Value.absent(),
    this.namaSuppliers = const Value.absent(),
    this.kodeBarang = const Value.absent(),
    this.namaBarang = const Value.absent(),
    this.tanggalBeli = const Value.absent(),
    this.expired = const Value.absent(),
    this.kelompok = const Value.absent(),
    this.satuan = const Value.absent(),
    this.hargaBeli = const Value.absent(),
    this.hargaJual = const Value.absent(),
    this.jualDisc1 = const Value.absent(),
    this.jualDisc2 = const Value.absent(),
    this.jualDisc3 = const Value.absent(),
    this.jualDisc4 = const Value.absent(),
    this.ppn = const Value.absent(),
    this.jumlahBeli = const Value.absent(),
    this.totalHarga = const Value.absent(),
  });
  PembeliansCompanion.insert({
    this.id = const Value.absent(),
    required String noFaktur,
    required String kodeSupplier,
    required String namaSuppliers,
    required String kodeBarang,
    required String namaBarang,
    required DateTime tanggalBeli,
    required DateTime expired,
    required String kelompok,
    required String satuan,
    this.hargaBeli = const Value.absent(),
    this.hargaJual = const Value.absent(),
    this.jualDisc1 = const Value.absent(),
    this.jualDisc2 = const Value.absent(),
    this.jualDisc3 = const Value.absent(),
    this.jualDisc4 = const Value.absent(),
    this.ppn = const Value.absent(),
    this.jumlahBeli = const Value.absent(),
    this.totalHarga = const Value.absent(),
  })  : noFaktur = Value(noFaktur),
        kodeSupplier = Value(kodeSupplier),
        namaSuppliers = Value(namaSuppliers),
        kodeBarang = Value(kodeBarang),
        namaBarang = Value(namaBarang),
        tanggalBeli = Value(tanggalBeli),
        expired = Value(expired),
        kelompok = Value(kelompok),
        satuan = Value(satuan);
  static Insertable<Pembelian> custom({
    Expression<int>? id,
    Expression<String>? noFaktur,
    Expression<String>? kodeSupplier,
    Expression<String>? namaSuppliers,
    Expression<String>? kodeBarang,
    Expression<String>? namaBarang,
    Expression<DateTime>? tanggalBeli,
    Expression<DateTime>? expired,
    Expression<String>? kelompok,
    Expression<String>? satuan,
    Expression<int>? hargaBeli,
    Expression<int>? hargaJual,
    Expression<int>? jualDisc1,
    Expression<int>? jualDisc2,
    Expression<int>? jualDisc3,
    Expression<int>? jualDisc4,
    Expression<int>? ppn,
    Expression<int>? jumlahBeli,
    Expression<int>? totalHarga,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (noFaktur != null) 'no_faktur': noFaktur,
      if (kodeSupplier != null) 'kode_supplier': kodeSupplier,
      if (namaSuppliers != null) 'nama_suppliers': namaSuppliers,
      if (kodeBarang != null) 'kode_barang': kodeBarang,
      if (namaBarang != null) 'nama_barang': namaBarang,
      if (tanggalBeli != null) 'tanggal_beli': tanggalBeli,
      if (expired != null) 'expired': expired,
      if (kelompok != null) 'kelompok': kelompok,
      if (satuan != null) 'satuan': satuan,
      if (hargaBeli != null) 'harga_beli': hargaBeli,
      if (hargaJual != null) 'harga_jual': hargaJual,
      if (jualDisc1 != null) 'jual_disc1': jualDisc1,
      if (jualDisc2 != null) 'jual_disc2': jualDisc2,
      if (jualDisc3 != null) 'jual_disc3': jualDisc3,
      if (jualDisc4 != null) 'jual_disc4': jualDisc4,
      if (ppn != null) 'ppn': ppn,
      if (jumlahBeli != null) 'jumlah_beli': jumlahBeli,
      if (totalHarga != null) 'total_harga': totalHarga,
    });
  }

  PembeliansCompanion copyWith(
      {Value<int>? id,
      Value<String>? noFaktur,
      Value<String>? kodeSupplier,
      Value<String>? namaSuppliers,
      Value<String>? kodeBarang,
      Value<String>? namaBarang,
      Value<DateTime>? tanggalBeli,
      Value<DateTime>? expired,
      Value<String>? kelompok,
      Value<String>? satuan,
      Value<int>? hargaBeli,
      Value<int>? hargaJual,
      Value<int?>? jualDisc1,
      Value<int?>? jualDisc2,
      Value<int?>? jualDisc3,
      Value<int?>? jualDisc4,
      Value<int?>? ppn,
      Value<int?>? jumlahBeli,
      Value<int?>? totalHarga}) {
    return PembeliansCompanion(
      id: id ?? this.id,
      noFaktur: noFaktur ?? this.noFaktur,
      kodeSupplier: kodeSupplier ?? this.kodeSupplier,
      namaSuppliers: namaSuppliers ?? this.namaSuppliers,
      kodeBarang: kodeBarang ?? this.kodeBarang,
      namaBarang: namaBarang ?? this.namaBarang,
      tanggalBeli: tanggalBeli ?? this.tanggalBeli,
      expired: expired ?? this.expired,
      kelompok: kelompok ?? this.kelompok,
      satuan: satuan ?? this.satuan,
      hargaBeli: hargaBeli ?? this.hargaBeli,
      hargaJual: hargaJual ?? this.hargaJual,
      jualDisc1: jualDisc1 ?? this.jualDisc1,
      jualDisc2: jualDisc2 ?? this.jualDisc2,
      jualDisc3: jualDisc3 ?? this.jualDisc3,
      jualDisc4: jualDisc4 ?? this.jualDisc4,
      ppn: ppn ?? this.ppn,
      jumlahBeli: jumlahBeli ?? this.jumlahBeli,
      totalHarga: totalHarga ?? this.totalHarga,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (noFaktur.present) {
      map['no_faktur'] = Variable<String>(noFaktur.value);
    }
    if (kodeSupplier.present) {
      map['kode_supplier'] = Variable<String>(kodeSupplier.value);
    }
    if (namaSuppliers.present) {
      map['nama_suppliers'] = Variable<String>(namaSuppliers.value);
    }
    if (kodeBarang.present) {
      map['kode_barang'] = Variable<String>(kodeBarang.value);
    }
    if (namaBarang.present) {
      map['nama_barang'] = Variable<String>(namaBarang.value);
    }
    if (tanggalBeli.present) {
      map['tanggal_beli'] = Variable<DateTime>(tanggalBeli.value);
    }
    if (expired.present) {
      map['expired'] = Variable<DateTime>(expired.value);
    }
    if (kelompok.present) {
      map['kelompok'] = Variable<String>(kelompok.value);
    }
    if (satuan.present) {
      map['satuan'] = Variable<String>(satuan.value);
    }
    if (hargaBeli.present) {
      map['harga_beli'] = Variable<int>(hargaBeli.value);
    }
    if (hargaJual.present) {
      map['harga_jual'] = Variable<int>(hargaJual.value);
    }
    if (jualDisc1.present) {
      map['jual_disc1'] = Variable<int>(jualDisc1.value);
    }
    if (jualDisc2.present) {
      map['jual_disc2'] = Variable<int>(jualDisc2.value);
    }
    if (jualDisc3.present) {
      map['jual_disc3'] = Variable<int>(jualDisc3.value);
    }
    if (jualDisc4.present) {
      map['jual_disc4'] = Variable<int>(jualDisc4.value);
    }
    if (ppn.present) {
      map['ppn'] = Variable<int>(ppn.value);
    }
    if (jumlahBeli.present) {
      map['jumlah_beli'] = Variable<int>(jumlahBeli.value);
    }
    if (totalHarga.present) {
      map['total_harga'] = Variable<int>(totalHarga.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PembeliansCompanion(')
          ..write('id: $id, ')
          ..write('noFaktur: $noFaktur, ')
          ..write('kodeSupplier: $kodeSupplier, ')
          ..write('namaSuppliers: $namaSuppliers, ')
          ..write('kodeBarang: $kodeBarang, ')
          ..write('namaBarang: $namaBarang, ')
          ..write('tanggalBeli: $tanggalBeli, ')
          ..write('expired: $expired, ')
          ..write('kelompok: $kelompok, ')
          ..write('satuan: $satuan, ')
          ..write('hargaBeli: $hargaBeli, ')
          ..write('hargaJual: $hargaJual, ')
          ..write('jualDisc1: $jualDisc1, ')
          ..write('jualDisc2: $jualDisc2, ')
          ..write('jualDisc3: $jualDisc3, ')
          ..write('jualDisc4: $jualDisc4, ')
          ..write('ppn: $ppn, ')
          ..write('jumlahBeli: $jumlahBeli, ')
          ..write('totalHarga: $totalHarga')
          ..write(')'))
        .toString();
  }
}

class $PembelianstmpTable extends Pembelianstmp
    with TableInfo<$PembelianstmpTable, PembelianstmpData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PembelianstmpTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _kodeBarangMeta =
      const VerificationMeta('kodeBarang');
  @override
  late final GeneratedColumn<String> kodeBarang = GeneratedColumn<String>(
      'kode_barang', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 20),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _namaBarangMeta =
      const VerificationMeta('namaBarang');
  @override
  late final GeneratedColumn<String> namaBarang = GeneratedColumn<String>(
      'nama_barang', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _expiredMeta =
      const VerificationMeta('expired');
  @override
  late final GeneratedColumn<DateTime> expired = GeneratedColumn<DateTime>(
      'expired', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _kelompokMeta =
      const VerificationMeta('kelompok');
  @override
  late final GeneratedColumn<String> kelompok = GeneratedColumn<String>(
      'kelompok', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _satuanMeta = const VerificationMeta('satuan');
  @override
  late final GeneratedColumn<String> satuan = GeneratedColumn<String>(
      'satuan', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _hargaBeliMeta =
      const VerificationMeta('hargaBeli');
  @override
  late final GeneratedColumn<int> hargaBeli = GeneratedColumn<int>(
      'harga_beli', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _hargaJualMeta =
      const VerificationMeta('hargaJual');
  @override
  late final GeneratedColumn<int> hargaJual = GeneratedColumn<int>(
      'harga_jual', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _jualDisc1Meta =
      const VerificationMeta('jualDisc1');
  @override
  late final GeneratedColumn<int> jualDisc1 = GeneratedColumn<int>(
      'jual_disc1', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _jualDisc2Meta =
      const VerificationMeta('jualDisc2');
  @override
  late final GeneratedColumn<int> jualDisc2 = GeneratedColumn<int>(
      'jual_disc2', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _jualDisc3Meta =
      const VerificationMeta('jualDisc3');
  @override
  late final GeneratedColumn<int> jualDisc3 = GeneratedColumn<int>(
      'jual_disc3', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _jualDisc4Meta =
      const VerificationMeta('jualDisc4');
  @override
  late final GeneratedColumn<int> jualDisc4 = GeneratedColumn<int>(
      'jual_disc4', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _ppnMeta = const VerificationMeta('ppn');
  @override
  late final GeneratedColumn<int> ppn = GeneratedColumn<int>(
      'ppn', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _jumlahBeliMeta =
      const VerificationMeta('jumlahBeli');
  @override
  late final GeneratedColumn<int> jumlahBeli = GeneratedColumn<int>(
      'jumlah_beli', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _totalHargaMeta =
      const VerificationMeta('totalHarga');
  @override
  late final GeneratedColumn<int> totalHarga = GeneratedColumn<int>(
      'total_harga', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        kodeBarang,
        namaBarang,
        expired,
        kelompok,
        satuan,
        hargaBeli,
        hargaJual,
        jualDisc1,
        jualDisc2,
        jualDisc3,
        jualDisc4,
        ppn,
        jumlahBeli,
        totalHarga
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'pembelianstmp';
  @override
  VerificationContext validateIntegrity(Insertable<PembelianstmpData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('kode_barang')) {
      context.handle(
          _kodeBarangMeta,
          kodeBarang.isAcceptableOrUnknown(
              data['kode_barang']!, _kodeBarangMeta));
    } else if (isInserting) {
      context.missing(_kodeBarangMeta);
    }
    if (data.containsKey('nama_barang')) {
      context.handle(
          _namaBarangMeta,
          namaBarang.isAcceptableOrUnknown(
              data['nama_barang']!, _namaBarangMeta));
    } else if (isInserting) {
      context.missing(_namaBarangMeta);
    }
    if (data.containsKey('expired')) {
      context.handle(_expiredMeta,
          expired.isAcceptableOrUnknown(data['expired']!, _expiredMeta));
    } else if (isInserting) {
      context.missing(_expiredMeta);
    }
    if (data.containsKey('kelompok')) {
      context.handle(_kelompokMeta,
          kelompok.isAcceptableOrUnknown(data['kelompok']!, _kelompokMeta));
    } else if (isInserting) {
      context.missing(_kelompokMeta);
    }
    if (data.containsKey('satuan')) {
      context.handle(_satuanMeta,
          satuan.isAcceptableOrUnknown(data['satuan']!, _satuanMeta));
    } else if (isInserting) {
      context.missing(_satuanMeta);
    }
    if (data.containsKey('harga_beli')) {
      context.handle(_hargaBeliMeta,
          hargaBeli.isAcceptableOrUnknown(data['harga_beli']!, _hargaBeliMeta));
    }
    if (data.containsKey('harga_jual')) {
      context.handle(_hargaJualMeta,
          hargaJual.isAcceptableOrUnknown(data['harga_jual']!, _hargaJualMeta));
    }
    if (data.containsKey('jual_disc1')) {
      context.handle(_jualDisc1Meta,
          jualDisc1.isAcceptableOrUnknown(data['jual_disc1']!, _jualDisc1Meta));
    }
    if (data.containsKey('jual_disc2')) {
      context.handle(_jualDisc2Meta,
          jualDisc2.isAcceptableOrUnknown(data['jual_disc2']!, _jualDisc2Meta));
    }
    if (data.containsKey('jual_disc3')) {
      context.handle(_jualDisc3Meta,
          jualDisc3.isAcceptableOrUnknown(data['jual_disc3']!, _jualDisc3Meta));
    }
    if (data.containsKey('jual_disc4')) {
      context.handle(_jualDisc4Meta,
          jualDisc4.isAcceptableOrUnknown(data['jual_disc4']!, _jualDisc4Meta));
    }
    if (data.containsKey('ppn')) {
      context.handle(
          _ppnMeta, ppn.isAcceptableOrUnknown(data['ppn']!, _ppnMeta));
    }
    if (data.containsKey('jumlah_beli')) {
      context.handle(
          _jumlahBeliMeta,
          jumlahBeli.isAcceptableOrUnknown(
              data['jumlah_beli']!, _jumlahBeliMeta));
    }
    if (data.containsKey('total_harga')) {
      context.handle(
          _totalHargaMeta,
          totalHarga.isAcceptableOrUnknown(
              data['total_harga']!, _totalHargaMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PembelianstmpData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PembelianstmpData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      kodeBarang: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}kode_barang'])!,
      namaBarang: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}nama_barang'])!,
      expired: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}expired'])!,
      kelompok: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}kelompok'])!,
      satuan: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}satuan'])!,
      hargaBeli: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}harga_beli'])!,
      hargaJual: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}harga_jual'])!,
      jualDisc1: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}jual_disc1']),
      jualDisc2: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}jual_disc2']),
      jualDisc3: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}jual_disc3']),
      jualDisc4: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}jual_disc4']),
      ppn: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}ppn']),
      jumlahBeli: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}jumlah_beli']),
      totalHarga: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}total_harga']),
    );
  }

  @override
  $PembelianstmpTable createAlias(String alias) {
    return $PembelianstmpTable(attachedDatabase, alias);
  }
}

class PembelianstmpData extends DataClass
    implements Insertable<PembelianstmpData> {
  final int id;
  final String kodeBarang;
  final String namaBarang;
  final DateTime expired;
  final String kelompok;
  final String satuan;
  final int hargaBeli;
  final int hargaJual;
  final int? jualDisc1;
  final int? jualDisc2;
  final int? jualDisc3;
  final int? jualDisc4;
  final int? ppn;
  final int? jumlahBeli;
  final int? totalHarga;
  const PembelianstmpData(
      {required this.id,
      required this.kodeBarang,
      required this.namaBarang,
      required this.expired,
      required this.kelompok,
      required this.satuan,
      required this.hargaBeli,
      required this.hargaJual,
      this.jualDisc1,
      this.jualDisc2,
      this.jualDisc3,
      this.jualDisc4,
      this.ppn,
      this.jumlahBeli,
      this.totalHarga});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['kode_barang'] = Variable<String>(kodeBarang);
    map['nama_barang'] = Variable<String>(namaBarang);
    map['expired'] = Variable<DateTime>(expired);
    map['kelompok'] = Variable<String>(kelompok);
    map['satuan'] = Variable<String>(satuan);
    map['harga_beli'] = Variable<int>(hargaBeli);
    map['harga_jual'] = Variable<int>(hargaJual);
    if (!nullToAbsent || jualDisc1 != null) {
      map['jual_disc1'] = Variable<int>(jualDisc1);
    }
    if (!nullToAbsent || jualDisc2 != null) {
      map['jual_disc2'] = Variable<int>(jualDisc2);
    }
    if (!nullToAbsent || jualDisc3 != null) {
      map['jual_disc3'] = Variable<int>(jualDisc3);
    }
    if (!nullToAbsent || jualDisc4 != null) {
      map['jual_disc4'] = Variable<int>(jualDisc4);
    }
    if (!nullToAbsent || ppn != null) {
      map['ppn'] = Variable<int>(ppn);
    }
    if (!nullToAbsent || jumlahBeli != null) {
      map['jumlah_beli'] = Variable<int>(jumlahBeli);
    }
    if (!nullToAbsent || totalHarga != null) {
      map['total_harga'] = Variable<int>(totalHarga);
    }
    return map;
  }

  PembelianstmpCompanion toCompanion(bool nullToAbsent) {
    return PembelianstmpCompanion(
      id: Value(id),
      kodeBarang: Value(kodeBarang),
      namaBarang: Value(namaBarang),
      expired: Value(expired),
      kelompok: Value(kelompok),
      satuan: Value(satuan),
      hargaBeli: Value(hargaBeli),
      hargaJual: Value(hargaJual),
      jualDisc1: jualDisc1 == null && nullToAbsent
          ? const Value.absent()
          : Value(jualDisc1),
      jualDisc2: jualDisc2 == null && nullToAbsent
          ? const Value.absent()
          : Value(jualDisc2),
      jualDisc3: jualDisc3 == null && nullToAbsent
          ? const Value.absent()
          : Value(jualDisc3),
      jualDisc4: jualDisc4 == null && nullToAbsent
          ? const Value.absent()
          : Value(jualDisc4),
      ppn: ppn == null && nullToAbsent ? const Value.absent() : Value(ppn),
      jumlahBeli: jumlahBeli == null && nullToAbsent
          ? const Value.absent()
          : Value(jumlahBeli),
      totalHarga: totalHarga == null && nullToAbsent
          ? const Value.absent()
          : Value(totalHarga),
    );
  }

  factory PembelianstmpData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PembelianstmpData(
      id: serializer.fromJson<int>(json['id']),
      kodeBarang: serializer.fromJson<String>(json['kodeBarang']),
      namaBarang: serializer.fromJson<String>(json['namaBarang']),
      expired: serializer.fromJson<DateTime>(json['expired']),
      kelompok: serializer.fromJson<String>(json['kelompok']),
      satuan: serializer.fromJson<String>(json['satuan']),
      hargaBeli: serializer.fromJson<int>(json['hargaBeli']),
      hargaJual: serializer.fromJson<int>(json['hargaJual']),
      jualDisc1: serializer.fromJson<int?>(json['jualDisc1']),
      jualDisc2: serializer.fromJson<int?>(json['jualDisc2']),
      jualDisc3: serializer.fromJson<int?>(json['jualDisc3']),
      jualDisc4: serializer.fromJson<int?>(json['jualDisc4']),
      ppn: serializer.fromJson<int?>(json['ppn']),
      jumlahBeli: serializer.fromJson<int?>(json['jumlahBeli']),
      totalHarga: serializer.fromJson<int?>(json['totalHarga']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'kodeBarang': serializer.toJson<String>(kodeBarang),
      'namaBarang': serializer.toJson<String>(namaBarang),
      'expired': serializer.toJson<DateTime>(expired),
      'kelompok': serializer.toJson<String>(kelompok),
      'satuan': serializer.toJson<String>(satuan),
      'hargaBeli': serializer.toJson<int>(hargaBeli),
      'hargaJual': serializer.toJson<int>(hargaJual),
      'jualDisc1': serializer.toJson<int?>(jualDisc1),
      'jualDisc2': serializer.toJson<int?>(jualDisc2),
      'jualDisc3': serializer.toJson<int?>(jualDisc3),
      'jualDisc4': serializer.toJson<int?>(jualDisc4),
      'ppn': serializer.toJson<int?>(ppn),
      'jumlahBeli': serializer.toJson<int?>(jumlahBeli),
      'totalHarga': serializer.toJson<int?>(totalHarga),
    };
  }

  PembelianstmpData copyWith(
          {int? id,
          String? kodeBarang,
          String? namaBarang,
          DateTime? expired,
          String? kelompok,
          String? satuan,
          int? hargaBeli,
          int? hargaJual,
          Value<int?> jualDisc1 = const Value.absent(),
          Value<int?> jualDisc2 = const Value.absent(),
          Value<int?> jualDisc3 = const Value.absent(),
          Value<int?> jualDisc4 = const Value.absent(),
          Value<int?> ppn = const Value.absent(),
          Value<int?> jumlahBeli = const Value.absent(),
          Value<int?> totalHarga = const Value.absent()}) =>
      PembelianstmpData(
        id: id ?? this.id,
        kodeBarang: kodeBarang ?? this.kodeBarang,
        namaBarang: namaBarang ?? this.namaBarang,
        expired: expired ?? this.expired,
        kelompok: kelompok ?? this.kelompok,
        satuan: satuan ?? this.satuan,
        hargaBeli: hargaBeli ?? this.hargaBeli,
        hargaJual: hargaJual ?? this.hargaJual,
        jualDisc1: jualDisc1.present ? jualDisc1.value : this.jualDisc1,
        jualDisc2: jualDisc2.present ? jualDisc2.value : this.jualDisc2,
        jualDisc3: jualDisc3.present ? jualDisc3.value : this.jualDisc3,
        jualDisc4: jualDisc4.present ? jualDisc4.value : this.jualDisc4,
        ppn: ppn.present ? ppn.value : this.ppn,
        jumlahBeli: jumlahBeli.present ? jumlahBeli.value : this.jumlahBeli,
        totalHarga: totalHarga.present ? totalHarga.value : this.totalHarga,
      );
  PembelianstmpData copyWithCompanion(PembelianstmpCompanion data) {
    return PembelianstmpData(
      id: data.id.present ? data.id.value : this.id,
      kodeBarang:
          data.kodeBarang.present ? data.kodeBarang.value : this.kodeBarang,
      namaBarang:
          data.namaBarang.present ? data.namaBarang.value : this.namaBarang,
      expired: data.expired.present ? data.expired.value : this.expired,
      kelompok: data.kelompok.present ? data.kelompok.value : this.kelompok,
      satuan: data.satuan.present ? data.satuan.value : this.satuan,
      hargaBeli: data.hargaBeli.present ? data.hargaBeli.value : this.hargaBeli,
      hargaJual: data.hargaJual.present ? data.hargaJual.value : this.hargaJual,
      jualDisc1: data.jualDisc1.present ? data.jualDisc1.value : this.jualDisc1,
      jualDisc2: data.jualDisc2.present ? data.jualDisc2.value : this.jualDisc2,
      jualDisc3: data.jualDisc3.present ? data.jualDisc3.value : this.jualDisc3,
      jualDisc4: data.jualDisc4.present ? data.jualDisc4.value : this.jualDisc4,
      ppn: data.ppn.present ? data.ppn.value : this.ppn,
      jumlahBeli:
          data.jumlahBeli.present ? data.jumlahBeli.value : this.jumlahBeli,
      totalHarga:
          data.totalHarga.present ? data.totalHarga.value : this.totalHarga,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PembelianstmpData(')
          ..write('id: $id, ')
          ..write('kodeBarang: $kodeBarang, ')
          ..write('namaBarang: $namaBarang, ')
          ..write('expired: $expired, ')
          ..write('kelompok: $kelompok, ')
          ..write('satuan: $satuan, ')
          ..write('hargaBeli: $hargaBeli, ')
          ..write('hargaJual: $hargaJual, ')
          ..write('jualDisc1: $jualDisc1, ')
          ..write('jualDisc2: $jualDisc2, ')
          ..write('jualDisc3: $jualDisc3, ')
          ..write('jualDisc4: $jualDisc4, ')
          ..write('ppn: $ppn, ')
          ..write('jumlahBeli: $jumlahBeli, ')
          ..write('totalHarga: $totalHarga')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      kodeBarang,
      namaBarang,
      expired,
      kelompok,
      satuan,
      hargaBeli,
      hargaJual,
      jualDisc1,
      jualDisc2,
      jualDisc3,
      jualDisc4,
      ppn,
      jumlahBeli,
      totalHarga);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PembelianstmpData &&
          other.id == this.id &&
          other.kodeBarang == this.kodeBarang &&
          other.namaBarang == this.namaBarang &&
          other.expired == this.expired &&
          other.kelompok == this.kelompok &&
          other.satuan == this.satuan &&
          other.hargaBeli == this.hargaBeli &&
          other.hargaJual == this.hargaJual &&
          other.jualDisc1 == this.jualDisc1 &&
          other.jualDisc2 == this.jualDisc2 &&
          other.jualDisc3 == this.jualDisc3 &&
          other.jualDisc4 == this.jualDisc4 &&
          other.ppn == this.ppn &&
          other.jumlahBeli == this.jumlahBeli &&
          other.totalHarga == this.totalHarga);
}

class PembelianstmpCompanion extends UpdateCompanion<PembelianstmpData> {
  final Value<int> id;
  final Value<String> kodeBarang;
  final Value<String> namaBarang;
  final Value<DateTime> expired;
  final Value<String> kelompok;
  final Value<String> satuan;
  final Value<int> hargaBeli;
  final Value<int> hargaJual;
  final Value<int?> jualDisc1;
  final Value<int?> jualDisc2;
  final Value<int?> jualDisc3;
  final Value<int?> jualDisc4;
  final Value<int?> ppn;
  final Value<int?> jumlahBeli;
  final Value<int?> totalHarga;
  const PembelianstmpCompanion({
    this.id = const Value.absent(),
    this.kodeBarang = const Value.absent(),
    this.namaBarang = const Value.absent(),
    this.expired = const Value.absent(),
    this.kelompok = const Value.absent(),
    this.satuan = const Value.absent(),
    this.hargaBeli = const Value.absent(),
    this.hargaJual = const Value.absent(),
    this.jualDisc1 = const Value.absent(),
    this.jualDisc2 = const Value.absent(),
    this.jualDisc3 = const Value.absent(),
    this.jualDisc4 = const Value.absent(),
    this.ppn = const Value.absent(),
    this.jumlahBeli = const Value.absent(),
    this.totalHarga = const Value.absent(),
  });
  PembelianstmpCompanion.insert({
    this.id = const Value.absent(),
    required String kodeBarang,
    required String namaBarang,
    required DateTime expired,
    required String kelompok,
    required String satuan,
    this.hargaBeli = const Value.absent(),
    this.hargaJual = const Value.absent(),
    this.jualDisc1 = const Value.absent(),
    this.jualDisc2 = const Value.absent(),
    this.jualDisc3 = const Value.absent(),
    this.jualDisc4 = const Value.absent(),
    this.ppn = const Value.absent(),
    this.jumlahBeli = const Value.absent(),
    this.totalHarga = const Value.absent(),
  })  : kodeBarang = Value(kodeBarang),
        namaBarang = Value(namaBarang),
        expired = Value(expired),
        kelompok = Value(kelompok),
        satuan = Value(satuan);
  static Insertable<PembelianstmpData> custom({
    Expression<int>? id,
    Expression<String>? kodeBarang,
    Expression<String>? namaBarang,
    Expression<DateTime>? expired,
    Expression<String>? kelompok,
    Expression<String>? satuan,
    Expression<int>? hargaBeli,
    Expression<int>? hargaJual,
    Expression<int>? jualDisc1,
    Expression<int>? jualDisc2,
    Expression<int>? jualDisc3,
    Expression<int>? jualDisc4,
    Expression<int>? ppn,
    Expression<int>? jumlahBeli,
    Expression<int>? totalHarga,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (kodeBarang != null) 'kode_barang': kodeBarang,
      if (namaBarang != null) 'nama_barang': namaBarang,
      if (expired != null) 'expired': expired,
      if (kelompok != null) 'kelompok': kelompok,
      if (satuan != null) 'satuan': satuan,
      if (hargaBeli != null) 'harga_beli': hargaBeli,
      if (hargaJual != null) 'harga_jual': hargaJual,
      if (jualDisc1 != null) 'jual_disc1': jualDisc1,
      if (jualDisc2 != null) 'jual_disc2': jualDisc2,
      if (jualDisc3 != null) 'jual_disc3': jualDisc3,
      if (jualDisc4 != null) 'jual_disc4': jualDisc4,
      if (ppn != null) 'ppn': ppn,
      if (jumlahBeli != null) 'jumlah_beli': jumlahBeli,
      if (totalHarga != null) 'total_harga': totalHarga,
    });
  }

  PembelianstmpCompanion copyWith(
      {Value<int>? id,
      Value<String>? kodeBarang,
      Value<String>? namaBarang,
      Value<DateTime>? expired,
      Value<String>? kelompok,
      Value<String>? satuan,
      Value<int>? hargaBeli,
      Value<int>? hargaJual,
      Value<int?>? jualDisc1,
      Value<int?>? jualDisc2,
      Value<int?>? jualDisc3,
      Value<int?>? jualDisc4,
      Value<int?>? ppn,
      Value<int?>? jumlahBeli,
      Value<int?>? totalHarga}) {
    return PembelianstmpCompanion(
      id: id ?? this.id,
      kodeBarang: kodeBarang ?? this.kodeBarang,
      namaBarang: namaBarang ?? this.namaBarang,
      expired: expired ?? this.expired,
      kelompok: kelompok ?? this.kelompok,
      satuan: satuan ?? this.satuan,
      hargaBeli: hargaBeli ?? this.hargaBeli,
      hargaJual: hargaJual ?? this.hargaJual,
      jualDisc1: jualDisc1 ?? this.jualDisc1,
      jualDisc2: jualDisc2 ?? this.jualDisc2,
      jualDisc3: jualDisc3 ?? this.jualDisc3,
      jualDisc4: jualDisc4 ?? this.jualDisc4,
      ppn: ppn ?? this.ppn,
      jumlahBeli: jumlahBeli ?? this.jumlahBeli,
      totalHarga: totalHarga ?? this.totalHarga,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (kodeBarang.present) {
      map['kode_barang'] = Variable<String>(kodeBarang.value);
    }
    if (namaBarang.present) {
      map['nama_barang'] = Variable<String>(namaBarang.value);
    }
    if (expired.present) {
      map['expired'] = Variable<DateTime>(expired.value);
    }
    if (kelompok.present) {
      map['kelompok'] = Variable<String>(kelompok.value);
    }
    if (satuan.present) {
      map['satuan'] = Variable<String>(satuan.value);
    }
    if (hargaBeli.present) {
      map['harga_beli'] = Variable<int>(hargaBeli.value);
    }
    if (hargaJual.present) {
      map['harga_jual'] = Variable<int>(hargaJual.value);
    }
    if (jualDisc1.present) {
      map['jual_disc1'] = Variable<int>(jualDisc1.value);
    }
    if (jualDisc2.present) {
      map['jual_disc2'] = Variable<int>(jualDisc2.value);
    }
    if (jualDisc3.present) {
      map['jual_disc3'] = Variable<int>(jualDisc3.value);
    }
    if (jualDisc4.present) {
      map['jual_disc4'] = Variable<int>(jualDisc4.value);
    }
    if (ppn.present) {
      map['ppn'] = Variable<int>(ppn.value);
    }
    if (jumlahBeli.present) {
      map['jumlah_beli'] = Variable<int>(jumlahBeli.value);
    }
    if (totalHarga.present) {
      map['total_harga'] = Variable<int>(totalHarga.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PembelianstmpCompanion(')
          ..write('id: $id, ')
          ..write('kodeBarang: $kodeBarang, ')
          ..write('namaBarang: $namaBarang, ')
          ..write('expired: $expired, ')
          ..write('kelompok: $kelompok, ')
          ..write('satuan: $satuan, ')
          ..write('hargaBeli: $hargaBeli, ')
          ..write('hargaJual: $hargaJual, ')
          ..write('jualDisc1: $jualDisc1, ')
          ..write('jualDisc2: $jualDisc2, ')
          ..write('jualDisc3: $jualDisc3, ')
          ..write('jualDisc4: $jualDisc4, ')
          ..write('ppn: $ppn, ')
          ..write('jumlahBeli: $jumlahBeli, ')
          ..write('totalHarga: $totalHarga')
          ..write(')'))
        .toString();
  }
}

class $PelanggansTable extends Pelanggans
    with TableInfo<$PelanggansTable, Pelanggan> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PelanggansTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _kodPelangganMeta =
      const VerificationMeta('kodPelanggan');
  @override
  late final GeneratedColumn<String> kodPelanggan = GeneratedColumn<String>(
      'kod_pelanggan', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 20),
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _namaPelangganMeta =
      const VerificationMeta('namaPelanggan');
  @override
  late final GeneratedColumn<String> namaPelanggan = GeneratedColumn<String>(
      'nama_pelanggan', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 50),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _usiaMeta = const VerificationMeta('usia');
  @override
  late final GeneratedColumn<int> usia = GeneratedColumn<int>(
      'usia', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _teleponMeta =
      const VerificationMeta('telepon');
  @override
  late final GeneratedColumn<int> telepon = GeneratedColumn<int>(
      'telepon', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _alamatMeta = const VerificationMeta('alamat');
  @override
  late final GeneratedColumn<String> alamat = GeneratedColumn<String>(
      'alamat', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _kelompokMeta =
      const VerificationMeta('kelompok');
  @override
  late final GeneratedColumn<String> kelompok = GeneratedColumn<String>(
      'kelompok', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _limitpiutangMeta =
      const VerificationMeta('limitpiutang');
  @override
  late final GeneratedColumn<int> limitpiutang = GeneratedColumn<int>(
      'limitpiutang', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _keteranganMeta =
      const VerificationMeta('keterangan');
  @override
  late final GeneratedColumn<String> keterangan = GeneratedColumn<String>(
      'keterangan', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _jualDisconMeta =
      const VerificationMeta('jualDiscon');
  @override
  late final GeneratedColumn<int> jualDiscon = GeneratedColumn<int>(
      'jual_discon', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _totalHargaSetelahDiscMeta =
      const VerificationMeta('totalHargaSetelahDisc');
  @override
  late final GeneratedColumn<int> totalHargaSetelahDisc = GeneratedColumn<int>(
      'total_harga_setelah_disc', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _saldoPiutangMeta =
      const VerificationMeta('saldoPiutang');
  @override
  late final GeneratedColumn<int> saldoPiutang = GeneratedColumn<int>(
      'saldo_piutang', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        kodPelanggan,
        namaPelanggan,
        usia,
        telepon,
        alamat,
        kelompok,
        limitpiutang,
        keterangan,
        jualDiscon,
        totalHargaSetelahDisc,
        saldoPiutang
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'pelanggans';
  @override
  VerificationContext validateIntegrity(Insertable<Pelanggan> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('kod_pelanggan')) {
      context.handle(
          _kodPelangganMeta,
          kodPelanggan.isAcceptableOrUnknown(
              data['kod_pelanggan']!, _kodPelangganMeta));
    } else if (isInserting) {
      context.missing(_kodPelangganMeta);
    }
    if (data.containsKey('nama_pelanggan')) {
      context.handle(
          _namaPelangganMeta,
          namaPelanggan.isAcceptableOrUnknown(
              data['nama_pelanggan']!, _namaPelangganMeta));
    } else if (isInserting) {
      context.missing(_namaPelangganMeta);
    }
    if (data.containsKey('usia')) {
      context.handle(
          _usiaMeta, usia.isAcceptableOrUnknown(data['usia']!, _usiaMeta));
    }
    if (data.containsKey('telepon')) {
      context.handle(_teleponMeta,
          telepon.isAcceptableOrUnknown(data['telepon']!, _teleponMeta));
    }
    if (data.containsKey('alamat')) {
      context.handle(_alamatMeta,
          alamat.isAcceptableOrUnknown(data['alamat']!, _alamatMeta));
    }
    if (data.containsKey('kelompok')) {
      context.handle(_kelompokMeta,
          kelompok.isAcceptableOrUnknown(data['kelompok']!, _kelompokMeta));
    }
    if (data.containsKey('limitpiutang')) {
      context.handle(
          _limitpiutangMeta,
          limitpiutang.isAcceptableOrUnknown(
              data['limitpiutang']!, _limitpiutangMeta));
    }
    if (data.containsKey('keterangan')) {
      context.handle(
          _keteranganMeta,
          keterangan.isAcceptableOrUnknown(
              data['keterangan']!, _keteranganMeta));
    }
    if (data.containsKey('jual_discon')) {
      context.handle(
          _jualDisconMeta,
          jualDiscon.isAcceptableOrUnknown(
              data['jual_discon']!, _jualDisconMeta));
    }
    if (data.containsKey('total_harga_setelah_disc')) {
      context.handle(
          _totalHargaSetelahDiscMeta,
          totalHargaSetelahDisc.isAcceptableOrUnknown(
              data['total_harga_setelah_disc']!, _totalHargaSetelahDiscMeta));
    }
    if (data.containsKey('saldo_piutang')) {
      context.handle(
          _saldoPiutangMeta,
          saldoPiutang.isAcceptableOrUnknown(
              data['saldo_piutang']!, _saldoPiutangMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Pelanggan map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Pelanggan(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      kodPelanggan: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}kod_pelanggan'])!,
      namaPelanggan: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}nama_pelanggan'])!,
      usia: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}usia']),
      telepon: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}telepon']),
      alamat: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}alamat']),
      kelompok: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}kelompok']),
      limitpiutang: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}limitpiutang']),
      keterangan: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}keterangan']),
      jualDiscon: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}jual_discon']),
      totalHargaSetelahDisc: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}total_harga_setelah_disc']),
      saldoPiutang: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}saldo_piutang']),
    );
  }

  @override
  $PelanggansTable createAlias(String alias) {
    return $PelanggansTable(attachedDatabase, alias);
  }
}

class Pelanggan extends DataClass implements Insertable<Pelanggan> {
  final int id;
  final String kodPelanggan;
  final String namaPelanggan;
  final int? usia;
  final int? telepon;
  final String? alamat;
  final String? kelompok;
  final int? limitpiutang;
  final String? keterangan;
  final int? jualDiscon;
  final int? totalHargaSetelahDisc;
  final int? saldoPiutang;
  const Pelanggan(
      {required this.id,
      required this.kodPelanggan,
      required this.namaPelanggan,
      this.usia,
      this.telepon,
      this.alamat,
      this.kelompok,
      this.limitpiutang,
      this.keterangan,
      this.jualDiscon,
      this.totalHargaSetelahDisc,
      this.saldoPiutang});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['kod_pelanggan'] = Variable<String>(kodPelanggan);
    map['nama_pelanggan'] = Variable<String>(namaPelanggan);
    if (!nullToAbsent || usia != null) {
      map['usia'] = Variable<int>(usia);
    }
    if (!nullToAbsent || telepon != null) {
      map['telepon'] = Variable<int>(telepon);
    }
    if (!nullToAbsent || alamat != null) {
      map['alamat'] = Variable<String>(alamat);
    }
    if (!nullToAbsent || kelompok != null) {
      map['kelompok'] = Variable<String>(kelompok);
    }
    if (!nullToAbsent || limitpiutang != null) {
      map['limitpiutang'] = Variable<int>(limitpiutang);
    }
    if (!nullToAbsent || keterangan != null) {
      map['keterangan'] = Variable<String>(keterangan);
    }
    if (!nullToAbsent || jualDiscon != null) {
      map['jual_discon'] = Variable<int>(jualDiscon);
    }
    if (!nullToAbsent || totalHargaSetelahDisc != null) {
      map['total_harga_setelah_disc'] = Variable<int>(totalHargaSetelahDisc);
    }
    if (!nullToAbsent || saldoPiutang != null) {
      map['saldo_piutang'] = Variable<int>(saldoPiutang);
    }
    return map;
  }

  PelanggansCompanion toCompanion(bool nullToAbsent) {
    return PelanggansCompanion(
      id: Value(id),
      kodPelanggan: Value(kodPelanggan),
      namaPelanggan: Value(namaPelanggan),
      usia: usia == null && nullToAbsent ? const Value.absent() : Value(usia),
      telepon: telepon == null && nullToAbsent
          ? const Value.absent()
          : Value(telepon),
      alamat:
          alamat == null && nullToAbsent ? const Value.absent() : Value(alamat),
      kelompok: kelompok == null && nullToAbsent
          ? const Value.absent()
          : Value(kelompok),
      limitpiutang: limitpiutang == null && nullToAbsent
          ? const Value.absent()
          : Value(limitpiutang),
      keterangan: keterangan == null && nullToAbsent
          ? const Value.absent()
          : Value(keterangan),
      jualDiscon: jualDiscon == null && nullToAbsent
          ? const Value.absent()
          : Value(jualDiscon),
      totalHargaSetelahDisc: totalHargaSetelahDisc == null && nullToAbsent
          ? const Value.absent()
          : Value(totalHargaSetelahDisc),
      saldoPiutang: saldoPiutang == null && nullToAbsent
          ? const Value.absent()
          : Value(saldoPiutang),
    );
  }

  factory Pelanggan.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Pelanggan(
      id: serializer.fromJson<int>(json['id']),
      kodPelanggan: serializer.fromJson<String>(json['kodPelanggan']),
      namaPelanggan: serializer.fromJson<String>(json['namaPelanggan']),
      usia: serializer.fromJson<int?>(json['usia']),
      telepon: serializer.fromJson<int?>(json['telepon']),
      alamat: serializer.fromJson<String?>(json['alamat']),
      kelompok: serializer.fromJson<String?>(json['kelompok']),
      limitpiutang: serializer.fromJson<int?>(json['limitpiutang']),
      keterangan: serializer.fromJson<String?>(json['keterangan']),
      jualDiscon: serializer.fromJson<int?>(json['jualDiscon']),
      totalHargaSetelahDisc:
          serializer.fromJson<int?>(json['totalHargaSetelahDisc']),
      saldoPiutang: serializer.fromJson<int?>(json['saldoPiutang']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'kodPelanggan': serializer.toJson<String>(kodPelanggan),
      'namaPelanggan': serializer.toJson<String>(namaPelanggan),
      'usia': serializer.toJson<int?>(usia),
      'telepon': serializer.toJson<int?>(telepon),
      'alamat': serializer.toJson<String?>(alamat),
      'kelompok': serializer.toJson<String?>(kelompok),
      'limitpiutang': serializer.toJson<int?>(limitpiutang),
      'keterangan': serializer.toJson<String?>(keterangan),
      'jualDiscon': serializer.toJson<int?>(jualDiscon),
      'totalHargaSetelahDisc': serializer.toJson<int?>(totalHargaSetelahDisc),
      'saldoPiutang': serializer.toJson<int?>(saldoPiutang),
    };
  }

  Pelanggan copyWith(
          {int? id,
          String? kodPelanggan,
          String? namaPelanggan,
          Value<int?> usia = const Value.absent(),
          Value<int?> telepon = const Value.absent(),
          Value<String?> alamat = const Value.absent(),
          Value<String?> kelompok = const Value.absent(),
          Value<int?> limitpiutang = const Value.absent(),
          Value<String?> keterangan = const Value.absent(),
          Value<int?> jualDiscon = const Value.absent(),
          Value<int?> totalHargaSetelahDisc = const Value.absent(),
          Value<int?> saldoPiutang = const Value.absent()}) =>
      Pelanggan(
        id: id ?? this.id,
        kodPelanggan: kodPelanggan ?? this.kodPelanggan,
        namaPelanggan: namaPelanggan ?? this.namaPelanggan,
        usia: usia.present ? usia.value : this.usia,
        telepon: telepon.present ? telepon.value : this.telepon,
        alamat: alamat.present ? alamat.value : this.alamat,
        kelompok: kelompok.present ? kelompok.value : this.kelompok,
        limitpiutang:
            limitpiutang.present ? limitpiutang.value : this.limitpiutang,
        keterangan: keterangan.present ? keterangan.value : this.keterangan,
        jualDiscon: jualDiscon.present ? jualDiscon.value : this.jualDiscon,
        totalHargaSetelahDisc: totalHargaSetelahDisc.present
            ? totalHargaSetelahDisc.value
            : this.totalHargaSetelahDisc,
        saldoPiutang:
            saldoPiutang.present ? saldoPiutang.value : this.saldoPiutang,
      );
  Pelanggan copyWithCompanion(PelanggansCompanion data) {
    return Pelanggan(
      id: data.id.present ? data.id.value : this.id,
      kodPelanggan: data.kodPelanggan.present
          ? data.kodPelanggan.value
          : this.kodPelanggan,
      namaPelanggan: data.namaPelanggan.present
          ? data.namaPelanggan.value
          : this.namaPelanggan,
      usia: data.usia.present ? data.usia.value : this.usia,
      telepon: data.telepon.present ? data.telepon.value : this.telepon,
      alamat: data.alamat.present ? data.alamat.value : this.alamat,
      kelompok: data.kelompok.present ? data.kelompok.value : this.kelompok,
      limitpiutang: data.limitpiutang.present
          ? data.limitpiutang.value
          : this.limitpiutang,
      keterangan:
          data.keterangan.present ? data.keterangan.value : this.keterangan,
      jualDiscon:
          data.jualDiscon.present ? data.jualDiscon.value : this.jualDiscon,
      totalHargaSetelahDisc: data.totalHargaSetelahDisc.present
          ? data.totalHargaSetelahDisc.value
          : this.totalHargaSetelahDisc,
      saldoPiutang: data.saldoPiutang.present
          ? data.saldoPiutang.value
          : this.saldoPiutang,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Pelanggan(')
          ..write('id: $id, ')
          ..write('kodPelanggan: $kodPelanggan, ')
          ..write('namaPelanggan: $namaPelanggan, ')
          ..write('usia: $usia, ')
          ..write('telepon: $telepon, ')
          ..write('alamat: $alamat, ')
          ..write('kelompok: $kelompok, ')
          ..write('limitpiutang: $limitpiutang, ')
          ..write('keterangan: $keterangan, ')
          ..write('jualDiscon: $jualDiscon, ')
          ..write('totalHargaSetelahDisc: $totalHargaSetelahDisc, ')
          ..write('saldoPiutang: $saldoPiutang')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      kodPelanggan,
      namaPelanggan,
      usia,
      telepon,
      alamat,
      kelompok,
      limitpiutang,
      keterangan,
      jualDiscon,
      totalHargaSetelahDisc,
      saldoPiutang);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Pelanggan &&
          other.id == this.id &&
          other.kodPelanggan == this.kodPelanggan &&
          other.namaPelanggan == this.namaPelanggan &&
          other.usia == this.usia &&
          other.telepon == this.telepon &&
          other.alamat == this.alamat &&
          other.kelompok == this.kelompok &&
          other.limitpiutang == this.limitpiutang &&
          other.keterangan == this.keterangan &&
          other.jualDiscon == this.jualDiscon &&
          other.totalHargaSetelahDisc == this.totalHargaSetelahDisc &&
          other.saldoPiutang == this.saldoPiutang);
}

class PelanggansCompanion extends UpdateCompanion<Pelanggan> {
  final Value<int> id;
  final Value<String> kodPelanggan;
  final Value<String> namaPelanggan;
  final Value<int?> usia;
  final Value<int?> telepon;
  final Value<String?> alamat;
  final Value<String?> kelompok;
  final Value<int?> limitpiutang;
  final Value<String?> keterangan;
  final Value<int?> jualDiscon;
  final Value<int?> totalHargaSetelahDisc;
  final Value<int?> saldoPiutang;
  const PelanggansCompanion({
    this.id = const Value.absent(),
    this.kodPelanggan = const Value.absent(),
    this.namaPelanggan = const Value.absent(),
    this.usia = const Value.absent(),
    this.telepon = const Value.absent(),
    this.alamat = const Value.absent(),
    this.kelompok = const Value.absent(),
    this.limitpiutang = const Value.absent(),
    this.keterangan = const Value.absent(),
    this.jualDiscon = const Value.absent(),
    this.totalHargaSetelahDisc = const Value.absent(),
    this.saldoPiutang = const Value.absent(),
  });
  PelanggansCompanion.insert({
    this.id = const Value.absent(),
    required String kodPelanggan,
    required String namaPelanggan,
    this.usia = const Value.absent(),
    this.telepon = const Value.absent(),
    this.alamat = const Value.absent(),
    this.kelompok = const Value.absent(),
    this.limitpiutang = const Value.absent(),
    this.keterangan = const Value.absent(),
    this.jualDiscon = const Value.absent(),
    this.totalHargaSetelahDisc = const Value.absent(),
    this.saldoPiutang = const Value.absent(),
  })  : kodPelanggan = Value(kodPelanggan),
        namaPelanggan = Value(namaPelanggan);
  static Insertable<Pelanggan> custom({
    Expression<int>? id,
    Expression<String>? kodPelanggan,
    Expression<String>? namaPelanggan,
    Expression<int>? usia,
    Expression<int>? telepon,
    Expression<String>? alamat,
    Expression<String>? kelompok,
    Expression<int>? limitpiutang,
    Expression<String>? keterangan,
    Expression<int>? jualDiscon,
    Expression<int>? totalHargaSetelahDisc,
    Expression<int>? saldoPiutang,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (kodPelanggan != null) 'kod_pelanggan': kodPelanggan,
      if (namaPelanggan != null) 'nama_pelanggan': namaPelanggan,
      if (usia != null) 'usia': usia,
      if (telepon != null) 'telepon': telepon,
      if (alamat != null) 'alamat': alamat,
      if (kelompok != null) 'kelompok': kelompok,
      if (limitpiutang != null) 'limitpiutang': limitpiutang,
      if (keterangan != null) 'keterangan': keterangan,
      if (jualDiscon != null) 'jual_discon': jualDiscon,
      if (totalHargaSetelahDisc != null)
        'total_harga_setelah_disc': totalHargaSetelahDisc,
      if (saldoPiutang != null) 'saldo_piutang': saldoPiutang,
    });
  }

  PelanggansCompanion copyWith(
      {Value<int>? id,
      Value<String>? kodPelanggan,
      Value<String>? namaPelanggan,
      Value<int?>? usia,
      Value<int?>? telepon,
      Value<String?>? alamat,
      Value<String?>? kelompok,
      Value<int?>? limitpiutang,
      Value<String?>? keterangan,
      Value<int?>? jualDiscon,
      Value<int?>? totalHargaSetelahDisc,
      Value<int?>? saldoPiutang}) {
    return PelanggansCompanion(
      id: id ?? this.id,
      kodPelanggan: kodPelanggan ?? this.kodPelanggan,
      namaPelanggan: namaPelanggan ?? this.namaPelanggan,
      usia: usia ?? this.usia,
      telepon: telepon ?? this.telepon,
      alamat: alamat ?? this.alamat,
      kelompok: kelompok ?? this.kelompok,
      limitpiutang: limitpiutang ?? this.limitpiutang,
      keterangan: keterangan ?? this.keterangan,
      jualDiscon: jualDiscon ?? this.jualDiscon,
      totalHargaSetelahDisc:
          totalHargaSetelahDisc ?? this.totalHargaSetelahDisc,
      saldoPiutang: saldoPiutang ?? this.saldoPiutang,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (kodPelanggan.present) {
      map['kod_pelanggan'] = Variable<String>(kodPelanggan.value);
    }
    if (namaPelanggan.present) {
      map['nama_pelanggan'] = Variable<String>(namaPelanggan.value);
    }
    if (usia.present) {
      map['usia'] = Variable<int>(usia.value);
    }
    if (telepon.present) {
      map['telepon'] = Variable<int>(telepon.value);
    }
    if (alamat.present) {
      map['alamat'] = Variable<String>(alamat.value);
    }
    if (kelompok.present) {
      map['kelompok'] = Variable<String>(kelompok.value);
    }
    if (limitpiutang.present) {
      map['limitpiutang'] = Variable<int>(limitpiutang.value);
    }
    if (keterangan.present) {
      map['keterangan'] = Variable<String>(keterangan.value);
    }
    if (jualDiscon.present) {
      map['jual_discon'] = Variable<int>(jualDiscon.value);
    }
    if (totalHargaSetelahDisc.present) {
      map['total_harga_setelah_disc'] =
          Variable<int>(totalHargaSetelahDisc.value);
    }
    if (saldoPiutang.present) {
      map['saldo_piutang'] = Variable<int>(saldoPiutang.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PelanggansCompanion(')
          ..write('id: $id, ')
          ..write('kodPelanggan: $kodPelanggan, ')
          ..write('namaPelanggan: $namaPelanggan, ')
          ..write('usia: $usia, ')
          ..write('telepon: $telepon, ')
          ..write('alamat: $alamat, ')
          ..write('kelompok: $kelompok, ')
          ..write('limitpiutang: $limitpiutang, ')
          ..write('keterangan: $keterangan, ')
          ..write('jualDiscon: $jualDiscon, ')
          ..write('totalHargaSetelahDisc: $totalHargaSetelahDisc, ')
          ..write('saldoPiutang: $saldoPiutang')
          ..write(')'))
        .toString();
  }
}

class $ResepsTable extends Reseps with TableInfo<$ResepsTable, Resep> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ResepsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _noResepMeta =
      const VerificationMeta('noResep');
  @override
  late final GeneratedColumn<String> noResep = GeneratedColumn<String>(
      'no_resep', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 20),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _tanggalMeta =
      const VerificationMeta('tanggal');
  @override
  late final GeneratedColumn<DateTime> tanggal = GeneratedColumn<DateTime>(
      'tanggal', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _kodePelangganMeta =
      const VerificationMeta('kodePelanggan');
  @override
  late final GeneratedColumn<String> kodePelanggan = GeneratedColumn<String>(
      'kode_pelanggan', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 50),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _namaPelangganMeta =
      const VerificationMeta('namaPelanggan');
  @override
  late final GeneratedColumn<String> namaPelanggan = GeneratedColumn<String>(
      'nama_pelanggan', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 50),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _kelompokPelangganMeta =
      const VerificationMeta('kelompokPelanggan');
  @override
  late final GeneratedColumn<String> kelompokPelanggan =
      GeneratedColumn<String>('kelompok_pelanggan', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _kodeDoctorMeta =
      const VerificationMeta('kodeDoctor');
  @override
  late final GeneratedColumn<String> kodeDoctor = GeneratedColumn<String>(
      'kode_doctor', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _namaDoctorMeta =
      const VerificationMeta('namaDoctor');
  @override
  late final GeneratedColumn<String> namaDoctor = GeneratedColumn<String>(
      'nama_doctor', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 50),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _usiaMeta = const VerificationMeta('usia');
  @override
  late final GeneratedColumn<int> usia = GeneratedColumn<int>(
      'usia', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _alamatMeta = const VerificationMeta('alamat');
  @override
  late final GeneratedColumn<String> alamat = GeneratedColumn<String>(
      'alamat', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _keteranganMeta =
      const VerificationMeta('keterangan');
  @override
  late final GeneratedColumn<String> keterangan = GeneratedColumn<String>(
      'keterangan', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _noTelpMeta = const VerificationMeta('noTelp');
  @override
  late final GeneratedColumn<String> noTelp = GeneratedColumn<String>(
      'no_telp', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _kodeBarangMeta =
      const VerificationMeta('kodeBarang');
  @override
  late final GeneratedColumn<String> kodeBarang = GeneratedColumn<String>(
      'kode_barang', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 20),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _namaBarangMeta =
      const VerificationMeta('namaBarang');
  @override
  late final GeneratedColumn<String> namaBarang = GeneratedColumn<String>(
      'nama_barang', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _kelompokMeta =
      const VerificationMeta('kelompok');
  @override
  late final GeneratedColumn<String> kelompok = GeneratedColumn<String>(
      'kelompok', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _satuanMeta = const VerificationMeta('satuan');
  @override
  late final GeneratedColumn<String> satuan = GeneratedColumn<String>(
      'satuan', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _hargaBeliMeta =
      const VerificationMeta('hargaBeli');
  @override
  late final GeneratedColumn<int> hargaBeli = GeneratedColumn<int>(
      'harga_beli', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _hargaJualMeta =
      const VerificationMeta('hargaJual');
  @override
  late final GeneratedColumn<int> hargaJual = GeneratedColumn<int>(
      'harga_jual', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _jualDisconMeta =
      const VerificationMeta('jualDiscon');
  @override
  late final GeneratedColumn<int> jualDiscon = GeneratedColumn<int>(
      'jual_discon', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _jumlahJualMeta =
      const VerificationMeta('jumlahJual');
  @override
  late final GeneratedColumn<int> jumlahJual = GeneratedColumn<int>(
      'jumlah_jual', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _totalHargaSebelumDiscMeta =
      const VerificationMeta('totalHargaSebelumDisc');
  @override
  late final GeneratedColumn<int> totalHargaSebelumDisc = GeneratedColumn<int>(
      'total_harga_sebelum_disc', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _totalHargaSetelahDiscMeta =
      const VerificationMeta('totalHargaSetelahDisc');
  @override
  late final GeneratedColumn<int> totalHargaSetelahDisc = GeneratedColumn<int>(
      'total_harga_setelah_disc', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _totalDiscMeta =
      const VerificationMeta('totalDisc');
  @override
  late final GeneratedColumn<int> totalDisc = GeneratedColumn<int>(
      'total_disc', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        noResep,
        tanggal,
        kodePelanggan,
        namaPelanggan,
        kelompokPelanggan,
        kodeDoctor,
        namaDoctor,
        usia,
        alamat,
        keterangan,
        noTelp,
        kodeBarang,
        namaBarang,
        kelompok,
        satuan,
        hargaBeli,
        hargaJual,
        jualDiscon,
        jumlahJual,
        totalHargaSebelumDisc,
        totalHargaSetelahDisc,
        totalDisc
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'reseps';
  @override
  VerificationContext validateIntegrity(Insertable<Resep> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('no_resep')) {
      context.handle(_noResepMeta,
          noResep.isAcceptableOrUnknown(data['no_resep']!, _noResepMeta));
    } else if (isInserting) {
      context.missing(_noResepMeta);
    }
    if (data.containsKey('tanggal')) {
      context.handle(_tanggalMeta,
          tanggal.isAcceptableOrUnknown(data['tanggal']!, _tanggalMeta));
    } else if (isInserting) {
      context.missing(_tanggalMeta);
    }
    if (data.containsKey('kode_pelanggan')) {
      context.handle(
          _kodePelangganMeta,
          kodePelanggan.isAcceptableOrUnknown(
              data['kode_pelanggan']!, _kodePelangganMeta));
    } else if (isInserting) {
      context.missing(_kodePelangganMeta);
    }
    if (data.containsKey('nama_pelanggan')) {
      context.handle(
          _namaPelangganMeta,
          namaPelanggan.isAcceptableOrUnknown(
              data['nama_pelanggan']!, _namaPelangganMeta));
    } else if (isInserting) {
      context.missing(_namaPelangganMeta);
    }
    if (data.containsKey('kelompok_pelanggan')) {
      context.handle(
          _kelompokPelangganMeta,
          kelompokPelanggan.isAcceptableOrUnknown(
              data['kelompok_pelanggan']!, _kelompokPelangganMeta));
    }
    if (data.containsKey('kode_doctor')) {
      context.handle(
          _kodeDoctorMeta,
          kodeDoctor.isAcceptableOrUnknown(
              data['kode_doctor']!, _kodeDoctorMeta));
    }
    if (data.containsKey('nama_doctor')) {
      context.handle(
          _namaDoctorMeta,
          namaDoctor.isAcceptableOrUnknown(
              data['nama_doctor']!, _namaDoctorMeta));
    } else if (isInserting) {
      context.missing(_namaDoctorMeta);
    }
    if (data.containsKey('usia')) {
      context.handle(
          _usiaMeta, usia.isAcceptableOrUnknown(data['usia']!, _usiaMeta));
    }
    if (data.containsKey('alamat')) {
      context.handle(_alamatMeta,
          alamat.isAcceptableOrUnknown(data['alamat']!, _alamatMeta));
    }
    if (data.containsKey('keterangan')) {
      context.handle(
          _keteranganMeta,
          keterangan.isAcceptableOrUnknown(
              data['keterangan']!, _keteranganMeta));
    }
    if (data.containsKey('no_telp')) {
      context.handle(_noTelpMeta,
          noTelp.isAcceptableOrUnknown(data['no_telp']!, _noTelpMeta));
    }
    if (data.containsKey('kode_barang')) {
      context.handle(
          _kodeBarangMeta,
          kodeBarang.isAcceptableOrUnknown(
              data['kode_barang']!, _kodeBarangMeta));
    } else if (isInserting) {
      context.missing(_kodeBarangMeta);
    }
    if (data.containsKey('nama_barang')) {
      context.handle(
          _namaBarangMeta,
          namaBarang.isAcceptableOrUnknown(
              data['nama_barang']!, _namaBarangMeta));
    } else if (isInserting) {
      context.missing(_namaBarangMeta);
    }
    if (data.containsKey('kelompok')) {
      context.handle(_kelompokMeta,
          kelompok.isAcceptableOrUnknown(data['kelompok']!, _kelompokMeta));
    } else if (isInserting) {
      context.missing(_kelompokMeta);
    }
    if (data.containsKey('satuan')) {
      context.handle(_satuanMeta,
          satuan.isAcceptableOrUnknown(data['satuan']!, _satuanMeta));
    } else if (isInserting) {
      context.missing(_satuanMeta);
    }
    if (data.containsKey('harga_beli')) {
      context.handle(_hargaBeliMeta,
          hargaBeli.isAcceptableOrUnknown(data['harga_beli']!, _hargaBeliMeta));
    }
    if (data.containsKey('harga_jual')) {
      context.handle(_hargaJualMeta,
          hargaJual.isAcceptableOrUnknown(data['harga_jual']!, _hargaJualMeta));
    }
    if (data.containsKey('jual_discon')) {
      context.handle(
          _jualDisconMeta,
          jualDiscon.isAcceptableOrUnknown(
              data['jual_discon']!, _jualDisconMeta));
    }
    if (data.containsKey('jumlah_jual')) {
      context.handle(
          _jumlahJualMeta,
          jumlahJual.isAcceptableOrUnknown(
              data['jumlah_jual']!, _jumlahJualMeta));
    }
    if (data.containsKey('total_harga_sebelum_disc')) {
      context.handle(
          _totalHargaSebelumDiscMeta,
          totalHargaSebelumDisc.isAcceptableOrUnknown(
              data['total_harga_sebelum_disc']!, _totalHargaSebelumDiscMeta));
    }
    if (data.containsKey('total_harga_setelah_disc')) {
      context.handle(
          _totalHargaSetelahDiscMeta,
          totalHargaSetelahDisc.isAcceptableOrUnknown(
              data['total_harga_setelah_disc']!, _totalHargaSetelahDiscMeta));
    }
    if (data.containsKey('total_disc')) {
      context.handle(_totalDiscMeta,
          totalDisc.isAcceptableOrUnknown(data['total_disc']!, _totalDiscMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Resep map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Resep(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      noResep: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}no_resep'])!,
      tanggal: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}tanggal'])!,
      kodePelanggan: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}kode_pelanggan'])!,
      namaPelanggan: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}nama_pelanggan'])!,
      kelompokPelanggan: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}kelompok_pelanggan']),
      kodeDoctor: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}kode_doctor']),
      namaDoctor: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}nama_doctor'])!,
      usia: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}usia']),
      alamat: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}alamat']),
      keterangan: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}keterangan']),
      noTelp: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}no_telp']),
      kodeBarang: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}kode_barang'])!,
      namaBarang: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}nama_barang'])!,
      kelompok: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}kelompok'])!,
      satuan: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}satuan'])!,
      hargaBeli: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}harga_beli'])!,
      hargaJual: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}harga_jual'])!,
      jualDiscon: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}jual_discon']),
      jumlahJual: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}jumlah_jual']),
      totalHargaSebelumDisc: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}total_harga_sebelum_disc']),
      totalHargaSetelahDisc: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}total_harga_setelah_disc']),
      totalDisc: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}total_disc']),
    );
  }

  @override
  $ResepsTable createAlias(String alias) {
    return $ResepsTable(attachedDatabase, alias);
  }
}

class Resep extends DataClass implements Insertable<Resep> {
  final int id;
  final String noResep;
  final DateTime tanggal;
  final String kodePelanggan;
  final String namaPelanggan;
  final String? kelompokPelanggan;
  final String? kodeDoctor;
  final String namaDoctor;
  final int? usia;
  final String? alamat;
  final String? keterangan;
  final String? noTelp;
  final String kodeBarang;
  final String namaBarang;
  final String kelompok;
  final String satuan;
  final int hargaBeli;
  final int hargaJual;
  final int? jualDiscon;
  final int? jumlahJual;
  final int? totalHargaSebelumDisc;
  final int? totalHargaSetelahDisc;
  final int? totalDisc;
  const Resep(
      {required this.id,
      required this.noResep,
      required this.tanggal,
      required this.kodePelanggan,
      required this.namaPelanggan,
      this.kelompokPelanggan,
      this.kodeDoctor,
      required this.namaDoctor,
      this.usia,
      this.alamat,
      this.keterangan,
      this.noTelp,
      required this.kodeBarang,
      required this.namaBarang,
      required this.kelompok,
      required this.satuan,
      required this.hargaBeli,
      required this.hargaJual,
      this.jualDiscon,
      this.jumlahJual,
      this.totalHargaSebelumDisc,
      this.totalHargaSetelahDisc,
      this.totalDisc});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['no_resep'] = Variable<String>(noResep);
    map['tanggal'] = Variable<DateTime>(tanggal);
    map['kode_pelanggan'] = Variable<String>(kodePelanggan);
    map['nama_pelanggan'] = Variable<String>(namaPelanggan);
    if (!nullToAbsent || kelompokPelanggan != null) {
      map['kelompok_pelanggan'] = Variable<String>(kelompokPelanggan);
    }
    if (!nullToAbsent || kodeDoctor != null) {
      map['kode_doctor'] = Variable<String>(kodeDoctor);
    }
    map['nama_doctor'] = Variable<String>(namaDoctor);
    if (!nullToAbsent || usia != null) {
      map['usia'] = Variable<int>(usia);
    }
    if (!nullToAbsent || alamat != null) {
      map['alamat'] = Variable<String>(alamat);
    }
    if (!nullToAbsent || keterangan != null) {
      map['keterangan'] = Variable<String>(keterangan);
    }
    if (!nullToAbsent || noTelp != null) {
      map['no_telp'] = Variable<String>(noTelp);
    }
    map['kode_barang'] = Variable<String>(kodeBarang);
    map['nama_barang'] = Variable<String>(namaBarang);
    map['kelompok'] = Variable<String>(kelompok);
    map['satuan'] = Variable<String>(satuan);
    map['harga_beli'] = Variable<int>(hargaBeli);
    map['harga_jual'] = Variable<int>(hargaJual);
    if (!nullToAbsent || jualDiscon != null) {
      map['jual_discon'] = Variable<int>(jualDiscon);
    }
    if (!nullToAbsent || jumlahJual != null) {
      map['jumlah_jual'] = Variable<int>(jumlahJual);
    }
    if (!nullToAbsent || totalHargaSebelumDisc != null) {
      map['total_harga_sebelum_disc'] = Variable<int>(totalHargaSebelumDisc);
    }
    if (!nullToAbsent || totalHargaSetelahDisc != null) {
      map['total_harga_setelah_disc'] = Variable<int>(totalHargaSetelahDisc);
    }
    if (!nullToAbsent || totalDisc != null) {
      map['total_disc'] = Variable<int>(totalDisc);
    }
    return map;
  }

  ResepsCompanion toCompanion(bool nullToAbsent) {
    return ResepsCompanion(
      id: Value(id),
      noResep: Value(noResep),
      tanggal: Value(tanggal),
      kodePelanggan: Value(kodePelanggan),
      namaPelanggan: Value(namaPelanggan),
      kelompokPelanggan: kelompokPelanggan == null && nullToAbsent
          ? const Value.absent()
          : Value(kelompokPelanggan),
      kodeDoctor: kodeDoctor == null && nullToAbsent
          ? const Value.absent()
          : Value(kodeDoctor),
      namaDoctor: Value(namaDoctor),
      usia: usia == null && nullToAbsent ? const Value.absent() : Value(usia),
      alamat:
          alamat == null && nullToAbsent ? const Value.absent() : Value(alamat),
      keterangan: keterangan == null && nullToAbsent
          ? const Value.absent()
          : Value(keterangan),
      noTelp:
          noTelp == null && nullToAbsent ? const Value.absent() : Value(noTelp),
      kodeBarang: Value(kodeBarang),
      namaBarang: Value(namaBarang),
      kelompok: Value(kelompok),
      satuan: Value(satuan),
      hargaBeli: Value(hargaBeli),
      hargaJual: Value(hargaJual),
      jualDiscon: jualDiscon == null && nullToAbsent
          ? const Value.absent()
          : Value(jualDiscon),
      jumlahJual: jumlahJual == null && nullToAbsent
          ? const Value.absent()
          : Value(jumlahJual),
      totalHargaSebelumDisc: totalHargaSebelumDisc == null && nullToAbsent
          ? const Value.absent()
          : Value(totalHargaSebelumDisc),
      totalHargaSetelahDisc: totalHargaSetelahDisc == null && nullToAbsent
          ? const Value.absent()
          : Value(totalHargaSetelahDisc),
      totalDisc: totalDisc == null && nullToAbsent
          ? const Value.absent()
          : Value(totalDisc),
    );
  }

  factory Resep.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Resep(
      id: serializer.fromJson<int>(json['id']),
      noResep: serializer.fromJson<String>(json['noResep']),
      tanggal: serializer.fromJson<DateTime>(json['tanggal']),
      kodePelanggan: serializer.fromJson<String>(json['kodePelanggan']),
      namaPelanggan: serializer.fromJson<String>(json['namaPelanggan']),
      kelompokPelanggan:
          serializer.fromJson<String?>(json['kelompokPelanggan']),
      kodeDoctor: serializer.fromJson<String?>(json['kodeDoctor']),
      namaDoctor: serializer.fromJson<String>(json['namaDoctor']),
      usia: serializer.fromJson<int?>(json['usia']),
      alamat: serializer.fromJson<String?>(json['alamat']),
      keterangan: serializer.fromJson<String?>(json['keterangan']),
      noTelp: serializer.fromJson<String?>(json['noTelp']),
      kodeBarang: serializer.fromJson<String>(json['kodeBarang']),
      namaBarang: serializer.fromJson<String>(json['namaBarang']),
      kelompok: serializer.fromJson<String>(json['kelompok']),
      satuan: serializer.fromJson<String>(json['satuan']),
      hargaBeli: serializer.fromJson<int>(json['hargaBeli']),
      hargaJual: serializer.fromJson<int>(json['hargaJual']),
      jualDiscon: serializer.fromJson<int?>(json['jualDiscon']),
      jumlahJual: serializer.fromJson<int?>(json['jumlahJual']),
      totalHargaSebelumDisc:
          serializer.fromJson<int?>(json['totalHargaSebelumDisc']),
      totalHargaSetelahDisc:
          serializer.fromJson<int?>(json['totalHargaSetelahDisc']),
      totalDisc: serializer.fromJson<int?>(json['totalDisc']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'noResep': serializer.toJson<String>(noResep),
      'tanggal': serializer.toJson<DateTime>(tanggal),
      'kodePelanggan': serializer.toJson<String>(kodePelanggan),
      'namaPelanggan': serializer.toJson<String>(namaPelanggan),
      'kelompokPelanggan': serializer.toJson<String?>(kelompokPelanggan),
      'kodeDoctor': serializer.toJson<String?>(kodeDoctor),
      'namaDoctor': serializer.toJson<String>(namaDoctor),
      'usia': serializer.toJson<int?>(usia),
      'alamat': serializer.toJson<String?>(alamat),
      'keterangan': serializer.toJson<String?>(keterangan),
      'noTelp': serializer.toJson<String?>(noTelp),
      'kodeBarang': serializer.toJson<String>(kodeBarang),
      'namaBarang': serializer.toJson<String>(namaBarang),
      'kelompok': serializer.toJson<String>(kelompok),
      'satuan': serializer.toJson<String>(satuan),
      'hargaBeli': serializer.toJson<int>(hargaBeli),
      'hargaJual': serializer.toJson<int>(hargaJual),
      'jualDiscon': serializer.toJson<int?>(jualDiscon),
      'jumlahJual': serializer.toJson<int?>(jumlahJual),
      'totalHargaSebelumDisc': serializer.toJson<int?>(totalHargaSebelumDisc),
      'totalHargaSetelahDisc': serializer.toJson<int?>(totalHargaSetelahDisc),
      'totalDisc': serializer.toJson<int?>(totalDisc),
    };
  }

  Resep copyWith(
          {int? id,
          String? noResep,
          DateTime? tanggal,
          String? kodePelanggan,
          String? namaPelanggan,
          Value<String?> kelompokPelanggan = const Value.absent(),
          Value<String?> kodeDoctor = const Value.absent(),
          String? namaDoctor,
          Value<int?> usia = const Value.absent(),
          Value<String?> alamat = const Value.absent(),
          Value<String?> keterangan = const Value.absent(),
          Value<String?> noTelp = const Value.absent(),
          String? kodeBarang,
          String? namaBarang,
          String? kelompok,
          String? satuan,
          int? hargaBeli,
          int? hargaJual,
          Value<int?> jualDiscon = const Value.absent(),
          Value<int?> jumlahJual = const Value.absent(),
          Value<int?> totalHargaSebelumDisc = const Value.absent(),
          Value<int?> totalHargaSetelahDisc = const Value.absent(),
          Value<int?> totalDisc = const Value.absent()}) =>
      Resep(
        id: id ?? this.id,
        noResep: noResep ?? this.noResep,
        tanggal: tanggal ?? this.tanggal,
        kodePelanggan: kodePelanggan ?? this.kodePelanggan,
        namaPelanggan: namaPelanggan ?? this.namaPelanggan,
        kelompokPelanggan: kelompokPelanggan.present
            ? kelompokPelanggan.value
            : this.kelompokPelanggan,
        kodeDoctor: kodeDoctor.present ? kodeDoctor.value : this.kodeDoctor,
        namaDoctor: namaDoctor ?? this.namaDoctor,
        usia: usia.present ? usia.value : this.usia,
        alamat: alamat.present ? alamat.value : this.alamat,
        keterangan: keterangan.present ? keterangan.value : this.keterangan,
        noTelp: noTelp.present ? noTelp.value : this.noTelp,
        kodeBarang: kodeBarang ?? this.kodeBarang,
        namaBarang: namaBarang ?? this.namaBarang,
        kelompok: kelompok ?? this.kelompok,
        satuan: satuan ?? this.satuan,
        hargaBeli: hargaBeli ?? this.hargaBeli,
        hargaJual: hargaJual ?? this.hargaJual,
        jualDiscon: jualDiscon.present ? jualDiscon.value : this.jualDiscon,
        jumlahJual: jumlahJual.present ? jumlahJual.value : this.jumlahJual,
        totalHargaSebelumDisc: totalHargaSebelumDisc.present
            ? totalHargaSebelumDisc.value
            : this.totalHargaSebelumDisc,
        totalHargaSetelahDisc: totalHargaSetelahDisc.present
            ? totalHargaSetelahDisc.value
            : this.totalHargaSetelahDisc,
        totalDisc: totalDisc.present ? totalDisc.value : this.totalDisc,
      );
  Resep copyWithCompanion(ResepsCompanion data) {
    return Resep(
      id: data.id.present ? data.id.value : this.id,
      noResep: data.noResep.present ? data.noResep.value : this.noResep,
      tanggal: data.tanggal.present ? data.tanggal.value : this.tanggal,
      kodePelanggan: data.kodePelanggan.present
          ? data.kodePelanggan.value
          : this.kodePelanggan,
      namaPelanggan: data.namaPelanggan.present
          ? data.namaPelanggan.value
          : this.namaPelanggan,
      kelompokPelanggan: data.kelompokPelanggan.present
          ? data.kelompokPelanggan.value
          : this.kelompokPelanggan,
      kodeDoctor:
          data.kodeDoctor.present ? data.kodeDoctor.value : this.kodeDoctor,
      namaDoctor:
          data.namaDoctor.present ? data.namaDoctor.value : this.namaDoctor,
      usia: data.usia.present ? data.usia.value : this.usia,
      alamat: data.alamat.present ? data.alamat.value : this.alamat,
      keterangan:
          data.keterangan.present ? data.keterangan.value : this.keterangan,
      noTelp: data.noTelp.present ? data.noTelp.value : this.noTelp,
      kodeBarang:
          data.kodeBarang.present ? data.kodeBarang.value : this.kodeBarang,
      namaBarang:
          data.namaBarang.present ? data.namaBarang.value : this.namaBarang,
      kelompok: data.kelompok.present ? data.kelompok.value : this.kelompok,
      satuan: data.satuan.present ? data.satuan.value : this.satuan,
      hargaBeli: data.hargaBeli.present ? data.hargaBeli.value : this.hargaBeli,
      hargaJual: data.hargaJual.present ? data.hargaJual.value : this.hargaJual,
      jualDiscon:
          data.jualDiscon.present ? data.jualDiscon.value : this.jualDiscon,
      jumlahJual:
          data.jumlahJual.present ? data.jumlahJual.value : this.jumlahJual,
      totalHargaSebelumDisc: data.totalHargaSebelumDisc.present
          ? data.totalHargaSebelumDisc.value
          : this.totalHargaSebelumDisc,
      totalHargaSetelahDisc: data.totalHargaSetelahDisc.present
          ? data.totalHargaSetelahDisc.value
          : this.totalHargaSetelahDisc,
      totalDisc: data.totalDisc.present ? data.totalDisc.value : this.totalDisc,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Resep(')
          ..write('id: $id, ')
          ..write('noResep: $noResep, ')
          ..write('tanggal: $tanggal, ')
          ..write('kodePelanggan: $kodePelanggan, ')
          ..write('namaPelanggan: $namaPelanggan, ')
          ..write('kelompokPelanggan: $kelompokPelanggan, ')
          ..write('kodeDoctor: $kodeDoctor, ')
          ..write('namaDoctor: $namaDoctor, ')
          ..write('usia: $usia, ')
          ..write('alamat: $alamat, ')
          ..write('keterangan: $keterangan, ')
          ..write('noTelp: $noTelp, ')
          ..write('kodeBarang: $kodeBarang, ')
          ..write('namaBarang: $namaBarang, ')
          ..write('kelompok: $kelompok, ')
          ..write('satuan: $satuan, ')
          ..write('hargaBeli: $hargaBeli, ')
          ..write('hargaJual: $hargaJual, ')
          ..write('jualDiscon: $jualDiscon, ')
          ..write('jumlahJual: $jumlahJual, ')
          ..write('totalHargaSebelumDisc: $totalHargaSebelumDisc, ')
          ..write('totalHargaSetelahDisc: $totalHargaSetelahDisc, ')
          ..write('totalDisc: $totalDisc')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
        id,
        noResep,
        tanggal,
        kodePelanggan,
        namaPelanggan,
        kelompokPelanggan,
        kodeDoctor,
        namaDoctor,
        usia,
        alamat,
        keterangan,
        noTelp,
        kodeBarang,
        namaBarang,
        kelompok,
        satuan,
        hargaBeli,
        hargaJual,
        jualDiscon,
        jumlahJual,
        totalHargaSebelumDisc,
        totalHargaSetelahDisc,
        totalDisc
      ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Resep &&
          other.id == this.id &&
          other.noResep == this.noResep &&
          other.tanggal == this.tanggal &&
          other.kodePelanggan == this.kodePelanggan &&
          other.namaPelanggan == this.namaPelanggan &&
          other.kelompokPelanggan == this.kelompokPelanggan &&
          other.kodeDoctor == this.kodeDoctor &&
          other.namaDoctor == this.namaDoctor &&
          other.usia == this.usia &&
          other.alamat == this.alamat &&
          other.keterangan == this.keterangan &&
          other.noTelp == this.noTelp &&
          other.kodeBarang == this.kodeBarang &&
          other.namaBarang == this.namaBarang &&
          other.kelompok == this.kelompok &&
          other.satuan == this.satuan &&
          other.hargaBeli == this.hargaBeli &&
          other.hargaJual == this.hargaJual &&
          other.jualDiscon == this.jualDiscon &&
          other.jumlahJual == this.jumlahJual &&
          other.totalHargaSebelumDisc == this.totalHargaSebelumDisc &&
          other.totalHargaSetelahDisc == this.totalHargaSetelahDisc &&
          other.totalDisc == this.totalDisc);
}

class ResepsCompanion extends UpdateCompanion<Resep> {
  final Value<int> id;
  final Value<String> noResep;
  final Value<DateTime> tanggal;
  final Value<String> kodePelanggan;
  final Value<String> namaPelanggan;
  final Value<String?> kelompokPelanggan;
  final Value<String?> kodeDoctor;
  final Value<String> namaDoctor;
  final Value<int?> usia;
  final Value<String?> alamat;
  final Value<String?> keterangan;
  final Value<String?> noTelp;
  final Value<String> kodeBarang;
  final Value<String> namaBarang;
  final Value<String> kelompok;
  final Value<String> satuan;
  final Value<int> hargaBeli;
  final Value<int> hargaJual;
  final Value<int?> jualDiscon;
  final Value<int?> jumlahJual;
  final Value<int?> totalHargaSebelumDisc;
  final Value<int?> totalHargaSetelahDisc;
  final Value<int?> totalDisc;
  const ResepsCompanion({
    this.id = const Value.absent(),
    this.noResep = const Value.absent(),
    this.tanggal = const Value.absent(),
    this.kodePelanggan = const Value.absent(),
    this.namaPelanggan = const Value.absent(),
    this.kelompokPelanggan = const Value.absent(),
    this.kodeDoctor = const Value.absent(),
    this.namaDoctor = const Value.absent(),
    this.usia = const Value.absent(),
    this.alamat = const Value.absent(),
    this.keterangan = const Value.absent(),
    this.noTelp = const Value.absent(),
    this.kodeBarang = const Value.absent(),
    this.namaBarang = const Value.absent(),
    this.kelompok = const Value.absent(),
    this.satuan = const Value.absent(),
    this.hargaBeli = const Value.absent(),
    this.hargaJual = const Value.absent(),
    this.jualDiscon = const Value.absent(),
    this.jumlahJual = const Value.absent(),
    this.totalHargaSebelumDisc = const Value.absent(),
    this.totalHargaSetelahDisc = const Value.absent(),
    this.totalDisc = const Value.absent(),
  });
  ResepsCompanion.insert({
    this.id = const Value.absent(),
    required String noResep,
    required DateTime tanggal,
    required String kodePelanggan,
    required String namaPelanggan,
    this.kelompokPelanggan = const Value.absent(),
    this.kodeDoctor = const Value.absent(),
    required String namaDoctor,
    this.usia = const Value.absent(),
    this.alamat = const Value.absent(),
    this.keterangan = const Value.absent(),
    this.noTelp = const Value.absent(),
    required String kodeBarang,
    required String namaBarang,
    required String kelompok,
    required String satuan,
    this.hargaBeli = const Value.absent(),
    this.hargaJual = const Value.absent(),
    this.jualDiscon = const Value.absent(),
    this.jumlahJual = const Value.absent(),
    this.totalHargaSebelumDisc = const Value.absent(),
    this.totalHargaSetelahDisc = const Value.absent(),
    this.totalDisc = const Value.absent(),
  })  : noResep = Value(noResep),
        tanggal = Value(tanggal),
        kodePelanggan = Value(kodePelanggan),
        namaPelanggan = Value(namaPelanggan),
        namaDoctor = Value(namaDoctor),
        kodeBarang = Value(kodeBarang),
        namaBarang = Value(namaBarang),
        kelompok = Value(kelompok),
        satuan = Value(satuan);
  static Insertable<Resep> custom({
    Expression<int>? id,
    Expression<String>? noResep,
    Expression<DateTime>? tanggal,
    Expression<String>? kodePelanggan,
    Expression<String>? namaPelanggan,
    Expression<String>? kelompokPelanggan,
    Expression<String>? kodeDoctor,
    Expression<String>? namaDoctor,
    Expression<int>? usia,
    Expression<String>? alamat,
    Expression<String>? keterangan,
    Expression<String>? noTelp,
    Expression<String>? kodeBarang,
    Expression<String>? namaBarang,
    Expression<String>? kelompok,
    Expression<String>? satuan,
    Expression<int>? hargaBeli,
    Expression<int>? hargaJual,
    Expression<int>? jualDiscon,
    Expression<int>? jumlahJual,
    Expression<int>? totalHargaSebelumDisc,
    Expression<int>? totalHargaSetelahDisc,
    Expression<int>? totalDisc,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (noResep != null) 'no_resep': noResep,
      if (tanggal != null) 'tanggal': tanggal,
      if (kodePelanggan != null) 'kode_pelanggan': kodePelanggan,
      if (namaPelanggan != null) 'nama_pelanggan': namaPelanggan,
      if (kelompokPelanggan != null) 'kelompok_pelanggan': kelompokPelanggan,
      if (kodeDoctor != null) 'kode_doctor': kodeDoctor,
      if (namaDoctor != null) 'nama_doctor': namaDoctor,
      if (usia != null) 'usia': usia,
      if (alamat != null) 'alamat': alamat,
      if (keterangan != null) 'keterangan': keterangan,
      if (noTelp != null) 'no_telp': noTelp,
      if (kodeBarang != null) 'kode_barang': kodeBarang,
      if (namaBarang != null) 'nama_barang': namaBarang,
      if (kelompok != null) 'kelompok': kelompok,
      if (satuan != null) 'satuan': satuan,
      if (hargaBeli != null) 'harga_beli': hargaBeli,
      if (hargaJual != null) 'harga_jual': hargaJual,
      if (jualDiscon != null) 'jual_discon': jualDiscon,
      if (jumlahJual != null) 'jumlah_jual': jumlahJual,
      if (totalHargaSebelumDisc != null)
        'total_harga_sebelum_disc': totalHargaSebelumDisc,
      if (totalHargaSetelahDisc != null)
        'total_harga_setelah_disc': totalHargaSetelahDisc,
      if (totalDisc != null) 'total_disc': totalDisc,
    });
  }

  ResepsCompanion copyWith(
      {Value<int>? id,
      Value<String>? noResep,
      Value<DateTime>? tanggal,
      Value<String>? kodePelanggan,
      Value<String>? namaPelanggan,
      Value<String?>? kelompokPelanggan,
      Value<String?>? kodeDoctor,
      Value<String>? namaDoctor,
      Value<int?>? usia,
      Value<String?>? alamat,
      Value<String?>? keterangan,
      Value<String?>? noTelp,
      Value<String>? kodeBarang,
      Value<String>? namaBarang,
      Value<String>? kelompok,
      Value<String>? satuan,
      Value<int>? hargaBeli,
      Value<int>? hargaJual,
      Value<int?>? jualDiscon,
      Value<int?>? jumlahJual,
      Value<int?>? totalHargaSebelumDisc,
      Value<int?>? totalHargaSetelahDisc,
      Value<int?>? totalDisc}) {
    return ResepsCompanion(
      id: id ?? this.id,
      noResep: noResep ?? this.noResep,
      tanggal: tanggal ?? this.tanggal,
      kodePelanggan: kodePelanggan ?? this.kodePelanggan,
      namaPelanggan: namaPelanggan ?? this.namaPelanggan,
      kelompokPelanggan: kelompokPelanggan ?? this.kelompokPelanggan,
      kodeDoctor: kodeDoctor ?? this.kodeDoctor,
      namaDoctor: namaDoctor ?? this.namaDoctor,
      usia: usia ?? this.usia,
      alamat: alamat ?? this.alamat,
      keterangan: keterangan ?? this.keterangan,
      noTelp: noTelp ?? this.noTelp,
      kodeBarang: kodeBarang ?? this.kodeBarang,
      namaBarang: namaBarang ?? this.namaBarang,
      kelompok: kelompok ?? this.kelompok,
      satuan: satuan ?? this.satuan,
      hargaBeli: hargaBeli ?? this.hargaBeli,
      hargaJual: hargaJual ?? this.hargaJual,
      jualDiscon: jualDiscon ?? this.jualDiscon,
      jumlahJual: jumlahJual ?? this.jumlahJual,
      totalHargaSebelumDisc:
          totalHargaSebelumDisc ?? this.totalHargaSebelumDisc,
      totalHargaSetelahDisc:
          totalHargaSetelahDisc ?? this.totalHargaSetelahDisc,
      totalDisc: totalDisc ?? this.totalDisc,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (noResep.present) {
      map['no_resep'] = Variable<String>(noResep.value);
    }
    if (tanggal.present) {
      map['tanggal'] = Variable<DateTime>(tanggal.value);
    }
    if (kodePelanggan.present) {
      map['kode_pelanggan'] = Variable<String>(kodePelanggan.value);
    }
    if (namaPelanggan.present) {
      map['nama_pelanggan'] = Variable<String>(namaPelanggan.value);
    }
    if (kelompokPelanggan.present) {
      map['kelompok_pelanggan'] = Variable<String>(kelompokPelanggan.value);
    }
    if (kodeDoctor.present) {
      map['kode_doctor'] = Variable<String>(kodeDoctor.value);
    }
    if (namaDoctor.present) {
      map['nama_doctor'] = Variable<String>(namaDoctor.value);
    }
    if (usia.present) {
      map['usia'] = Variable<int>(usia.value);
    }
    if (alamat.present) {
      map['alamat'] = Variable<String>(alamat.value);
    }
    if (keterangan.present) {
      map['keterangan'] = Variable<String>(keterangan.value);
    }
    if (noTelp.present) {
      map['no_telp'] = Variable<String>(noTelp.value);
    }
    if (kodeBarang.present) {
      map['kode_barang'] = Variable<String>(kodeBarang.value);
    }
    if (namaBarang.present) {
      map['nama_barang'] = Variable<String>(namaBarang.value);
    }
    if (kelompok.present) {
      map['kelompok'] = Variable<String>(kelompok.value);
    }
    if (satuan.present) {
      map['satuan'] = Variable<String>(satuan.value);
    }
    if (hargaBeli.present) {
      map['harga_beli'] = Variable<int>(hargaBeli.value);
    }
    if (hargaJual.present) {
      map['harga_jual'] = Variable<int>(hargaJual.value);
    }
    if (jualDiscon.present) {
      map['jual_discon'] = Variable<int>(jualDiscon.value);
    }
    if (jumlahJual.present) {
      map['jumlah_jual'] = Variable<int>(jumlahJual.value);
    }
    if (totalHargaSebelumDisc.present) {
      map['total_harga_sebelum_disc'] =
          Variable<int>(totalHargaSebelumDisc.value);
    }
    if (totalHargaSetelahDisc.present) {
      map['total_harga_setelah_disc'] =
          Variable<int>(totalHargaSetelahDisc.value);
    }
    if (totalDisc.present) {
      map['total_disc'] = Variable<int>(totalDisc.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ResepsCompanion(')
          ..write('id: $id, ')
          ..write('noResep: $noResep, ')
          ..write('tanggal: $tanggal, ')
          ..write('kodePelanggan: $kodePelanggan, ')
          ..write('namaPelanggan: $namaPelanggan, ')
          ..write('kelompokPelanggan: $kelompokPelanggan, ')
          ..write('kodeDoctor: $kodeDoctor, ')
          ..write('namaDoctor: $namaDoctor, ')
          ..write('usia: $usia, ')
          ..write('alamat: $alamat, ')
          ..write('keterangan: $keterangan, ')
          ..write('noTelp: $noTelp, ')
          ..write('kodeBarang: $kodeBarang, ')
          ..write('namaBarang: $namaBarang, ')
          ..write('kelompok: $kelompok, ')
          ..write('satuan: $satuan, ')
          ..write('hargaBeli: $hargaBeli, ')
          ..write('hargaJual: $hargaJual, ')
          ..write('jualDiscon: $jualDiscon, ')
          ..write('jumlahJual: $jumlahJual, ')
          ..write('totalHargaSebelumDisc: $totalHargaSebelumDisc, ')
          ..write('totalHargaSetelahDisc: $totalHargaSetelahDisc, ')
          ..write('totalDisc: $totalDisc')
          ..write(')'))
        .toString();
  }
}

class $ResepstmpTable extends Resepstmp
    with TableInfo<$ResepstmpTable, ResepstmpData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ResepstmpTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _kodeBarangMeta =
      const VerificationMeta('kodeBarang');
  @override
  late final GeneratedColumn<String> kodeBarang = GeneratedColumn<String>(
      'kode_barang', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 20),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _namaBarangMeta =
      const VerificationMeta('namaBarang');
  @override
  late final GeneratedColumn<String> namaBarang = GeneratedColumn<String>(
      'nama_barang', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _kelompokMeta =
      const VerificationMeta('kelompok');
  @override
  late final GeneratedColumn<String> kelompok = GeneratedColumn<String>(
      'kelompok', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _satuanMeta = const VerificationMeta('satuan');
  @override
  late final GeneratedColumn<String> satuan = GeneratedColumn<String>(
      'satuan', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _hargaBeliMeta =
      const VerificationMeta('hargaBeli');
  @override
  late final GeneratedColumn<int> hargaBeli = GeneratedColumn<int>(
      'harga_beli', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _hargaJualMeta =
      const VerificationMeta('hargaJual');
  @override
  late final GeneratedColumn<int> hargaJual = GeneratedColumn<int>(
      'harga_jual', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _jualDisconMeta =
      const VerificationMeta('jualDiscon');
  @override
  late final GeneratedColumn<int> jualDiscon = GeneratedColumn<int>(
      'jual_discon', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _jumlahJualMeta =
      const VerificationMeta('jumlahJual');
  @override
  late final GeneratedColumn<int> jumlahJual = GeneratedColumn<int>(
      'jumlah_jual', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _totalHargaSebelumDiscMeta =
      const VerificationMeta('totalHargaSebelumDisc');
  @override
  late final GeneratedColumn<int> totalHargaSebelumDisc = GeneratedColumn<int>(
      'total_harga_sebelum_disc', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _totalHargaSetelahDiscMeta =
      const VerificationMeta('totalHargaSetelahDisc');
  @override
  late final GeneratedColumn<int> totalHargaSetelahDisc = GeneratedColumn<int>(
      'total_harga_setelah_disc', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _totalDiscMeta =
      const VerificationMeta('totalDisc');
  @override
  late final GeneratedColumn<int> totalDisc = GeneratedColumn<int>(
      'total_disc', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        kodeBarang,
        namaBarang,
        kelompok,
        satuan,
        hargaBeli,
        hargaJual,
        jualDiscon,
        jumlahJual,
        totalHargaSebelumDisc,
        totalHargaSetelahDisc,
        totalDisc
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'resepstmp';
  @override
  VerificationContext validateIntegrity(Insertable<ResepstmpData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('kode_barang')) {
      context.handle(
          _kodeBarangMeta,
          kodeBarang.isAcceptableOrUnknown(
              data['kode_barang']!, _kodeBarangMeta));
    } else if (isInserting) {
      context.missing(_kodeBarangMeta);
    }
    if (data.containsKey('nama_barang')) {
      context.handle(
          _namaBarangMeta,
          namaBarang.isAcceptableOrUnknown(
              data['nama_barang']!, _namaBarangMeta));
    } else if (isInserting) {
      context.missing(_namaBarangMeta);
    }
    if (data.containsKey('kelompok')) {
      context.handle(_kelompokMeta,
          kelompok.isAcceptableOrUnknown(data['kelompok']!, _kelompokMeta));
    } else if (isInserting) {
      context.missing(_kelompokMeta);
    }
    if (data.containsKey('satuan')) {
      context.handle(_satuanMeta,
          satuan.isAcceptableOrUnknown(data['satuan']!, _satuanMeta));
    } else if (isInserting) {
      context.missing(_satuanMeta);
    }
    if (data.containsKey('harga_beli')) {
      context.handle(_hargaBeliMeta,
          hargaBeli.isAcceptableOrUnknown(data['harga_beli']!, _hargaBeliMeta));
    }
    if (data.containsKey('harga_jual')) {
      context.handle(_hargaJualMeta,
          hargaJual.isAcceptableOrUnknown(data['harga_jual']!, _hargaJualMeta));
    }
    if (data.containsKey('jual_discon')) {
      context.handle(
          _jualDisconMeta,
          jualDiscon.isAcceptableOrUnknown(
              data['jual_discon']!, _jualDisconMeta));
    }
    if (data.containsKey('jumlah_jual')) {
      context.handle(
          _jumlahJualMeta,
          jumlahJual.isAcceptableOrUnknown(
              data['jumlah_jual']!, _jumlahJualMeta));
    }
    if (data.containsKey('total_harga_sebelum_disc')) {
      context.handle(
          _totalHargaSebelumDiscMeta,
          totalHargaSebelumDisc.isAcceptableOrUnknown(
              data['total_harga_sebelum_disc']!, _totalHargaSebelumDiscMeta));
    }
    if (data.containsKey('total_harga_setelah_disc')) {
      context.handle(
          _totalHargaSetelahDiscMeta,
          totalHargaSetelahDisc.isAcceptableOrUnknown(
              data['total_harga_setelah_disc']!, _totalHargaSetelahDiscMeta));
    }
    if (data.containsKey('total_disc')) {
      context.handle(_totalDiscMeta,
          totalDisc.isAcceptableOrUnknown(data['total_disc']!, _totalDiscMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ResepstmpData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ResepstmpData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      kodeBarang: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}kode_barang'])!,
      namaBarang: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}nama_barang'])!,
      kelompok: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}kelompok'])!,
      satuan: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}satuan'])!,
      hargaBeli: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}harga_beli'])!,
      hargaJual: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}harga_jual'])!,
      jualDiscon: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}jual_discon']),
      jumlahJual: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}jumlah_jual']),
      totalHargaSebelumDisc: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}total_harga_sebelum_disc']),
      totalHargaSetelahDisc: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}total_harga_setelah_disc']),
      totalDisc: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}total_disc']),
    );
  }

  @override
  $ResepstmpTable createAlias(String alias) {
    return $ResepstmpTable(attachedDatabase, alias);
  }
}

class ResepstmpData extends DataClass implements Insertable<ResepstmpData> {
  final int id;
  final String kodeBarang;
  final String namaBarang;
  final String kelompok;
  final String satuan;
  final int hargaBeli;
  final int hargaJual;
  final int? jualDiscon;
  final int? jumlahJual;
  final int? totalHargaSebelumDisc;
  final int? totalHargaSetelahDisc;
  final int? totalDisc;
  const ResepstmpData(
      {required this.id,
      required this.kodeBarang,
      required this.namaBarang,
      required this.kelompok,
      required this.satuan,
      required this.hargaBeli,
      required this.hargaJual,
      this.jualDiscon,
      this.jumlahJual,
      this.totalHargaSebelumDisc,
      this.totalHargaSetelahDisc,
      this.totalDisc});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['kode_barang'] = Variable<String>(kodeBarang);
    map['nama_barang'] = Variable<String>(namaBarang);
    map['kelompok'] = Variable<String>(kelompok);
    map['satuan'] = Variable<String>(satuan);
    map['harga_beli'] = Variable<int>(hargaBeli);
    map['harga_jual'] = Variable<int>(hargaJual);
    if (!nullToAbsent || jualDiscon != null) {
      map['jual_discon'] = Variable<int>(jualDiscon);
    }
    if (!nullToAbsent || jumlahJual != null) {
      map['jumlah_jual'] = Variable<int>(jumlahJual);
    }
    if (!nullToAbsent || totalHargaSebelumDisc != null) {
      map['total_harga_sebelum_disc'] = Variable<int>(totalHargaSebelumDisc);
    }
    if (!nullToAbsent || totalHargaSetelahDisc != null) {
      map['total_harga_setelah_disc'] = Variable<int>(totalHargaSetelahDisc);
    }
    if (!nullToAbsent || totalDisc != null) {
      map['total_disc'] = Variable<int>(totalDisc);
    }
    return map;
  }

  ResepstmpCompanion toCompanion(bool nullToAbsent) {
    return ResepstmpCompanion(
      id: Value(id),
      kodeBarang: Value(kodeBarang),
      namaBarang: Value(namaBarang),
      kelompok: Value(kelompok),
      satuan: Value(satuan),
      hargaBeli: Value(hargaBeli),
      hargaJual: Value(hargaJual),
      jualDiscon: jualDiscon == null && nullToAbsent
          ? const Value.absent()
          : Value(jualDiscon),
      jumlahJual: jumlahJual == null && nullToAbsent
          ? const Value.absent()
          : Value(jumlahJual),
      totalHargaSebelumDisc: totalHargaSebelumDisc == null && nullToAbsent
          ? const Value.absent()
          : Value(totalHargaSebelumDisc),
      totalHargaSetelahDisc: totalHargaSetelahDisc == null && nullToAbsent
          ? const Value.absent()
          : Value(totalHargaSetelahDisc),
      totalDisc: totalDisc == null && nullToAbsent
          ? const Value.absent()
          : Value(totalDisc),
    );
  }

  factory ResepstmpData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ResepstmpData(
      id: serializer.fromJson<int>(json['id']),
      kodeBarang: serializer.fromJson<String>(json['kodeBarang']),
      namaBarang: serializer.fromJson<String>(json['namaBarang']),
      kelompok: serializer.fromJson<String>(json['kelompok']),
      satuan: serializer.fromJson<String>(json['satuan']),
      hargaBeli: serializer.fromJson<int>(json['hargaBeli']),
      hargaJual: serializer.fromJson<int>(json['hargaJual']),
      jualDiscon: serializer.fromJson<int?>(json['jualDiscon']),
      jumlahJual: serializer.fromJson<int?>(json['jumlahJual']),
      totalHargaSebelumDisc:
          serializer.fromJson<int?>(json['totalHargaSebelumDisc']),
      totalHargaSetelahDisc:
          serializer.fromJson<int?>(json['totalHargaSetelahDisc']),
      totalDisc: serializer.fromJson<int?>(json['totalDisc']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'kodeBarang': serializer.toJson<String>(kodeBarang),
      'namaBarang': serializer.toJson<String>(namaBarang),
      'kelompok': serializer.toJson<String>(kelompok),
      'satuan': serializer.toJson<String>(satuan),
      'hargaBeli': serializer.toJson<int>(hargaBeli),
      'hargaJual': serializer.toJson<int>(hargaJual),
      'jualDiscon': serializer.toJson<int?>(jualDiscon),
      'jumlahJual': serializer.toJson<int?>(jumlahJual),
      'totalHargaSebelumDisc': serializer.toJson<int?>(totalHargaSebelumDisc),
      'totalHargaSetelahDisc': serializer.toJson<int?>(totalHargaSetelahDisc),
      'totalDisc': serializer.toJson<int?>(totalDisc),
    };
  }

  ResepstmpData copyWith(
          {int? id,
          String? kodeBarang,
          String? namaBarang,
          String? kelompok,
          String? satuan,
          int? hargaBeli,
          int? hargaJual,
          Value<int?> jualDiscon = const Value.absent(),
          Value<int?> jumlahJual = const Value.absent(),
          Value<int?> totalHargaSebelumDisc = const Value.absent(),
          Value<int?> totalHargaSetelahDisc = const Value.absent(),
          Value<int?> totalDisc = const Value.absent()}) =>
      ResepstmpData(
        id: id ?? this.id,
        kodeBarang: kodeBarang ?? this.kodeBarang,
        namaBarang: namaBarang ?? this.namaBarang,
        kelompok: kelompok ?? this.kelompok,
        satuan: satuan ?? this.satuan,
        hargaBeli: hargaBeli ?? this.hargaBeli,
        hargaJual: hargaJual ?? this.hargaJual,
        jualDiscon: jualDiscon.present ? jualDiscon.value : this.jualDiscon,
        jumlahJual: jumlahJual.present ? jumlahJual.value : this.jumlahJual,
        totalHargaSebelumDisc: totalHargaSebelumDisc.present
            ? totalHargaSebelumDisc.value
            : this.totalHargaSebelumDisc,
        totalHargaSetelahDisc: totalHargaSetelahDisc.present
            ? totalHargaSetelahDisc.value
            : this.totalHargaSetelahDisc,
        totalDisc: totalDisc.present ? totalDisc.value : this.totalDisc,
      );
  ResepstmpData copyWithCompanion(ResepstmpCompanion data) {
    return ResepstmpData(
      id: data.id.present ? data.id.value : this.id,
      kodeBarang:
          data.kodeBarang.present ? data.kodeBarang.value : this.kodeBarang,
      namaBarang:
          data.namaBarang.present ? data.namaBarang.value : this.namaBarang,
      kelompok: data.kelompok.present ? data.kelompok.value : this.kelompok,
      satuan: data.satuan.present ? data.satuan.value : this.satuan,
      hargaBeli: data.hargaBeli.present ? data.hargaBeli.value : this.hargaBeli,
      hargaJual: data.hargaJual.present ? data.hargaJual.value : this.hargaJual,
      jualDiscon:
          data.jualDiscon.present ? data.jualDiscon.value : this.jualDiscon,
      jumlahJual:
          data.jumlahJual.present ? data.jumlahJual.value : this.jumlahJual,
      totalHargaSebelumDisc: data.totalHargaSebelumDisc.present
          ? data.totalHargaSebelumDisc.value
          : this.totalHargaSebelumDisc,
      totalHargaSetelahDisc: data.totalHargaSetelahDisc.present
          ? data.totalHargaSetelahDisc.value
          : this.totalHargaSetelahDisc,
      totalDisc: data.totalDisc.present ? data.totalDisc.value : this.totalDisc,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ResepstmpData(')
          ..write('id: $id, ')
          ..write('kodeBarang: $kodeBarang, ')
          ..write('namaBarang: $namaBarang, ')
          ..write('kelompok: $kelompok, ')
          ..write('satuan: $satuan, ')
          ..write('hargaBeli: $hargaBeli, ')
          ..write('hargaJual: $hargaJual, ')
          ..write('jualDiscon: $jualDiscon, ')
          ..write('jumlahJual: $jumlahJual, ')
          ..write('totalHargaSebelumDisc: $totalHargaSebelumDisc, ')
          ..write('totalHargaSetelahDisc: $totalHargaSetelahDisc, ')
          ..write('totalDisc: $totalDisc')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      kodeBarang,
      namaBarang,
      kelompok,
      satuan,
      hargaBeli,
      hargaJual,
      jualDiscon,
      jumlahJual,
      totalHargaSebelumDisc,
      totalHargaSetelahDisc,
      totalDisc);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ResepstmpData &&
          other.id == this.id &&
          other.kodeBarang == this.kodeBarang &&
          other.namaBarang == this.namaBarang &&
          other.kelompok == this.kelompok &&
          other.satuan == this.satuan &&
          other.hargaBeli == this.hargaBeli &&
          other.hargaJual == this.hargaJual &&
          other.jualDiscon == this.jualDiscon &&
          other.jumlahJual == this.jumlahJual &&
          other.totalHargaSebelumDisc == this.totalHargaSebelumDisc &&
          other.totalHargaSetelahDisc == this.totalHargaSetelahDisc &&
          other.totalDisc == this.totalDisc);
}

class ResepstmpCompanion extends UpdateCompanion<ResepstmpData> {
  final Value<int> id;
  final Value<String> kodeBarang;
  final Value<String> namaBarang;
  final Value<String> kelompok;
  final Value<String> satuan;
  final Value<int> hargaBeli;
  final Value<int> hargaJual;
  final Value<int?> jualDiscon;
  final Value<int?> jumlahJual;
  final Value<int?> totalHargaSebelumDisc;
  final Value<int?> totalHargaSetelahDisc;
  final Value<int?> totalDisc;
  const ResepstmpCompanion({
    this.id = const Value.absent(),
    this.kodeBarang = const Value.absent(),
    this.namaBarang = const Value.absent(),
    this.kelompok = const Value.absent(),
    this.satuan = const Value.absent(),
    this.hargaBeli = const Value.absent(),
    this.hargaJual = const Value.absent(),
    this.jualDiscon = const Value.absent(),
    this.jumlahJual = const Value.absent(),
    this.totalHargaSebelumDisc = const Value.absent(),
    this.totalHargaSetelahDisc = const Value.absent(),
    this.totalDisc = const Value.absent(),
  });
  ResepstmpCompanion.insert({
    this.id = const Value.absent(),
    required String kodeBarang,
    required String namaBarang,
    required String kelompok,
    required String satuan,
    this.hargaBeli = const Value.absent(),
    this.hargaJual = const Value.absent(),
    this.jualDiscon = const Value.absent(),
    this.jumlahJual = const Value.absent(),
    this.totalHargaSebelumDisc = const Value.absent(),
    this.totalHargaSetelahDisc = const Value.absent(),
    this.totalDisc = const Value.absent(),
  })  : kodeBarang = Value(kodeBarang),
        namaBarang = Value(namaBarang),
        kelompok = Value(kelompok),
        satuan = Value(satuan);
  static Insertable<ResepstmpData> custom({
    Expression<int>? id,
    Expression<String>? kodeBarang,
    Expression<String>? namaBarang,
    Expression<String>? kelompok,
    Expression<String>? satuan,
    Expression<int>? hargaBeli,
    Expression<int>? hargaJual,
    Expression<int>? jualDiscon,
    Expression<int>? jumlahJual,
    Expression<int>? totalHargaSebelumDisc,
    Expression<int>? totalHargaSetelahDisc,
    Expression<int>? totalDisc,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (kodeBarang != null) 'kode_barang': kodeBarang,
      if (namaBarang != null) 'nama_barang': namaBarang,
      if (kelompok != null) 'kelompok': kelompok,
      if (satuan != null) 'satuan': satuan,
      if (hargaBeli != null) 'harga_beli': hargaBeli,
      if (hargaJual != null) 'harga_jual': hargaJual,
      if (jualDiscon != null) 'jual_discon': jualDiscon,
      if (jumlahJual != null) 'jumlah_jual': jumlahJual,
      if (totalHargaSebelumDisc != null)
        'total_harga_sebelum_disc': totalHargaSebelumDisc,
      if (totalHargaSetelahDisc != null)
        'total_harga_setelah_disc': totalHargaSetelahDisc,
      if (totalDisc != null) 'total_disc': totalDisc,
    });
  }

  ResepstmpCompanion copyWith(
      {Value<int>? id,
      Value<String>? kodeBarang,
      Value<String>? namaBarang,
      Value<String>? kelompok,
      Value<String>? satuan,
      Value<int>? hargaBeli,
      Value<int>? hargaJual,
      Value<int?>? jualDiscon,
      Value<int?>? jumlahJual,
      Value<int?>? totalHargaSebelumDisc,
      Value<int?>? totalHargaSetelahDisc,
      Value<int?>? totalDisc}) {
    return ResepstmpCompanion(
      id: id ?? this.id,
      kodeBarang: kodeBarang ?? this.kodeBarang,
      namaBarang: namaBarang ?? this.namaBarang,
      kelompok: kelompok ?? this.kelompok,
      satuan: satuan ?? this.satuan,
      hargaBeli: hargaBeli ?? this.hargaBeli,
      hargaJual: hargaJual ?? this.hargaJual,
      jualDiscon: jualDiscon ?? this.jualDiscon,
      jumlahJual: jumlahJual ?? this.jumlahJual,
      totalHargaSebelumDisc:
          totalHargaSebelumDisc ?? this.totalHargaSebelumDisc,
      totalHargaSetelahDisc:
          totalHargaSetelahDisc ?? this.totalHargaSetelahDisc,
      totalDisc: totalDisc ?? this.totalDisc,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (kodeBarang.present) {
      map['kode_barang'] = Variable<String>(kodeBarang.value);
    }
    if (namaBarang.present) {
      map['nama_barang'] = Variable<String>(namaBarang.value);
    }
    if (kelompok.present) {
      map['kelompok'] = Variable<String>(kelompok.value);
    }
    if (satuan.present) {
      map['satuan'] = Variable<String>(satuan.value);
    }
    if (hargaBeli.present) {
      map['harga_beli'] = Variable<int>(hargaBeli.value);
    }
    if (hargaJual.present) {
      map['harga_jual'] = Variable<int>(hargaJual.value);
    }
    if (jualDiscon.present) {
      map['jual_discon'] = Variable<int>(jualDiscon.value);
    }
    if (jumlahJual.present) {
      map['jumlah_jual'] = Variable<int>(jumlahJual.value);
    }
    if (totalHargaSebelumDisc.present) {
      map['total_harga_sebelum_disc'] =
          Variable<int>(totalHargaSebelumDisc.value);
    }
    if (totalHargaSetelahDisc.present) {
      map['total_harga_setelah_disc'] =
          Variable<int>(totalHargaSetelahDisc.value);
    }
    if (totalDisc.present) {
      map['total_disc'] = Variable<int>(totalDisc.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ResepstmpCompanion(')
          ..write('id: $id, ')
          ..write('kodeBarang: $kodeBarang, ')
          ..write('namaBarang: $namaBarang, ')
          ..write('kelompok: $kelompok, ')
          ..write('satuan: $satuan, ')
          ..write('hargaBeli: $hargaBeli, ')
          ..write('hargaJual: $hargaJual, ')
          ..write('jualDiscon: $jualDiscon, ')
          ..write('jumlahJual: $jumlahJual, ')
          ..write('totalHargaSebelumDisc: $totalHargaSebelumDisc, ')
          ..write('totalHargaSetelahDisc: $totalHargaSetelahDisc, ')
          ..write('totalDisc: $totalDisc')
          ..write(')'))
        .toString();
  }
}

class $RaksTable extends Raks with TableInfo<$RaksTable, Rak> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RaksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _kodeRakMeta =
      const VerificationMeta('kodeRak');
  @override
  late final GeneratedColumn<String> kodeRak = GeneratedColumn<String>(
      'kode_rak', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 20),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _namaRakMeta =
      const VerificationMeta('namaRak');
  @override
  late final GeneratedColumn<String> namaRak = GeneratedColumn<String>(
      'nama_rak', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 50),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _lokasiMeta = const VerificationMeta('lokasi');
  @override
  late final GeneratedColumn<String> lokasi = GeneratedColumn<String>(
      'lokasi', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _keteranganMeta =
      const VerificationMeta('keterangan');
  @override
  late final GeneratedColumn<String> keterangan = GeneratedColumn<String>(
      'keterangan', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, kodeRak, namaRak, lokasi, keterangan];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'raks';
  @override
  VerificationContext validateIntegrity(Insertable<Rak> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('kode_rak')) {
      context.handle(_kodeRakMeta,
          kodeRak.isAcceptableOrUnknown(data['kode_rak']!, _kodeRakMeta));
    } else if (isInserting) {
      context.missing(_kodeRakMeta);
    }
    if (data.containsKey('nama_rak')) {
      context.handle(_namaRakMeta,
          namaRak.isAcceptableOrUnknown(data['nama_rak']!, _namaRakMeta));
    } else if (isInserting) {
      context.missing(_namaRakMeta);
    }
    if (data.containsKey('lokasi')) {
      context.handle(_lokasiMeta,
          lokasi.isAcceptableOrUnknown(data['lokasi']!, _lokasiMeta));
    } else if (isInserting) {
      context.missing(_lokasiMeta);
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
  Rak map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Rak(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      kodeRak: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}kode_rak'])!,
      namaRak: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}nama_rak'])!,
      lokasi: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}lokasi'])!,
      keterangan: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}keterangan']),
    );
  }

  @override
  $RaksTable createAlias(String alias) {
    return $RaksTable(attachedDatabase, alias);
  }
}

class Rak extends DataClass implements Insertable<Rak> {
  final int id;
  final String kodeRak;
  final String namaRak;
  final String lokasi;
  final String? keterangan;
  const Rak(
      {required this.id,
      required this.kodeRak,
      required this.namaRak,
      required this.lokasi,
      this.keterangan});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['kode_rak'] = Variable<String>(kodeRak);
    map['nama_rak'] = Variable<String>(namaRak);
    map['lokasi'] = Variable<String>(lokasi);
    if (!nullToAbsent || keterangan != null) {
      map['keterangan'] = Variable<String>(keterangan);
    }
    return map;
  }

  RaksCompanion toCompanion(bool nullToAbsent) {
    return RaksCompanion(
      id: Value(id),
      kodeRak: Value(kodeRak),
      namaRak: Value(namaRak),
      lokasi: Value(lokasi),
      keterangan: keterangan == null && nullToAbsent
          ? const Value.absent()
          : Value(keterangan),
    );
  }

  factory Rak.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Rak(
      id: serializer.fromJson<int>(json['id']),
      kodeRak: serializer.fromJson<String>(json['kodeRak']),
      namaRak: serializer.fromJson<String>(json['namaRak']),
      lokasi: serializer.fromJson<String>(json['lokasi']),
      keterangan: serializer.fromJson<String?>(json['keterangan']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'kodeRak': serializer.toJson<String>(kodeRak),
      'namaRak': serializer.toJson<String>(namaRak),
      'lokasi': serializer.toJson<String>(lokasi),
      'keterangan': serializer.toJson<String?>(keterangan),
    };
  }

  Rak copyWith(
          {int? id,
          String? kodeRak,
          String? namaRak,
          String? lokasi,
          Value<String?> keterangan = const Value.absent()}) =>
      Rak(
        id: id ?? this.id,
        kodeRak: kodeRak ?? this.kodeRak,
        namaRak: namaRak ?? this.namaRak,
        lokasi: lokasi ?? this.lokasi,
        keterangan: keterangan.present ? keterangan.value : this.keterangan,
      );
  Rak copyWithCompanion(RaksCompanion data) {
    return Rak(
      id: data.id.present ? data.id.value : this.id,
      kodeRak: data.kodeRak.present ? data.kodeRak.value : this.kodeRak,
      namaRak: data.namaRak.present ? data.namaRak.value : this.namaRak,
      lokasi: data.lokasi.present ? data.lokasi.value : this.lokasi,
      keterangan:
          data.keterangan.present ? data.keterangan.value : this.keterangan,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Rak(')
          ..write('id: $id, ')
          ..write('kodeRak: $kodeRak, ')
          ..write('namaRak: $namaRak, ')
          ..write('lokasi: $lokasi, ')
          ..write('keterangan: $keterangan')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, kodeRak, namaRak, lokasi, keterangan);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Rak &&
          other.id == this.id &&
          other.kodeRak == this.kodeRak &&
          other.namaRak == this.namaRak &&
          other.lokasi == this.lokasi &&
          other.keterangan == this.keterangan);
}

class RaksCompanion extends UpdateCompanion<Rak> {
  final Value<int> id;
  final Value<String> kodeRak;
  final Value<String> namaRak;
  final Value<String> lokasi;
  final Value<String?> keterangan;
  const RaksCompanion({
    this.id = const Value.absent(),
    this.kodeRak = const Value.absent(),
    this.namaRak = const Value.absent(),
    this.lokasi = const Value.absent(),
    this.keterangan = const Value.absent(),
  });
  RaksCompanion.insert({
    this.id = const Value.absent(),
    required String kodeRak,
    required String namaRak,
    required String lokasi,
    this.keterangan = const Value.absent(),
  })  : kodeRak = Value(kodeRak),
        namaRak = Value(namaRak),
        lokasi = Value(lokasi);
  static Insertable<Rak> custom({
    Expression<int>? id,
    Expression<String>? kodeRak,
    Expression<String>? namaRak,
    Expression<String>? lokasi,
    Expression<String>? keterangan,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (kodeRak != null) 'kode_rak': kodeRak,
      if (namaRak != null) 'nama_rak': namaRak,
      if (lokasi != null) 'lokasi': lokasi,
      if (keterangan != null) 'keterangan': keterangan,
    });
  }

  RaksCompanion copyWith(
      {Value<int>? id,
      Value<String>? kodeRak,
      Value<String>? namaRak,
      Value<String>? lokasi,
      Value<String?>? keterangan}) {
    return RaksCompanion(
      id: id ?? this.id,
      kodeRak: kodeRak ?? this.kodeRak,
      namaRak: namaRak ?? this.namaRak,
      lokasi: lokasi ?? this.lokasi,
      keterangan: keterangan ?? this.keterangan,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (kodeRak.present) {
      map['kode_rak'] = Variable<String>(kodeRak.value);
    }
    if (namaRak.present) {
      map['nama_rak'] = Variable<String>(namaRak.value);
    }
    if (lokasi.present) {
      map['lokasi'] = Variable<String>(lokasi.value);
    }
    if (keterangan.present) {
      map['keterangan'] = Variable<String>(keterangan.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RaksCompanion(')
          ..write('id: $id, ')
          ..write('kodeRak: $kodeRak, ')
          ..write('namaRak: $namaRak, ')
          ..write('lokasi: $lokasi, ')
          ..write('keterangan: $keterangan')
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
  late final $BarangsTable barangs = $BarangsTable(this);
  late final $PenjualansTable penjualans = $PenjualansTable(this);
  late final $PenjualanstmpTable penjualanstmp = $PenjualanstmpTable(this);
  late final $PembeliansTable pembelians = $PembeliansTable(this);
  late final $PembelianstmpTable pembelianstmp = $PembelianstmpTable(this);
  late final $PelanggansTable pelanggans = $PelanggansTable(this);
  late final $ResepsTable reseps = $ResepsTable(this);
  late final $ResepstmpTable resepstmp = $ResepstmpTable(this);
  late final $RaksTable raks = $RaksTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        users,
        suppliers,
        doctors,
        barangs,
        penjualans,
        penjualanstmp,
        pembelians,
        pembelianstmp,
        pelanggans,
        reseps,
        resepstmp,
        raks
      ];
}

typedef $$UsersTableCreateCompanionBuilder = UsersCompanion Function({
  Value<int> id,
  required String username,
  required String password,
  required String role,
  Value<bool> aktif,
  Value<String?> avatar,
});
typedef $$UsersTableUpdateCompanionBuilder = UsersCompanion Function({
  Value<int> id,
  Value<String> username,
  Value<String> password,
  Value<String> role,
  Value<bool> aktif,
  Value<String?> avatar,
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

  ColumnFilters<bool> get aktif => $composableBuilder(
      column: $table.aktif, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get avatar => $composableBuilder(
      column: $table.avatar, builder: (column) => ColumnFilters(column));
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

  ColumnOrderings<bool> get aktif => $composableBuilder(
      column: $table.aktif, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get avatar => $composableBuilder(
      column: $table.avatar, builder: (column) => ColumnOrderings(column));
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

  GeneratedColumn<bool> get aktif =>
      $composableBuilder(column: $table.aktif, builder: (column) => column);

  GeneratedColumn<String> get avatar =>
      $composableBuilder(column: $table.avatar, builder: (column) => column);
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
            Value<bool> aktif = const Value.absent(),
            Value<String?> avatar = const Value.absent(),
          }) =>
              UsersCompanion(
            id: id,
            username: username,
            password: password,
            role: role,
            aktif: aktif,
            avatar: avatar,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String username,
            required String password,
            required String role,
            Value<bool> aktif = const Value.absent(),
            Value<String?> avatar = const Value.absent(),
          }) =>
              UsersCompanion.insert(
            id: id,
            username: username,
            password: password,
            role: role,
            aktif: aktif,
            avatar: avatar,
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
typedef $$BarangsTableCreateCompanionBuilder = BarangsCompanion Function({
  Value<int> id,
  required String kodeBarang,
  required String namaBarang,
  required String kelompok,
  required String satuan,
  required String noRak,
  Value<int> stokAktual,
  Value<int> hargaBeli,
  Value<int> hargaJual,
  Value<int?> jualDisc1,
  Value<int?> jualDisc2,
  Value<int?> jualDisc3,
  Value<int?> jualDisc4,
});
typedef $$BarangsTableUpdateCompanionBuilder = BarangsCompanion Function({
  Value<int> id,
  Value<String> kodeBarang,
  Value<String> namaBarang,
  Value<String> kelompok,
  Value<String> satuan,
  Value<String> noRak,
  Value<int> stokAktual,
  Value<int> hargaBeli,
  Value<int> hargaJual,
  Value<int?> jualDisc1,
  Value<int?> jualDisc2,
  Value<int?> jualDisc3,
  Value<int?> jualDisc4,
});

class $$BarangsTableFilterComposer
    extends Composer<_$AppDatabase, $BarangsTable> {
  $$BarangsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get kodeBarang => $composableBuilder(
      column: $table.kodeBarang, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get namaBarang => $composableBuilder(
      column: $table.namaBarang, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get kelompok => $composableBuilder(
      column: $table.kelompok, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get satuan => $composableBuilder(
      column: $table.satuan, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get noRak => $composableBuilder(
      column: $table.noRak, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get stokAktual => $composableBuilder(
      column: $table.stokAktual, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get hargaBeli => $composableBuilder(
      column: $table.hargaBeli, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get hargaJual => $composableBuilder(
      column: $table.hargaJual, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get jualDisc1 => $composableBuilder(
      column: $table.jualDisc1, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get jualDisc2 => $composableBuilder(
      column: $table.jualDisc2, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get jualDisc3 => $composableBuilder(
      column: $table.jualDisc3, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get jualDisc4 => $composableBuilder(
      column: $table.jualDisc4, builder: (column) => ColumnFilters(column));
}

class $$BarangsTableOrderingComposer
    extends Composer<_$AppDatabase, $BarangsTable> {
  $$BarangsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get kodeBarang => $composableBuilder(
      column: $table.kodeBarang, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get namaBarang => $composableBuilder(
      column: $table.namaBarang, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get kelompok => $composableBuilder(
      column: $table.kelompok, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get satuan => $composableBuilder(
      column: $table.satuan, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get noRak => $composableBuilder(
      column: $table.noRak, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get stokAktual => $composableBuilder(
      column: $table.stokAktual, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get hargaBeli => $composableBuilder(
      column: $table.hargaBeli, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get hargaJual => $composableBuilder(
      column: $table.hargaJual, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get jualDisc1 => $composableBuilder(
      column: $table.jualDisc1, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get jualDisc2 => $composableBuilder(
      column: $table.jualDisc2, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get jualDisc3 => $composableBuilder(
      column: $table.jualDisc3, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get jualDisc4 => $composableBuilder(
      column: $table.jualDisc4, builder: (column) => ColumnOrderings(column));
}

class $$BarangsTableAnnotationComposer
    extends Composer<_$AppDatabase, $BarangsTable> {
  $$BarangsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get kodeBarang => $composableBuilder(
      column: $table.kodeBarang, builder: (column) => column);

  GeneratedColumn<String> get namaBarang => $composableBuilder(
      column: $table.namaBarang, builder: (column) => column);

  GeneratedColumn<String> get kelompok =>
      $composableBuilder(column: $table.kelompok, builder: (column) => column);

  GeneratedColumn<String> get satuan =>
      $composableBuilder(column: $table.satuan, builder: (column) => column);

  GeneratedColumn<String> get noRak =>
      $composableBuilder(column: $table.noRak, builder: (column) => column);

  GeneratedColumn<int> get stokAktual => $composableBuilder(
      column: $table.stokAktual, builder: (column) => column);

  GeneratedColumn<int> get hargaBeli =>
      $composableBuilder(column: $table.hargaBeli, builder: (column) => column);

  GeneratedColumn<int> get hargaJual =>
      $composableBuilder(column: $table.hargaJual, builder: (column) => column);

  GeneratedColumn<int> get jualDisc1 =>
      $composableBuilder(column: $table.jualDisc1, builder: (column) => column);

  GeneratedColumn<int> get jualDisc2 =>
      $composableBuilder(column: $table.jualDisc2, builder: (column) => column);

  GeneratedColumn<int> get jualDisc3 =>
      $composableBuilder(column: $table.jualDisc3, builder: (column) => column);

  GeneratedColumn<int> get jualDisc4 =>
      $composableBuilder(column: $table.jualDisc4, builder: (column) => column);
}

class $$BarangsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $BarangsTable,
    Barang,
    $$BarangsTableFilterComposer,
    $$BarangsTableOrderingComposer,
    $$BarangsTableAnnotationComposer,
    $$BarangsTableCreateCompanionBuilder,
    $$BarangsTableUpdateCompanionBuilder,
    (Barang, BaseReferences<_$AppDatabase, $BarangsTable, Barang>),
    Barang,
    PrefetchHooks Function()> {
  $$BarangsTableTableManager(_$AppDatabase db, $BarangsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BarangsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BarangsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BarangsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> kodeBarang = const Value.absent(),
            Value<String> namaBarang = const Value.absent(),
            Value<String> kelompok = const Value.absent(),
            Value<String> satuan = const Value.absent(),
            Value<String> noRak = const Value.absent(),
            Value<int> stokAktual = const Value.absent(),
            Value<int> hargaBeli = const Value.absent(),
            Value<int> hargaJual = const Value.absent(),
            Value<int?> jualDisc1 = const Value.absent(),
            Value<int?> jualDisc2 = const Value.absent(),
            Value<int?> jualDisc3 = const Value.absent(),
            Value<int?> jualDisc4 = const Value.absent(),
          }) =>
              BarangsCompanion(
            id: id,
            kodeBarang: kodeBarang,
            namaBarang: namaBarang,
            kelompok: kelompok,
            satuan: satuan,
            noRak: noRak,
            stokAktual: stokAktual,
            hargaBeli: hargaBeli,
            hargaJual: hargaJual,
            jualDisc1: jualDisc1,
            jualDisc2: jualDisc2,
            jualDisc3: jualDisc3,
            jualDisc4: jualDisc4,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String kodeBarang,
            required String namaBarang,
            required String kelompok,
            required String satuan,
            required String noRak,
            Value<int> stokAktual = const Value.absent(),
            Value<int> hargaBeli = const Value.absent(),
            Value<int> hargaJual = const Value.absent(),
            Value<int?> jualDisc1 = const Value.absent(),
            Value<int?> jualDisc2 = const Value.absent(),
            Value<int?> jualDisc3 = const Value.absent(),
            Value<int?> jualDisc4 = const Value.absent(),
          }) =>
              BarangsCompanion.insert(
            id: id,
            kodeBarang: kodeBarang,
            namaBarang: namaBarang,
            kelompok: kelompok,
            satuan: satuan,
            noRak: noRak,
            stokAktual: stokAktual,
            hargaBeli: hargaBeli,
            hargaJual: hargaJual,
            jualDisc1: jualDisc1,
            jualDisc2: jualDisc2,
            jualDisc3: jualDisc3,
            jualDisc4: jualDisc4,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$BarangsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $BarangsTable,
    Barang,
    $$BarangsTableFilterComposer,
    $$BarangsTableOrderingComposer,
    $$BarangsTableAnnotationComposer,
    $$BarangsTableCreateCompanionBuilder,
    $$BarangsTableUpdateCompanionBuilder,
    (Barang, BaseReferences<_$AppDatabase, $BarangsTable, Barang>),
    Barang,
    PrefetchHooks Function()>;
typedef $$PenjualansTableCreateCompanionBuilder = PenjualansCompanion Function({
  Value<int> id,
  required String noFaktur,
  required String kodeBarang,
  required String namaBarang,
  required DateTime tanggalBeli,
  required DateTime expired,
  required String kelompok,
  required String satuan,
  Value<int> hargaBeli,
  Value<int> hargaJual,
  Value<int?> jualDiscon,
  Value<int?> jumlahJual,
  Value<int?> totalHargaSebelumDisc,
  Value<int?> totalHargaSetelahDisc,
  Value<int?> totalDisc,
});
typedef $$PenjualansTableUpdateCompanionBuilder = PenjualansCompanion Function({
  Value<int> id,
  Value<String> noFaktur,
  Value<String> kodeBarang,
  Value<String> namaBarang,
  Value<DateTime> tanggalBeli,
  Value<DateTime> expired,
  Value<String> kelompok,
  Value<String> satuan,
  Value<int> hargaBeli,
  Value<int> hargaJual,
  Value<int?> jualDiscon,
  Value<int?> jumlahJual,
  Value<int?> totalHargaSebelumDisc,
  Value<int?> totalHargaSetelahDisc,
  Value<int?> totalDisc,
});

class $$PenjualansTableFilterComposer
    extends Composer<_$AppDatabase, $PenjualansTable> {
  $$PenjualansTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get noFaktur => $composableBuilder(
      column: $table.noFaktur, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get kodeBarang => $composableBuilder(
      column: $table.kodeBarang, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get namaBarang => $composableBuilder(
      column: $table.namaBarang, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get tanggalBeli => $composableBuilder(
      column: $table.tanggalBeli, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get expired => $composableBuilder(
      column: $table.expired, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get kelompok => $composableBuilder(
      column: $table.kelompok, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get satuan => $composableBuilder(
      column: $table.satuan, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get hargaBeli => $composableBuilder(
      column: $table.hargaBeli, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get hargaJual => $composableBuilder(
      column: $table.hargaJual, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get jualDiscon => $composableBuilder(
      column: $table.jualDiscon, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get jumlahJual => $composableBuilder(
      column: $table.jumlahJual, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get totalHargaSebelumDisc => $composableBuilder(
      column: $table.totalHargaSebelumDisc,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get totalHargaSetelahDisc => $composableBuilder(
      column: $table.totalHargaSetelahDisc,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get totalDisc => $composableBuilder(
      column: $table.totalDisc, builder: (column) => ColumnFilters(column));
}

class $$PenjualansTableOrderingComposer
    extends Composer<_$AppDatabase, $PenjualansTable> {
  $$PenjualansTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get noFaktur => $composableBuilder(
      column: $table.noFaktur, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get kodeBarang => $composableBuilder(
      column: $table.kodeBarang, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get namaBarang => $composableBuilder(
      column: $table.namaBarang, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get tanggalBeli => $composableBuilder(
      column: $table.tanggalBeli, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get expired => $composableBuilder(
      column: $table.expired, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get kelompok => $composableBuilder(
      column: $table.kelompok, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get satuan => $composableBuilder(
      column: $table.satuan, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get hargaBeli => $composableBuilder(
      column: $table.hargaBeli, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get hargaJual => $composableBuilder(
      column: $table.hargaJual, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get jualDiscon => $composableBuilder(
      column: $table.jualDiscon, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get jumlahJual => $composableBuilder(
      column: $table.jumlahJual, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get totalHargaSebelumDisc => $composableBuilder(
      column: $table.totalHargaSebelumDisc,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get totalHargaSetelahDisc => $composableBuilder(
      column: $table.totalHargaSetelahDisc,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get totalDisc => $composableBuilder(
      column: $table.totalDisc, builder: (column) => ColumnOrderings(column));
}

class $$PenjualansTableAnnotationComposer
    extends Composer<_$AppDatabase, $PenjualansTable> {
  $$PenjualansTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get noFaktur =>
      $composableBuilder(column: $table.noFaktur, builder: (column) => column);

  GeneratedColumn<String> get kodeBarang => $composableBuilder(
      column: $table.kodeBarang, builder: (column) => column);

  GeneratedColumn<String> get namaBarang => $composableBuilder(
      column: $table.namaBarang, builder: (column) => column);

  GeneratedColumn<DateTime> get tanggalBeli => $composableBuilder(
      column: $table.tanggalBeli, builder: (column) => column);

  GeneratedColumn<DateTime> get expired =>
      $composableBuilder(column: $table.expired, builder: (column) => column);

  GeneratedColumn<String> get kelompok =>
      $composableBuilder(column: $table.kelompok, builder: (column) => column);

  GeneratedColumn<String> get satuan =>
      $composableBuilder(column: $table.satuan, builder: (column) => column);

  GeneratedColumn<int> get hargaBeli =>
      $composableBuilder(column: $table.hargaBeli, builder: (column) => column);

  GeneratedColumn<int> get hargaJual =>
      $composableBuilder(column: $table.hargaJual, builder: (column) => column);

  GeneratedColumn<int> get jualDiscon => $composableBuilder(
      column: $table.jualDiscon, builder: (column) => column);

  GeneratedColumn<int> get jumlahJual => $composableBuilder(
      column: $table.jumlahJual, builder: (column) => column);

  GeneratedColumn<int> get totalHargaSebelumDisc => $composableBuilder(
      column: $table.totalHargaSebelumDisc, builder: (column) => column);

  GeneratedColumn<int> get totalHargaSetelahDisc => $composableBuilder(
      column: $table.totalHargaSetelahDisc, builder: (column) => column);

  GeneratedColumn<int> get totalDisc =>
      $composableBuilder(column: $table.totalDisc, builder: (column) => column);
}

class $$PenjualansTableTableManager extends RootTableManager<
    _$AppDatabase,
    $PenjualansTable,
    Penjualan,
    $$PenjualansTableFilterComposer,
    $$PenjualansTableOrderingComposer,
    $$PenjualansTableAnnotationComposer,
    $$PenjualansTableCreateCompanionBuilder,
    $$PenjualansTableUpdateCompanionBuilder,
    (Penjualan, BaseReferences<_$AppDatabase, $PenjualansTable, Penjualan>),
    Penjualan,
    PrefetchHooks Function()> {
  $$PenjualansTableTableManager(_$AppDatabase db, $PenjualansTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PenjualansTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PenjualansTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PenjualansTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> noFaktur = const Value.absent(),
            Value<String> kodeBarang = const Value.absent(),
            Value<String> namaBarang = const Value.absent(),
            Value<DateTime> tanggalBeli = const Value.absent(),
            Value<DateTime> expired = const Value.absent(),
            Value<String> kelompok = const Value.absent(),
            Value<String> satuan = const Value.absent(),
            Value<int> hargaBeli = const Value.absent(),
            Value<int> hargaJual = const Value.absent(),
            Value<int?> jualDiscon = const Value.absent(),
            Value<int?> jumlahJual = const Value.absent(),
            Value<int?> totalHargaSebelumDisc = const Value.absent(),
            Value<int?> totalHargaSetelahDisc = const Value.absent(),
            Value<int?> totalDisc = const Value.absent(),
          }) =>
              PenjualansCompanion(
            id: id,
            noFaktur: noFaktur,
            kodeBarang: kodeBarang,
            namaBarang: namaBarang,
            tanggalBeli: tanggalBeli,
            expired: expired,
            kelompok: kelompok,
            satuan: satuan,
            hargaBeli: hargaBeli,
            hargaJual: hargaJual,
            jualDiscon: jualDiscon,
            jumlahJual: jumlahJual,
            totalHargaSebelumDisc: totalHargaSebelumDisc,
            totalHargaSetelahDisc: totalHargaSetelahDisc,
            totalDisc: totalDisc,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String noFaktur,
            required String kodeBarang,
            required String namaBarang,
            required DateTime tanggalBeli,
            required DateTime expired,
            required String kelompok,
            required String satuan,
            Value<int> hargaBeli = const Value.absent(),
            Value<int> hargaJual = const Value.absent(),
            Value<int?> jualDiscon = const Value.absent(),
            Value<int?> jumlahJual = const Value.absent(),
            Value<int?> totalHargaSebelumDisc = const Value.absent(),
            Value<int?> totalHargaSetelahDisc = const Value.absent(),
            Value<int?> totalDisc = const Value.absent(),
          }) =>
              PenjualansCompanion.insert(
            id: id,
            noFaktur: noFaktur,
            kodeBarang: kodeBarang,
            namaBarang: namaBarang,
            tanggalBeli: tanggalBeli,
            expired: expired,
            kelompok: kelompok,
            satuan: satuan,
            hargaBeli: hargaBeli,
            hargaJual: hargaJual,
            jualDiscon: jualDiscon,
            jumlahJual: jumlahJual,
            totalHargaSebelumDisc: totalHargaSebelumDisc,
            totalHargaSetelahDisc: totalHargaSetelahDisc,
            totalDisc: totalDisc,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$PenjualansTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $PenjualansTable,
    Penjualan,
    $$PenjualansTableFilterComposer,
    $$PenjualansTableOrderingComposer,
    $$PenjualansTableAnnotationComposer,
    $$PenjualansTableCreateCompanionBuilder,
    $$PenjualansTableUpdateCompanionBuilder,
    (Penjualan, BaseReferences<_$AppDatabase, $PenjualansTable, Penjualan>),
    Penjualan,
    PrefetchHooks Function()>;
typedef $$PenjualanstmpTableCreateCompanionBuilder = PenjualanstmpCompanion
    Function({
  Value<int> id,
  required String kodeBarang,
  required String namaBarang,
  required String kelompok,
  required String satuan,
  Value<int> hargaBeli,
  Value<int> hargaJual,
  Value<int?> jualDiscon,
  Value<int?> jumlahJual,
  Value<int?> totalHargaSebelumDisc,
  Value<int?> totalHargaSetelahDisc,
  Value<int?> totalDisc,
});
typedef $$PenjualanstmpTableUpdateCompanionBuilder = PenjualanstmpCompanion
    Function({
  Value<int> id,
  Value<String> kodeBarang,
  Value<String> namaBarang,
  Value<String> kelompok,
  Value<String> satuan,
  Value<int> hargaBeli,
  Value<int> hargaJual,
  Value<int?> jualDiscon,
  Value<int?> jumlahJual,
  Value<int?> totalHargaSebelumDisc,
  Value<int?> totalHargaSetelahDisc,
  Value<int?> totalDisc,
});

class $$PenjualanstmpTableFilterComposer
    extends Composer<_$AppDatabase, $PenjualanstmpTable> {
  $$PenjualanstmpTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get kodeBarang => $composableBuilder(
      column: $table.kodeBarang, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get namaBarang => $composableBuilder(
      column: $table.namaBarang, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get kelompok => $composableBuilder(
      column: $table.kelompok, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get satuan => $composableBuilder(
      column: $table.satuan, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get hargaBeli => $composableBuilder(
      column: $table.hargaBeli, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get hargaJual => $composableBuilder(
      column: $table.hargaJual, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get jualDiscon => $composableBuilder(
      column: $table.jualDiscon, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get jumlahJual => $composableBuilder(
      column: $table.jumlahJual, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get totalHargaSebelumDisc => $composableBuilder(
      column: $table.totalHargaSebelumDisc,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get totalHargaSetelahDisc => $composableBuilder(
      column: $table.totalHargaSetelahDisc,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get totalDisc => $composableBuilder(
      column: $table.totalDisc, builder: (column) => ColumnFilters(column));
}

class $$PenjualanstmpTableOrderingComposer
    extends Composer<_$AppDatabase, $PenjualanstmpTable> {
  $$PenjualanstmpTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get kodeBarang => $composableBuilder(
      column: $table.kodeBarang, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get namaBarang => $composableBuilder(
      column: $table.namaBarang, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get kelompok => $composableBuilder(
      column: $table.kelompok, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get satuan => $composableBuilder(
      column: $table.satuan, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get hargaBeli => $composableBuilder(
      column: $table.hargaBeli, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get hargaJual => $composableBuilder(
      column: $table.hargaJual, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get jualDiscon => $composableBuilder(
      column: $table.jualDiscon, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get jumlahJual => $composableBuilder(
      column: $table.jumlahJual, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get totalHargaSebelumDisc => $composableBuilder(
      column: $table.totalHargaSebelumDisc,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get totalHargaSetelahDisc => $composableBuilder(
      column: $table.totalHargaSetelahDisc,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get totalDisc => $composableBuilder(
      column: $table.totalDisc, builder: (column) => ColumnOrderings(column));
}

class $$PenjualanstmpTableAnnotationComposer
    extends Composer<_$AppDatabase, $PenjualanstmpTable> {
  $$PenjualanstmpTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get kodeBarang => $composableBuilder(
      column: $table.kodeBarang, builder: (column) => column);

  GeneratedColumn<String> get namaBarang => $composableBuilder(
      column: $table.namaBarang, builder: (column) => column);

  GeneratedColumn<String> get kelompok =>
      $composableBuilder(column: $table.kelompok, builder: (column) => column);

  GeneratedColumn<String> get satuan =>
      $composableBuilder(column: $table.satuan, builder: (column) => column);

  GeneratedColumn<int> get hargaBeli =>
      $composableBuilder(column: $table.hargaBeli, builder: (column) => column);

  GeneratedColumn<int> get hargaJual =>
      $composableBuilder(column: $table.hargaJual, builder: (column) => column);

  GeneratedColumn<int> get jualDiscon => $composableBuilder(
      column: $table.jualDiscon, builder: (column) => column);

  GeneratedColumn<int> get jumlahJual => $composableBuilder(
      column: $table.jumlahJual, builder: (column) => column);

  GeneratedColumn<int> get totalHargaSebelumDisc => $composableBuilder(
      column: $table.totalHargaSebelumDisc, builder: (column) => column);

  GeneratedColumn<int> get totalHargaSetelahDisc => $composableBuilder(
      column: $table.totalHargaSetelahDisc, builder: (column) => column);

  GeneratedColumn<int> get totalDisc =>
      $composableBuilder(column: $table.totalDisc, builder: (column) => column);
}

class $$PenjualanstmpTableTableManager extends RootTableManager<
    _$AppDatabase,
    $PenjualanstmpTable,
    PenjualanstmpData,
    $$PenjualanstmpTableFilterComposer,
    $$PenjualanstmpTableOrderingComposer,
    $$PenjualanstmpTableAnnotationComposer,
    $$PenjualanstmpTableCreateCompanionBuilder,
    $$PenjualanstmpTableUpdateCompanionBuilder,
    (
      PenjualanstmpData,
      BaseReferences<_$AppDatabase, $PenjualanstmpTable, PenjualanstmpData>
    ),
    PenjualanstmpData,
    PrefetchHooks Function()> {
  $$PenjualanstmpTableTableManager(_$AppDatabase db, $PenjualanstmpTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PenjualanstmpTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PenjualanstmpTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PenjualanstmpTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> kodeBarang = const Value.absent(),
            Value<String> namaBarang = const Value.absent(),
            Value<String> kelompok = const Value.absent(),
            Value<String> satuan = const Value.absent(),
            Value<int> hargaBeli = const Value.absent(),
            Value<int> hargaJual = const Value.absent(),
            Value<int?> jualDiscon = const Value.absent(),
            Value<int?> jumlahJual = const Value.absent(),
            Value<int?> totalHargaSebelumDisc = const Value.absent(),
            Value<int?> totalHargaSetelahDisc = const Value.absent(),
            Value<int?> totalDisc = const Value.absent(),
          }) =>
              PenjualanstmpCompanion(
            id: id,
            kodeBarang: kodeBarang,
            namaBarang: namaBarang,
            kelompok: kelompok,
            satuan: satuan,
            hargaBeli: hargaBeli,
            hargaJual: hargaJual,
            jualDiscon: jualDiscon,
            jumlahJual: jumlahJual,
            totalHargaSebelumDisc: totalHargaSebelumDisc,
            totalHargaSetelahDisc: totalHargaSetelahDisc,
            totalDisc: totalDisc,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String kodeBarang,
            required String namaBarang,
            required String kelompok,
            required String satuan,
            Value<int> hargaBeli = const Value.absent(),
            Value<int> hargaJual = const Value.absent(),
            Value<int?> jualDiscon = const Value.absent(),
            Value<int?> jumlahJual = const Value.absent(),
            Value<int?> totalHargaSebelumDisc = const Value.absent(),
            Value<int?> totalHargaSetelahDisc = const Value.absent(),
            Value<int?> totalDisc = const Value.absent(),
          }) =>
              PenjualanstmpCompanion.insert(
            id: id,
            kodeBarang: kodeBarang,
            namaBarang: namaBarang,
            kelompok: kelompok,
            satuan: satuan,
            hargaBeli: hargaBeli,
            hargaJual: hargaJual,
            jualDiscon: jualDiscon,
            jumlahJual: jumlahJual,
            totalHargaSebelumDisc: totalHargaSebelumDisc,
            totalHargaSetelahDisc: totalHargaSetelahDisc,
            totalDisc: totalDisc,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$PenjualanstmpTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $PenjualanstmpTable,
    PenjualanstmpData,
    $$PenjualanstmpTableFilterComposer,
    $$PenjualanstmpTableOrderingComposer,
    $$PenjualanstmpTableAnnotationComposer,
    $$PenjualanstmpTableCreateCompanionBuilder,
    $$PenjualanstmpTableUpdateCompanionBuilder,
    (
      PenjualanstmpData,
      BaseReferences<_$AppDatabase, $PenjualanstmpTable, PenjualanstmpData>
    ),
    PenjualanstmpData,
    PrefetchHooks Function()>;
typedef $$PembeliansTableCreateCompanionBuilder = PembeliansCompanion Function({
  Value<int> id,
  required String noFaktur,
  required String kodeSupplier,
  required String namaSuppliers,
  required String kodeBarang,
  required String namaBarang,
  required DateTime tanggalBeli,
  required DateTime expired,
  required String kelompok,
  required String satuan,
  Value<int> hargaBeli,
  Value<int> hargaJual,
  Value<int?> jualDisc1,
  Value<int?> jualDisc2,
  Value<int?> jualDisc3,
  Value<int?> jualDisc4,
  Value<int?> ppn,
  Value<int?> jumlahBeli,
  Value<int?> totalHarga,
});
typedef $$PembeliansTableUpdateCompanionBuilder = PembeliansCompanion Function({
  Value<int> id,
  Value<String> noFaktur,
  Value<String> kodeSupplier,
  Value<String> namaSuppliers,
  Value<String> kodeBarang,
  Value<String> namaBarang,
  Value<DateTime> tanggalBeli,
  Value<DateTime> expired,
  Value<String> kelompok,
  Value<String> satuan,
  Value<int> hargaBeli,
  Value<int> hargaJual,
  Value<int?> jualDisc1,
  Value<int?> jualDisc2,
  Value<int?> jualDisc3,
  Value<int?> jualDisc4,
  Value<int?> ppn,
  Value<int?> jumlahBeli,
  Value<int?> totalHarga,
});

class $$PembeliansTableFilterComposer
    extends Composer<_$AppDatabase, $PembeliansTable> {
  $$PembeliansTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get noFaktur => $composableBuilder(
      column: $table.noFaktur, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get kodeSupplier => $composableBuilder(
      column: $table.kodeSupplier, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get namaSuppliers => $composableBuilder(
      column: $table.namaSuppliers, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get kodeBarang => $composableBuilder(
      column: $table.kodeBarang, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get namaBarang => $composableBuilder(
      column: $table.namaBarang, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get tanggalBeli => $composableBuilder(
      column: $table.tanggalBeli, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get expired => $composableBuilder(
      column: $table.expired, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get kelompok => $composableBuilder(
      column: $table.kelompok, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get satuan => $composableBuilder(
      column: $table.satuan, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get hargaBeli => $composableBuilder(
      column: $table.hargaBeli, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get hargaJual => $composableBuilder(
      column: $table.hargaJual, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get jualDisc1 => $composableBuilder(
      column: $table.jualDisc1, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get jualDisc2 => $composableBuilder(
      column: $table.jualDisc2, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get jualDisc3 => $composableBuilder(
      column: $table.jualDisc3, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get jualDisc4 => $composableBuilder(
      column: $table.jualDisc4, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get ppn => $composableBuilder(
      column: $table.ppn, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get jumlahBeli => $composableBuilder(
      column: $table.jumlahBeli, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get totalHarga => $composableBuilder(
      column: $table.totalHarga, builder: (column) => ColumnFilters(column));
}

class $$PembeliansTableOrderingComposer
    extends Composer<_$AppDatabase, $PembeliansTable> {
  $$PembeliansTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get noFaktur => $composableBuilder(
      column: $table.noFaktur, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get kodeSupplier => $composableBuilder(
      column: $table.kodeSupplier,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get namaSuppliers => $composableBuilder(
      column: $table.namaSuppliers,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get kodeBarang => $composableBuilder(
      column: $table.kodeBarang, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get namaBarang => $composableBuilder(
      column: $table.namaBarang, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get tanggalBeli => $composableBuilder(
      column: $table.tanggalBeli, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get expired => $composableBuilder(
      column: $table.expired, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get kelompok => $composableBuilder(
      column: $table.kelompok, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get satuan => $composableBuilder(
      column: $table.satuan, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get hargaBeli => $composableBuilder(
      column: $table.hargaBeli, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get hargaJual => $composableBuilder(
      column: $table.hargaJual, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get jualDisc1 => $composableBuilder(
      column: $table.jualDisc1, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get jualDisc2 => $composableBuilder(
      column: $table.jualDisc2, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get jualDisc3 => $composableBuilder(
      column: $table.jualDisc3, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get jualDisc4 => $composableBuilder(
      column: $table.jualDisc4, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get ppn => $composableBuilder(
      column: $table.ppn, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get jumlahBeli => $composableBuilder(
      column: $table.jumlahBeli, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get totalHarga => $composableBuilder(
      column: $table.totalHarga, builder: (column) => ColumnOrderings(column));
}

class $$PembeliansTableAnnotationComposer
    extends Composer<_$AppDatabase, $PembeliansTable> {
  $$PembeliansTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get noFaktur =>
      $composableBuilder(column: $table.noFaktur, builder: (column) => column);

  GeneratedColumn<String> get kodeSupplier => $composableBuilder(
      column: $table.kodeSupplier, builder: (column) => column);

  GeneratedColumn<String> get namaSuppliers => $composableBuilder(
      column: $table.namaSuppliers, builder: (column) => column);

  GeneratedColumn<String> get kodeBarang => $composableBuilder(
      column: $table.kodeBarang, builder: (column) => column);

  GeneratedColumn<String> get namaBarang => $composableBuilder(
      column: $table.namaBarang, builder: (column) => column);

  GeneratedColumn<DateTime> get tanggalBeli => $composableBuilder(
      column: $table.tanggalBeli, builder: (column) => column);

  GeneratedColumn<DateTime> get expired =>
      $composableBuilder(column: $table.expired, builder: (column) => column);

  GeneratedColumn<String> get kelompok =>
      $composableBuilder(column: $table.kelompok, builder: (column) => column);

  GeneratedColumn<String> get satuan =>
      $composableBuilder(column: $table.satuan, builder: (column) => column);

  GeneratedColumn<int> get hargaBeli =>
      $composableBuilder(column: $table.hargaBeli, builder: (column) => column);

  GeneratedColumn<int> get hargaJual =>
      $composableBuilder(column: $table.hargaJual, builder: (column) => column);

  GeneratedColumn<int> get jualDisc1 =>
      $composableBuilder(column: $table.jualDisc1, builder: (column) => column);

  GeneratedColumn<int> get jualDisc2 =>
      $composableBuilder(column: $table.jualDisc2, builder: (column) => column);

  GeneratedColumn<int> get jualDisc3 =>
      $composableBuilder(column: $table.jualDisc3, builder: (column) => column);

  GeneratedColumn<int> get jualDisc4 =>
      $composableBuilder(column: $table.jualDisc4, builder: (column) => column);

  GeneratedColumn<int> get ppn =>
      $composableBuilder(column: $table.ppn, builder: (column) => column);

  GeneratedColumn<int> get jumlahBeli => $composableBuilder(
      column: $table.jumlahBeli, builder: (column) => column);

  GeneratedColumn<int> get totalHarga => $composableBuilder(
      column: $table.totalHarga, builder: (column) => column);
}

class $$PembeliansTableTableManager extends RootTableManager<
    _$AppDatabase,
    $PembeliansTable,
    Pembelian,
    $$PembeliansTableFilterComposer,
    $$PembeliansTableOrderingComposer,
    $$PembeliansTableAnnotationComposer,
    $$PembeliansTableCreateCompanionBuilder,
    $$PembeliansTableUpdateCompanionBuilder,
    (Pembelian, BaseReferences<_$AppDatabase, $PembeliansTable, Pembelian>),
    Pembelian,
    PrefetchHooks Function()> {
  $$PembeliansTableTableManager(_$AppDatabase db, $PembeliansTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PembeliansTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PembeliansTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PembeliansTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> noFaktur = const Value.absent(),
            Value<String> kodeSupplier = const Value.absent(),
            Value<String> namaSuppliers = const Value.absent(),
            Value<String> kodeBarang = const Value.absent(),
            Value<String> namaBarang = const Value.absent(),
            Value<DateTime> tanggalBeli = const Value.absent(),
            Value<DateTime> expired = const Value.absent(),
            Value<String> kelompok = const Value.absent(),
            Value<String> satuan = const Value.absent(),
            Value<int> hargaBeli = const Value.absent(),
            Value<int> hargaJual = const Value.absent(),
            Value<int?> jualDisc1 = const Value.absent(),
            Value<int?> jualDisc2 = const Value.absent(),
            Value<int?> jualDisc3 = const Value.absent(),
            Value<int?> jualDisc4 = const Value.absent(),
            Value<int?> ppn = const Value.absent(),
            Value<int?> jumlahBeli = const Value.absent(),
            Value<int?> totalHarga = const Value.absent(),
          }) =>
              PembeliansCompanion(
            id: id,
            noFaktur: noFaktur,
            kodeSupplier: kodeSupplier,
            namaSuppliers: namaSuppliers,
            kodeBarang: kodeBarang,
            namaBarang: namaBarang,
            tanggalBeli: tanggalBeli,
            expired: expired,
            kelompok: kelompok,
            satuan: satuan,
            hargaBeli: hargaBeli,
            hargaJual: hargaJual,
            jualDisc1: jualDisc1,
            jualDisc2: jualDisc2,
            jualDisc3: jualDisc3,
            jualDisc4: jualDisc4,
            ppn: ppn,
            jumlahBeli: jumlahBeli,
            totalHarga: totalHarga,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String noFaktur,
            required String kodeSupplier,
            required String namaSuppliers,
            required String kodeBarang,
            required String namaBarang,
            required DateTime tanggalBeli,
            required DateTime expired,
            required String kelompok,
            required String satuan,
            Value<int> hargaBeli = const Value.absent(),
            Value<int> hargaJual = const Value.absent(),
            Value<int?> jualDisc1 = const Value.absent(),
            Value<int?> jualDisc2 = const Value.absent(),
            Value<int?> jualDisc3 = const Value.absent(),
            Value<int?> jualDisc4 = const Value.absent(),
            Value<int?> ppn = const Value.absent(),
            Value<int?> jumlahBeli = const Value.absent(),
            Value<int?> totalHarga = const Value.absent(),
          }) =>
              PembeliansCompanion.insert(
            id: id,
            noFaktur: noFaktur,
            kodeSupplier: kodeSupplier,
            namaSuppliers: namaSuppliers,
            kodeBarang: kodeBarang,
            namaBarang: namaBarang,
            tanggalBeli: tanggalBeli,
            expired: expired,
            kelompok: kelompok,
            satuan: satuan,
            hargaBeli: hargaBeli,
            hargaJual: hargaJual,
            jualDisc1: jualDisc1,
            jualDisc2: jualDisc2,
            jualDisc3: jualDisc3,
            jualDisc4: jualDisc4,
            ppn: ppn,
            jumlahBeli: jumlahBeli,
            totalHarga: totalHarga,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$PembeliansTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $PembeliansTable,
    Pembelian,
    $$PembeliansTableFilterComposer,
    $$PembeliansTableOrderingComposer,
    $$PembeliansTableAnnotationComposer,
    $$PembeliansTableCreateCompanionBuilder,
    $$PembeliansTableUpdateCompanionBuilder,
    (Pembelian, BaseReferences<_$AppDatabase, $PembeliansTable, Pembelian>),
    Pembelian,
    PrefetchHooks Function()>;
typedef $$PembelianstmpTableCreateCompanionBuilder = PembelianstmpCompanion
    Function({
  Value<int> id,
  required String kodeBarang,
  required String namaBarang,
  required DateTime expired,
  required String kelompok,
  required String satuan,
  Value<int> hargaBeli,
  Value<int> hargaJual,
  Value<int?> jualDisc1,
  Value<int?> jualDisc2,
  Value<int?> jualDisc3,
  Value<int?> jualDisc4,
  Value<int?> ppn,
  Value<int?> jumlahBeli,
  Value<int?> totalHarga,
});
typedef $$PembelianstmpTableUpdateCompanionBuilder = PembelianstmpCompanion
    Function({
  Value<int> id,
  Value<String> kodeBarang,
  Value<String> namaBarang,
  Value<DateTime> expired,
  Value<String> kelompok,
  Value<String> satuan,
  Value<int> hargaBeli,
  Value<int> hargaJual,
  Value<int?> jualDisc1,
  Value<int?> jualDisc2,
  Value<int?> jualDisc3,
  Value<int?> jualDisc4,
  Value<int?> ppn,
  Value<int?> jumlahBeli,
  Value<int?> totalHarga,
});

class $$PembelianstmpTableFilterComposer
    extends Composer<_$AppDatabase, $PembelianstmpTable> {
  $$PembelianstmpTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get kodeBarang => $composableBuilder(
      column: $table.kodeBarang, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get namaBarang => $composableBuilder(
      column: $table.namaBarang, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get expired => $composableBuilder(
      column: $table.expired, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get kelompok => $composableBuilder(
      column: $table.kelompok, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get satuan => $composableBuilder(
      column: $table.satuan, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get hargaBeli => $composableBuilder(
      column: $table.hargaBeli, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get hargaJual => $composableBuilder(
      column: $table.hargaJual, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get jualDisc1 => $composableBuilder(
      column: $table.jualDisc1, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get jualDisc2 => $composableBuilder(
      column: $table.jualDisc2, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get jualDisc3 => $composableBuilder(
      column: $table.jualDisc3, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get jualDisc4 => $composableBuilder(
      column: $table.jualDisc4, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get ppn => $composableBuilder(
      column: $table.ppn, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get jumlahBeli => $composableBuilder(
      column: $table.jumlahBeli, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get totalHarga => $composableBuilder(
      column: $table.totalHarga, builder: (column) => ColumnFilters(column));
}

class $$PembelianstmpTableOrderingComposer
    extends Composer<_$AppDatabase, $PembelianstmpTable> {
  $$PembelianstmpTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get kodeBarang => $composableBuilder(
      column: $table.kodeBarang, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get namaBarang => $composableBuilder(
      column: $table.namaBarang, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get expired => $composableBuilder(
      column: $table.expired, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get kelompok => $composableBuilder(
      column: $table.kelompok, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get satuan => $composableBuilder(
      column: $table.satuan, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get hargaBeli => $composableBuilder(
      column: $table.hargaBeli, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get hargaJual => $composableBuilder(
      column: $table.hargaJual, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get jualDisc1 => $composableBuilder(
      column: $table.jualDisc1, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get jualDisc2 => $composableBuilder(
      column: $table.jualDisc2, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get jualDisc3 => $composableBuilder(
      column: $table.jualDisc3, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get jualDisc4 => $composableBuilder(
      column: $table.jualDisc4, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get ppn => $composableBuilder(
      column: $table.ppn, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get jumlahBeli => $composableBuilder(
      column: $table.jumlahBeli, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get totalHarga => $composableBuilder(
      column: $table.totalHarga, builder: (column) => ColumnOrderings(column));
}

class $$PembelianstmpTableAnnotationComposer
    extends Composer<_$AppDatabase, $PembelianstmpTable> {
  $$PembelianstmpTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get kodeBarang => $composableBuilder(
      column: $table.kodeBarang, builder: (column) => column);

  GeneratedColumn<String> get namaBarang => $composableBuilder(
      column: $table.namaBarang, builder: (column) => column);

  GeneratedColumn<DateTime> get expired =>
      $composableBuilder(column: $table.expired, builder: (column) => column);

  GeneratedColumn<String> get kelompok =>
      $composableBuilder(column: $table.kelompok, builder: (column) => column);

  GeneratedColumn<String> get satuan =>
      $composableBuilder(column: $table.satuan, builder: (column) => column);

  GeneratedColumn<int> get hargaBeli =>
      $composableBuilder(column: $table.hargaBeli, builder: (column) => column);

  GeneratedColumn<int> get hargaJual =>
      $composableBuilder(column: $table.hargaJual, builder: (column) => column);

  GeneratedColumn<int> get jualDisc1 =>
      $composableBuilder(column: $table.jualDisc1, builder: (column) => column);

  GeneratedColumn<int> get jualDisc2 =>
      $composableBuilder(column: $table.jualDisc2, builder: (column) => column);

  GeneratedColumn<int> get jualDisc3 =>
      $composableBuilder(column: $table.jualDisc3, builder: (column) => column);

  GeneratedColumn<int> get jualDisc4 =>
      $composableBuilder(column: $table.jualDisc4, builder: (column) => column);

  GeneratedColumn<int> get ppn =>
      $composableBuilder(column: $table.ppn, builder: (column) => column);

  GeneratedColumn<int> get jumlahBeli => $composableBuilder(
      column: $table.jumlahBeli, builder: (column) => column);

  GeneratedColumn<int> get totalHarga => $composableBuilder(
      column: $table.totalHarga, builder: (column) => column);
}

class $$PembelianstmpTableTableManager extends RootTableManager<
    _$AppDatabase,
    $PembelianstmpTable,
    PembelianstmpData,
    $$PembelianstmpTableFilterComposer,
    $$PembelianstmpTableOrderingComposer,
    $$PembelianstmpTableAnnotationComposer,
    $$PembelianstmpTableCreateCompanionBuilder,
    $$PembelianstmpTableUpdateCompanionBuilder,
    (
      PembelianstmpData,
      BaseReferences<_$AppDatabase, $PembelianstmpTable, PembelianstmpData>
    ),
    PembelianstmpData,
    PrefetchHooks Function()> {
  $$PembelianstmpTableTableManager(_$AppDatabase db, $PembelianstmpTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PembelianstmpTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PembelianstmpTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PembelianstmpTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> kodeBarang = const Value.absent(),
            Value<String> namaBarang = const Value.absent(),
            Value<DateTime> expired = const Value.absent(),
            Value<String> kelompok = const Value.absent(),
            Value<String> satuan = const Value.absent(),
            Value<int> hargaBeli = const Value.absent(),
            Value<int> hargaJual = const Value.absent(),
            Value<int?> jualDisc1 = const Value.absent(),
            Value<int?> jualDisc2 = const Value.absent(),
            Value<int?> jualDisc3 = const Value.absent(),
            Value<int?> jualDisc4 = const Value.absent(),
            Value<int?> ppn = const Value.absent(),
            Value<int?> jumlahBeli = const Value.absent(),
            Value<int?> totalHarga = const Value.absent(),
          }) =>
              PembelianstmpCompanion(
            id: id,
            kodeBarang: kodeBarang,
            namaBarang: namaBarang,
            expired: expired,
            kelompok: kelompok,
            satuan: satuan,
            hargaBeli: hargaBeli,
            hargaJual: hargaJual,
            jualDisc1: jualDisc1,
            jualDisc2: jualDisc2,
            jualDisc3: jualDisc3,
            jualDisc4: jualDisc4,
            ppn: ppn,
            jumlahBeli: jumlahBeli,
            totalHarga: totalHarga,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String kodeBarang,
            required String namaBarang,
            required DateTime expired,
            required String kelompok,
            required String satuan,
            Value<int> hargaBeli = const Value.absent(),
            Value<int> hargaJual = const Value.absent(),
            Value<int?> jualDisc1 = const Value.absent(),
            Value<int?> jualDisc2 = const Value.absent(),
            Value<int?> jualDisc3 = const Value.absent(),
            Value<int?> jualDisc4 = const Value.absent(),
            Value<int?> ppn = const Value.absent(),
            Value<int?> jumlahBeli = const Value.absent(),
            Value<int?> totalHarga = const Value.absent(),
          }) =>
              PembelianstmpCompanion.insert(
            id: id,
            kodeBarang: kodeBarang,
            namaBarang: namaBarang,
            expired: expired,
            kelompok: kelompok,
            satuan: satuan,
            hargaBeli: hargaBeli,
            hargaJual: hargaJual,
            jualDisc1: jualDisc1,
            jualDisc2: jualDisc2,
            jualDisc3: jualDisc3,
            jualDisc4: jualDisc4,
            ppn: ppn,
            jumlahBeli: jumlahBeli,
            totalHarga: totalHarga,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$PembelianstmpTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $PembelianstmpTable,
    PembelianstmpData,
    $$PembelianstmpTableFilterComposer,
    $$PembelianstmpTableOrderingComposer,
    $$PembelianstmpTableAnnotationComposer,
    $$PembelianstmpTableCreateCompanionBuilder,
    $$PembelianstmpTableUpdateCompanionBuilder,
    (
      PembelianstmpData,
      BaseReferences<_$AppDatabase, $PembelianstmpTable, PembelianstmpData>
    ),
    PembelianstmpData,
    PrefetchHooks Function()>;
typedef $$PelanggansTableCreateCompanionBuilder = PelanggansCompanion Function({
  Value<int> id,
  required String kodPelanggan,
  required String namaPelanggan,
  Value<int?> usia,
  Value<int?> telepon,
  Value<String?> alamat,
  Value<String?> kelompok,
  Value<int?> limitpiutang,
  Value<String?> keterangan,
  Value<int?> jualDiscon,
  Value<int?> totalHargaSetelahDisc,
  Value<int?> saldoPiutang,
});
typedef $$PelanggansTableUpdateCompanionBuilder = PelanggansCompanion Function({
  Value<int> id,
  Value<String> kodPelanggan,
  Value<String> namaPelanggan,
  Value<int?> usia,
  Value<int?> telepon,
  Value<String?> alamat,
  Value<String?> kelompok,
  Value<int?> limitpiutang,
  Value<String?> keterangan,
  Value<int?> jualDiscon,
  Value<int?> totalHargaSetelahDisc,
  Value<int?> saldoPiutang,
});

class $$PelanggansTableFilterComposer
    extends Composer<_$AppDatabase, $PelanggansTable> {
  $$PelanggansTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get kodPelanggan => $composableBuilder(
      column: $table.kodPelanggan, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get namaPelanggan => $composableBuilder(
      column: $table.namaPelanggan, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get usia => $composableBuilder(
      column: $table.usia, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get telepon => $composableBuilder(
      column: $table.telepon, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get alamat => $composableBuilder(
      column: $table.alamat, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get kelompok => $composableBuilder(
      column: $table.kelompok, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get limitpiutang => $composableBuilder(
      column: $table.limitpiutang, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get keterangan => $composableBuilder(
      column: $table.keterangan, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get jualDiscon => $composableBuilder(
      column: $table.jualDiscon, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get totalHargaSetelahDisc => $composableBuilder(
      column: $table.totalHargaSetelahDisc,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get saldoPiutang => $composableBuilder(
      column: $table.saldoPiutang, builder: (column) => ColumnFilters(column));
}

class $$PelanggansTableOrderingComposer
    extends Composer<_$AppDatabase, $PelanggansTable> {
  $$PelanggansTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get kodPelanggan => $composableBuilder(
      column: $table.kodPelanggan,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get namaPelanggan => $composableBuilder(
      column: $table.namaPelanggan,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get usia => $composableBuilder(
      column: $table.usia, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get telepon => $composableBuilder(
      column: $table.telepon, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get alamat => $composableBuilder(
      column: $table.alamat, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get kelompok => $composableBuilder(
      column: $table.kelompok, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get limitpiutang => $composableBuilder(
      column: $table.limitpiutang,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get keterangan => $composableBuilder(
      column: $table.keterangan, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get jualDiscon => $composableBuilder(
      column: $table.jualDiscon, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get totalHargaSetelahDisc => $composableBuilder(
      column: $table.totalHargaSetelahDisc,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get saldoPiutang => $composableBuilder(
      column: $table.saldoPiutang,
      builder: (column) => ColumnOrderings(column));
}

class $$PelanggansTableAnnotationComposer
    extends Composer<_$AppDatabase, $PelanggansTable> {
  $$PelanggansTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get kodPelanggan => $composableBuilder(
      column: $table.kodPelanggan, builder: (column) => column);

  GeneratedColumn<String> get namaPelanggan => $composableBuilder(
      column: $table.namaPelanggan, builder: (column) => column);

  GeneratedColumn<int> get usia =>
      $composableBuilder(column: $table.usia, builder: (column) => column);

  GeneratedColumn<int> get telepon =>
      $composableBuilder(column: $table.telepon, builder: (column) => column);

  GeneratedColumn<String> get alamat =>
      $composableBuilder(column: $table.alamat, builder: (column) => column);

  GeneratedColumn<String> get kelompok =>
      $composableBuilder(column: $table.kelompok, builder: (column) => column);

  GeneratedColumn<int> get limitpiutang => $composableBuilder(
      column: $table.limitpiutang, builder: (column) => column);

  GeneratedColumn<String> get keterangan => $composableBuilder(
      column: $table.keterangan, builder: (column) => column);

  GeneratedColumn<int> get jualDiscon => $composableBuilder(
      column: $table.jualDiscon, builder: (column) => column);

  GeneratedColumn<int> get totalHargaSetelahDisc => $composableBuilder(
      column: $table.totalHargaSetelahDisc, builder: (column) => column);

  GeneratedColumn<int> get saldoPiutang => $composableBuilder(
      column: $table.saldoPiutang, builder: (column) => column);
}

class $$PelanggansTableTableManager extends RootTableManager<
    _$AppDatabase,
    $PelanggansTable,
    Pelanggan,
    $$PelanggansTableFilterComposer,
    $$PelanggansTableOrderingComposer,
    $$PelanggansTableAnnotationComposer,
    $$PelanggansTableCreateCompanionBuilder,
    $$PelanggansTableUpdateCompanionBuilder,
    (Pelanggan, BaseReferences<_$AppDatabase, $PelanggansTable, Pelanggan>),
    Pelanggan,
    PrefetchHooks Function()> {
  $$PelanggansTableTableManager(_$AppDatabase db, $PelanggansTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PelanggansTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PelanggansTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PelanggansTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> kodPelanggan = const Value.absent(),
            Value<String> namaPelanggan = const Value.absent(),
            Value<int?> usia = const Value.absent(),
            Value<int?> telepon = const Value.absent(),
            Value<String?> alamat = const Value.absent(),
            Value<String?> kelompok = const Value.absent(),
            Value<int?> limitpiutang = const Value.absent(),
            Value<String?> keterangan = const Value.absent(),
            Value<int?> jualDiscon = const Value.absent(),
            Value<int?> totalHargaSetelahDisc = const Value.absent(),
            Value<int?> saldoPiutang = const Value.absent(),
          }) =>
              PelanggansCompanion(
            id: id,
            kodPelanggan: kodPelanggan,
            namaPelanggan: namaPelanggan,
            usia: usia,
            telepon: telepon,
            alamat: alamat,
            kelompok: kelompok,
            limitpiutang: limitpiutang,
            keterangan: keterangan,
            jualDiscon: jualDiscon,
            totalHargaSetelahDisc: totalHargaSetelahDisc,
            saldoPiutang: saldoPiutang,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String kodPelanggan,
            required String namaPelanggan,
            Value<int?> usia = const Value.absent(),
            Value<int?> telepon = const Value.absent(),
            Value<String?> alamat = const Value.absent(),
            Value<String?> kelompok = const Value.absent(),
            Value<int?> limitpiutang = const Value.absent(),
            Value<String?> keterangan = const Value.absent(),
            Value<int?> jualDiscon = const Value.absent(),
            Value<int?> totalHargaSetelahDisc = const Value.absent(),
            Value<int?> saldoPiutang = const Value.absent(),
          }) =>
              PelanggansCompanion.insert(
            id: id,
            kodPelanggan: kodPelanggan,
            namaPelanggan: namaPelanggan,
            usia: usia,
            telepon: telepon,
            alamat: alamat,
            kelompok: kelompok,
            limitpiutang: limitpiutang,
            keterangan: keterangan,
            jualDiscon: jualDiscon,
            totalHargaSetelahDisc: totalHargaSetelahDisc,
            saldoPiutang: saldoPiutang,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$PelanggansTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $PelanggansTable,
    Pelanggan,
    $$PelanggansTableFilterComposer,
    $$PelanggansTableOrderingComposer,
    $$PelanggansTableAnnotationComposer,
    $$PelanggansTableCreateCompanionBuilder,
    $$PelanggansTableUpdateCompanionBuilder,
    (Pelanggan, BaseReferences<_$AppDatabase, $PelanggansTable, Pelanggan>),
    Pelanggan,
    PrefetchHooks Function()>;
typedef $$ResepsTableCreateCompanionBuilder = ResepsCompanion Function({
  Value<int> id,
  required String noResep,
  required DateTime tanggal,
  required String kodePelanggan,
  required String namaPelanggan,
  Value<String?> kelompokPelanggan,
  Value<String?> kodeDoctor,
  required String namaDoctor,
  Value<int?> usia,
  Value<String?> alamat,
  Value<String?> keterangan,
  Value<String?> noTelp,
  required String kodeBarang,
  required String namaBarang,
  required String kelompok,
  required String satuan,
  Value<int> hargaBeli,
  Value<int> hargaJual,
  Value<int?> jualDiscon,
  Value<int?> jumlahJual,
  Value<int?> totalHargaSebelumDisc,
  Value<int?> totalHargaSetelahDisc,
  Value<int?> totalDisc,
});
typedef $$ResepsTableUpdateCompanionBuilder = ResepsCompanion Function({
  Value<int> id,
  Value<String> noResep,
  Value<DateTime> tanggal,
  Value<String> kodePelanggan,
  Value<String> namaPelanggan,
  Value<String?> kelompokPelanggan,
  Value<String?> kodeDoctor,
  Value<String> namaDoctor,
  Value<int?> usia,
  Value<String?> alamat,
  Value<String?> keterangan,
  Value<String?> noTelp,
  Value<String> kodeBarang,
  Value<String> namaBarang,
  Value<String> kelompok,
  Value<String> satuan,
  Value<int> hargaBeli,
  Value<int> hargaJual,
  Value<int?> jualDiscon,
  Value<int?> jumlahJual,
  Value<int?> totalHargaSebelumDisc,
  Value<int?> totalHargaSetelahDisc,
  Value<int?> totalDisc,
});

class $$ResepsTableFilterComposer
    extends Composer<_$AppDatabase, $ResepsTable> {
  $$ResepsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get noResep => $composableBuilder(
      column: $table.noResep, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get tanggal => $composableBuilder(
      column: $table.tanggal, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get kodePelanggan => $composableBuilder(
      column: $table.kodePelanggan, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get namaPelanggan => $composableBuilder(
      column: $table.namaPelanggan, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get kelompokPelanggan => $composableBuilder(
      column: $table.kelompokPelanggan,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get kodeDoctor => $composableBuilder(
      column: $table.kodeDoctor, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get namaDoctor => $composableBuilder(
      column: $table.namaDoctor, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get usia => $composableBuilder(
      column: $table.usia, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get alamat => $composableBuilder(
      column: $table.alamat, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get keterangan => $composableBuilder(
      column: $table.keterangan, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get noTelp => $composableBuilder(
      column: $table.noTelp, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get kodeBarang => $composableBuilder(
      column: $table.kodeBarang, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get namaBarang => $composableBuilder(
      column: $table.namaBarang, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get kelompok => $composableBuilder(
      column: $table.kelompok, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get satuan => $composableBuilder(
      column: $table.satuan, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get hargaBeli => $composableBuilder(
      column: $table.hargaBeli, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get hargaJual => $composableBuilder(
      column: $table.hargaJual, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get jualDiscon => $composableBuilder(
      column: $table.jualDiscon, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get jumlahJual => $composableBuilder(
      column: $table.jumlahJual, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get totalHargaSebelumDisc => $composableBuilder(
      column: $table.totalHargaSebelumDisc,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get totalHargaSetelahDisc => $composableBuilder(
      column: $table.totalHargaSetelahDisc,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get totalDisc => $composableBuilder(
      column: $table.totalDisc, builder: (column) => ColumnFilters(column));
}

class $$ResepsTableOrderingComposer
    extends Composer<_$AppDatabase, $ResepsTable> {
  $$ResepsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get noResep => $composableBuilder(
      column: $table.noResep, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get tanggal => $composableBuilder(
      column: $table.tanggal, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get kodePelanggan => $composableBuilder(
      column: $table.kodePelanggan,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get namaPelanggan => $composableBuilder(
      column: $table.namaPelanggan,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get kelompokPelanggan => $composableBuilder(
      column: $table.kelompokPelanggan,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get kodeDoctor => $composableBuilder(
      column: $table.kodeDoctor, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get namaDoctor => $composableBuilder(
      column: $table.namaDoctor, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get usia => $composableBuilder(
      column: $table.usia, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get alamat => $composableBuilder(
      column: $table.alamat, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get keterangan => $composableBuilder(
      column: $table.keterangan, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get noTelp => $composableBuilder(
      column: $table.noTelp, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get kodeBarang => $composableBuilder(
      column: $table.kodeBarang, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get namaBarang => $composableBuilder(
      column: $table.namaBarang, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get kelompok => $composableBuilder(
      column: $table.kelompok, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get satuan => $composableBuilder(
      column: $table.satuan, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get hargaBeli => $composableBuilder(
      column: $table.hargaBeli, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get hargaJual => $composableBuilder(
      column: $table.hargaJual, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get jualDiscon => $composableBuilder(
      column: $table.jualDiscon, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get jumlahJual => $composableBuilder(
      column: $table.jumlahJual, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get totalHargaSebelumDisc => $composableBuilder(
      column: $table.totalHargaSebelumDisc,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get totalHargaSetelahDisc => $composableBuilder(
      column: $table.totalHargaSetelahDisc,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get totalDisc => $composableBuilder(
      column: $table.totalDisc, builder: (column) => ColumnOrderings(column));
}

class $$ResepsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ResepsTable> {
  $$ResepsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get noResep =>
      $composableBuilder(column: $table.noResep, builder: (column) => column);

  GeneratedColumn<DateTime> get tanggal =>
      $composableBuilder(column: $table.tanggal, builder: (column) => column);

  GeneratedColumn<String> get kodePelanggan => $composableBuilder(
      column: $table.kodePelanggan, builder: (column) => column);

  GeneratedColumn<String> get namaPelanggan => $composableBuilder(
      column: $table.namaPelanggan, builder: (column) => column);

  GeneratedColumn<String> get kelompokPelanggan => $composableBuilder(
      column: $table.kelompokPelanggan, builder: (column) => column);

  GeneratedColumn<String> get kodeDoctor => $composableBuilder(
      column: $table.kodeDoctor, builder: (column) => column);

  GeneratedColumn<String> get namaDoctor => $composableBuilder(
      column: $table.namaDoctor, builder: (column) => column);

  GeneratedColumn<int> get usia =>
      $composableBuilder(column: $table.usia, builder: (column) => column);

  GeneratedColumn<String> get alamat =>
      $composableBuilder(column: $table.alamat, builder: (column) => column);

  GeneratedColumn<String> get keterangan => $composableBuilder(
      column: $table.keterangan, builder: (column) => column);

  GeneratedColumn<String> get noTelp =>
      $composableBuilder(column: $table.noTelp, builder: (column) => column);

  GeneratedColumn<String> get kodeBarang => $composableBuilder(
      column: $table.kodeBarang, builder: (column) => column);

  GeneratedColumn<String> get namaBarang => $composableBuilder(
      column: $table.namaBarang, builder: (column) => column);

  GeneratedColumn<String> get kelompok =>
      $composableBuilder(column: $table.kelompok, builder: (column) => column);

  GeneratedColumn<String> get satuan =>
      $composableBuilder(column: $table.satuan, builder: (column) => column);

  GeneratedColumn<int> get hargaBeli =>
      $composableBuilder(column: $table.hargaBeli, builder: (column) => column);

  GeneratedColumn<int> get hargaJual =>
      $composableBuilder(column: $table.hargaJual, builder: (column) => column);

  GeneratedColumn<int> get jualDiscon => $composableBuilder(
      column: $table.jualDiscon, builder: (column) => column);

  GeneratedColumn<int> get jumlahJual => $composableBuilder(
      column: $table.jumlahJual, builder: (column) => column);

  GeneratedColumn<int> get totalHargaSebelumDisc => $composableBuilder(
      column: $table.totalHargaSebelumDisc, builder: (column) => column);

  GeneratedColumn<int> get totalHargaSetelahDisc => $composableBuilder(
      column: $table.totalHargaSetelahDisc, builder: (column) => column);

  GeneratedColumn<int> get totalDisc =>
      $composableBuilder(column: $table.totalDisc, builder: (column) => column);
}

class $$ResepsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ResepsTable,
    Resep,
    $$ResepsTableFilterComposer,
    $$ResepsTableOrderingComposer,
    $$ResepsTableAnnotationComposer,
    $$ResepsTableCreateCompanionBuilder,
    $$ResepsTableUpdateCompanionBuilder,
    (Resep, BaseReferences<_$AppDatabase, $ResepsTable, Resep>),
    Resep,
    PrefetchHooks Function()> {
  $$ResepsTableTableManager(_$AppDatabase db, $ResepsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ResepsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ResepsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ResepsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> noResep = const Value.absent(),
            Value<DateTime> tanggal = const Value.absent(),
            Value<String> kodePelanggan = const Value.absent(),
            Value<String> namaPelanggan = const Value.absent(),
            Value<String?> kelompokPelanggan = const Value.absent(),
            Value<String?> kodeDoctor = const Value.absent(),
            Value<String> namaDoctor = const Value.absent(),
            Value<int?> usia = const Value.absent(),
            Value<String?> alamat = const Value.absent(),
            Value<String?> keterangan = const Value.absent(),
            Value<String?> noTelp = const Value.absent(),
            Value<String> kodeBarang = const Value.absent(),
            Value<String> namaBarang = const Value.absent(),
            Value<String> kelompok = const Value.absent(),
            Value<String> satuan = const Value.absent(),
            Value<int> hargaBeli = const Value.absent(),
            Value<int> hargaJual = const Value.absent(),
            Value<int?> jualDiscon = const Value.absent(),
            Value<int?> jumlahJual = const Value.absent(),
            Value<int?> totalHargaSebelumDisc = const Value.absent(),
            Value<int?> totalHargaSetelahDisc = const Value.absent(),
            Value<int?> totalDisc = const Value.absent(),
          }) =>
              ResepsCompanion(
            id: id,
            noResep: noResep,
            tanggal: tanggal,
            kodePelanggan: kodePelanggan,
            namaPelanggan: namaPelanggan,
            kelompokPelanggan: kelompokPelanggan,
            kodeDoctor: kodeDoctor,
            namaDoctor: namaDoctor,
            usia: usia,
            alamat: alamat,
            keterangan: keterangan,
            noTelp: noTelp,
            kodeBarang: kodeBarang,
            namaBarang: namaBarang,
            kelompok: kelompok,
            satuan: satuan,
            hargaBeli: hargaBeli,
            hargaJual: hargaJual,
            jualDiscon: jualDiscon,
            jumlahJual: jumlahJual,
            totalHargaSebelumDisc: totalHargaSebelumDisc,
            totalHargaSetelahDisc: totalHargaSetelahDisc,
            totalDisc: totalDisc,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String noResep,
            required DateTime tanggal,
            required String kodePelanggan,
            required String namaPelanggan,
            Value<String?> kelompokPelanggan = const Value.absent(),
            Value<String?> kodeDoctor = const Value.absent(),
            required String namaDoctor,
            Value<int?> usia = const Value.absent(),
            Value<String?> alamat = const Value.absent(),
            Value<String?> keterangan = const Value.absent(),
            Value<String?> noTelp = const Value.absent(),
            required String kodeBarang,
            required String namaBarang,
            required String kelompok,
            required String satuan,
            Value<int> hargaBeli = const Value.absent(),
            Value<int> hargaJual = const Value.absent(),
            Value<int?> jualDiscon = const Value.absent(),
            Value<int?> jumlahJual = const Value.absent(),
            Value<int?> totalHargaSebelumDisc = const Value.absent(),
            Value<int?> totalHargaSetelahDisc = const Value.absent(),
            Value<int?> totalDisc = const Value.absent(),
          }) =>
              ResepsCompanion.insert(
            id: id,
            noResep: noResep,
            tanggal: tanggal,
            kodePelanggan: kodePelanggan,
            namaPelanggan: namaPelanggan,
            kelompokPelanggan: kelompokPelanggan,
            kodeDoctor: kodeDoctor,
            namaDoctor: namaDoctor,
            usia: usia,
            alamat: alamat,
            keterangan: keterangan,
            noTelp: noTelp,
            kodeBarang: kodeBarang,
            namaBarang: namaBarang,
            kelompok: kelompok,
            satuan: satuan,
            hargaBeli: hargaBeli,
            hargaJual: hargaJual,
            jualDiscon: jualDiscon,
            jumlahJual: jumlahJual,
            totalHargaSebelumDisc: totalHargaSebelumDisc,
            totalHargaSetelahDisc: totalHargaSetelahDisc,
            totalDisc: totalDisc,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ResepsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ResepsTable,
    Resep,
    $$ResepsTableFilterComposer,
    $$ResepsTableOrderingComposer,
    $$ResepsTableAnnotationComposer,
    $$ResepsTableCreateCompanionBuilder,
    $$ResepsTableUpdateCompanionBuilder,
    (Resep, BaseReferences<_$AppDatabase, $ResepsTable, Resep>),
    Resep,
    PrefetchHooks Function()>;
typedef $$ResepstmpTableCreateCompanionBuilder = ResepstmpCompanion Function({
  Value<int> id,
  required String kodeBarang,
  required String namaBarang,
  required String kelompok,
  required String satuan,
  Value<int> hargaBeli,
  Value<int> hargaJual,
  Value<int?> jualDiscon,
  Value<int?> jumlahJual,
  Value<int?> totalHargaSebelumDisc,
  Value<int?> totalHargaSetelahDisc,
  Value<int?> totalDisc,
});
typedef $$ResepstmpTableUpdateCompanionBuilder = ResepstmpCompanion Function({
  Value<int> id,
  Value<String> kodeBarang,
  Value<String> namaBarang,
  Value<String> kelompok,
  Value<String> satuan,
  Value<int> hargaBeli,
  Value<int> hargaJual,
  Value<int?> jualDiscon,
  Value<int?> jumlahJual,
  Value<int?> totalHargaSebelumDisc,
  Value<int?> totalHargaSetelahDisc,
  Value<int?> totalDisc,
});

class $$ResepstmpTableFilterComposer
    extends Composer<_$AppDatabase, $ResepstmpTable> {
  $$ResepstmpTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get kodeBarang => $composableBuilder(
      column: $table.kodeBarang, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get namaBarang => $composableBuilder(
      column: $table.namaBarang, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get kelompok => $composableBuilder(
      column: $table.kelompok, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get satuan => $composableBuilder(
      column: $table.satuan, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get hargaBeli => $composableBuilder(
      column: $table.hargaBeli, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get hargaJual => $composableBuilder(
      column: $table.hargaJual, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get jualDiscon => $composableBuilder(
      column: $table.jualDiscon, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get jumlahJual => $composableBuilder(
      column: $table.jumlahJual, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get totalHargaSebelumDisc => $composableBuilder(
      column: $table.totalHargaSebelumDisc,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get totalHargaSetelahDisc => $composableBuilder(
      column: $table.totalHargaSetelahDisc,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get totalDisc => $composableBuilder(
      column: $table.totalDisc, builder: (column) => ColumnFilters(column));
}

class $$ResepstmpTableOrderingComposer
    extends Composer<_$AppDatabase, $ResepstmpTable> {
  $$ResepstmpTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get kodeBarang => $composableBuilder(
      column: $table.kodeBarang, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get namaBarang => $composableBuilder(
      column: $table.namaBarang, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get kelompok => $composableBuilder(
      column: $table.kelompok, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get satuan => $composableBuilder(
      column: $table.satuan, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get hargaBeli => $composableBuilder(
      column: $table.hargaBeli, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get hargaJual => $composableBuilder(
      column: $table.hargaJual, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get jualDiscon => $composableBuilder(
      column: $table.jualDiscon, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get jumlahJual => $composableBuilder(
      column: $table.jumlahJual, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get totalHargaSebelumDisc => $composableBuilder(
      column: $table.totalHargaSebelumDisc,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get totalHargaSetelahDisc => $composableBuilder(
      column: $table.totalHargaSetelahDisc,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get totalDisc => $composableBuilder(
      column: $table.totalDisc, builder: (column) => ColumnOrderings(column));
}

class $$ResepstmpTableAnnotationComposer
    extends Composer<_$AppDatabase, $ResepstmpTable> {
  $$ResepstmpTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get kodeBarang => $composableBuilder(
      column: $table.kodeBarang, builder: (column) => column);

  GeneratedColumn<String> get namaBarang => $composableBuilder(
      column: $table.namaBarang, builder: (column) => column);

  GeneratedColumn<String> get kelompok =>
      $composableBuilder(column: $table.kelompok, builder: (column) => column);

  GeneratedColumn<String> get satuan =>
      $composableBuilder(column: $table.satuan, builder: (column) => column);

  GeneratedColumn<int> get hargaBeli =>
      $composableBuilder(column: $table.hargaBeli, builder: (column) => column);

  GeneratedColumn<int> get hargaJual =>
      $composableBuilder(column: $table.hargaJual, builder: (column) => column);

  GeneratedColumn<int> get jualDiscon => $composableBuilder(
      column: $table.jualDiscon, builder: (column) => column);

  GeneratedColumn<int> get jumlahJual => $composableBuilder(
      column: $table.jumlahJual, builder: (column) => column);

  GeneratedColumn<int> get totalHargaSebelumDisc => $composableBuilder(
      column: $table.totalHargaSebelumDisc, builder: (column) => column);

  GeneratedColumn<int> get totalHargaSetelahDisc => $composableBuilder(
      column: $table.totalHargaSetelahDisc, builder: (column) => column);

  GeneratedColumn<int> get totalDisc =>
      $composableBuilder(column: $table.totalDisc, builder: (column) => column);
}

class $$ResepstmpTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ResepstmpTable,
    ResepstmpData,
    $$ResepstmpTableFilterComposer,
    $$ResepstmpTableOrderingComposer,
    $$ResepstmpTableAnnotationComposer,
    $$ResepstmpTableCreateCompanionBuilder,
    $$ResepstmpTableUpdateCompanionBuilder,
    (
      ResepstmpData,
      BaseReferences<_$AppDatabase, $ResepstmpTable, ResepstmpData>
    ),
    ResepstmpData,
    PrefetchHooks Function()> {
  $$ResepstmpTableTableManager(_$AppDatabase db, $ResepstmpTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ResepstmpTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ResepstmpTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ResepstmpTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> kodeBarang = const Value.absent(),
            Value<String> namaBarang = const Value.absent(),
            Value<String> kelompok = const Value.absent(),
            Value<String> satuan = const Value.absent(),
            Value<int> hargaBeli = const Value.absent(),
            Value<int> hargaJual = const Value.absent(),
            Value<int?> jualDiscon = const Value.absent(),
            Value<int?> jumlahJual = const Value.absent(),
            Value<int?> totalHargaSebelumDisc = const Value.absent(),
            Value<int?> totalHargaSetelahDisc = const Value.absent(),
            Value<int?> totalDisc = const Value.absent(),
          }) =>
              ResepstmpCompanion(
            id: id,
            kodeBarang: kodeBarang,
            namaBarang: namaBarang,
            kelompok: kelompok,
            satuan: satuan,
            hargaBeli: hargaBeli,
            hargaJual: hargaJual,
            jualDiscon: jualDiscon,
            jumlahJual: jumlahJual,
            totalHargaSebelumDisc: totalHargaSebelumDisc,
            totalHargaSetelahDisc: totalHargaSetelahDisc,
            totalDisc: totalDisc,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String kodeBarang,
            required String namaBarang,
            required String kelompok,
            required String satuan,
            Value<int> hargaBeli = const Value.absent(),
            Value<int> hargaJual = const Value.absent(),
            Value<int?> jualDiscon = const Value.absent(),
            Value<int?> jumlahJual = const Value.absent(),
            Value<int?> totalHargaSebelumDisc = const Value.absent(),
            Value<int?> totalHargaSetelahDisc = const Value.absent(),
            Value<int?> totalDisc = const Value.absent(),
          }) =>
              ResepstmpCompanion.insert(
            id: id,
            kodeBarang: kodeBarang,
            namaBarang: namaBarang,
            kelompok: kelompok,
            satuan: satuan,
            hargaBeli: hargaBeli,
            hargaJual: hargaJual,
            jualDiscon: jualDiscon,
            jumlahJual: jumlahJual,
            totalHargaSebelumDisc: totalHargaSebelumDisc,
            totalHargaSetelahDisc: totalHargaSetelahDisc,
            totalDisc: totalDisc,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ResepstmpTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ResepstmpTable,
    ResepstmpData,
    $$ResepstmpTableFilterComposer,
    $$ResepstmpTableOrderingComposer,
    $$ResepstmpTableAnnotationComposer,
    $$ResepstmpTableCreateCompanionBuilder,
    $$ResepstmpTableUpdateCompanionBuilder,
    (
      ResepstmpData,
      BaseReferences<_$AppDatabase, $ResepstmpTable, ResepstmpData>
    ),
    ResepstmpData,
    PrefetchHooks Function()>;
typedef $$RaksTableCreateCompanionBuilder = RaksCompanion Function({
  Value<int> id,
  required String kodeRak,
  required String namaRak,
  required String lokasi,
  Value<String?> keterangan,
});
typedef $$RaksTableUpdateCompanionBuilder = RaksCompanion Function({
  Value<int> id,
  Value<String> kodeRak,
  Value<String> namaRak,
  Value<String> lokasi,
  Value<String?> keterangan,
});

class $$RaksTableFilterComposer extends Composer<_$AppDatabase, $RaksTable> {
  $$RaksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get kodeRak => $composableBuilder(
      column: $table.kodeRak, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get namaRak => $composableBuilder(
      column: $table.namaRak, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get lokasi => $composableBuilder(
      column: $table.lokasi, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get keterangan => $composableBuilder(
      column: $table.keterangan, builder: (column) => ColumnFilters(column));
}

class $$RaksTableOrderingComposer extends Composer<_$AppDatabase, $RaksTable> {
  $$RaksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get kodeRak => $composableBuilder(
      column: $table.kodeRak, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get namaRak => $composableBuilder(
      column: $table.namaRak, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get lokasi => $composableBuilder(
      column: $table.lokasi, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get keterangan => $composableBuilder(
      column: $table.keterangan, builder: (column) => ColumnOrderings(column));
}

class $$RaksTableAnnotationComposer
    extends Composer<_$AppDatabase, $RaksTable> {
  $$RaksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get kodeRak =>
      $composableBuilder(column: $table.kodeRak, builder: (column) => column);

  GeneratedColumn<String> get namaRak =>
      $composableBuilder(column: $table.namaRak, builder: (column) => column);

  GeneratedColumn<String> get lokasi =>
      $composableBuilder(column: $table.lokasi, builder: (column) => column);

  GeneratedColumn<String> get keterangan => $composableBuilder(
      column: $table.keterangan, builder: (column) => column);
}

class $$RaksTableTableManager extends RootTableManager<
    _$AppDatabase,
    $RaksTable,
    Rak,
    $$RaksTableFilterComposer,
    $$RaksTableOrderingComposer,
    $$RaksTableAnnotationComposer,
    $$RaksTableCreateCompanionBuilder,
    $$RaksTableUpdateCompanionBuilder,
    (Rak, BaseReferences<_$AppDatabase, $RaksTable, Rak>),
    Rak,
    PrefetchHooks Function()> {
  $$RaksTableTableManager(_$AppDatabase db, $RaksTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RaksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RaksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RaksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> kodeRak = const Value.absent(),
            Value<String> namaRak = const Value.absent(),
            Value<String> lokasi = const Value.absent(),
            Value<String?> keterangan = const Value.absent(),
          }) =>
              RaksCompanion(
            id: id,
            kodeRak: kodeRak,
            namaRak: namaRak,
            lokasi: lokasi,
            keterangan: keterangan,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String kodeRak,
            required String namaRak,
            required String lokasi,
            Value<String?> keterangan = const Value.absent(),
          }) =>
              RaksCompanion.insert(
            id: id,
            kodeRak: kodeRak,
            namaRak: namaRak,
            lokasi: lokasi,
            keterangan: keterangan,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$RaksTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $RaksTable,
    Rak,
    $$RaksTableFilterComposer,
    $$RaksTableOrderingComposer,
    $$RaksTableAnnotationComposer,
    $$RaksTableCreateCompanionBuilder,
    $$RaksTableUpdateCompanionBuilder,
    (Rak, BaseReferences<_$AppDatabase, $RaksTable, Rak>),
    Rak,
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
  $$BarangsTableTableManager get barangs =>
      $$BarangsTableTableManager(_db, _db.barangs);
  $$PenjualansTableTableManager get penjualans =>
      $$PenjualansTableTableManager(_db, _db.penjualans);
  $$PenjualanstmpTableTableManager get penjualanstmp =>
      $$PenjualanstmpTableTableManager(_db, _db.penjualanstmp);
  $$PembeliansTableTableManager get pembelians =>
      $$PembeliansTableTableManager(_db, _db.pembelians);
  $$PembelianstmpTableTableManager get pembelianstmp =>
      $$PembelianstmpTableTableManager(_db, _db.pembelianstmp);
  $$PelanggansTableTableManager get pelanggans =>
      $$PelanggansTableTableManager(_db, _db.pelanggans);
  $$ResepsTableTableManager get reseps =>
      $$ResepsTableTableManager(_db, _db.reseps);
  $$ResepstmpTableTableManager get resepstmp =>
      $$ResepstmpTableTableManager(_db, _db.resepstmp);
  $$RaksTableTableManager get raks => $$RaksTableTableManager(_db, _db.raks);
}
