extends GridContainer

@onready var scroll_container: ScrollContainer = get_parent()

@export var activity_button_scene: PackedScene = preload("res://Scenes/User_Interface/activity_button.tscn")

func _ready():
	for item in Inventory.items:
		item.placed = false
		
	populate_grid()
	
func populate_grid():
	var num_columns = columns
	var num_rows = 0
	var row_items = []
	
	for child in get_children():
		child.queue_free()

	for item_data in Inventory.items:
		if item_data and item_data.placed == false:
			var turret_data = Turrets.get_turret_data(item_data.name)
			var item_button = activity_button_scene.instantiate()
			item_button.activity_button_icon = load(turret_data.icon)
			item_button.activity_draggable = load(turret_data.activity_draggable)
			item_button.turret_to_instantiate = load(turret_data.turret_to_instantiate)
			item_button.item_data = item_data
			item_button.get_child(2).visible = true
			item_button.get_child(1).visible = true
			var rarity_label = item_button.get_child(0)
			rarity_label.visible = true
			var rarity = turret_data.rarity.to_lower()
			match rarity:
				"common":
					rarity_label.modulate = Color("#A5CCC4")
				"uncommon":
					rarity_label.modulate = Color("#80E076")
				"rare":
					rarity_label.modulate = Color("#61B6DD")
				"epic":
					rarity_label.modulate = Color("#C461DD")
				"legendary":
					rarity_label.modulate = Color("#DDCD61")
					
			item_button.set_meta("turret_data", turret_data)
			add_child(item_button)
			row_items.append(item_button)
			
			if len(row_items) == num_columns:
				num_rows += 1
				row_items.clear()
	
	if not row_items.is_empty():
		num_rows += 1
		var remaining_space = num_columns - len(row_items)
		for _i in range(remaining_space):
			var empty_button = activity_button_scene.instantiate()
			empty_button.activity_button_icon = null
			empty_button.activity_draggable = null
			empty_button.turret_to_instantiate = null
			add_child(empty_button)
			row_items.append(empty_button)
