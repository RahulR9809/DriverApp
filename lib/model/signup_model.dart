

class SignupModel {
  final String name;
  final String email;
    final String password;
  final String phone;

  SignupModel({required this.name,required this.phone, required this.email, required this.password});

  Map<String, dynamic> toJson() {
    return {
      'name': name,
        'email': email,
        'phone': phone,
        'password': password,
    };
  }
}