part of 'user_cubit.dart';

@immutable
sealed class UserState {}

final class UserInitial extends UserState {}

class TherapistLoginSuccessState extends UserState {}

//class UserLoginSuccessState extends UserState {}

class PatientLoginSuccessState extends UserState {}

class LoginLoadingState extends UserState {}

class LoadingState extends UserState {}

class FailedToLoginState extends UserState {}

class RegisterLoadingState extends UserState {}

class FailedToSaveUserDataOnFirestoreState extends UserState {}

class FailedToSaveExerciseDataOnFirestoreState extends UserState {}

class SavePatientDataOnFirestoreSuccessState extends UserState {}

class SaveExerciseDataOnFirestoreSuccessState extends UserState {}

class SaveTherapistDataOnFirestoreSuccessState extends UserState {}

class UserImageSelectedSuccessState extends UserState {}

class FailedToGeUserImageSelectedState extends UserState {}

class UserCreatedSuccessState extends UserState {}

class TherabistCreatedSuccessState extends UserState {}

class FailedToUpdateUserQuizScoreState extends UserState {}

class UpdateUserQuizScoreSuccessState extends UserState {}

class updateUserDataOnFirestoreSuccessState extends UserState {}

class FailedToupdateUserDataOnFirestoreState extends UserState {}

class UserDataFetchedSuccessState extends UserState {
  UserDataFetchedSuccessState(UserModel? userModel);
}

class FailedToFetchUserDataState extends UserState {}

class FailedToGetMyDataState extends UserState {}

class SuccessGetUsersDataState extends UserState {
  final UserModel? userModel;

  SuccessGetUsersDataState(this.userModel);
}

class FailedToCreateUserState extends UserState {}

class FailedToGetUsersDataState extends UserState {}

class GetUsersDataSuccessState extends UserState {}

class GetUsersLoadingState extends UserState {}

class GetUsersLoadingState2 extends UserState {}

class FailedToGetUsersDataState2 extends UserState {}

class GetUsersDataSuccessState2 extends UserState {}
