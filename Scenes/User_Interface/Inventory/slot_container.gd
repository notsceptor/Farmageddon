extends GridContainer

class_name SlotContainer

var item_slot_scene = load("res://Scenes/User_Interface/Inventory/item_slot.tscn")
var item_slot = item_slot_scene.instantiate()

var slots = []

func display_item_slots(cols: int, rows: int):
	columns = cols
	for index in range(cols * rows):
		var item_slot = item_slot_scene.instantiate()
		add_child(item_slot)
		slots.append(item_slot)
		item_slot.display_item(Inventory.items[index])
	Inventory.connect("items_changed", Callable(self, "_on_Inventory_items_changed"))

func _on_Inventory_items_changed(indexes: Array[int]):
	for index in indexes:
		if index < len(slots):
			slots[index].display_item(Inventory.items[index])
