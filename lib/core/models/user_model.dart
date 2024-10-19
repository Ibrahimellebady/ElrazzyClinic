class UserModel {
  //required
  String? id;
  String? firstName;
  String? lastName;
  String? email;
  String? password;
  String? phoneNumber;

// optional
  String? image;
  String? chooseStatus;
  String? university;
  String? address;
  String? sex;
  String? birthDate;

// backend

  UserModel({
    this.id,
    this.image,
    this.firstName,
    this.lastName,
    this.email,
    this.password,
    this.chooseStatus,
    this.university,
    this.address,
    this.phoneNumber,
    this.sex,
    this.birthDate,
  });

  // From JSON
  UserModel.fromJson({required Map<String, dynamic> data}) {
    id = data['id'];
    image = data['image'] ?? "";
    firstName = data['firstName'];
    lastName = data['lastName'];
    email = data['email'];
    password = data['password'];
    chooseStatus = data['chooseStatus'];
    university = data['university'];
    address = data['address'];
    phoneNumber = data['phoneNumber'];
    sex = data['sex'];
    birthDate = data['birthDate'];
  }

  // To JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'image': image ?? "",
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'password': password,
      'chooseStatus': chooseStatus,
      'university': university,
      'address': address,
      'phoneNumber': phoneNumber,
      'sex': sex,
      'birthDate': birthDate,
    };
  }
}
