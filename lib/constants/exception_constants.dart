class ExC{
  static const String serverError = ': Server Error (Server connection failed)';
  static const String inputError = ': Input Data Error (Invalid value inputed)';

  static const String fetchResultError = 'Failed to fetch result';
  static const String fetchResultServerError = fetchResultError + serverError;
  static const String fetchResultInputError = fetchResultError + inputError;

  static const String addUserError = 'Failed to add user for DB';
  static const String addUserServerError = addUserError + serverError;
  static const String addUserInputError = addUserError + inputError;

  static const String deleteUserError = 'Failed to delete user from DB';
  static const String deleteUserServerError = deleteUserError + serverError;
  static const String deleteUserInputError = deleteUserError + inputError;

  static const String fetchStatusError = 'Failed to fetch status';
  static const String fetchStatusServerError =  fetchStatusError + serverError;
  static const String fetchStatusInputError = fetchStatusError + inputError;

  static const String getStartError = 'Failed to start algorithm';
  static const String getStartServerError = getStartError + serverError;
  static const String getStartInputError = getStartError + inputError;
}
