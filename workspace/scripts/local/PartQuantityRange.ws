class CPartQuantityRange {
	var itemName : name;
	var minQuantity : int;
	var maxQuantity : int;

	public function PartQuantityRange(itemName: name, minQuantity: int, maxQuantity: int) {
		this.itemName = itemName;
		this.minQuantity = minQuantity;
		this.maxQuantity = maxQuantity;
	}

	public function Print() {
        Log("Item Name: " + this.itemName);
        Log("Min Quantity: " + IntToString(this.minQuantity));
        Log("Max Quantity: " + IntToString(this.maxQuantity));
    }
}

function PredictRecyclePartQuantity(item: SItemUniqueId, level: ECraftsmanLevel) : array<PartQuantityRange> {
	var parts : array<SItemParts>;
	var predictedParts : array<PartQuantityRange>;
	var i : int;

	parts = _inv.GetRecycleParts(item);

	for(i = 0; i < parts.Size(); i += 1) {
		var part : SItemParts;
		part = parts[i];

		var minQuantity : int;
		var maxQuantity : int;

		if (ECL_Grand_Master == level || ECL_Arch_Master == level) {
			minQuantity = maxQuantity = part.quantity;
		}
		else if (ECL_Master == level && part.quantity > 1) {
			minQuantity = 1;
			maxQuantity = part.quantity;
		}
		else {
			minQuantity = maxQuantity = 1;
		}

		predictedParts.PushBack(new PartQuantityRange(part.itemName, minQuantity, maxQuantity));
	}

	return predictedParts;
}