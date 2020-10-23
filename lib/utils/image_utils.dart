import 'package:camera/camera.dart';
import 'package:image/image.dart';

class ImageUtils {
  final shift = (0xFF << 24);
  Future<Image> convertYUV420toImageColor(CameraImage image) async {
    try {
      final int width = image.width;
      final int height = image.height;
      final int uvRowStride = image.planes[1].bytesPerRow;
      final int uvPixelStride = image.planes[1].bytesPerPixel;

      // imgLib -> Image package from https://pub.dartlang.org/packages/image
      Image img = Image(width, height); // Create Image buffer

      // Fill image buffer with plane[0] from YUV420_888
      int uvIndex, index, yp, up, vp, r, g, b;
      for (int x = 0; x < width; x++) {
        for (int y = 0; y < height; y++) {
          uvIndex =
              uvPixelStride * (x / 2).floor() + uvRowStride * (y / 2).floor();
          index = y * width + x;

          yp = image.planes[0].bytes[index];
          up = image.planes[1].bytes[uvIndex];
          vp = image.planes[2].bytes[uvIndex];
          // Calculate pixel color
          r = (yp + vp * 1436 / 1024 - 179).round().clamp(0, 255);
          g = (yp - up * 46549 / 131072 + 44 - vp * 93604 / 131072 + 91)
              .round()
              .clamp(0, 255);
          b = (yp + up * 1814 / 1024 - 227).round().clamp(0, 255);
          // color: 0x FF  FF  FF  FF
          //           A   B   G   R
          img.data[index] = shift | (b << 16) | (g << 8) | r;
        }
      }
      return img;
    } catch (e) {
      print(">>>>>>>>>>>> ERROR:" + e.toString());
    }
    return null;
  }

  static Future<List<double>> meanRGB(CameraImage image) async {
    try {
      final int width = image.width;
      final int height = image.height;
      final int uvRowStride = image.planes[1].bytesPerRow;
      final int uvPixelStride = image.planes[1].bytesPerPixel;
      final int n = width * height;

      // Fill image buffer with plane[0] from YUV420_888
      int uvIndex, index, yp, up, vp, r = 0, g = 0, b = 0;
      for (int x = 0; x < width; x++) {
        for (int y = 0; y < height; y++) {
          uvIndex =
              uvPixelStride * (x / 2).floor() + uvRowStride * (y / 2).floor();
          index = y * width + x;

          yp = image.planes[0].bytes[index];
          up = image.planes[1].bytes[uvIndex];
          vp = image.planes[2].bytes[uvIndex];
          // Calculate pixel color
          r += (yp + vp * 1436 / 1024 - 179).round().clamp(0, 255);
          g += (yp - up * 46549 / 131072 + 44 - vp * 93604 / 131072 + 91)
              .round()
              .clamp(0, 255);
          b += (yp + up * 1814 / 1024 - 227).round().clamp(0, 255);
          // color: 0x FF  FF  FF  FF
          //           A   B   G   R
        }
      }
      return [r / n, g / n, b / n];
    } catch (e) {
      print(">>>>>>>>>>>> ERROR:" + e.toString());
    }
    return null;
  }

  static Future<List<double>> meanG(CameraImage image) async {
    try {
      final int width = image.width;
      final int height = image.height;
      final int uvRowStride = image.planes[1].bytesPerRow;
      final int uvPixelStride = image.planes[1].bytesPerPixel;
      final int n = 25 * 25;

      // Fill image buffer with plane[0] from YUV420_888
      int uvIndex, index, yp, up, vp, g1 = 0, g2 = 0, g3 = 0, g4 = 0;
      for (int x = 0; x < 25; x++) {
        for (int y = 0; y < 25; y++) {
          uvIndex =
              uvPixelStride * (x / 2).floor() + uvRowStride * (y / 2).floor();
          index = y * width + x;

          yp = image.planes[0].bytes[index];
          up = image.planes[1].bytes[uvIndex];
          vp = image.planes[2].bytes[uvIndex];
          g1 += (yp - up * 46549 / 131072 + 44 - vp * 93604 / 131072 + 91)
              .round()
              .clamp(0, 255);
        }

        for (int y = (height - 1) - 25; y < height; y++) {
          uvIndex =
              uvPixelStride * (x / 2).floor() + uvRowStride * (y / 2).floor();
          index = y * width + x;

          yp = image.planes[0].bytes[index];
          up = image.planes[1].bytes[uvIndex];
          vp = image.planes[2].bytes[uvIndex];
          g2 += (yp - up * 46549 / 131072 + 44 - vp * 93604 / 131072 + 91)
              .round()
              .clamp(0, 255);
        }
      }
      for (int x = (width - 1) - 25; x < width; x++) {
        for (int y = 0; y < 25; y++) {
          uvIndex =
              uvPixelStride * (x / 2).floor() + uvRowStride * (y / 2).floor();
          index = y * width + x;

          yp = image.planes[0].bytes[index];
          up = image.planes[1].bytes[uvIndex];
          vp = image.planes[2].bytes[uvIndex];
          g3 += (yp - up * 46549 / 131072 + 44 - vp * 93604 / 131072 + 91)
              .round()
              .clamp(0, 255);
        }

        for (int y = (height - 1) - 25; y < height; y++) {
          uvIndex =
              uvPixelStride * (x / 2).floor() + uvRowStride * (y / 2).floor();
          index = y * width + x;

          yp = image.planes[0].bytes[index];
          up = image.planes[1].bytes[uvIndex];
          vp = image.planes[2].bytes[uvIndex];
          g4 += (yp - up * 46549 / 131072 + 44 - vp * 93604 / 131072 + 91)
              .round()
              .clamp(0, 255);
        }
      }

      return [g1 / n, g2 / n, g3 / n, g4 / n];
    } catch (e) {
      print(">>>>>>>>>>>> ERROR:" + e.toString());
    }
    return null;
  }

  static Future<List<double>> meanRG(CameraImage image) async {
    try {
      final int width = image.width;
      final int height = image.height;
      final int uvRowStride = image.planes[1].bytesPerRow;
      final int uvPixelStride = image.planes[1].bytesPerPixel;
      final int n = 25 * 25;

      // Fill image buffer with plane[0] from YUV420_888
      int uvIndex,
          index,
          yp,
          up,
          vp,
          r1 = 0,
          r2 = 0,
          r3 = 0,
          r4 = 0,
          g1 = 0,
          g2 = 0,
          g3 = 0,
          g4 = 0;
      for (int x = 0; x < 25; x++) {
        for (int y = 0; y < 25; y++) {
          uvIndex =
              uvPixelStride * (x / 2).floor() + uvRowStride * (y / 2).floor();
          index = y * width + x;

          yp = image.planes[0].bytes[index];
          up = image.planes[1].bytes[uvIndex];
          vp = image.planes[2].bytes[uvIndex];
          r1 += (yp + vp * 1436 / 1024 - 179).round().clamp(0, 255);
          g1 += (yp - up * 46549 / 131072 + 44 - vp * 93604 / 131072 + 91)
              .round()
              .clamp(0, 255);
        }

        for (int y = (height - 1) - 25; y < height; y++) {
          uvIndex =
              uvPixelStride * (x / 2).floor() + uvRowStride * (y / 2).floor();
          index = y * width + x;

          yp = image.planes[0].bytes[index];
          up = image.planes[1].bytes[uvIndex];
          vp = image.planes[2].bytes[uvIndex];
          r2 += (yp + vp * 1436 / 1024 - 179).round().clamp(0, 255);
          g2 += (yp - up * 46549 / 131072 + 44 - vp * 93604 / 131072 + 91)
              .round()
              .clamp(0, 255);
        }
      }
      for (int x = (width - 1) - 25; x < width; x++) {
        for (int y = 0; y < 25; y++) {
          uvIndex =
              uvPixelStride * (x / 2).floor() + uvRowStride * (y / 2).floor();
          index = y * width + x;

          yp = image.planes[0].bytes[index];
          up = image.planes[1].bytes[uvIndex];
          vp = image.planes[2].bytes[uvIndex];
          r3 += (yp + vp * 1436 / 1024 - 179).round().clamp(0, 255);
          g3 += (yp - up * 46549 / 131072 + 44 - vp * 93604 / 131072 + 91)
              .round()
              .clamp(0, 255);
        }

        for (int y = (height - 1) - 25; y < height; y++) {
          uvIndex =
              uvPixelStride * (x / 2).floor() + uvRowStride * (y / 2).floor();
          index = y * width + x;

          yp = image.planes[0].bytes[index];
          up = image.planes[1].bytes[uvIndex];
          vp = image.planes[2].bytes[uvIndex];
          r4 += (yp + vp * 1436 / 1024 - 179).round().clamp(0, 255);
          g4 += (yp - up * 46549 / 131072 + 44 - vp * 93604 / 131072 + 91)
              .round()
              .clamp(0, 255);
        }
      }

      return [r1 / n, r2 / n, r3 / n, r4 / n, g1 / n, g2 / n, g3 / n, g4 / n];
    } catch (e) {
      print(">>>>>>>>>>>> ERROR:" + e.toString());
    }
    return null;
  }
}
