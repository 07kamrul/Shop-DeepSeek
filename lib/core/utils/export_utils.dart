import 'dart:io';
import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import '../../data/models/product_model.dart';
import '../../data/models/sale_model.dart';

class ExportUtils {
  static Future<String?> exportToCSV({
    required List<List<dynamic>> data,
    required String fileName,
  }) async {
    try {
      // For Android 10+, we use the downloads directory
      // For iOS, we use the documents directory
      Directory directory;

      if (Platform.isAndroid) {
        // Request storage permission for Android
        final status = await Permission.storage.status;
        if (!status.isGranted) {
          await Permission.storage.request();
        }

        if (!await Permission.storage.isGranted) {
          throw Exception('Storage permission denied');
        }

        // Try to get downloads directory, fallback to documents
        directory =
            await getDownloadsDirectory() ??
            await getApplicationDocumentsDirectory();
      } else if (Platform.isIOS) {
        // For iOS, use documents directory
        directory = await getApplicationDocumentsDirectory();
      } else {
        // For other platforms, use documents directory
        directory = await getApplicationDocumentsDirectory();
      }

      // Create exports subdirectory
      final exportsDir = Directory('${directory.path}/exports');
      if (!await exportsDir.exists()) {
        await exportsDir.create(recursive: true);
      }

      final file = File('${exportsDir.path}/$fileName.csv');
      final csvData = const ListToCsvConverter().convert(data);
      await file.writeAsString(csvData);

      return file.path;
    } catch (e) {
      throw Exception('Export failed: $e');
    }
  }

  // Enhanced export with share functionality
  static Future<void> exportAndShare({
    required List<List<dynamic>> data,
    required String fileName,
    required String subject,
    required String text,
  }) async {
    try {
      final filePath = await exportToCSVSimple(data: data, fileName: fileName);

      if (filePath != null) {
        final file = File(filePath);
        if (await file.exists()) {
          await Share.shareXFiles(
            [XFile(filePath)],
            subject: subject,
            text: text,
          );
        }
      }
    } catch (e) {
      throw Exception('Share failed: $e');
    }
  }

  // Quick export methods for different data types
  static Future<void> quickExportSales(List<Sale> sales) async {
    final data = prepareSalesData(sales);
    await exportAndShare(
      data: data,
      fileName: 'sales_export_${DateTime.now().millisecondsSinceEpoch}',
      subject: 'Sales Data Export',
      text: 'Sales data exported from Shop Management App',
    );
  }

  static Future<void> quickExportProducts(List<Product> products) async {
    final data = prepareProductsData(products);
    await exportAndShare(
      data: data,
      fileName: 'products_export_${DateTime.now().millisecondsSinceEpoch}',
      subject: 'Products Data Export',
      text: 'Products data exported from Shop Management App',
    );
  }

  static Future<void> quickExportInventory(List<Product> products) async {
    final data = prepareInventoryData(products);
    await exportAndShare(
      data: data,
      fileName: 'inventory_export_${DateTime.now().millisecondsSinceEpoch}',
      subject: 'Inventory Data Export',
      text: 'Inventory data exported from Shop Management App',
    );
  }

  // Alternative method for sharing files directly
  static Future<String?> exportToCSVInAppDirectory({
    required List<List<dynamic>> data,
    required String fileName,
  }) async {
    try {
      // Get application documents directory (works on all platforms)
      final directory = await getApplicationDocumentsDirectory();

      // Create exports subdirectory
      final exportsDir = Directory('${directory.path}/exports');
      if (!await exportsDir.exists()) {
        await exportsDir.create(recursive: true);
      }

      final file = File('${exportsDir.path}/$fileName.csv');
      final csvData = const ListToCsvConverter().convert(data);
      await file.writeAsString(csvData);

      return file.path;
    } catch (e) {
      throw Exception('Export failed: $e');
    }
  }

  // Method that works without storage permission (recommended)
  static Future<String?> exportToCSVSimple({
    required List<List<dynamic>> data,
    required String fileName,
  }) async {
    try {
      // Get temporary directory (no permissions needed)
      final directory = await getTemporaryDirectory();

      final file = File('${directory.path}/$fileName.csv');
      final csvData = const ListToCsvConverter().convert(data);
      await file.writeAsString(csvData);

      return file.path;
    } catch (e) {
      throw Exception('Export failed: $e');
    }
  }

  static List<List<dynamic>> prepareSalesData(List<Sale> sales) {
    final data = <List<dynamic>>[];

    // Header
    data.add([
      'Sale ID',
      'Date',
      'Customer',
      'Items Count',
      'Total Amount (₹)',
      'Total Profit (₹)',
      'Payment Method',
    ]);

    // Data
    for (final sale in sales) {
      data.add([
        sale.id?.substring(0, 8) ?? 'N/A',
        _formatDate(sale.dateTime),
        sale.customerName ?? 'Walk-in',
        sale.items.length,
        sale.totalAmount.toStringAsFixed(2),
        sale.totalProfit.toStringAsFixed(2),
        _capitalize(sale.paymentMethod),
      ]);
    }

    return data;
  }

  static List<List<dynamic>> prepareProductsData(List<Product> products) {
    final data = <List<dynamic>>[];

    // Header
    data.add([
      'Product Name',
      'Barcode',
      'Buying Price (₹)',
      'Selling Price (₹)',
      'Current Stock',
      'Min Stock',
      'Profit per Unit (₹)',
      'Profit Margin (%)',
    ]);

    // Data
    for (final product in products) {
      data.add([
        product.name,
        product.barcode ?? 'N/A',
        product.buyingPrice.toStringAsFixed(2),
        product.sellingPrice.toStringAsFixed(2),
        product.currentStock,
        product.minStockLevel,
        product.profitPerUnit.toStringAsFixed(2),
        product.profitMargin.toStringAsFixed(1),
      ]);
    }

    return data;
  }

  static List<List<dynamic>> prepareInventoryData(List<Product> products) {
    final data = <List<dynamic>>[];

    // Header
    data.add([
      'Product Name',
      'Current Stock',
      'Min Stock Level',
      'Status',
      'Buying Price (₹)',
      'Stock Value (₹)',
    ]);

    // Data
    for (final product in products) {
      final status = product.isLowStock ? 'Low Stock' : 'Adequate';
      final stockValue = product.currentStock * product.buyingPrice;

      data.add([
        product.name,
        product.currentStock,
        product.minStockLevel,
        status,
        product.buyingPrice.toStringAsFixed(2),
        stockValue.toStringAsFixed(2),
      ]);
    }

    return data;
  }

  // Helper method to format date
  static String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }

  // Helper method to capitalize first letter
  static String _capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }
}
