//Eventos
abstract class SignupEvent {}

class SignupSubmitEvent extends SignupEvent {}

//States
abstract class SignupState {}

abstract class SignupIdleState extends SignupState {}

abstract class SignupSuccessState extends SignupState {}

abstract class SignupFailState extends SignupState {}

abstract class SignupLoadingState extends SignupState {}

//BloC
