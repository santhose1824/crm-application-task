class CustomerModel {
  final String uid;
  final String name;
  final String email;
  final String phone;
  final String agentUid;

  CustomerModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.phone,
    required this.agentUid,
  });

  factory CustomerModel.fromMap(Map<String, dynamic> map) {
    return CustomerModel(
      uid: map['uid'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      agentUid: map['agentUid'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'phone': phone,
      'agentUid': agentUid,
      'role': 'customer',
    };
  }

  CustomerModel copyWith({
    String? uid,
    String? name,
    String? email,
    String? phone,
    String? agentUid,
  }) {
    return CustomerModel(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      agentUid: agentUid ?? this.agentUid,
    );
  }
}
