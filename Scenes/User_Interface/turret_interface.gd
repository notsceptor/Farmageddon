extends Node

var turret_data = {}

@onready var turret_container: GridContainer = $TurretContainer

func _ready():
	var file = FileAccess.open("res://Items/items.json", FileAccess.READ)
	var json_data = JSON.parse_string(file.get_as_text())
	file.close()

	turret_data = json_data

	for turret_name in turret_data:
		var turret_info = turret_data[turret_name]
		var turret_texture = TextureRect.new()

		var texture = load(turret_info["icon"])
		turret_texture.texture = texture
		
		var quantity_label = Label.new()
		quantity_label.text = str(turret_info["quantity"])
		quantity_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
		quantity_label.add_theme_constant_override("font_size", 16)
		quantity_label.position = Vector2(turret_texture.texture.get_width() - 20, 5)

		var delete_button = Button.new()
		delete_button.text = "Delete"
		delete_button.pressed.connect(self._on_delete_button_pressed.bind(turret_name))

		var place_button = Button.new()
		place_button.text = "Place"
		place_button.pressed.connect(self._on_place_button_pressed.bind(turret_name))

		var container = VBoxContainer.new()
		container.add_child(turret_texture)
		container.add_child(quantity_label)
		container.add_child(delete_button)
		container.add_child(place_button)

		turret_container.add_child(container)

func _on_delete_button_pressed(turret_name):
	print("Deleting turret: ", turret_name)

func _on_place_button_pressed(turret_name):
	print("Placing turret: ", turret_name)
