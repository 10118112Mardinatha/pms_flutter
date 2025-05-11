class DoctorModel {
  final int id;
  final String kodeDoctor;
  final String namaDoctor;
  final String? alamat;
  final String? telepon;
  final int? nilaipenjualan;

  DoctorModel({
    required this.id,
    required this.kodeDoctor,
    required this.namaDoctor,
    this.alamat,
    this.telepon,
    this.nilaipenjualan,
  });

  factory DoctorModel.fromJson(Map<String, dynamic> json) {
    return DoctorModel(
      id: json['id'],
      kodeDoctor: json['kodeDoctor']?.toString() ?? '',
      namaDoctor: json['namaDoctor']?.toString() ?? '',
      alamat: json['alamat']?.toString(),
      telepon: json['telepon']?.toString(),
      nilaipenjualan: json['nilaipenjualan'] is int
          ? json['nilaipenjualan']
          : int.tryParse(json['nilaipenjualan']?.toString() ?? '0'),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'kodeDoctor': kodeDoctor,
      'namaDoctor': namaDoctor,
      'alamat': alamat,
      'telepon': telepon,
      'nilaipenjualan': nilaipenjualan,
    };
  }
}
