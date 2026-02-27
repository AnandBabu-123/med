import 'dart:convert';
import 'dart:io';

class ImageUtils {

  /// ✅ Convert image to BASE64 WITH PREFIX
  static Future<String> convertToBase64(File imageFile) async {
    try {

      print("===== IMAGE CONVERSION START =====");

      final bytes = await imageFile.readAsBytes();

      print("IMAGE BYTES LENGTH => ${bytes.length}");

      final base64Image = base64Encode(bytes);

      /// IMPORTANT 🔥 add prefix
      final finalImage =
          "data:image/jpeg;base64,$base64Image";

      print("BASE64 LENGTH => ${finalImage.length}");
      print("===== IMAGE CONVERSION END =====");

      return finalImage;

    } catch (e) {
      print("IMAGE CONVERT ERROR => $e");
      return "";
    }
  }
}