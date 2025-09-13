class TreatmentResponse {
  final bool status;
  final String message;
  final List<Treatment> treatments;

  TreatmentResponse({
    required this.status,
    required this.message,
    required this.treatments,
  });

  factory TreatmentResponse.fromJson(Map<String, dynamic> json) {
    return TreatmentResponse(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      treatments: (json['treatments'] as List<dynamic>? ?? [])
          .map((e) => Treatment.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'treatments': treatments.map((e) => e.toJson()).toList(),
    };
  }
}

class Treatment {
  final int id;
  final String name;
  final String duration;
  final String price;
  final bool isActive;
  final String createdAt;
  final String updatedAt;
  final List<Branch> branches;

  Treatment({
    required this.id,
    required this.name,
    required this.duration,
    required this.price,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
    required this.branches,
  });

  factory Treatment.fromJson(Map<String, dynamic> json) {
    return Treatment(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      duration: json['duration'] ?? '',
      price: json['price'] ?? '',
      isActive: json['is_active'] ?? false,
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      branches: (json['branches'] as List<dynamic>? ?? [])
          .map((e) => Branch.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'duration': duration,
      'price': price,
      'is_active': isActive,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'branches': branches.map((e) => e.toJson()).toList(),
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
      name: json['name'] ?? '',
      patientsCount: json['patients_count'] ?? 0,
      location: json['location'] ?? '',
      phone: json['phone'] ?? '',
      mail: json['mail'] ?? '',
      address: json['address'] ?? '',
      gst: json['gst'] ?? '',
      isActive: json['is_active'] ?? false,
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
