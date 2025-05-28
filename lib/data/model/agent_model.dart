class AgentModel {
  final String uid;
  final String name;
  final String email;
  final String phone;

  AgentModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.phone,
  });

  factory AgentModel.fromMap(Map<String, dynamic> map) {
    return AgentModel(
      uid: map['uid'],
      name: map['name'],
      email: map['email'],
      phone: map['phone'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'phone': phone,
      'role': 'agent',
      'createdAt': DateTime.now(),
    };
  }

  // ✅ Add this method
  AgentModel copyWith({
    String? uid,
    String? name,
    String? email,
    String? phone,
  }) {
    return AgentModel(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
    );
  }
}
