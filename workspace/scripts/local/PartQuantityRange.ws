class CPartQuantityRange {
	var itemName		: name;
	var minQuantity		: int;
	var maxQuantity		: int;

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

// get the craftsman level of the current merchant
function GetCraftsmanLevel() : ECraftsmanLevel {
	var craftComp	: W3CraftsmanComponent;
	var level		: ECraftsmanLevel;

	craftComp = (W3CraftsmanComponent)_fixerNpc.GetComponentByClassName('W3CraftsmanComponent');

	if(craftComp) {
		if(craftComp.IsCraftsmanType(ECT_Smith)) {
			level = craftComp.GetCraftsmanLevel(ECT_Smith);
		}
		else if(craftComp.IsCraftsmanType(ECT_Armorer)) {
			level = craftComp.GetCraftsmanLevel(ECT_Armorer);
		}
		else {
			level = ECL_Journeyman;
		}
	}
	else {
		level = ECL_Journeyman;
	}

	return level;
}

// code based on RecycleItem( id : SItemUniqueId, level : ECraftsmanLevel ) :  array<SItemUniqueId> from W3InventoryComponent
function PredictRecyclePartsQuantity(item: SItemUniqueId) : array<PartQuantityRange> {
	var level 			: ECraftsmanLevel;
	var parts 			: array<SItemParts>;
	var predictedParts 	: array<PartQuantityRange>;
	var i 				: int;

	level = GetCraftsmanLevel(); 
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

// get the string representation of the quantity of the parts that will be returned when recycling the item
function GetPartsNumString(item: SItemUniqueId) : array<string> {
	var predictedParts 	: array<PartQuantityRange>;
	var numStrings		: array<string>;
	var i 				: int;

	predictedParts = PredictRecyclePartsQuantity(item);
	
	for(i = 0; i < predictedParts.Size(); i += 1) {
		var part : PartQuantityRange;
		part = predictedParts[i];

		var numString : string;
		numString = IntToString(part.minQuantity);

		if(part.minQuantity != part.maxQuantity) {
			numString += " - " + IntToString(part.maxQuantity);
		}

		numStrings.PushBack(numString);
	}

	return numStrings;
}