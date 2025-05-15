class PembelianModel {
  final int id;
  final String noFaktur;
  final String kodeSupplier;
  final String namaSuppliers;
  final String kodeBarang;
  final String namaBarang;
  final DateTime tanggalBeli;
  final String kelompok;
  final String satuan;
  final int hargaBeli;
  final int hargaJual;
  final int? jualDisc1;
  final int? jualDisc2;
  final int? jualDisc3;
  final int? jualDisc4;
  final int? jumlahBeli;
  final int? totalHarga;

  PembelianModel({
    required this.id,
    required this.noFaktur,
    required this.kodeSupplier,
    required this.namaSuppliers,
    required this.kodeBarang,
    required this.namaBarang,
    required this.tanggalBeli,
    required this.kelompok,
    required this.satuan,
    this.hargaBeli = 0,
    this.hargaJual = 0,
    this.jualDisc1,
    this.jualDisc2,
    this.jualDisc3,
    this.jualDisc4,
    this.jumlahBeli,
    this.totalHarga,
  });

  factory PembelianModel.fromJson(Map<String, dynamic> json) {
    return PembelianModel(
      id: json['id'],
      noFaktur: json['noFaktur'],
      kodeSupplier: json['kodeSupplier'],
      namaSuppliers: json['namaSuppliers'],
      kodeBarang: json['kodeBarang'],
      namaBarang: json['namaBarang'],
      tanggalBeli: json['tanggalBeli'] is String
          ? DateTime.parse(json['tanggalBeli'])
          : DateTime.fromMillisecondsSinceEpoch(json['tanggalBeli']),
      kelompok: json['kelompok'],
      satuan: json['satuan'],
      hargaBeli: json['hargaBeli'],
      hargaJual: json['hargaJual'],
      jualDisc1: json['jualDisc1'],
      jualDisc2: json['jualDisc2'],
      jualDisc3: json['jualDisc3'],
      jualDisc4: json['jualDisc4'],
      jumlahBeli: json['jumlahBeli'],
      totalHarga: json['totalHarga'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'noFaktur': noFaktur,
        'kodeSupplier': kodeSupplier,
        'namaSuppliers': namaSuppliers,
        'kodeBarang': kodeBarang,
        'namaBarang': namaBarang,
        'tanggalBeli': tanggalBeli.toIso8601String(),
        'kelompok': kelompok,
        'satuan': satuan,
        'hargaBeli': hargaBeli,
        'hargaJual': hargaJual,
        'jualDisc1': jualDisc1,
        'jualDisc2': jualDisc2,
        'jualDisc3': jualDisc3,
        'jualDisc4': jualDisc4,
        'jumlahBeli': jumlahBeli,
        'totalHarga': totalHarga,
      };
}
