extends GridContainer

var dragged_item: Dictionary
var dragged_node: TextureRect
var drag_preview_node: TextureRect
@onready var hotbar_container: HBoxContainer = get_node("/root/Workshop UI/CanvasLayer/Turrets/HotbarContainer/PanelContainer/MarginContainer/HBoxContainer")

func _ready():
	populate_grid()

func populate_grid():
	for turret_data in Inventory.items:
		var container = Control.new()
		container.mouse_filter = Control.MOUSE_FILTER_PASS

		var background = ColorRect.new()
		background.color = Color(0, 0, 0, 0.3)
		background.custom_minimum_size = Vector2(114, 114) 
		background.show_behind_parent = true
		container.add_child(background)

		var square = TextureRect.new()
		square.texture = load(turret_data.icon)
		square.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		square.custom_minimum_size = Vector2(64, 64)
		container.add_child(square)

		square.set_meta("turret_data", turret_data)
		square.connect("gui_input", Callable(self, "_on_gui_input").bind(square))

		add_child(container)


func _on_gui_input(event: InputEvent, node: TextureRect):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if !node.get_meta("turret_data"):
			return
			
		if event.is_pressed():
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
			dragged_item = {}
			
func clear_item_from_grid(node: TextureRect):
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
	pass
