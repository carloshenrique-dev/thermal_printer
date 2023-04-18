import 'dart:convert';

class UserInformation {
  String name;
  String email;
  String phone;

  UserInformation({
    this.name = ' ',
    this.email = ' ',
    this.phone = '',
  });

  UserInformation copyWith({
    String? name,
    String? email,
    String? phone,
  }) {
    return UserInformation(
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'email': email,
      'phone': phone,
    };
  }

  factory UserInformation.fromMap(Map<String, dynamic> map) {
    return UserInformation(
      name: map['name'] as String,
      email: map['email'] as String,
      phone: map['phone'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserInformation.fromJson(String source) =>
      UserInformation.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'UserInformation(name: $name, email: $email, phone: $phone)';

  @override
  bool operator ==(covariant UserInformation other) {
    if (identical(this, other)) return true;

    return other.name == name && other.email == email && other.phone == phone;
  }

  @override
  int get hashCode => name.hashCode ^ email.hashCode ^ phone.hashCode;
}
