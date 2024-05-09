extends Node

signal hotbar_changed(indexes)

var cols = 9
var rows = 3
var slots = cols * rows
var items: Array[Dictionary] = []

func _ready():
	_load_items()

func set_item(index, item):
	var previous_item = items[index]
	items[index] = item
	var test : Array[int] = [index]
	emit_signal("hotbar_changed", test)
	return previous_item

func remove_item(index):
	var previous_item = items[index].duplicate()
	items[index].clear()
	var test : Array[int] = [index]
	emit_signal("hotbar_changed", test)
	return previous_item

func set_item_quantity(index, amount):
	items[index].quantity += amount
	if items[index].quantity <= 0:
		remove_item(index)
	else:
		var test : Array[int] = [index]
		emit_signal("items_changed", test)

func _load_items():
	var file = FileAccess.open("res://Items/hotbar.json", FileAccess.READ)
	if file != null:
		var json_content = file.get_as_text()
		var items_data = JSON.parse_string(json_content)
		
		for item_data in items_data.turrets:
			items.append(item_data)
	else:
		printerr("Failed to open hotbar.json file")

func get_item_by_key(key):
	for item in items:
		if item.key == key:
			return item.duplicate()
	return null
