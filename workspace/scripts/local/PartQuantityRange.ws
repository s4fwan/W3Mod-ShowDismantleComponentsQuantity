struct PartQuantityRange {
	var itemName		: name;
	var minQuantity		: int;
	var maxQuantity		: int;

	// public function PartQuantityRange(itemName: name, minQuantity: int, maxQuantity: int) {
	// 	this.itemName = itemName;
	// 	this.minQuantity = minQuantity;
	// 	this.maxQuantity = maxQuantity;
	// }

	// public function Print() {
    //     Log("Item Name: " + this.itemName);
    //     Log("Min Quantity: " + IntToString(this.minQuantity));
    //     Log("Max Quantity: " + IntToString(this.maxQuantity));
    // }
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

// get the string representation of the craftsman level of the current merchant
function GetLevelString(npc: CNewNPC) : string {
	var level	: ECraftsmanLevel;
	var levelString : string;

	level = GetCraftsmanLevel(npc);

	switch(level) {
		case ECL_Undefined:
			levelString = "Undefined";
			break;
		case ECL_Journeyman:
			levelString = "Journeyman";
			break;
		case ECL_Master:
			levelString = "Master";
			break;
		case ECL_Grand_Master:
			levelString = "Grand Master";
			break;
		case ECL_Arch_Master:
			levelString = "Arch Master";
			break;
		default:
			levelString = "Unknown";
			break;
	}

	return levelString;
}

// code based on RecycleItem( id : SItemUniqueId, level : ECraftsmanLevel ) :  array<SItemUniqueId> from W3InventoryComponent
function PredictRecyclePartsQuantity(part: SItemParts, npc: CNewNPC) : PartQuantityRange {
	var level 				: ECraftsmanLevel;
	var predictedQuantity 	: PartQuantityRange;
	var i 					: int;
	var partName 			: name;
	var partMinQuantity 	: int;
	var partMaxQuantity 	: int;

	level = GetCraftsmanLevel(npc);

	partName = part.itemName;

	// // set the min and max quantity of the part based on the craftsman level
	// if (ECL_Grand_Master == level || ECL_Arch_Master == level) {
	// 	partMinQuantity = part.quantity;  // if the craftsman level is Grand Master or Arch Master, the quantity of the part will not change
	// 	partMaxQuantity = part.quantity;
	// }
	// else if (ECL_Master == level) {
	// 	partMinQuantity = 1;
	// 	partMaxQuantity = part.quantity; // if the craftsman level is Master, the quantity of the part will be between 1 and the original quantity of the part
	// }
	// else {
	// 	partMinQuantity = 1; // if the craftsman level is Apprentice, the quantity of the part will be 1
	// 	partMaxQuantity = 1;
	// }

	switch(level) {
		case ECL_Grand_Master:
			partMinQuantity = part.quantity;
			partMaxQuantity = part.quantity;
			break;
		case ECL_Arch_Master:
			partMinQuantity = part.quantity;
			partMaxQuantity = part.quantity;
			break;
		case ECL_Master:
			partMinQuantity = 1;
			partMaxQuantity = part.quantity;
			break;
		default:
			partMinQuantity = 1;
			partMaxQuantity = 1;
			break;
	}

	predictedQuantity.itemName = partName;
	predictedQuantity.minQuantity = partMinQuantity;
	predictedQuantity.maxQuantity = partMaxQuantity;

	return predictedQuantity;
}

// get the string representation of the quantity for the part that will be returned when recycling the item
function GetPartNumString(part: SItemParts, npc: CNewNPC) : string {
	var numString		: string;
	var range : PartQuantityRange;

	range = PredictRecyclePartsQuantity(part, npc);
	
	numString = IntToString(range.minQuantity);

	// if(range.minQuantity != range.maxQuantity) {
	// 	numString += " - " + IntToString(range.maxQuantity);
	// }

	// debug
	numString += " - " + IntToString(range.maxQuantity);

	return numString;
}