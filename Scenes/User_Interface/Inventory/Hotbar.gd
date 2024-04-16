extends SlotContainer

func _ready():
	display_item_slots(Inventory.cols, 1)
	await get_tree().process_frame
	position.x = (get_viewport_rect().size.x - size.x) / 2
	position.y = get_viewport_rect().size.y - size.y - 8
