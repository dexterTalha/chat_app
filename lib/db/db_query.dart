class Query {
  static const String chat = "chat";
  static const String friend = "friend";

  static const String createChatTable = '''
    CREATE TABLE IF NOT EXIST $chat(
      id VARCHAR(100) PRIMARY KEY,
      sender VARCHAR(100),
      receiver VARCHAR(100),
      message TEXT,
      isseen NUMERIC
    )
   ''';
}
