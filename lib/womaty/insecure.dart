import "dart:io";
import "dart:math";

class InsecureDemo {
  void hardcodedSecrets() {
    // 🚨 BAD: Hardcoded secrets
    String password = "superSecret123";
    String apiKey = "XYZ-API-999";
    print("Password: $password, API Key: $apiKey");
  }

  void insecureRandom() {
    // 🚨 BAD: Using insecure random for OTP
    int otp = Random().nextInt(999999);
    print("Generated OTP: $otp");
  }

  void sqlInjection(String userInput) {
    // 🚨 BAD: Concatenating user input in SQL
    String query = "SELECT * FROM users WHERE name = '" + userInput + "'";
    print("Running query: $query");
  }

  void commandInjection(String userInput) {
    // 🚨 BAD: Passing untrusted input to system command
    Process.runSync("sh", ["-c", "echo $userInput > insecure.txt"]);
  }

  void logSensitiveData() {
    // 🚨 BAD: Logging sensitive information
    String token = "topSecretToken";
    print("Debug: using token = $token");
  }
}
