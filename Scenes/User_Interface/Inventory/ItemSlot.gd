extends ColorRect

@onready var item_icon = $ItemIcon
@onready var item_quantity = $ItemQuantity

func display_item(item):
	if item:
		item_icon.texture = load(item.icon)
		if item.has("stackable"):
			item_quantity.text = str(item.quantity) if item.stackable else ""
		else:
			item_quantity.text = ""
	else:
		item_icon.texture = null
		item_quantity.text = ""
