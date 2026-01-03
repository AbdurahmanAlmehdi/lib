// /// Service prices constants
// class ServicePrices {
//   ServicePrices._();

//   // Service prices in Libyan Dinars (د.ل)
//   static const double carCleaning = 50.0; // تنظيف السيارات
//   static const double homeCleaning = 100.0; // تنظيف المنازل
//   static const double carpetCleaning = 70.0; // تنظيف السجاد
//   static const double dishWashing = 70.0; // تنظيف الأطباق

//   /// Get price by service name (Arabic)
//   static double? getPriceByServiceName(String serviceName) {
//     final name = serviceName.toLowerCase().trim();
    
//     if (name.contains('سيارات') || name.contains('car')) {
//       return carCleaning;
//     } else if (name.contains('منازل') || name.contains('home') || name.contains('house')) {
//       return homeCleaning;
//     } else if (name.contains('سجاد') || name.contains('carpet')) {
//       return carpetCleaning;
//     } else if (name.contains('أطباق') || name.contains('dishes') || name.contains('dish')) {
//       return dishWashing;
//     }
    
//     return null;
//   }

//   /// Get price by service ID
//   static double? getPriceByServiceId(String serviceId) {
//     // You can map service IDs to prices if needed
//     // For now, return null to use service name instead
//     return null;
//   }
// }

