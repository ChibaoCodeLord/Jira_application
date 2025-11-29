import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

class AuthState {
  final bool isLoggedIn;
  final String uid;

  AuthState({required this.isLoggedIn, this.uid = ''});

  AuthState copyWith({bool? isLoggedIn, String? uid}) {
    return AuthState(
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      uid: uid ?? this.uid,
    );
  }
}


@lazySingleton
class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthState(isLoggedIn: false));

  void login(String uid) => emit(state.copyWith(isLoggedIn: true, uid: uid));
  void logout() => emit(AuthState(isLoggedIn: false));
}

