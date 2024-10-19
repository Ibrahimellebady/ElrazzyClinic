import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/constants/constants.dart';
import '../../../core/models/user_model.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  UserCubit() : super(UserInitial());

// get pic from my devise
  File? userImgFile;

  void getImage() async {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      userImgFile = File(pickedImage.path);
      emit(UserImageSelectedSuccessState());
    } else {
      emit(FailedToGeUserImageSelectedState());
    }
  }

  Future<String> uploadImageToStorage() async {
    Reference imageRef = FirebaseStorage.instance
        .ref()
        .child('images/${basename(userImgFile!.path)}');
    await imageRef.putFile(userImgFile!);
    return await imageRef.getDownloadURL();
  }

  // send data of registration to firestore

  Future<void> sendUserDataToFireStore({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String phoneNumber,
    required String userID,
    String? image,
  }) async {
    UserModel userModel = UserModel(
      image: image,
      firstName: firstName,
      lastName: lastName,
      email: email,
      password: password,
      phoneNumber: phoneNumber,
      id: userID,
    );
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userID)
          .set(userModel.toJson());
      print(
          "============================User data sent to Firestore successfully");
      emit(SavePatientDataOnFirestoreSuccessState());
    } on FirebaseException catch (e) {
      print(
          "===========================Failed to save user data to Firestore: $e");
      emit(FailedToSaveUserDataOnFirestoreState());
    }
  }

  // registration methode to create user, send verification link to email and send data to firestore
  Future<void> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String phoneNumber,
  }) async {
    emit(LoadingState());
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      String? imageUrl;
      if (userImgFile != null) {
        imageUrl = await uploadImageToStorage();
      } else {
        imageUrl = ''; // or you can use a default image URL
      }
      await sendUserDataToFireStore(
        image: imageUrl,
        firstName: firstName,
        lastName: lastName,
        email: email,
        password: password,
        phoneNumber: phoneNumber,
        userID: userCredential.user!.uid,
      );
      final sharedPref = await SharedPreferences.getInstance();
      await sharedPref.setString('userID', userCredential.user!.uid);
      Constants.userID = sharedPref.getString('userID');

      //
      await sharedPref.setString('userEmail', userCredential.user!.email!);
      Constants.userEmail = sharedPref.getString('userEmail');
      print("======================= ${Constants.userEmail}");
      Constants.userID = userCredential.user!.uid;
      emit(UserCreatedSuccessState());
    } catch (e) {
      emit(FailedToCreateUserState());
    }
  }

  // get user data from firebase
  UserModel? userModel;

  void getUsersData() async {
    emit(
        GetUsersLoadingState()); // Emit loading state before starting the operation
    try {
      DocumentSnapshot<Map<String, dynamic>> docSnapshot =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(Constants.userID)
              .get();

      if (docSnapshot.exists) {
        final data = docSnapshot.data();
        if (data != null) {
          userModel = UserModel.fromJson(data: data);
          emit(SuccessGetUsersDataState(userModel));
          // print("User data retrieved: ${userModel!.firstName}");
        } else {
          print("No user data found for user ID: ${Constants.userID}");
          emit(FailedToGetMyDataState());
        }
      } else {
        print("User document does not exist for user ID: ${Constants.userID}");
        emit(FailedToGetMyDataState());
      }
    } on FirebaseException catch (e) {
      print("Error fetching user data from Firestore: $e");
      emit(FailedToGetMyDataState());
    }
  }

  // get List of all the users from firebase [used for admin app]

  List<UserModel> users = [];

  void getUsers() async {
    users.clear();
    emit(GetUsersLoadingState());
    try {
      await FirebaseFirestore.instance.collection('users').get().then((value) {
        for (var item in value.docs) {
          if (item.id != Constants.userID) {
            users.add(UserModel.fromJson(data: item.data()));
          }
        }
        emit(GetUsersDataSuccessState());
      });
    }
    // on FirebaseException
    catch (e) {
      users = [];
      emit(FailedToGetUsersDataState());
    }
  }
}
