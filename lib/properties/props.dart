class Props {
  static Uri signUp = Uri.parse(
      'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyDnK0-cQ6Uu5t-g-8poy24ZgMIUBjb9zEk');
  static Uri logIn = Uri.parse(
      'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyDnK0-cQ6Uu5t-g-8poy24ZgMIUBjb9zEk');
  static Uri getBooks =
      Uri.parse('https://www.googleapis.com/books/v1/volumes?q=');

  static String LOGIN_FLAG = 'loginflag';
  static String UID = 'uid';
  static String FAV = 'false';
  static String LOGIN_FLAG_GMAIL = 'loginflaggmail';
}
