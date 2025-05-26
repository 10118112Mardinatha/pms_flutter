class PembelianTmpModel {
  final int id;
  final String username;
  final String kodeBarang;
  final String namaBarang;
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
  final String? keterangan;

  PembelianTmpModel({
    required this.id,
    required this.username,
    required this.kodeBarang,
    required this.namaBarang,
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
    this.keterangan,
  });

  factory PembelianTmpModel.fromJson(Map<String, dynamic> json) {
    return PembelianTmpModel(
      id: json['id'],
      username: json['username'],
      kodeBarang: json['kodeBarang'],
      namaBarang: json['namaBarang'],
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
      keterangan: json['keterangan'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'username': username,
        'kodeBarang': kodeBarang,
        'namaBarang': namaBarang,
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
        'keterangan': keterangan,
      };
}
