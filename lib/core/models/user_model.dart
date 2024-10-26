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

  String? address;
  String? sex;
  String? birthDate;
// backend
  String? chiefComplain;
  List<String>? attachments;

  UserModel({
    this.id,
    this.image,
    this.firstName,
    this.lastName,
    this.email,
    this.password,
    this.address,
    this.phoneNumber,
    this.sex,
    this.birthDate,
    this.chiefComplain,
    this.attachments,
  });

  // From JSON
  UserModel.fromJson({required Map<String, dynamic> data}) {
    id = data['id'];
    image = data['image'] ?? "";
    firstName = data['firstName'];
    lastName = data['lastName'];
    email = data['email'];
    password = data['password'];

    address = data['address'];
    phoneNumber = data['phoneNumber'];
    sex = data['sex'];
    birthDate = data['birthDate'];
    chiefComplain = data['chiefComplain'];
    attachments = data['attachments'];
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
      'address': address,
      'phoneNumber': phoneNumber,
      'sex': sex,
      'birthDate': birthDate,
      'chiefComplain': chiefComplain ?? "",
      "attachments": attachments ?? [""],
    };
  }
}
