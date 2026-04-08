import 'package:flutter/material.dart';
import '../services/chatbot_service.dart';

/// Model for a single chat message.
class ChatMessage {
  final String text;
  final bool isUser;

  const ChatMessage({required this.text, required this.isUser});
}

/// Full-screen chatbot interface with modern chat-bubble UI.
///
/// Uses [RuleBasedChatbotProvider] by default.
/// Swap to any other [ChatbotProvider] implementation for AI integration.
class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  // Pluggable provider – swap for OpenAI / Gemini later.
  final ChatbotProvider _provider = RuleBasedChatbotProvider();

  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  /// Conversation history.
  final List<ChatMessage> _messages = [];

  /// True while the bot is "typing" (awaiting a response).
  bool _isTyping = false;

  @override
  void initState() {
    super.initState();
    // Seed the conversation with a welcome message from the bot.
    _messages.add(const ChatMessage(
      text: 'Hi! 👋 I\'m your Expense Tracker assistant.\n'
          'Ask me anything – adding expenses, viewing analytics, '
          'GPS location, AR experience, and more!\n\n'
          'Type "help" for all options.',
      isUser: false,
    ));
  }

  // ── Scroll helper ─────────────────────────────────────────────────────────

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  // ── Message sending ───────────────────────────────────────────────────────

  Future<void> _sendMessage(String text) async {
    final String trimmed = text.trim();
    if (trimmed.isEmpty) return;

    _controller.clear();

    // Show the user bubble immediately.
    setState(() {
      _messages.add(ChatMessage(text: trimmed, isUser: true));
      _isTyping = true;
    });
    _scrollToBottom();

    // Await the bot response.
    final String response = await _provider.getResponse(trimmed);
    if (!mounted) return;

    final bool navigateToDashboard =
        response == ChatbotProvider.kNavigateDashboard;

    setState(() {
      _isTyping = false;
      _messages.add(ChatMessage(
        text: navigateToDashboard
            ? 'Taking you to the Dashboard now… 📊'
            : response,
        isUser: false,
      ));
    });
    _scrollToBottom();

    // Handle special navigation sentinel.
    if (navigateToDashboard) {
      await Future.delayed(const Duration(milliseconds: 700));
      if (mounted) Navigator.pop(context); // Return to home / dashboard.
    }
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.smart_toy_outlined, size: 22),
            SizedBox(width: 8),
            Text('Expense Assistant'),
          ],
        ),
        centerTitle: true,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.indigo, Colors.blueAccent],
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          // ── Messages list ───────────────────────────────────────────────
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              itemCount: _messages.length + (_isTyping ? 1 : 0),
              itemBuilder: (context, index) {
                if (_isTyping && index == _messages.length) {
                  return _buildTypingIndicator(isDark);
                }
                return _buildBubble(_messages[index], isDark);
              },
            ),
          ),

          // ── Suggestion chips ────────────────────────────────────────────
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            child: Row(
              children: [
                _chip('Add expense', isDark),
                _chip('Show spending', isDark),
                _chip('How to use GPS?', isDark),
                _chip('Dark mode', isDark),
              ],
            ),
          ),

          // ── Input bar ───────────────────────────────────────────────────
          Container(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
            decoration: BoxDecoration(
              color: isDark ? Colors.grey[900] : Colors.white,
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 8,
                  offset: Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              top: false,
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      textInputAction: TextInputAction.send,
                      decoration: InputDecoration(
                        hintText: 'Ask me anything…',
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor:
                            isDark ? Colors.grey[800] : Colors.grey[100],
                      ),
                      onSubmitted: _sendMessage,
                    ),
                  ),
                  const SizedBox(width: 8),
                  CircleAvatar(
                    backgroundColor: Colors.indigo,
                    child: IconButton(
                      icon: const Icon(Icons.send,
                          color: Colors.white, size: 18),
                      onPressed: () => _sendMessage(_controller.text),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Bubble builder ────────────────────────────────────────────────────────

  Widget _buildBubble(ChatMessage msg, bool isDark) {
    final bool isUser = msg.isUser;
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        decoration: BoxDecoration(
          color: isUser
              ? Colors.indigo
              : (isDark ? Colors.grey[800] : Colors.grey[200]),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(18),
            topRight: const Radius.circular(18),
            bottomLeft: Radius.circular(isUser ? 18 : 4),
            bottomRight: Radius.circular(isUser ? 4 : 18),
          ),
        ),
        child: Text(
          msg.text,
          style: TextStyle(
            color: isUser
                ? Colors.white
                : (isDark ? Colors.white : Colors.black87),
            fontSize: 14,
            height: 1.4,
          ),
        ),
      ),
    );
  }

  // ── Typing indicator ──────────────────────────────────────────────────────

  Widget _buildTypingIndicator(bool isDark) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isDark ? Colors.grey[800] : Colors.grey[200],
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(18),
            topRight: Radius.circular(18),
            bottomLeft: Radius.circular(4),
            bottomRight: Radius.circular(18),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(
            3,
            (i) => Container(
              width: 8,
              height: 8,
              margin: EdgeInsets.only(left: i == 0 ? 0 : 4),
              decoration: const BoxDecoration(
                color: Colors.indigo,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ── Suggestion chip ───────────────────────────────────────────────────────

  Widget _chip(String label, bool isDark) {
    return GestureDetector(
      onTap: () => _sendMessage(label),
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isDark ? Colors.indigo[900] : Colors.indigo[50],
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.indigo.withOpacity(0.31),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isDark ? Colors.indigo[200] : Colors.indigo[700],
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}
