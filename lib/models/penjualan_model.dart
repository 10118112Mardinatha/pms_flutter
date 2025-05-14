class PenjualanModel {
  final int id;
  final String noFaktur;
  final String kodePelanggan;
  final String namaPelanggan;
  final String kodeDoctor;
  final String namaDoctor;
  final DateTime tanggalPenjualan;
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
  final String status;

  PenjualanModel({
    required this.id,
    required this.noFaktur,
    required this.kodePelanggan,
    required this.namaPelanggan,
    required this.kodeDoctor,
    required this.namaDoctor,
    required this.tanggalPenjualan,
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
    required this.status,
  });

  factory PenjualanModel.fromJson(Map<String, dynamic> json) {
    return PenjualanModel(
      id: json['id'],
      noFaktur: json['noFaktur'],
      kodePelanggan: json['kodePelanggan'],
      namaPelanggan: json['namaPelanggan'],
      kodeDoctor: json['kodeDoctor'],
      namaDoctor: json['namaDoctor'],
      tanggalPenjualan: DateTime.parse(json['tanggalPenjualan']),
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
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'noFaktur': noFaktur,
        'kodePelanggan': kodePelanggan,
        'namaPelanggan': namaPelanggan,
        'kodeDoctor': kodeDoctor,
        'namaDoctor': namaDoctor,
        'tanggalPenjualan': tanggalPenjualan.toIso8601String(),
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
