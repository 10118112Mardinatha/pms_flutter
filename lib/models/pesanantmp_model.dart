class PesananTmpModel {
  final int id;
  final String username;
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
  final String? status;

  PesananTmpModel({
    required this.id,
    required this.username,
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
    this.status,
  });

  factory PesananTmpModel.fromJson(Map<String, dynamic> json) {
    return PesananTmpModel(
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
        status: json['status']);
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
        'jualDiscon': jualDiscon,
        'jumlahJual': jumlahJual,
        'totalHargaSebelumDisc': totalHargaSebelumDisc,
        'totalHargaSetelahDisc': totalHargaSetelahDisc,
        'totalDisc': totalDisc,
        'status': status,
      };
}
