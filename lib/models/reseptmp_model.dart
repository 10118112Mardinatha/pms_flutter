class ResepTmpModel {
  final int id;
  final String username;
  final String kodeBarang;
  final String namaBarang;
  final String kelompok;
  final String satuan;
  final int hargaBeli;
  final int hargaJual;
  final int? jumlahJual;
  final int? jualDiscon;
  final int? totalHargaSebelumDisc;
  final int? totalHargaSetelahDisc;
  final int? totalDisc;

  ResepTmpModel(
      {required this.id,
      required this.username,
      required this.kodeBarang,
      required this.namaBarang,
      required this.kelompok,
      required this.satuan,
      this.hargaBeli = 0,
      this.hargaJual = 0,
      this.jumlahJual,
      this.jualDiscon,
      this.totalHargaSebelumDisc,
      this.totalHargaSetelahDisc,
      this.totalDisc});

  factory ResepTmpModel.fromJson(Map<String, dynamic> json) {
    return ResepTmpModel(
      id: json['id'],
      username: json['username'],
      kodeBarang: json['kodeBarang'],
      namaBarang: json['namaBarang'],
      kelompok: json['kelompok'],
      satuan: json['satuan'],
      hargaBeli: json['hargaBeli'],
      hargaJual: json['hargaJual'],
      jualDiscon: json['jualDiscon'],
      jumlahJual: json['jumlahJual'],
      totalHargaSebelumDisc: json['totalHargaSebelumDisc'],
      totalHargaSetelahDisc: json['totalHargaSetelahDisc'],
      totalDisc: json['totalDisc'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'noTelp': username,
        'kodeBarang': kodeBarang,
        'namaBarang': namaBarang,
        'kelompok': kelompok,
        'satuan': satuan,
        'hargaBeli': hargaBeli,
        'hargaJual': hargaJual,
        'jualDiscon': jualDiscon,
        'jumlahJual': jumlahJual,
        'totalHargaSebelumDisc': totalHargaSebelumDisc,
        'totalHargaSetelahDisc': totalHargaSetelahDisc,
        'totalDisc': totalDisc,
      };
}
