import 'dart:io';

void logToFile(String message) {
  // Define the path to the log file.
  String path = 'path_to_your_log_file.txt';

  // Create a reference to the log file.
  File logFile = File(path);

  // Write the message to the file.
  logFile.writeAsStringSync('$message\n', mode: FileMode.append);
}
