class PelangganModel {
  final int id;
  final String kodePelanggan;
  final String namaPelanggan;
  final int? usia;
  final String? telepon;
  final String? alamat;
  final String? kelompok;

  PelangganModel({
    required this.id,
    required this.kodePelanggan,
    required this.namaPelanggan,
    this.usia,
    this.telepon,
    this.alamat,
    this.kelompok,
  });

  factory PelangganModel.fromJson(Map<String, dynamic> json) {
    return PelangganModel(
      id: json['id'],
      kodePelanggan: json['kodePelanggan'],
      namaPelanggan: json['namaPelanggan'],
      usia: json['usia'] is int
          ? json['usia']
          : int.tryParse(json['usia']?.toString() ?? '0'),
      telepon: json['telepon'],
      alamat: json['alamat'],
      kelompok: json['kelompok'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'kodePelanggan': kodePelanggan,
      'namaPelanggan': namaPelanggan,
      'usia': usia,
      'telepon': telepon,
      'alamat': alamat,
      'kelompok': kelompok,
    };
  }
}
