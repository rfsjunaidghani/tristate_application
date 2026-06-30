import 'dart:io';
import 'package:image/image.dart' as img;

/// Generates a padded version of the splash logo for the Android 12+ splash
/// screen, which forces the image into a fixed circular icon slot.
///
/// Android 12 spec: a 1152x1152 canvas where the visible content must fit
/// within a centered circle ~768px in diameter. We place the logo at 700px so
/// the full circular logo stays inside the safe zone (no cropping / zoom).
///
/// Run with: dart run tool/pad_splash.dart
void main() {
  const String srcPath = 'assets/images/launch_screen.png';
  const String outPath = 'assets/images/launch_screen_android12.png';
  const int canvasSize = 1152;
  const int logoSize = 700;

  final img.Image? src = img.decodePng(File(srcPath).readAsBytesSync());
  if (src == null) {
    stderr.writeln('Could not decode $srcPath');
    exit(1);
  }

  // Transparent canvas.
  final img.Image canvas =
      img.Image(width: canvasSize, height: canvasSize, numChannels: 4);

  // Scale the logo down and composite it centered.
  final img.Image logo = img.copyResize(
    src,
    width: logoSize,
    height: logoSize,
    interpolation: img.Interpolation.cubic,
  );
  final int offset = (canvasSize - logoSize) ~/ 2;
  img.compositeImage(canvas, logo, dstX: offset, dstY: offset);

  File(outPath).writeAsBytesSync(img.encodePng(canvas));
  stdout.writeln('Wrote $outPath (${canvasSize}x$canvasSize, logo ${logoSize}px)');
}
