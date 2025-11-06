import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:permission_handler/permission_handler.dart';

class BarcodeScannerUtil {
  static Future<String?> scanBarcode() async {
    try {
      // Check and request camera permission
      final status = await Permission.camera.status;
      if (!status.isGranted) {
        await Permission.camera.request();
      }

      if (await Permission.camera.isGranted) {
        final ScanResult result = await BarcodeScanner.scan();
        return result.rawContent.isNotEmpty ? result.rawContent : null;
      } else {
        throw Exception('Camera permission denied');
      }
    } catch (e) {
      throw Exception('Barcode scan failed: $e');
    }
  }
}
