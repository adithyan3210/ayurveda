class PatientResponse {
  final bool status;
  final String message;
  final List<Patient> patient;

  PatientResponse({
    required this.status,
    required this.message,
    required this.patient,
  });

  factory PatientResponse.fromJson(Map<String, dynamic> json) {
    return PatientResponse(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      patient:
          (json['patient'] as List<dynamic>?)
              ?.map((e) => Patient.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'patient': patient.map((e) => e.toJson()).toList(),
    };
  }
}

class Patient {
  final int id;
  final List<PatientDetail> patientdetailsSet;
  final Branch branch;
  final String user;
  final String payment;
  final String name;
  final String phone;
  final String address;
  final dynamic price;
  final int totalAmount;
  final int discountAmount;
  final int advanceAmount;
  final int balanceAmount;
  final DateTime? dateNdTime;
  final bool isActive;
  final String createdAt;
  final String updatedAt;

  Patient({
    required this.id,
    required this.patientdetailsSet,
    required this.branch,
    required this.user,
    required this.payment,
    required this.name,
    required this.phone,
    required this.address,
    this.price,
    required this.totalAmount,
    required this.discountAmount,
    required this.advanceAmount,
    required this.balanceAmount,
    this.dateNdTime,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Patient.fromJson(Map<String, dynamic> json) {
    return Patient(
      id: json['id'] ?? 0,
      patientdetailsSet:
          (json['patientdetails_set'] as List<dynamic>?)
              ?.map((e) => PatientDetail.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      branch: Branch.fromJson(json['branch'] as Map<String, dynamic>? ?? {}),
      user: json['user']?.toString() ?? '',
      payment: json['payment']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      address: json['address']?.toString() ?? '',
      price: json['price'],
      totalAmount: _parseInt(json['total_amount']),
      discountAmount: _parseInt(json['discount_amount']),
      advanceAmount: _parseInt(json['advance_amount']),
      balanceAmount: _parseInt(json['balance_amount']),
      dateNdTime: json['date_nd_time'] != null
          ? DateTime.parse(json['date_nd_time'])
          : null,
      isActive: json['is_active'] ?? true,
      createdAt: json['created_at']?.toString() ?? '',
      updatedAt: json['updated_at']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'patientdetails_set': patientdetailsSet.map((e) => e.toJson()).toList(),
      'branch': branch.toJson(),
      'user': user,
      'payment': payment,
      'name': name,
      'phone': phone,
      'address': address,
      'price': price,
      'total_amount': totalAmount,
      'discount_amount': discountAmount,
      'advance_amount': advanceAmount,
      'balance_amount': balanceAmount,
      'date_nd_time': dateNdTime,
      'is_active': isActive,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }
}

class PatientDetail {
  final int id;
  final String male;
  final String female;
  final int patient;
  final int? treatment;
  final String? treatmentName;

  PatientDetail({
    required this.id,
    required this.male,
    required this.female,
    required this.patient,
    this.treatment,
    this.treatmentName,
  });

  factory PatientDetail.fromJson(Map<String, dynamic> json) {
    return PatientDetail(
      id: json['id'] ?? 0,
      male: json['male']?.toString() ?? '',
      female: json['female']?.toString() ?? '',
      patient: json['patient'] ?? 0,
      treatment: json['treatment'],
      treatmentName: json['treatment_name']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'male': male,
      'female': female,
      'patient': patient,
      'treatment': treatment,
      'treatment_name': treatmentName,
    };
  }
}

class Branch {
  final int id;
  final String name;
  final int patientsCount;
  final String location;
  final String phone;
  final String mail;
  final String address;
  final String gst;
  final bool isActive;

  Branch({
    required this.id,
    required this.name,
    required this.patientsCount,
    required this.location,
    required this.phone,
    required this.mail,
    required this.address,
    required this.gst,
    required this.isActive,
  });

  factory Branch.fromJson(Map<String, dynamic> json) {
    return Branch(
      id: json['id'] ?? 0,
      name: json['name']?.toString() ?? '',
      patientsCount: json['patients_count'] ?? 0,
      location: json['location']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      mail: json['mail']?.toString() ?? '',
      address: json['address']?.toString() ?? '',
      gst: json['gst']?.toString() ?? '',
      isActive: json['is_active'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'patients_count': patientsCount,
      'location': location,
      'phone': phone,
      'mail': mail,
      'address': address,
      'gst': gst,
      'is_active': isActive,
    };
  }
}
