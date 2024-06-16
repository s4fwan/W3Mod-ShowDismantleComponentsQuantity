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

	parts = _inv.GetRecycleParts(item); // get the parts that will be returned when recycling the item

	for(i = 0; i < parts.Size(); i += 1) {
		var part : SItemParts;
		part = parts[i];

		var minQuantity : int;
		var maxQuantity : int;

		// set the min and max quantity of the part based on the craftsman level
		if (ECL_Grand_Master == level || ECL_Arch_Master == level) {
			minQuantity = maxQuantity = part.quantity;  // if the craftsman level is Grand Master or Arch Master, the quantity of the part will not change
		}
		else if (ECL_Master == level && part.quantity > 1) {
			minQuantity = 1;
			maxQuantity = part.quantity; // if the craftsman level is Master, the quantity of the part will be between 1 and the original quantity of the part
		}
		else {
			minQuantity = maxQuantity = 1; // if the craftsman level is Apprentice, the quantity of the part will be 1
		}

		predictedParts.PushBack(new PartQuantityRange(part.itemName, minQuantity, maxQuantity));
	}

	return predictedParts;
}