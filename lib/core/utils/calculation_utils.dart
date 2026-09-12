class CalculationUtils {
  CalculationUtils._();

  static int calculateItemRevenue(int quantity, int sellingPrice) {
    return quantity * sellingPrice;
  }

  static int calculateItemCost(int quantity, int hpp) {
    return quantity * hpp;
  }

  static int calculateItemProfit(int quantity, int sellingPrice, int hpp) {
    return calculateItemRevenue(quantity, sellingPrice) - calculateItemCost(quantity, hpp);
  }

  static int calculateTotalRevenue(List<Map<String, int>> items) {
    return items.fold(0, (sum, item) {
      return sum + calculateItemRevenue(item['quantity']!, item['sellingPrice']!);
    });
  }

  static int calculateTotalCost(List<Map<String, int>> items) {
    return items.fold(0, (sum, item) {
      return sum + calculateItemCost(item['quantity']!, item['hpp']!);
    });
  }

  static int calculateTotalProfit(List<Map<String, int>> items) {
    return calculateTotalRevenue(items) - calculateTotalCost(items);
  }

  static int calculateMargin(int revenue, int cost) {
    if (revenue == 0) return 0;
    return ((revenue - cost) / revenue * 100).round();
  }

  static double calculateMarginDouble(int revenue, int cost) {
    if (revenue == 0) return 0.0;
    return (revenue - cost) / revenue * 100;
  }

  static int totalQuantity(List<Map<String, int>> items) {
    return items.fold(0, (sum, item) => sum + item['quantity']!);
  }
}
