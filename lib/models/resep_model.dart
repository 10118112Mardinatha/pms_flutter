class ResepModel {
  final int id;
  final String noResep;
  final DateTime tanggal;
  final String namaPelanggan;
  final String kodePelanggan;
  final String kelompokPelanggan;
  final String kodeDoctor;
  final String namaDoctor;
  final int usia;
  final String alamat;
  final String keterangan;
  final String noTelp;
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

  ResepModel(
      {required this.id,
      required this.noResep,
      required this.tanggal,
      required this.kodePelanggan,
      required this.namaPelanggan,
      required this.kelompokPelanggan,
      required this.kodeDoctor,
      required this.namaDoctor,
      required this.usia,
      required this.alamat,
      required this.keterangan,
      required this.noTelp,
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

  factory ResepModel.fromJson(Map<String, dynamic> json) {
    return ResepModel(
      id: json['id'],
      noResep: json['noResep'],
      tanggal: json['tanggal'],
      kodePelanggan: json['kodePelanggan'],
      namaPelanggan: json['namaPelanggan'],
      kelompokPelanggan: json['kelompokPelanggan'],
      kodeDoctor: json['kodeDoctor'],
      namaDoctor: json['namaDoctor'],
      usia: json['usia'],
      alamat: json['alamat'],
      keterangan: json['keterangan'],
      noTelp: json['noTelp'],
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
        'noResep': noResep,
        'tanggal': tanggal,
        'kodePelanggan': kodePelanggan,
        'namaPelanggan': namaPelanggan,
        'kelompokPelanggan': kelompokPelanggan,
        'kodeDoctor': kodeDoctor,
        'namaDoctor': namaDoctor,
        'usia': usia,
        'alamat': alamat,
        'keterangan': keterangan,
        'noTelp': noTelp,
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
