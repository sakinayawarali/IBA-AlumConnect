bool isValidPassword(String password) {
  // Implement your password validation logic here
  return password.length >= 8 &&
      RegExp(r'[A-Z]').hasMatch(password) &&
      RegExp(r'[a-z]').hasMatch(password) &&
      RegExp(r'[0-9]').hasMatch(password) &&
      RegExp(r'[!@#\$&*~]').hasMatch(password);
}

bool doPasswordsMatch(String password, String confirmPassword) {
  return password == confirmPassword;
}
