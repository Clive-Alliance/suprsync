// class WithdrawalSelection {
//   final String inventoryItemId;
//   int? quantity;
//   String? measurementUnitId;
//   String? locationId;

//   WithdrawalSelection({
//     required this.inventoryItemId,
//     this.quantity,
//     this.measurementUnitId,
//     this.locationId,
//   });

//   Map<String, dynamic> toJson() {
//     return {
//       "inventoryItemsId": inventoryItemId,
//       "quantityToWithdraw": quantity,
//       "measurementUnitId": measurementUnitId,
//       "withdrawLocationId": locationId,
//     };
//   }
// }

class WithdrawalSelection {
  final String inventoryItemId;
  int? quantity;
  String? measurementUnitId;
  String? measurementUnitName;
  String? locationId;

  WithdrawalSelection({
    required this.inventoryItemId,
    this.quantity = 1, // Default to 1
    this.measurementUnitId,
    this.measurementUnitName,
    this.locationId,
  });

  Map<String, dynamic> toJson() {
    return {
      "inventoryItemsId": inventoryItemId,
      "quantityToWithdraw": quantity ?? 1, // Ensure we always have a quantity
      "measurementUnitId": measurementUnitId,
      "withdrawLocationId": locationId,
    };
  }

  @override
  String toString() {
    return 'WithdrawalSelection(inventoryItemId: $inventoryItemId, quantity: $quantity, measurementUnitId: $measurementUnitId, locationId: $locationId)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is WithdrawalSelection &&
        other.inventoryItemId == inventoryItemId;
  }

  @override
  int get hashCode => inventoryItemId.hashCode;
}
