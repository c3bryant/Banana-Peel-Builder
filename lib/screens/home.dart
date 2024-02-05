import 'dart:math';

import 'package:bananapeel_eyeball/widgets/error_snack.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/image_controller.dart';
import '../widgets/custom_input_decoration.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  final ImageController controller = Get.put(ImageController());
  final TextEditingController promptController = TextEditingController();
  final FocusNode focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    focusNode.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    promptController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;
    double imageSize = min(min(deviceWidth, deviceHeight), 1024);
    double countdownFontSize = imageSize * 0.44;
    double buttonSize = 134;

    final bool isTablet = MediaQuery.of(context).size.shortestSide >= 600;
    if (!isTablet) {
      buttonSize = 84;
    }

    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: SafeArea(
        child: Scaffold(
          body: Obx(() {
            return SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 20),
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: imageSize),
                  child: Column(
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: const FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            'Banana  Peel  Builder',
                            style: TextStyle(
                              fontSize: 68,
                              fontFamily: 'BungeeSpice',
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(
                                  right: 16,
                                  bottom: 10,
                                  top: isTablet ? 0 : 16),
                              child: Stack(
                                children: [
                                  TextFormField(
                                    controller: promptController,
                                    enabled: !controller.isLoading.value,
                                    focusNode: focusNode,
                                    style: const TextStyle(
                                        fontSize: 28,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black), // Black text
                                    decoration: getCustomInputDecoration(
                                            'What to build?',
                                            focusNode.hasFocus,
                                            promptController.text.isEmpty)
                                        .copyWith(
                                      fillColor: controller.isLoading.value
                                          ? Colors.grey[500]
                                          : Colors
                                              .white, // Darker grey when disabled
                                      filled:
                                          true, // Enable the fillColor effect
                                      disabledBorder: const OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.grey, width: 1.0),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20)),
                                      ),
                                    ),
                                    textInputAction: TextInputAction.done,
                                    onFieldSubmitted: (value) {
                                      FocusScope.of(context)
                                          .unfocus(); // This will close the keyboard
                                    },
                                    keyboardType: TextInputType.multiline,
                                    minLines: isTablet ? 2 : 1,
                                    maxLines: null,
                                  ),
                                  Visibility(
                                    visible: focusNode.hasFocus,
                                    child: Positioned(
                                      top: 0,
                                      left: 0,
                                      child: ClipRRect(
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(20),
                                        ),
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 4),
                                          color: Colors
                                              .white, // Background color for the label
                                          child: const Text(
                                            'What to build?',
                                            style: TextStyle(
                                              backgroundColor: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            width: buttonSize,
                            height: buttonSize,
                            child: IconButton(
                              icon: Image.asset(controller.isLoading.value
                                  ? 'assets/images/build-disabled.png'
                                  : 'assets/images/build.png'),
                              onPressed: () {
                                if (!controller.isLoading.value) {
                                  String trimmedInput =
                                      promptController.text.trim();
                                  if (trimmedInput.isNotEmpty) {
                                    controller.imageUrl(
                                        ''); // Clear existing image URL
                                    controller.fetchImage(trimmedInput);
                                    FocusScope.of(context)
                                        .unfocus(); // Close the keyboard
                                  } else {
                                    errorSnack('Type idea then build it');
                                  }
                                }
                              },
                            ),
                          ),
                          SizedBox(
                            width: buttonSize,
                            height: buttonSize,
                            child: IconButton(
                              icon: controller.isLoading.value
                                  ? Image.asset(
                                      'assets/images/trash-disabled.png')
                                  : Image.asset('assets/images/trash.png'),
                              onPressed: () {
                                if (!controller.isLoading.value) {
                                  promptController.clear();
                                  controller.imageUrl('');
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Stack(
                        alignment: Alignment.topRight,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Container(
                              width: imageSize,
                              height: imageSize,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border:
                                    Border.all(color: Colors.white, width: 4),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: controller.isLoading.isTrue
                                  ? Center(
                                      child: Text(
                                        controller.countdown.value > 0
                                            ? controller.countdown.value
                                                .toString()
                                            : "!!!",
                                        style: TextStyle(
                                            fontSize: countdownFontSize,
                                            fontFamily: 'BungeeSpice',
                                            fontWeight: FontWeight.bold,
                                            color: Colors.yellow),
                                      ),
                                    )
                                  : (controller.imageUrl.isNotEmpty
                                      ? ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          child: Image(
                                            image: NetworkImage(
                                                controller.imageUrl.value),
                                            key: ValueKey(
                                                controller.imageUrl.value),
                                            width: imageSize,
                                            height: imageSize,
                                            fit: BoxFit.cover,
                                          ),
                                        )
                                      : const Center(
                                          child: Text(
                                          'Bananas will appear here',
                                          style: TextStyle(fontSize: 28),
                                        ))),
                            ),
                          ),
                          // Save button and other widgets that should overlay
                          controller.imageUrl.isNotEmpty
                              ? Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: IconButton(
                                    icon: Opacity(
                                      opacity:
                                          controller.isSaveButtonDisabled.value
                                              ? 0.4
                                              : 0.7,
                                      child: Image.asset(
                                          'assets/images/save-banana.png',
                                          width: 100,
                                          height: 100),
                                    ),
                                    onPressed:
                                        controller.isSaveButtonDisabled.value
                                            ? null
                                            : () {
                                                if (controller
                                                    .imageUrl.isNotEmpty) {
                                                  controller.saveImage(
                                                      controller.imageUrl.value,
                                                      promptController.text);
                                                }
                                              },
                                  ))
                              : Container(),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
