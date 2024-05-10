extends HBoxContainer

signal item_added(item_data, slot_index)

func _ready():
	populate_hotbar()

func populate_hotbar():
	for i in range(get_child_count()):
		var child = get_child(i)

		if i < Hotbar.items.size():
			var turret_data = Hotbar.items[i]
			child.set_item_data(turret_data)
			child.activity_button_icon = load(turret_data.icon)
			child.activity_draggable = load(turret_data.activity_draggable)
			child.turret_to_instantiate = load(turret_data.turret_to_instantiate)
		else:
			child.set_meta("turret_data", null)
			child.activity_button_icon = null
			child.activity_draggable = null
			child.turret_to_instantiate = null
			
func get_dropped_item(drop_position: Vector2) -> Dictionary:
	var dropped_item = null
	var drop_target = get_drop_target(drop_position)
	if drop_target and drop_target.get_parent() == self:
		var drop_target_index = drop_target.get_index()
		dropped_item = Hotbar.items[drop_target_index]
		emit_signal("item_dropped", dropped_item, drop_position)
	return dropped_item

func get_drop_target(drop_position: Vector2) -> Control:
	var drop_target = null
	var hotbar_children = get_children()
	for child in hotbar_children:
		var child_rect = Rect2(child.rect_global_position, child.rect_size)
		if child_rect.has_point(drop_position):
			drop_target = child
			break
	return drop_target
			
func add_item_to_hotbar(item_data: Dictionary, slot_index: int):
	if slot_index >= 0 and slot_index < get_child_count():
		var slot = get_child(slot_index)
		if slot is Button:
			print(item_data)
			slot.set_item_data(item_data)
			emit_signal("item_added", item_data, slot_index)
		else:
			print("Child node at index ", slot_index, " is not a Button")
	else:
		print("Invalid slot index: ", slot_index)
		
func set_item_data(item_data: Dictionary):
	set_meta("turret_data", item_data)
