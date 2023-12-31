// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:casualbear_backoffice/local_storage.dart';
import 'package:casualbear_backoffice/repositories/authentication_repository.dart';
// ignore: depend_on_referenced_packages
import 'package:meta/meta.dart';
part 'authentication_state.dart';

class AuthenticationCubit extends Cubit<AuthenticationState> {
  final AuthenticationRepository repository;
  AuthenticationCubit(this.repository) : super(AuthenticationInitial());

  void login(String username, String password, String deviceId) async {
    emit(AuthenticationLoading());
    try {
      String response = await repository.login(username, password, deviceId);
      saveToken(response);
      emit(AuthenticationLoaded());
    } catch (e) {
      emit(AuthenticationError());
    }
  }
}
