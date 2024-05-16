extends Node

signal items_changed(indexes)

var items: Array = []

func _ready():
	_load_items()

func add_item(item: Dictionary):
	if item is Dictionary:
		items.append(item)
		var index = items.size() - 1
		var test: Array[int] = [index]
		emit_signal("items_changed", test)
		_save_items()

func remove_item(index):
	var previous_item = items[index].duplicate()
	items.remove_at(index)
	var test: Array[int] = [index]
	emit_signal("items_changed", test)
	_save_items()
	return previous_item

func set_item_quantity(index, amount):
	if items[index] is Dictionary:
		items[index].quantity += amount
		if items[index].quantity <= 0:
			remove_item(index)
		else:
			var test: Array[int] = [index]
			emit_signal("items_changed", test)
			_save_items()

func _load_items():
	var file = FileAccess.open("res://Items/inventory.json", FileAccess.READ)
	if file != null:
		var json_content = file.get_as_text()
		var items_data = JSON.parse_string(json_content)

		for item_data in items_data.turrets:
			if item_data is Dictionary:
				items.append(item_data)
	else:
		printerr("Failed to open inventory.json file")

func _save_items():
	var file = FileAccess.open("res://Items/inventory.json", FileAccess.WRITE)
	if file != null:
		var items_data = []
		for item in items:
			if item is Dictionary:
				var item_data = {
					"name": item.name,
					"damage": item.damage,
					"ID": item.ID,
					"turret_level": item.get("turret_level", 1),
					"placed": item.placed
				}
				items_data.append(item_data)

		var data = {"turrets": items_data}
		var json_string = JSON.stringify(data, " ")
		file.store_string(json_string)
	else:
		printerr("Failed to open inventory.json file for writing")

func get_item_by_key(key):
	for item in items:
		if item is Dictionary and item.key == key:
			return item.duplicate()
	return null
