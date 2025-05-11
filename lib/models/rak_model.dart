class RakModel {
  final int id;
  final String kodeRak;
  final String namaRak;
  final String lokasi;
  final String? keterangan;

  RakModel({
    required this.id,
    required this.kodeRak,
    required this.namaRak,
    required this.lokasi,
    this.keterangan,
  });

  factory RakModel.fromJson(Map<String, dynamic> json) {
    return RakModel(
      id: json['id'],
      kodeRak: json['kodeRak'],
      namaRak: json['namaRak'],
      lokasi: json['lokasi'],
      keterangan: json['keterangan'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'kodeRak': kodeRak,
      'namaRak': namaRak,
      'lokasi': lokasi,
      'keterangan': keterangan,
    };
  }
}
