import 'dart:io';
import 'dart:math';

mixin Authenticator {
  bool authenticate(String username, String password);
}

mixin AuthorizationManager {
  bool isAuthorized(String resource, String userRole);
}

class User with Authenticator, AuthorizationManager {
  final String _username;
  final String _password;
  final String _userRole;

  User(this._username, this._password, this._userRole);

  @override
  bool authenticate(String username, String password) {
    return username == _username && password == _password;
  }

  bool _isValidPassword(String password) {
    final hasSpecialChar = RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password);
    return password.length >= 6 && hasSpecialChar;
  }

  @override
  bool isAuthorized(String resource, String userRole) {
    return this._userRole == userRole;
  }
}

void main() {
  stdout.write('Enter your username: ');
  final String? username = stdin.readLineSync();

  stdout.write('Enter your password (at least 6 characters long with one special character): ');
  final String? password = stdin.readLineSync();

  stdout.write('Enter your role (admin or user): ');
  final String? userRole = stdin.readLineSync();

  if (username != null && password != null && userRole != null) {
    User user = User(username, password, userRole.toLowerCase());

    if (user.authenticate(username, password)) {
      print('User is authenticated');

      if (user.isAuthorized('/admin', 'admin')) {
        print('User is authorized to access /admin');
      } else {
        print('User is not authorized to access /admin');
      }

      if (user.isAuthorized('/users', 'user')) {
        print('User is authorized to access /users');
      } else {
        print('User is not authorized to access /users');
      }
    } else {
      print('User is not authenticated');
    }
  } else {
    print('Invalid input');
  }
}