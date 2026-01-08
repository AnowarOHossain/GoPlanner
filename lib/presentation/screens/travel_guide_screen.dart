// Simple AI Travel Chatbot Screen
// Clean UI with quick planning options and chat interface

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/auth_providers.dart';
import '../providers/ai_suggestions_provider.dart';

class TravelGuideScreen extends ConsumerStatefulWidget {
  const TravelGuideScreen({super.key});

  @override
  ConsumerState<TravelGuideScreen> createState() => _TravelGuideScreenState();
}

class _TravelGuideScreenState extends ConsumerState<TravelGuideScreen> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Travel Planner'),
        backgroundColor: const Color(0xFF2E7D5A),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.home),
            onPressed: () => context.go('/'),
            tooltip: 'Home',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // AI Assistant Card
            _buildAIAssistantCard(),
            const SizedBox(height: 24),
            
            // Quick Planning Section
            _buildQuickPlanningSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildAIAssistantCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: const LinearGradient(
            colors: [Color(0xFF2E7D5A), Color(0xFF4ADE80)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.auto_awesome, color: Colors.white, size: 28),
                SizedBox(width: 12),
                Text(
                  'AI Travel Assistant',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Text(
              'Get personalized travel recommendations powered by AI. Tell me your preferences and I\'ll create the perfect itinerary for you!',
              style: TextStyle(fontSize: 14, color: Colors.white),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _openChat(context),
                icon: const Icon(Icons.chat, color: Color(0xFF2E7D5A)),
                label: const Text(
                  'Start Planning',
                  style: TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF2E7D5A)),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickPlanningSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Quick Planning',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildQuickPlanCard(
                'Day Trip',
                'Perfect for a single day adventure',
                Icons.today,
                Colors.blue,
                1,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildQuickPlanCard(
                'Weekend',
                'Great for 2-3 day getaways',
                Icons.weekend,
                Colors.orange,
                2,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _buildQuickPlanCard(
          'Week Long',
          'Comprehensive 7-day exploration',
          Icons.calendar_month,
          Colors.purple,
          7,
        ),
      ],
    );
  }

  Widget _buildQuickPlanCard(String title, String description, IconData icon, Color color, int days) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () => _openChat(context, days: days, title: title),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Icon(icon, size: 32, color: color),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openChat(BuildContext context, {int? days, String? title}) {
    final user = ref.read(currentUserProvider);
    if (user == null) {
      _showLoginDialog();
      return;
    }
    
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => _ChatScreen(initialDays: days, planType: title),
      ),
    );
  }

  void _showLoginDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Sign In Required'),
        content: const Text('Please sign in to use the AI Travel Assistant.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.go('/login');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2E7D5A),
              foregroundColor: Colors.white,
            ),
            child: const Text('Sign In'),
          ),
        ],
      ),
    );
  }
}

// Chat Screen - Opens when user clicks Start Planning or Quick Plan cards
class _ChatScreen extends ConsumerStatefulWidget {
  final int? initialDays;
  final String? planType;

  const _ChatScreen({this.initialDays, this.planType});

  @override
  ConsumerState<_ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<_ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<_ChatMessage> _messages = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Add initial greeting
    String greeting;
    if (widget.planType != null) {
      greeting = "Let's plan your ${widget.planType}! 🎉\n\n"
          "Tell me:\n"
          "• Where do you want to go? (e.g., Cox's Bazar, Sylhet)\n"
          "• What's your budget in BDT?\n\n"
          "Example: \"I want to visit Cox's Bazar with 15000 BDT budget\"";
    } else {
      greeting = "Hi! I'm your AI Travel Assistant for Bangladesh. 🇧🇩\n\n"
          "Tell me about your trip! For example:\n"
          "• \"Cox's Bazar for 3 days with 15000 BDT\"\n"
          "• \"Weekend trip to Sylhet\"\n"
          "• \"Budget hotels in Dhaka\"\n\n"
          "What would you like to explore?";
    }
    _messages.add(_ChatMessage(text: greeting, isUser: false));
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _sendMessage() async {
    final message = _messageController.text.trim();
    if (message.isEmpty || _isLoading) return;

    setState(() {
      _messages.add(_ChatMessage(text: message, isUser: true));
      _isLoading = true;
    });
    _messageController.clear();
    _scrollToBottom();

    try {
      final response = await _getAIResponse(message);
      setState(() {
        _messages.add(_ChatMessage(text: response, isUser: false));
      });
    } catch (e) {
      String errorMessage;
      final errorStr = e.toString().toLowerCase();
      
      if (errorStr.contains('429') || errorStr.contains('quota')) {
        errorMessage = "⏳ AI is taking a short break!\n\n"
            "Free tier limit reached. Please wait a minute and try again. 😊";
      } else if (errorStr.contains('network') || errorStr.contains('socket')) {
        errorMessage = "📶 Connection issue! Please check your internet.";
      } else {
        errorMessage = "Sorry, something went wrong. Please try again.";
      }
      
      setState(() {
        _messages.add(_ChatMessage(text: errorMessage, isUser: false));
      });
    }

    setState(() => _isLoading = false);
    _scrollToBottom();
  }

  Future<String> _getAIResponse(String userMessage) async {
    final details = _parseUserMessage(userMessage);
    
    await ref.read(aiSuggestionsProvider.notifier).generateSuggestions(
      destination: details['destination'] ?? 'Bangladesh',
      days: details['days'] ?? widget.initialDays ?? 3,
      budget: details['budget'] ?? 10000,
      interests: details['interests'],
    );

    final state = ref.read(aiSuggestionsProvider);
    if (state.error != null) throw Exception(state.error);
    return state.suggestions ?? "I couldn't generate suggestions. Please try again.";
  }

  Map<String, dynamic> _parseUserMessage(String message) {
    final lower = message.toLowerCase();
    
    // Extract destination
    String? destination;
    final destinations = ['dhaka', 'cox\'s bazar', 'coxs bazar', 'sylhet', 'chittagong', 
      'sundarbans', 'rangamati', 'bandarban', 'srimangal', 'kuakata', 'sajek'];
    for (final dest in destinations) {
      if (lower.contains(dest)) {
        destination = dest.replaceAll('coxs', 'Cox\'s');
        destination = destination[0].toUpperCase() + destination.substring(1);
        break;
      }
    }
    
    // Extract budget
    double? budget;
    final budgetMatch = RegExp(r'(\d+)\s*(tk|taka|bdt)?', caseSensitive: false).firstMatch(lower);
    if (budgetMatch != null) {
      budget = double.tryParse(budgetMatch.group(1) ?? '');
    }
    
    // Extract days
    int? days;
    final daysMatch = RegExp(r'(\d+)\s*(day|days|night|nights)', caseSensitive: false).firstMatch(lower);
    if (daysMatch != null) {
      days = int.tryParse(daysMatch.group(1) ?? '');
    }
    if (lower.contains('weekend')) days = 2;
    if (lower.contains('week')) days = 7;
    
    // Extract interests
    List<String>? interests;
    final keywords = ['food', 'nature', 'beach', 'history', 'culture', 'adventure', 'shopping'];
    final found = keywords.where((k) => lower.contains(k)).toList();
    if (found.isNotEmpty) interests = found;
    
    return {'destination': destination, 'budget': budget, 'days': days, 'interests': interests};
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.planType != null ? '${widget.planType} Planner' : 'AI Travel Chat'),
        backgroundColor: const Color(0xFF2E7D5A),
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length + (_isLoading ? 1 : 0),
              itemBuilder: (context, index) {
                if (_isLoading && index == _messages.length) {
                  return _buildTypingIndicator();
                }
                return _buildMessageBubble(_messages[index]);
              },
            ),
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(_ChatMessage message) {
    return Align(
      alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.8),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: message.isUser ? const Color(0xFF2E7D5A) : Colors.grey[100],
          borderRadius: BorderRadius.circular(16).copyWith(
            bottomRight: message.isUser ? const Radius.circular(4) : null,
            bottomLeft: !message.isUser ? const Radius.circular(4) : null,
          ),
        ),
        child: SelectableText(
          message.text,
          style: TextStyle(
            color: message.isUser ? Colors.white : Colors.black87,
            fontSize: 15,
            height: 1.4,
          ),
        ),
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(16).copyWith(bottomLeft: const Radius.circular(4)),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFF2E7D5A))),
            SizedBox(width: 10),
            Text('Thinking...', style: TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.grey.withValues(alpha: 0.2), blurRadius: 4, offset: const Offset(0, -2))],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _messageController,
                decoration: InputDecoration(
                  hintText: 'Type your message...',
                  hintStyle: TextStyle(color: Colors.grey[400]),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(24), borderSide: BorderSide.none),
                  filled: true,
                  fillColor: Colors.grey[100],
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => _sendMessage(),
              ),
            ),
            const SizedBox(width: 8),
            CircleAvatar(
              radius: 24,
              backgroundColor: const Color(0xFF2E7D5A),
              child: IconButton(
                icon: Icon(_isLoading ? Icons.hourglass_empty : Icons.send, color: Colors.white),
                onPressed: _isLoading ? null : _sendMessage,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Simple chat message class
class _ChatMessage {
  final String text;
  final bool isUser;
  _ChatMessage({required this.text, required this.isUser});
}
