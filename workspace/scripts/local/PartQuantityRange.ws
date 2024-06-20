class PartQuantityRange {
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
function GetCraftsmanLevel(npc: CNewNPC) : ECraftsmanLevel {
	var craftComp	: W3CraftsmanComponent;
	var level		: ECraftsmanLevel;

	craftComp = (W3CraftsmanComponent)npc.GetComponentByClassName('W3CraftsmanComponent');

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
function PredictRecyclePartsQuantity(part: SItemParts, npc: CNewNPC) : PartQuantityRange {
	var level 				: ECraftsmanLevel;
	var predictedQuantity 	: PartQuantityRange;
	var i 					: int;
	var partName 		: name;
	var partMinQuantity : int;
	var partMaxQuantity : int;

	level = GetCraftsmanLevel(npc);

	partName = part.itemName;

	// set the min and max quantity of the part based on the craftsman level
	if (ECL_Grand_Master == level || ECL_Arch_Master == level) {
		partMinQuantity = partMaxQuantity = part.quantity;  // if the craftsman level is Grand Master or Arch Master, the quantity of the part will not change
	}
	else if (ECL_Master == level && part.quantity > 1) {
		partMinQuantity = 1;
		partMaxQuantity = part.quantity; // if the craftsman level is Master, the quantity of the part will be between 1 and the original quantity of the part
	}
	else {
		partMinQuantity = partMaxQuantity = 1; // if the craftsman level is Apprentice, the quantity of the part will be 1
	}

	predictedQuantity = new PartQuantityRange(partName, partMinQuantity, partMaxQuantity);

	return predictedQuantity;
}

// get the string representation of the quantity of the parts that will be returned when recycling the item
function GetPartsNumString(parts: array<SItemParts>, npc: CNewNPC) : array<string> {
	var numStrings		: array<string>;
	var i 				: int;
	var part : PartQuantityRange;
	var numString : string;
	
	for(i = 0; i < parts.Size(); i += 1) {
		part = PredictRecyclePartsQuantity(parts[i], npc);

		numString = IntToString(part.minQuantity);

		if(part.minQuantity != part.maxQuantity) {
			numString += " - " + IntToString(part.maxQuantity);
		}

		numStrings.PushBack(numString);
	}

	return numStrings;
}