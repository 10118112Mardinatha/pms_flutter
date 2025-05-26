class BarangModel {
  final int id;
  final String kodeBarang;
  final String? namaBarang;
  final String? kelompok;
  final String? satuan;
  final String? noRak;
  final int stokAktual;
  final int hargaBeli;
  final int hargaJual;
  final int? jualDisc1;
  final int? jualDisc2;
  final int? jualDisc3;
  final int? jualDisc4;
  final String? keterangan;

  BarangModel({
    required this.id,
    required this.kodeBarang,
    this.namaBarang,
    this.kelompok,
    this.satuan,
    this.noRak,
    this.stokAktual = 0,
    this.hargaBeli = 0,
    this.hargaJual = 0,
    this.jualDisc1,
    this.jualDisc2,
    this.jualDisc3,
    this.jualDisc4,
    this.keterangan,
  });

  factory BarangModel.fromJson(Map<String, dynamic> json) {
    return BarangModel(
      id: json['id'],
      kodeBarang: json['kodeBarang'],
      namaBarang: json['namaBarang'] ?? '',
      kelompok: json['kelompok'],
      satuan: json['satuan'],
      noRak: json['noRak'],
      stokAktual: json['stokAktual'] is int
          ? json['stokAktual']
          : int.tryParse(json['stokAktual']?.toString() ?? '0'),
      hargaBeli: json['hargaBeli'] is int
          ? json['hargaBeli']
          : int.tryParse(json['hargaBeli']?.toString() ?? '0'),
      hargaJual: json['hargaJual'] is int
          ? json['hargaJual']
          : int.tryParse(json['hargaJual']?.toString() ?? '0'),
      jualDisc1: json['jualDisc1'] is int
          ? json['jualDisc1']
          : int.tryParse(json['jualDisc1']?.toString() ?? '0'),
      jualDisc2: json['jualDisc2'] is int
          ? json['jualDisc2']
          : int.tryParse(json['jualDisc2']?.toString() ?? '0'),
      jualDisc3: json['jualDisc3'] is int
          ? json['jualDisc3']
          : int.tryParse(json['jualDisc3']?.toString() ?? '0'),
      jualDisc4: json['jualDisc4'] is int
          ? json['jualDisc4']
          : int.tryParse(json['jualDisc4']?.toString() ?? '0'),
      keterangan: json['keterangan'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'kodeBarang': kodeBarang,
      'namaBarang': namaBarang,
      'kelompok': kelompok,
      'satuan': satuan,
      'noRak': noRak,
      'stokAktual': stokAktual,
      'hargaBeli': hargaBeli,
      'hargaJual': hargaJual,
      'jualDisc1': jualDisc1,
      'jualDisc2': jualDisc2,
      'jualDisc3': jualDisc3,
      'jualDisc4': jualDisc4,
      'keterangan': keterangan,
    };
  }
}
