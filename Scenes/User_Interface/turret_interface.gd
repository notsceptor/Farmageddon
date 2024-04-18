extends Node

signal start_placing_turret(turret_scene)

var turret_data = {}

@onready var turret_grid: GridContainer = $GridPadding/ScrollContainer/TurretGrid
@onready var turret_display: VBoxContainer = $DisplayPadding/TurretDisplay

func _ready():
	var file = FileAccess.open("res://Items/items.json", FileAccess.READ)
	var json_data = JSON.parse_string(file.get_as_text())
	file.close()

	turret_data = json_data

	turret_grid.columns = 4
	turret_grid.custom_minimum_size = Vector2(500, 500)

	for x in range(5):
		for y in range(5):
			var grid_texture = ColorRect.new()
			grid_texture.color = Color(0.2, 0.2, 0.2, 0.2)
			grid_texture.custom_minimum_size = Vector2(100, 100)
			turret_grid.add_child(grid_texture)

	var turret_index = 0
	for turret_name in turret_data:
		var turret_info = turret_data[turret_name]
		var turret_texture = TextureRect.new()

		var texture = load(turret_info["icon"])
		turret_texture.texture = texture

		var quantity_label = Label.new()
		quantity_label.text = str(turret_info["quantity"])
		quantity_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
		quantity_label.add_theme_constant_override("font_size", 16)
		turret_texture.add_child(quantity_label)

		turret_texture.gui_input.connect(self._on_turret_texture_gui_input.bind(turret_name))
		turret_grid.get_child(turret_index).add_child(turret_texture)
		turret_index += 1

	_on_turret_texture_gui_input(Vector2.ZERO, turret_data.keys()[0])

func _on_turret_texture_gui_input(event, turret_name):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		_display_turret(turret_name)

func _display_turret(turret_name):
	for child in turret_display.get_children():
		turret_display.remove_child(child)
		child.queue_free()

	var turret_info = turret_data[turret_name]
	var turret_texture = TextureRect.new()
	turret_texture.custom_minimum_size = Vector2(200, 200)

	var texture = load(turret_info["icon"])
	turret_texture.texture = texture

	var delete_button = Button.new()
	delete_button.text = "Delete"
	delete_button.custom_minimum_size = Vector2(150, 50)
	delete_button.pressed.connect(self._on_delete_button_pressed.bind(turret_name))

	var place_button = Button.new()
	place_button.text = "Place"
	place_button.custom_minimum_size = Vector2(150, 50)
	place_button.pressed.connect(self._on_place_button_pressed.bind(turret_name))

	turret_display.add_child(turret_texture)
	turret_display.add_child(delete_button)
	turret_display.add_child(place_button)

func _on_delete_button_pressed(turret_name):
	print("Deleting turret: ", turret_name)

func _on_place_button_pressed(turret_name):
	print("Placing turret: ", turret_name)

