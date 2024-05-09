extends HBoxContainer

func _ready():
	populate_hotbar()

func populate_hotbar():
	for i in range(get_child_count()):
		var child = get_child(i)

		if i < Hotbar.items.size():
			var turret_data = Hotbar.items[i]
			print(turret_data)
			child.activity_button_icon = load(turret_data.icon)
			print(child.activity_button_icon)
			child.activity_draggable = load(turret_data.activity_draggable)
			child.turret_to_instantiate = load(turret_data.turret_to_instantiate)
		else:
			child.activity_button_icon = null
			child.activity_draggable = null
			child.turret_to_instantiate = null
