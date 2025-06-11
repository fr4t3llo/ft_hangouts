import 'package:flutter/material.dart';
import 'package:ft_hangouts/pages/components/change_appbar_color.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:ft_hangouts/pages/components/message.dart';
import 'package:ft_hangouts/pages/components/message_provider.dart';
import 'package:ft_hangouts/providers/app_lifecycle_provider.dart';
import 'package:ft_hangouts/db/database_helper.dart';

import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:ft_hangouts/translations/locale_keys.g.dart';
import 'package:iconsax/iconsax.dart';
import 'dart:io' show Platform;
import 'package:telephony/telephony.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:url_launcher/url_launcher.dart';

class MessagePage extends StatefulWidget {
  final Contact contact;

  const MessagePage({
    super.key,
    required this.contact,
  });

  @override
  State<MessagePage> createState() => _MessagePageState();
}


class _MessagePageState extends State<MessagePage> with WidgetsBindingObserver {
  final TextEditingController _messageController = TextEditingController();
  late final Telephony? telephony;
  bool _isLoadingMessages = true;
  late MessageProvider _messageProvider;
  bool _isAndroid = false;
  int _backgroundTime = 0;
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    // Check if running on Android
    _checkPlatform();

    // Initialize message provider
    _messageProvider = Provider.of<MessageProvider>(context, listen: false);
    _loadMessages();

    // Only request SMS permissions on Android
    if (_isAndroid) {
      _requestSmsPermissions();
    }

    _loadBackgroundTime();
    // Set this contact as the current contact for background time tracking
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.contact.id != null) {
        context.read<AppLifecycleProvider>().setCurrentContact(int.parse(widget.contact.id!));
      }
    });
  }

  void _checkPlatform() {
    try {
      _isAndroid = Platform.isAndroid;
      if (_isAndroid) {
        telephony = Telephony.instance;
      } else {
        telephony = null;
      }
    } catch (e) {
      // Running on web or other platforms that don't support dart:io
      _isAndroid = false;
      telephony = null;
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      // App is going to background
      _messageProvider.recordBackgroundTime();
    } else if (state == AppLifecycleState.resumed) {
      // App is coming back to foreground
      _showBackgroundTimeDialog();
    }
  }

  Future<void> _loadMessages() async {
    setState(() {
      _isLoadingMessages = true;
    });

    // Get messages for this contact
    await _messageProvider.initialize();

    if (mounted) {
      setState(() {
        _isLoadingMessages = false;
      });
    }
  }

  Future<void> _requestSmsPermissions() async {
    if (!_isAndroid) return;

    // Request SMS permissions
    await Permission.sms.request();

    // Set up SMS listener
    telephony!.listenIncomingSms(
      onNewMessage: (SmsMessage message) {
        // Check if message is from this contact
        final contactPhones = widget.contact.phones
            .map((phone) => phone.number.replaceAll(RegExp(r'[\s\-\(\)]'), ''))
            .toList();

        final normalizedSender =
            message.address?.replaceAll(RegExp(r'[\s\-\(\)]'), '') ?? '';

        if (contactPhones.contains(normalizedSender)) {
          _messageProvider.addMessage(
            Message(
              date: DateTime.now(),
              text: message.body ?? "Empty message",
              sentByMe: false,
              contactId: widget.contact.id,
            ),
          );
        }
      },
      listenInBackground: false,
    );
  }

  Future<void> _loadBackgroundTime() async {
    if (widget.contact.id != null) {
      final contact = await _dbHelper.getContact(widget.contact.id!);
      if (contact != null) {
        setState(() {
          _backgroundTime = (contact['total_background_time'] as int?) ?? 0;
        });
      }
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _showBackgroundTimeDialog() async {
    final lastBackgroundTime = _messageProvider.lastBackgroundTime;
    if (lastBackgroundTime != null) {
      final now = DateTime.now();
      final difference = now.difference(lastBackgroundTime);

      if (difference.inSeconds > 5) {
        // Only show if app was in background for more than 5 seconds
        await Future.delayed(const Duration(milliseconds: 500)); // Short delay to let UI settle
        if (!mounted) return;

        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(LocaleKeys.app_background_time.tr()),
            content: Text(
              difference.inMinutes > 0
                  ? LocaleKeys.app_in_background_for_minutes
                      .tr(args: [difference.inMinutes.toString()])
                  : LocaleKeys.app_in_background_for_seconds
                      .tr(args: [difference.inSeconds.toString()]),
              style: const TextStyle(fontFamily: 'my'),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(LocaleKeys.ok.tr()),
              ),
            ],
          ),
        );
      }
    }
  }

  void _sendMessage() async {
    final messageText = _messageController.text.trim();
    if (messageText.isEmpty) return;

    // Get contact phone number
    if (widget.contact.phones.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(LocaleKeys.no_phone_number_available.tr()),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final phoneNumber = widget.contact.phones.first.number;
    final formattedNumber = phoneNumber.replaceAll(RegExp(r'[\s\-\(\)]'), '');

    // Add message to history first (so it appears immediately in UI)
    final newMessage = Message(
      date: DateTime.now(),
      text: messageText,
      sentByMe: true,
      contactId: widget.contact.id,
    );
    await _messageProvider.addMessage(newMessage);

    // Try to send the actual SMS based on platform
    if (_isAndroid && telephony != null) {
      // Use Telephony package for Android
      try {
        await telephony!.sendSms(
          to: formattedNumber,
          message: messageText,
        );
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error sending SMS: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } else {
      // Use url_launcher for iOS
      final Uri smsUri = Uri.parse(
          'sms:$formattedNumber&body=${Uri.encodeComponent(messageText)}');

      try {
        if (await canLaunchUrl(smsUri)) {
          await launchUrl(smsUri);
        } else {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(LocaleKeys.could_not_open_messages_app.tr()),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${LocaleKeys.error_opening_messages.tr()} $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }

    // Clear the text field after sending
    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final contact = widget.contact;
    final lifecycleProvider = context.watch<AppLifecycleProvider>();
    final currentBackgroundTime = contact.id != null
        ? lifecycleProvider.getBackgroundTimeForContact(contact.id!)
        : 0;
        
    final totalBackgroundTime = _backgroundTime + currentBackgroundTime;

    String formatDuration(int seconds) {
      final hours = seconds ~/ 3600;
      final minutes = (seconds % 3600) ~/ 60;
      final remainingSeconds = seconds % 60;
      return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
    }



    return Consumer<AppBarColorProvider>(
      builder: (context, appBarColorProvider, child) {
        return Scaffold(
          backgroundColor: Colors.grey[100],
          appBar: AppBar(
            backgroundColor: appBarColorProvider.appBarColor,
            leading: IconButton(
              icon: const Icon(Iconsax.back_square, color: Colors.black),
              onPressed: () => Navigator.pop(context),
            ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${widget.contact.displayName}',
                  style: const TextStyle(
                    fontFamily: 'my',
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                // Add background time display
                Text(
                  '${LocaleKeys.app_background_time.tr()}: ${formatDuration(totalBackgroundTime)}',
                  style: const TextStyle(
                    fontFamily: 'my',
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          body: SafeArea(
            child: _isLoadingMessages
                ? const Center(child: CircularProgressIndicator())
                : Consumer<MessageProvider>(
                    builder: (context, messageProvider, child) {
                      final messages = messageProvider
                          .getMessagesForContact(widget.contact.id);

                      return Column(
                        children: [
                          Expanded(
                            child: messages.isEmpty
                                ? Center(
                                    child: Text(
                                      LocaleKeys.no_messages_yet.tr(),
                                      style: const TextStyle(
                                        fontFamily: 'my',
                                        color: Colors.grey,
                                      ),
                                    ),
                                  )
                                : GroupedListView<Message, DateTime>(
                                    elements: messages,
                                    padding: const EdgeInsets.all(8),
                                    reverse:
                                        true, // Display most recent messages at the bottom
                                    order: GroupedListOrder
                                        .DESC, // Newest date first
                                    groupBy: (message) => DateTime(
                                      message.date.year,
                                      message.date.month,
                                      message.date.day,
                                    ),
                                    groupSeparatorBuilder: (DateTime date) =>
                                        Center(
                                      child: Container(
                                        margin: const EdgeInsets.symmetric(
                                            vertical: 8),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.grey[300],
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: Text(
                                          _getFormattedDate(date),
                                          style: const TextStyle(
                                            fontFamily: 'my',
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                    itemBuilder: (context, Message message) =>
                                        Align(
                                      alignment: message.sentByMe
                                          ? Alignment.centerRight
                                          : Alignment.centerLeft,
                                      child: Container(
                                        margin: const EdgeInsets.symmetric(
                                          vertical: 4,
                                          horizontal: 8,
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 10,
                                          horizontal: 14,
                                        ),
                                        decoration: BoxDecoration(
                                          color: message.sentByMe
                                              ? Colors.blue[400]
                                              : Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(16),
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.grey.withOpacity(0.2),
                                              spreadRadius: 1,
                                              blurRadius: 2,
                                              offset: const Offset(0, 1),
                                            ),
                                          ],
                                        ),
                                        child: Column(
                                          crossAxisAlignment: message.sentByMe
                                              ? CrossAxisAlignment.end
                                              : CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              message.text,
                                              style: TextStyle(
                                                color: message.sentByMe
                                                    ? Colors.white
                                                    : Colors.black,
                                                fontFamily: 'my',
                                                fontSize: 16,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              DateFormat('HH:mm')
                                                  .format(message.date),
                                              style: TextStyle(
                                                color: message.sentByMe
                                                    ? Colors.white
                                                        .withOpacity(0.8)
                                                    : Colors.grey,
                                                fontFamily: 'my',
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8.0,
                              vertical: 8.0,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.2),
                                  spreadRadius: 1,
                                  blurRadius: 2,
                                  offset: const Offset(0, -1),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: _messageController,
                                    decoration: InputDecoration(
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 12,
                                      ),
                                      hintText:
                                          LocaleKeys.type_your_message.tr(),
                                      hintStyle:
                                          const TextStyle(fontFamily: 'my'),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(24),
                                        borderSide: BorderSide.none,
                                      ),
                                      filled: true,
                                      fillColor: Colors.grey[100],
                                    ),
                                    style: const TextStyle(fontFamily: 'my'),
                                    maxLines: null, // Allow multiple lines
                                    textCapitalization:
                                        TextCapitalization.sentences,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                FloatingActionButton(
                                  onPressed: _sendMessage,
                                  mini: true,
                                  backgroundColor: Colors.blue[400],
                                  elevation: 0,
                                  child: const Icon(
                                    Icons.send_rounded,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  ),
          ),
        );
      },
    );
  }

  String _getFormattedDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));

    if (date == today) {
      return LocaleKeys.today.tr();
    } else if (date == yesterday) {
      return LocaleKeys.yesterday.tr();
    } else {
      return DateFormat.yMMMd().format(date);
    }
  }
}
