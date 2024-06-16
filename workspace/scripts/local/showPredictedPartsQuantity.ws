class CshowPredictedPartsQuantity {
	struct SPredictedItemPart {
		var itemName: string;
		var minQuantity: int;
		var maxQuantity: int;
		
		public function SPredictedItemPart(itemName: string, minQuantity: int, maxQuantity: int) {
			this.itemName = itemName;
			this.minQuantity = minQuantity;
			this.maxQuantity = maxQuantity;
		}
	}
}