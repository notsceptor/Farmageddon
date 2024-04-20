extends Node

signal place_turret(turret_scene, location)
signal cancel_turret_placement()

var turret_data = {}

@onready var turret_grid: GridContainer = $GridPadding/ScrollContainer/TurretGrid
@onready var turret_display: VBoxContainer = $DisplayPadding/TurretDisplay

var _is_dragging:bool = false
var _draggable:Node
var _current_turret_name:String

var _cam:Camera3D
var RAYCAST_LENGTH:float = 100

var _last_valid_location:Vector3
@onready var _error_mat:BaseMaterial3D = preload("res://Models/Turrets/red_transparent.material")

func _ready():
	# Load turret data from JSON file
	print("Script path: ", get_script().resource_path)
	var file = FileAccess.open("res://Items/items.json", FileAccess.READ)
	var json_data = JSON.parse_string(file.get_as_text())
	file.close()
	turret_data = json_data
	
	for turret_name in turret_data:
		var turret_info = turret_data[turret_name]
		if "draggable" in turret_info:
			_draggable = load(turret_info["draggable"]).instantiate()
			add_child(_draggable)
			_draggable.visible = false
			break

	_cam = get_viewport().get_camera_3d()

	# Set up turret grid
	turret_grid.columns = 4
	turret_grid.custom_minimum_size = Vector2(500, 500)

	# Add grid textures
	for x in range(5):
		for y in range(5):
			var grid_texture = ColorRect.new()
			grid_texture.color = Color(0.2, 0.2, 0.2, 0.2)
			grid_texture.custom_minimum_size = Vector2(100, 100)
			turret_grid.add_child(grid_texture)

	# Add turret icons to the grid
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

func _physics_process(_delta):
	if _is_dragging:
		var space_state = _draggable.get_world_3d().direct_space_state
		var mouse_pos:Vector2 = get_viewport().get_mouse_position()
		var origin:Vector3 = _cam.project_ray_origin(mouse_pos)
		var end:Vector3 = origin + _cam.project_ray_normal(mouse_pos) * RAYCAST_LENGTH
		var query = PhysicsRayQueryParameters3D.create(origin, end)
		query.collide_with_areas = true
		query.exclude = Globals.turret_rid_list
		var rayResult:Dictionary = space_state.intersect_ray(query)
		if rayResult.size() > 0:
			var co:CollisionObject3D = rayResult.get("collider")
			_draggable.visible = true
			_draggable.global_position = Vector3(co.global_position.x, 0.2, co.global_position.z)
			if co.get_groups()[0] != "tile" or _last_valid_location in Globals.turret_locations_list:
				configure_child_mesh(_draggable, _error_mat)
				_last_valid_location = Vector3.ZERO
				return
			configure_child_mesh(_draggable, null)
			_last_valid_location = _draggable.global_position
		else:
			_draggable.visible = false

func configure_child_mesh(n: Node, material_to_set: Material):
	for c in n.get_children():
		if c is MeshInstance3D:
			configure_mesh(c, material_to_set)
		elif c is Node:
			configure_child_mesh(c, material_to_set)

func configure_mesh(mesh_3d: MeshInstance3D, material_to_set: Material):
	for si in range(mesh_3d.mesh.get_surface_count()):
		mesh_3d.set_surface_override_material(si, material_to_set)

func _on_turret_texture_gui_input(event, turret_name):
	var turret_info = turret_data[turret_name]
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
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
	turret_display.add_child(place_button)
	turret_display.add_child(delete_button)

func _on_delete_button_pressed(turret_name):
	print("Deleting turret: ", turret_name)

func _on_place_button_pressed(turret_name):
	_current_turret_name = turret_name
	_is_dragging = true
	_draggable.visible = true
	get_parent().visible = !get_parent().visible

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
		if _is_dragging:
			var turret_info = turret_data[_current_turret_name]
			if _last_valid_location != Vector3.ZERO and _last_valid_location not in Globals.turret_locations_list:
				print("Placing turret")
				var map_parent = get_tree().current_scene
				if map_parent:
					map_parent._on_ui_place_turret(turret_info["scene"], _last_valid_location)
				else:
					print("Could not find MapParent node")
				Globals.turret_locations_list.append(_last_valid_location)
			else:
				print("Cannot place turret")
			_is_dragging = false
			_draggable.visible = false
			get_parent().visible = !get_parent().visible
