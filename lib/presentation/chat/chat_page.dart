import 'dart:async';
import 'package:deeds/core/constants/text.dart';
import 'package:deeds/presentation/chat/chat_controller.dart';
import 'package:deeds/presentation/widgets/card_widget.dart';
import 'package:deeds/presentation/widgets/icon_btn_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../core/constants/colors.dart';
import '../../domain/repositories/chat_repo.dart';
import '../widgets/background.dart';

class ChatPage extends StatelessWidget {
  final ChatController controller =
      Get.put(ChatController(Get.find<ChatRepository>()));
  final TextEditingController textController = TextEditingController();

  ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Theme(
        data: Theme.of(context).copyWith(
          drawerTheme: DrawerThemeData(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(0.r),
            ),
          ),
        ),
        child: Drawer(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 50.h,
                ),
                Text(
                  'Saved Chats',
                  style: AppTextStyles.midBoldText,
                ),
                Divider(
                  color: AppColors.primary,
                ),
                Expanded(
                  child: Obx(
                    () => controller.savedChats.isEmpty
                        ? Center(
                            child: Text(
                              'No saved chats',
                              style: AppTextStyles.smallMidText,
                            ),
                          )
                        : ListView.builder(
                            itemCount: controller.savedChats.length,
                            itemBuilder: (context, index) {
                              final chat = controller.savedChats[index];
                              return Dismissible(
                                key: Key(chat.id),
                                direction: DismissDirection.endToStart,
                                background: Container(
                                  color: Colors.red,
                                  alignment: Alignment.centerRight,
                                  padding: EdgeInsets.only(right: 20.w),
                                  child: const Icon(
                                    Icons.delete,
                                    color: Colors.white,
                                  ),
                                ),
                                onDismissed: (direction) {
                                  controller.deleteChat(chat.id);
                                },
                                child: ListTile(
                                  title: Text(
                                    chat.title,
                                    style: AppTextStyles.smallMidText,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  subtitle: Text(
                                    DateFormat('MMM dd, yyyy - hh:mm a')
                                        .format(chat.timestamp),
                                    style: AppTextStyles.smallMidText.copyWith(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  onTap: () {
                                    controller.loadChat(chat);
                                    Navigator.pop(context);
                                  },
                                ),
                              );
                            },
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          const Background(),
          Column(
            children: [
              //app bar
              Container(
                width: MediaQuery.of(context).size.width,
                height: 60.h,
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                margin: EdgeInsets.only(top: 30.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        IconButtonWidget(
                          onTap: () {
                            Get.back();
                          },
                          icon: const Icon(
                            CupertinoIcons.back,
                          ),
                        ),
                        SizedBox(
                          width: 10.w,
                        ),
                        Text(
                          "Bilel",
                          style: AppTextStyles.mediumBoldText.copyWith(),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        //new chat button
                        IconButtonWidget(
                          onTap: () {
                            controller.startNewChat();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Started a new chat'),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          },
                          icon: const Icon(
                            CupertinoIcons.add_circled,
                          ),
                        ),
                        //saved chats button
                        Builder(
                          builder: (context) => IconButtonWidget(
                            onTap: () {
                              Scaffold.of(context).openDrawer();
                            },
                            icon: const Icon(
                              CupertinoIcons.collections,
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              Expanded(
                child: Obx(() {
                  // Scroll to the bottom when messages update
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    controller.scrollToBottom();
                  });
                  return controller.messages.isEmpty
                      ? Column(
                          children: [
                            SizedBox(
                              height: 30.w,
                            ),
                            SizedBox(
                              width: 300.w,
                              child: TypingText(
                                text:
                                    "Hello I'm Bilel, an AI companion that helps you with your questions about Islam. Ask me anything!",
                                speed: const Duration(milliseconds: 10),
                                textStyle: AppTextStyles.smallBoldText,
                              ),
                            ),
                          ],
                        )
                      : ListView.separated(
                          padding: const EdgeInsets.all(16),
                          controller: controller
                              .scrollController, // Attach ScrollController
                          separatorBuilder: (context, index) {
                            return SizedBox(
                              height: 10.h,
                            );
                          },
                          itemCount: controller.messages.length,
                          itemBuilder: (context, index) {
                            final msg = controller.messages[index];
                            final isUser = msg['role'] == 'user';
                            return Align(
                              alignment: isUser
                                  ? Alignment.centerRight
                                  : Alignment.centerLeft,
                              child: Container(
                                constraints: BoxConstraints(
                                  maxWidth: 300.w,
                                ),
                                margin: const EdgeInsets.symmetric(vertical: 4),
                                padding: EdgeInsets.symmetric(
                                  horizontal: 20.w,
                                  vertical: 10.h,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5.r),
                                  border: Border.all(
                                    color: isUser
                                        ? AppColors.secondary
                                        : Colors.grey,
                                    width: 0.5,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.white.withAlpha(50),
                                      spreadRadius: 0,
                                      blurRadius: 0,
                                      offset: const Offset(-3.5, -3.5),
                                    ),
                                    BoxShadow(
                                      color: Colors.white.withAlpha(50),
                                      spreadRadius: 0,
                                      blurRadius: 0,
                                      offset: const Offset(3.5, 3.5),
                                    ),
                                  ],
                                ),
                                child: Text(
                                  msg['content']!,
                                  style: AppTextStyles.smallMidText.copyWith(
                                    color: isUser
                                        ? AppColors.secondary
                                        : Colors.black54,
                                  ),
                                  // TextStyle(
                                  //   color: isUser ? Colors.white : Colors.black,
                                  // ),
                                ),
                              ),
                            );
                          },
                        );
                }),
              ),
              SizedBox(
                height: 50.h,
                width: MediaQuery.of(context).size.width,
                child: ListView.separated(
                  padding: EdgeInsets.symmetric(horizontal: 15.w),
                  itemCount: controller.topicSuggestions.keys.length,
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  separatorBuilder: (context, index) {
                    return SizedBox(
                      width: 10.w,
                    );
                  },
                  itemBuilder: (context, index) {
                    final topic =
                        controller.topicSuggestions.keys.toList()[index];
                    return InkWell(
                      onTap: () {
                        controller.sendMessage(
                            controller.topicSuggestions.values.toList()[index]);
                      },
                      child: Container(
                        constraints: BoxConstraints(
                          minWidth: 100.w,
                          maxWidth: 150.w,
                        ),
                        child: CardWidget(
                          padding: EdgeInsets.symmetric(horizontal: 10.w),
                          content: SizedBox(
                            width: double.infinity,
                            child: Center(
                              child: Text(
                                topic,
                                style: AppTextStyles.smallMidText.copyWith(
                                  color: AppColors.secondary,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(
                height: 85.h,
              ),
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(
                bottom: 10.h,
                left: 15.w,
                right: 15.w,
              ),
              child: SizedBox(
                height: 65.h,
                child: CardWidget(
                  width: MediaQuery.of(context).size.width,
                  height: 65.h,
                  padding: const EdgeInsets.symmetric(),
                  content: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: TextField(
                            controller: textController,
                            style: AppTextStyles.smallMidText.copyWith(
                              color: AppColors.primary,
                            ),
                            cursorColor: AppColors.blackColor,
                            decoration: InputDecoration(
                              hintText: "Ask me about Islam.",
                              hintStyle: AppTextStyles.smallMidText.copyWith(
                                color: AppColors.cardBgColor,
                              ),
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 20.w),
                              border: InputBorder.none,
                              errorBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                            ),
                          ),
                        ),
                        Obx(
                          () => IconButton(
                            icon: Icon(
                              Icons.send,
                              color: AppColors.cardBgColor,
                            ),
                            onPressed: controller.isLoading.value
                                ? null
                                : () {
                                    controller.sendMessage(textController.text);
                                    textController.clear();
                                  },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TypingText extends StatefulWidget {
  final String text;
  final TextStyle? textStyle;
  final Duration speed;

  const TypingText({
    Key? key,
    required this.text,
    this.textStyle,
    this.speed = const Duration(milliseconds: 50),
  }) : super(key: key);

  @override
  _TypingTextState createState() => _TypingTextState();
}

class _TypingTextState extends State<TypingText> {
  String displayedText = "";
  int index = 0;

  @override
  void initState() {
    super.initState();
    startTyping();
  }

  void startTyping() {
    Timer.periodic(widget.speed, (timer) {
      if (index < widget.text.length) {
        setState(() {
          displayedText += widget.text[index];
          index++;
        });
      } else {
        timer.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      displayedText,
      textAlign: TextAlign.center,
      style: widget.textStyle ??
          const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
    );
  }
}
