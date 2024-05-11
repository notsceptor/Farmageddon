extends GridContainer

var dragged_item: Dictionary
var dragged_node: TextureRect
var drag_preview_node: TextureRect

@onready var hotbar_container: HBoxContainer = get_node("/root/Workshop UI/CanvasLayer/Turrets/HotbarContainer/PanelContainer/MarginContainer/HBoxContainer")
@onready var item_preview: Control = get_node("/root/Workshop UI/CanvasLayer/Turrets/UpgradeContainer/PanelContainer/MarginContainer/VBoxContainer/TurretPreview")
@onready var stat_change_label: Label = get_node("/root/Workshop UI/CanvasLayer/Turrets/UpgradeContainer/PanelContainer/MarginContainer/VBoxContainer/StatChange")
@onready var resources_to_upgrade_label: Label = get_node("/root/Workshop UI/CanvasLayer/Turrets/UpgradeContainer/PanelContainer/MarginContainer/VBoxContainer/ResourcesNeeded")
@onready var turret_name_label: Label = get_node("/root/Workshop UI/CanvasLayer/Turrets/UpgradeContainer/PanelContainer/MarginContainer/VBoxContainer/TurretName")
@onready var upgrade_button: Button = get_node("/root/Workshop UI/CanvasLayer/Turrets/UpgradeContainer/PanelContainer/MarginContainer/VBoxContainer/UpgradeButton")

func _ready():
	populate_grid()

func populate_grid():
	self.columns = 7

	var index = 0
	for row in range(7):
		for col in range(7):
			var background = ColorRect.new()
			background.color = Color(0, 0, 0, 0.5)
			background.custom_minimum_size = Vector2(114, 114) 
			background.show_behind_parent = true
			
			var square = TextureRect.new()
			if index < Inventory.items.size():
				var item_data = Inventory.items[index]
				if item_data:
					square.texture = load(item_data.icon)
					square.set_meta("turret_data", item_data)
				
			square.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
			square.custom_minimum_size = Vector2(114, 114)
			background.add_child(square)
			square.connect("gui_input", Callable(self, "_on_gui_input").bind(square))
			add_child(background)
			
			index += 1

func _on_gui_input(event: InputEvent, node: TextureRect):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if !node.get_meta("turret_data"):
			return
			
		if event.is_pressed():
			var item_data = node.get_meta("turret_data")
			display_item_preview(item_data)
			
		"""if event.is_pressed():
			dragged_node = node
			dragged_item = node.get_meta("turret_data")
			create_drag_preview(dragged_item.icon)
		else:
			remove_drag_preview()
			var mouse_position = get_global_mouse_position()
			var drop_target = get_drop_target(mouse_position)
			if drop_target and drop_target.get_parent() == hotbar_container:
				var drop_target_index = drop_target.get_index()
				hotbar_container.add_item_to_hotbar(dragged_item, drop_target_index)
				clear_item_from_grid(dragged_node)
			
			dragged_node = null
			dragged_item = {}"""
			
func display_item_preview(item_data: Dictionary):
	for child in item_preview.get_children():
		child.queue_free()

	var enlarged_icon = TextureRect.new()
	enlarged_icon.texture = load(item_data.icon)
	enlarged_icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	enlarged_icon.custom_minimum_size = Vector2(256, 256)

	item_preview.add_child(enlarged_icon)

	turret_name_label.text = item_data.name

	stat_change_label.text = "Damage: +%d" % item_data.damage

	var upgrade_cost = calculate_upgrade_cost(item_data.rarity)
	resources_to_upgrade_label.text = "Upgrade Cost: %d Gems" % upgrade_cost

	upgrade_button.text = "Upgrade"
	upgrade_button.connect("pressed", Callable(self, "_on_upgrade_button_pressed").bind(item_data))
	
func calculate_upgrade_cost(rarity: String) -> int:
	match rarity:
		"common":
			return 100
		"uncommon":
			return 200
		"rare":
			return 300
		"epic":
			return 400
		"legendary":
			return 500
		_:
			return 0

"""func clear_item_from_grid(node: TextureRect):
	node.texture = null
	node.set_meta("turret_data", null)

func create_drag_preview(icon_path: String):
	drag_preview_node = TextureRect.new()
	drag_preview_node.texture = load(icon_path)
	drag_preview_node.modulate = Color(1, 1, 1, 0.5)
	add_child(drag_preview_node)
	set_process(true)

func remove_drag_preview():
	if drag_preview_node:
		remove_child(drag_preview_node)
		drag_preview_node.queue_free()
		drag_preview_node = null
		set_process(false)

func _process(delta):
	if drag_preview_node:
		drag_preview_node.global_position = get_global_mouse_position()
		
func get_drop_target(mouse_position: Vector2) -> Control:
	var drop_target = null
	var hotbar_children = hotbar_container.get_children()
	
	for child in hotbar_children:
		var child_rect = Rect2(child.get_global_position(), child.get_rect().size)
		if child_rect.has_point(mouse_position):
			drop_target = child
			break
	
	return drop_target

func add_item_to_hotbar(item_data: Dictionary, index: int):
	pass"""
