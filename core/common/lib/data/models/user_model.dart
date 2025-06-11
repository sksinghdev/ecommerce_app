import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  final String uid;
  final String? email;
  final String? displayName;
  final String? photoUrl;

  const UserModel({
    required this.uid,
    this.email,
    this.displayName,
    this.photoUrl,
  });

  factory UserModel.fromFirebaseUser(dynamic user) {
    return UserModel(
      uid: user.uid,
      email: user.email,
      displayName: user.displayName,
      photoUrl: user.photoURL,
    );
  }

  @override
  List<Object?> get props => [uid, email, displayName, photoUrl];
}