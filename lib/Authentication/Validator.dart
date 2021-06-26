nameValidator(String name) {
  if (name == "") {
    return "Please enter a name";
  }
  return null;
}

emailValidator(String email) {
  String pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regex = new RegExp(pattern);
  if (!regex.hasMatch(email)) {
    return "Enter a valid email";
  } else if (Validator.getMessage() == "email") {
    return "Email already exists";
  }
  return null;
}

usernameValidator(String username) {
  if (username.length < 4) {
    return "Username is too short, 4 characters minimum.";
  } else if (username.length > 20) {
    return "Username is too long, 20 characters maximum.";
  } else if (Validator.getMessage() == "username") {
    return "Username already exists";
  }
  return null;
}

passwordValidator(String password) {
  if (password.length < 6) {
    return "Password is too short, 6 character minimum.";
  } else if (password.length > 30) {
    return "Password is too long, 30 characters maximum";
  } else if (Validator.getMessage() == "match-passwords") {
    return "Passwords do not match";
  }
  return null;
}

class Validator {
  static String _message;

  static void setMessage(String message) {
    _message = message;
  }

  static String getMessage() {
    return _message;
  }
}
