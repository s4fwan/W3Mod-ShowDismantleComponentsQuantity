struct PartQuantityRange {
	var itemName		: name;
	var minQuantity		: int;
	var maxQuantity		: int;
}

// get the craftsman level of the current merchant
// function based on code from OnDisassembleItem( item : SItemUniqueId, price : int) from CR4BlacksmithMenu
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

// function based on RecycleItem( id : SItemUniqueId, level : ECraftsmanLevel ) :  array<SItemUniqueId> from W3InventoryComponent
function PredictPartQuantity(part: SItemParts, level: ECraftsmanLevel) : PartQuantityRange {
	var predictedQuantity 	: PartQuantityRange;
	var partName 			: name;
	var partMinQuantity 	: int;
	var partMaxQuantity 	: int;

	partName = part.itemName;

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
			if(part.quantity < 3) {
				partMinQuantity = 1;
				partMaxQuantity = 1;
			}
			else {
				partMinQuantity = 1;
				partMaxQuantity = part.quantity - 1;
			}
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
function GetPartQuantityString(part: SItemParts, level: ECraftsmanLevel) : string {
	var quantity	: string;
	var range 		: PartQuantityRange;

	range = PredictPartQuantity(part, level);
	
	quantity = IntToString(range.minQuantity);

	if(range.minQuantity != range.maxQuantity) {
		quantity += "-" + IntToString(range.maxQuantity);
	}

	return quantity;
}