extends Node

signal items_changed(indexes)

var cols = 9
var rows = 3
var slots = cols * rows
var items: Array[Dictionary] = []

func _ready():
	_initialize_inventory()
	_load_items()

func _initialize_inventory():
	for i in range(slots):
		items.append(null)

func add_item(item: Dictionary):
	var index = items.find(null)
	if index != -1:
		items[index] = item
		var test: Array[int] = [index]
		emit_signal("items_changed", test)
		_save_items()
	else:
		items.append(item)
		var test: Array[int] = [items.size() - 1]
		emit_signal("items_changed", test)
		_save_items()

func remove_item(index):
	var previous_item = items[index].duplicate()
	#items[index] = null
	var test: Array[int] = [index]
	emit_signal("items_changed", test)
	_save_items()
	return previous_item

func set_item_quantity(index, amount):
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
			add_item(item_data)
	else:
		printerr("Failed to open inventory.json file")

func _save_items():
	var file = FileAccess.open("res://Items/inventory.json", FileAccess.WRITE)
	if file != null:
		var items_data = {"turrets": items}
		var json_string = JSON.stringify(items_data, " ")
		file.store_string(json_string)
	else:
		printerr("Failed to open inventory.json file for writing")

func get_item_by_key(key):
	for item in items:
		if item and item.key == key:
			return item.duplicate()
	return null
