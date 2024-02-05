import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:file_selector/file_selector.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_gallery_saver/image_gallery_saver.dart';

import '../widgets/error_snack.dart';
import '../widgets/success_snack.dart';

class ImageController extends GetxController {
  var isLoading = false.obs;
  var imageUrl = ''.obs;
  var ignoreResult = false; // Flag to ignore the result
  var countdown = 10.obs; // Countdown observable
  Timer? _timer; // Timer for countdown
  var isSaveButtonDisabled = false.obs;

  void startCountdown() {
    countdown(10); // Set initial countdown value
    _timer?.cancel(); // Cancel any existing timer
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (countdown.value <= 1) {
        _timer?.cancel();
        countdown(0);
      } else {
        countdown(countdown.value - 1);
      }
    });
  }

  Future<void> saveImage(String imageNetworkUrl, String prompt) async {
    isSaveButtonDisabled(true);
    try {
      var response = await http.get(Uri.parse(imageNetworkUrl));
      if (response.statusCode == 200) {
        String sanitizedFileName = 'bpe_${sanitizeFileName(prompt)}.jpg';
        if (Platform.isAndroid || Platform.isIOS) {
          // Logic for mobile platforms
          final result = await ImageGallerySaver.saveImage(response.bodyBytes,
              name: sanitizedFileName, quality: 100);
          if (result['isSuccess']) {
            successSnack('Image saved to Photos');
          } else {
            errorSnack('Failed to save image 😕');
          }
        } else if (Platform.isMacOS || Platform.isWindows) {
          // Display file save dialog for desktop platforms
          final FileSaveLocation? saveLocation =
              await getSaveLocation(suggestedName: sanitizedFileName);
          if (saveLocation == null) {
            // User canceled the save dialog
            return;
          }

          final Uint8List fileData = response.bodyBytes;
          final XFile imageFile =
              XFile.fromData(fileData, name: sanitizedFileName);
          await imageFile.saveTo(saveLocation.path);
          successSnack('Image saved to ${saveLocation.path}');
        }
      } else {
        errorSnack('Failed to save image 😕');
      }
    } catch (e) {
      print(e);
      errorSnack('Failed to save image 😕' + e.toString());
    } finally {
      isSaveButtonDisabled(false);
    }
  }

  String sanitizeFileName(String name) {
    RegExp pattern = RegExp(r'[^a-zA-Z0-9\-_]');
    // Replace disallowed characters with a hyphen
    return name.replaceAll(pattern, '-');
  }

  Future<void> fetchImage(String prompt) async {
    isLoading(true);
    startCountdown();
    String apiKey = dotenv.env['OPENAI_API_KEY'] ?? 'default_api_key';
    String promptGuardrail =
        " Image generated MUST be appropriate for a younger audience - PG or G.";

    try {
      var response = await http.post(
        Uri.parse('https://api.openai.com/v1/images/generations'),
        headers: {
          'Authorization': 'Bearer $apiKey',
          'Content-Type': 'application/json'
        },
        body: jsonEncode({
          'prompt': prompt + promptGuardrail,
          'n': 1,
          'size': "1024x1024",
          'model': "dall-e-3"
        }),
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        imageUrl(data['data'][0]['url']); // Set the network URL directly
      } else {
        errorSnack('Failed to build banana 😕');
      }
    } catch (e) {
      errorSnack('Failed to build banana 😕');
    } finally {
      isLoading(false);
    }
  }

  @override
  void onClose() {
    _timer?.cancel(); // Cancel timer when controller is disposed
    super.onClose();
  }
}
