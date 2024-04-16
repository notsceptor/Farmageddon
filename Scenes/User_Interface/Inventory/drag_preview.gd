extends Control

var dragged_item: Dictionary = {}

@onready var item_icon: TextureRect = $ItemIcon
@onready var item_quantity: Label = $ItemQuantity

func _process(delta: float):
	if dragged_item:
		global_position = get_global_mouse_position()

func set_dragged_item(item):
	dragged_item = item
	if dragged_item:
		var dir = DirAccess.open("res://Models/Turrets/")
		if dir == OK:
			dir.list_dir_begin()
			var file_name = dir.get_next()
			while file_name != "":
				if file_name.ends_with("_cover.png"):
					item_icon.texture = load("res://Models/Turrets/" + file_name)
					break
				file_name = dir.get_next()
			dir.list_dir_end()
		item_quantity.text = str(dragged_item.quantity) if dragged_item.stackable else ""
	else:
		item_icon.texture = null
		item_quantity.text = ""

func get_dragged_item() -> Dictionary:
	return dragged_item
