/// Abstract interface for chatbot response providers.
///
/// To plug in OpenAI or any other AI backend, create a class that
/// implements [ChatbotProvider] and swap it in [ChatbotScreen].
abstract class ChatbotProvider {
  /// Returns a bot response string for the given user [message].
  /// Use the special sentinel value [ChatbotProvider.kNavigateDashboard]
  /// to signal an in-app navigation action.
  Future<String> getResponse(String message);

  /// Sentinel response that tells the UI to navigate to the dashboard.
  static const String kNavigateDashboard = '__NAV_DASHBOARD__';
}

/// Rule-based chatbot provider.
///
/// Matches keywords in user messages and returns predefined responses.
/// This is the default implementation; replace or extend for AI integration.
class RuleBasedChatbotProvider implements ChatbotProvider {
  @override
  Future<String> getResponse(String message) async {
    // Simulate a realistic typing delay.
    await Future.delayed(const Duration(milliseconds: 400));

    final String msg = message.toLowerCase().trim();

    // --- Intent: Add expense / transaction ---
    if (_contains(msg, ['add', 'create', 'new']) &&
        _contains(msg, ['expense', 'transaction', 'income', 'entry'])) {
      return 'To add a transaction:\n'
          '1. Tap the ➕ button on the Home screen.\n'
          '2. Enter a title and amount.\n'
          '3. Select "expense" or "income".\n'
          '4. Tap Save. Done! 🎉';
    }

    // --- Intent: View spending / dashboard ---
    if (_containsAny(msg, [
      'spending',
      'dashboard',
      'analytics',
      'balance',
      'chart',
      'show my',
      'total',
    ])) {
      return ChatbotProvider.kNavigateDashboard;
    }

    // --- Intent: GPS / location ---
    if (_containsAny(msg, ['location', 'gps', 'where am i', 'coordinates'])) {
      return 'You can view your current location on the Home screen.\n'
          'Tap "Get Current Location" 📍 inside the teal location card.\n'
          'It shows your latitude, longitude, and city name (when available).';
    }

    // --- Intent: AR ---
    if (_containsAny(msg, ['ar', 'augmented', '3d', 'model', 'astronaut'])) {
      return 'Try the AR Experience! 🔷\n'
          'Tap the cube icon (▣) in the top-right of the Home screen.\n'
          'On supported Android devices you can view the model in real AR.';
    }

    // --- Intent: Dark mode / theme ---
    if (_containsAny(msg, ['dark', 'light', 'theme', 'mode', 'toggle'])) {
      return 'Toggle Dark Mode from the ☰ side menu on the Home screen. '
          'Just flip the Dark Mode switch!';
    }

    // --- Intent: Logout ---
    if (_containsAny(msg, ['logout', 'log out', 'sign out'])) {
      return 'To log out, open the ☰ side menu on the Home screen '
          'and tap "Logout".';
    }

    // --- Intent: Login / credentials ---
    if (_containsAny(msg, ['login', 'sign in', 'password', 'username'])) {
      return 'Use your username and password on the Login screen.\n'
          'Default credentials: username = admin, password = 1234.';
    }

    // --- Intent: Chatbot / help ---
    if (_containsAny(msg, ['help', 'what can you do', 'commands', 'options'])) {
      return 'I can help you with:\n'
          '• Adding expenses or income\n'
          '• Viewing your spending dashboard\n'
          '• Using the GPS location card\n'
          '• Exploring the AR Experience\n'
          '• Toggling dark mode\n'
          '• Logging out\n\n'
          'Just ask away! 😊';
    }

    // --- Intent: Greeting ---
    if (_containsAny(msg, ['hello', 'hi', 'hey', 'hola', 'greetings'])) {
      return 'Hello! 👋 I\'m your Expense Tracker assistant.\n'
          'Type "help" to see what I can do.';
    }

    // --- Fallback ---
    return 'I\'m not sure about that. 🤔\n\n'
        'Try asking:\n'
        '  • "How to add expense?"\n'
        '  • "Show my spending"\n'
        '  • "How do I use GPS?"\n'
        '  • "Toggle dark mode"\n\n'
        'Or type "help" for the full list.';
  }

  // ── Helpers ──────────────────────────────────────────────────────────────

  /// Returns true if [msg] contains ALL words in [keywords].
  bool _contains(String msg, List<String> keywords) =>
      keywords.every((k) => msg.contains(k));

  /// Returns true if [msg] contains ANY of the [keywords].
  bool _containsAny(String msg, List<String> keywords) =>
      keywords.any((k) => msg.contains(k));
}
