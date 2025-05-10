class SupplierModel {
  final String kodeSupplier;
  final String namaSupplier;
  final String alamat;
  final String telepon;
  final String keterangan;
  final int id;
  SupplierModel(
      {required this.kodeSupplier,
      required this.namaSupplier,
      required this.alamat,
      required this.telepon,
      required this.keterangan,
      required this.id});

  factory SupplierModel.fromJson(Map<String, dynamic> json) {
    return SupplierModel(
      id: json['id'],
      kodeSupplier: json['kodeSupplier']?.toString() ?? '',
      namaSupplier: json['namaSupplier']?.toString() ?? '',
      alamat: json['alamat']?.toString() ?? '',
      telepon: json['telepon']?.toString() ?? '',
      keterangan: json['keterangan']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'kodeSupplier': kodeSupplier,
      'namaSupplier': namaSupplier,
      'alamat': alamat,
      'telepon': telepon,
      'keterangan': keterangan,
    };
  }
}
