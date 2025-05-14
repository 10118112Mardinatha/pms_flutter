class PenjualanTmpModel {
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

  PenjualanTmpModel({
    required this.id,
    required this.kodeBarang,
    required this.namaBarang,
    required this.kelompok,
    required this.satuan,
    this.hargaBeli = 0,
    this.hargaJual = 0,
    this.jualDiscon,
    this.jumlahJual,
    this.totalHargaSebelumDisc,
    this.totalHargaSetelahDisc,
    this.totalDisc,
  });

  factory PenjualanTmpModel.fromJson(Map<String, dynamic> json) {
    return PenjualanTmpModel(
      id: json['id'],
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
