import 'package:flutter/material.dart';
import '../themes/wellness_colors.dart';
import '../themes/wellness_theme.dart';

/// AI Assistant Avatar - Friendly, animated, always visible companion
/// Features: Mood expressions, gentle animations, contextual responses
class AiAssistantAvatar extends StatefulWidget {
  final String mood; // 'happy', 'thinking', 'encouraging', 'celebrating'
  final double size;
  final String message;
  final VoidCallback? onTap;
  final bool showPulse;

  const AiAssistantAvatar({
    Key? key,
    this.mood = 'happy',
    this.size = 56,
    this.message = '',
    this.onTap,
    this.showPulse = true,
  }) : super(key: key);

  @override
  State<AiAssistantAvatar> createState() => _AiAssistantAvatarState();
}

class _AiAssistantAvatarState extends State<AiAssistantAvatar>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _floatController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _floatAnimation;

  @override
  void initState() {
    super.initState();

    // Gentle pulse animation for attention
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.08,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    // Subtle floating animation for liveliness
    _floatController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );
    _floatAnimation = Tween<double>(
      begin: -2.0,
      end: 2.0,
    ).animate(CurvedAnimation(
      parent: _floatController,
      curve: Curves.easeInOut,
    ));

    if (widget.showPulse) {
      _pulseController.repeat(reverse: true);
    }
    _floatController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _floatController.dispose();
    super.dispose();
  }

  IconData get _moodIcon {
    switch (widget.mood) {
      case 'thinking':
        return Icons.psychology_alt_rounded;
      case 'encouraging':
        return Icons.favorite_rounded;
      case 'celebrating':
        return Icons.celebration_rounded;
      case 'sleeping':
        return Icons.bedtime_rounded;
      default:
        return Icons.psychology_rounded; // Default happy/smart
    }
  }

  List<Color> get _moodGradient {
    switch (widget.mood) {
      case 'thinking':
        return [WellnessColors.secondaryBlue, WellnessColors.lavenderBlue];
      case 'encouraging':
        return [WellnessColors.primaryGreen, WellnessColors.mintGreen];
      case 'celebrating':
        return [WellnessColors.sunsetOrange, WellnessColors.accentPeach];
      case 'sleeping':
        return [WellnessColors.lavenderBlue, WellnessColors.textTertiary];
      default:
        return WellnessColors.aiAvatarGradient;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Assistant IA Nutrition - ${widget.mood}',
      hint:
          widget.message.isNotEmpty ? widget.message : 'Touchez pour interagir',
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedBuilder(
          animation: Listenable.merge([_pulseController, _floatController]),
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(0, _floatAnimation.value),
              child: Transform.scale(
                scale: widget.showPulse ? _pulseAnimation.value : 1.0,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Outer glow effect
                    Container(
                      width: widget.size + 16,
                      height: widget.size + 16,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            _moodGradient.first.withOpacity(0.3),
                            _moodGradient.first.withOpacity(0.1),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),

                    // Main avatar container
                    Container(
                      width: widget.size,
                      height: widget.size,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: _moodGradient,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: _moodGradient.first.withOpacity(0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Icon(
                        _moodIcon,
                        color: Colors.white,
                        size: widget.size * 0.5,
                        semanticLabel: 'Icône assistant IA',
                      ),
                    ),

                    // Notification dot for new messages
                    if (widget.message.isNotEmpty)
                      Positioned(
                        top: 0,
                        right: 0,
                        child: Container(
                          width: 16,
                          height: 16,
                          decoration: const BoxDecoration(
                            color: WellnessColors.errorCoral,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.chat_bubble_rounded,
                            color: Colors.white,
                            size: 10,
                            semanticLabel: 'Nouveau message',
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

/// AI Assistant Chat Bubble - Friendly conversation interface
class AiChatBubble extends StatefulWidget {
  final String message;
  final bool isFromAi;
  final DateTime timestamp;
  final VoidCallback? onTap;

  const AiChatBubble({
    Key? key,
    required this.message,
    required this.isFromAi,
    required this.timestamp,
    this.onTap,
  }) : super(key: key);

  @override
  State<AiChatBubble> createState() => _AiChatBubbleState();
}

class _AiChatBubbleState extends State<AiChatBubble>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOutBack),
    ));

    _slideAnimation = Tween<Offset>(
      begin: widget.isFromAi ? const Offset(-0.3, 0) : const Offset(0.3, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.2, 1.0, curve: Curves.easeOut),
    ));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: WellnessSpacing.md,
        vertical: WellnessSpacing.xs,
      ),
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return SlideTransition(
            position: _slideAnimation,
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: Row(
                mainAxisAlignment: widget.isFromAi
                    ? MainAxisAlignment.start
                    : MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.isFromAi) ...[
                    const AiAssistantAvatar(
                      size: 32,
                      showPulse: false,
                    ),
                    const SizedBox(width: WellnessSpacing.sm),
                  ],
                  Flexible(
                    child: GestureDetector(
                      onTap: widget.onTap,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: WellnessSpacing.md,
                          vertical: WellnessSpacing.sm,
                        ),
                        decoration: BoxDecoration(
                          color: widget.isFromAi
                              ? WellnessColors.backgroundSecondary
                              : WellnessColors.primaryGreen,
                          borderRadius: BorderRadius.only(
                            topLeft:
                                const Radius.circular(WellnessBorderRadius.lg),
                            topRight:
                                const Radius.circular(WellnessBorderRadius.lg),
                            bottomLeft: widget.isFromAi
                                ? const Radius.circular(WellnessBorderRadius.xs)
                                : const Radius.circular(
                                    WellnessBorderRadius.lg),
                            bottomRight: widget.isFromAi
                                ? const Radius.circular(WellnessBorderRadius.lg)
                                : const Radius.circular(
                                    WellnessBorderRadius.xs),
                          ),
                          boxShadow: WellnessShadows.soft,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.message,
                              style: WellnessTypography.bodyMedium.copyWith(
                                color: widget.isFromAi
                                    ? WellnessColors.textPrimary
                                    : Colors.white,
                              ),
                            ),
                            const SizedBox(height: WellnessSpacing.xs),
                            Text(
                              _formatTime(widget.timestamp),
                              style: WellnessTypography.labelMedium.copyWith(
                                color: widget.isFromAi
                                    ? WellnessColors.textTertiary
                                    : Colors.white.withOpacity(0.7),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  if (!widget.isFromAi) ...[
                    const SizedBox(width: WellnessSpacing.sm),
                    CircleAvatar(
                      radius: 16,
                      backgroundColor: WellnessColors.accentPeach,
                      child: const Icon(
                        Icons.person_rounded,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return 'À l\'instant';
    } else if (difference.inHours < 1) {
      return 'Il y a ${difference.inMinutes}min';
    } else if (difference.inDays < 1) {
      return 'Il y a ${difference.inHours}h';
    } else {
      return '${dateTime.day}/${dateTime.month}';
    }
  }
}
