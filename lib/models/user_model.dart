// ignore_for_file: public_member_api_docs, sort_constructors_first

class UserModel {
  final String? uid;
  final String? name;
  final String? email;
  final String? mobile;
  UserModel({
    this.uid,
    this.name,
    this.email,
    this.mobile,
  });

  UserModel copyWith({
    String? uid,
    String? name,
    String? email,
    String? mobile,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      email: email ?? this.email,
      mobile: mobile ?? this.mobile,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'name': name,
      'email': email,
      'mobile': mobile,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] != null ? map['uid'] as String : null,
      name: map['name'] != null ? map['name'] as String : null,
      email: map['email'] != null ? map['email'] as String : null,
      mobile: map['mobile'] != null ? map['mobile'] as String : null,
    );
  }
}
