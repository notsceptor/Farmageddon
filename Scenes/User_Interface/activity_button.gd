extends Button

@export var enable_drag_and_drop: bool = true
@onready var grid_container: GridContainer = get_node("/root/Workshop UI/CanvasLayer/Turrets/TurretsContainer/PanelContainer/MarginContainer/ScrollContainer/GridContainer")

@export var activity_button_icon: Texture2D:
	set(value):
		activity_button_icon = value
		icon = value

@export var activity_draggable: PackedScene:
	set(value):
		activity_draggable = value
		if activity_draggable:
			_draggable = activity_draggable.instantiate()
			add_child(_draggable)
			_draggable.visible = false
		else:
			_draggable = null

@export var turret_to_instantiate: PackedScene:
	set(value):
		turret_to_instantiate = value

var _is_dragging: bool = false
var _draggable: Node
var _drag_preview_node: TextureRect

var _cam: Camera3D
var RAYCAST_LENGTH: float = 100

var _last_valid_location: Vector3
@onready var _error_mat: BaseMaterial3D = preload("res://Models/Turrets/red_transparent.material")

func _ready():
	_cam = get_viewport().get_camera_3d()
	connect("gui_input", Callable(self, "_on_gui_input"))
	
	if not grid_container:
		grid_container = get_node_or_null("root/Workshop UI/CanvasLayer/Turrets/TurretsContainer/PanelContainer/MarginContainer/ScrollContainer/GridContainer")
	
	if enable_drag_and_drop:
		if not is_connected("button_down", Callable(self, "_on_button_down")):
			connect("button_down", Callable(self, "_on_button_down"))
		if not is_connected("button_up", Callable(self, "_on_button_up")):
			connect("button_up", Callable(self, "_on_button_up"))
	else:
		if is_connected("button_down", Callable(self, "_on_button_down")):
			disconnect("button_down", Callable(self, "_on_button_down"))
		if is_connected("button_up", Callable(self, "_on_button_up")):
			disconnect("button_up", Callable(self, "_on_button_up"))

func _on_gui_input(event: InputEvent):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.is_pressed():
			create_drag_preview(activity_button_icon)
		else:
			var drop_position = get_global_mouse_position()
			var drop_target = get_drop_target(drop_position)
			if drop_target is TextureRect:
				handle_drop_on_grid(drop_target, drop_position)
			remove_drag_preview()
					
func handle_drop_on_grid(drop_target: TextureRect, drop_position: Vector2):
	var turret_data = get_meta("turret_data")

	drop_target.set_meta("turret_data", turret_data)
	drop_target.texture = load(turret_data.icon)
	
func get_drop_target(drop_position: Vector2) -> Node:
	var drop_target = null
	if grid_container:
		for child in grid_container.get_children():
			if child is TextureRect:
				var child_rect = Rect2(child.global_position, child.size)
				if child_rect.has_point(drop_position):
					drop_target = child
					break

	return drop_target
			
func create_drag_preview(texture: Texture2D):
	_drag_preview_node = TextureRect.new()
	_drag_preview_node.texture = texture
	_drag_preview_node.modulate = Color(1, 1, 1, 0.5)
	add_child(_drag_preview_node)
	set_process(true)

func remove_drag_preview():
	if _drag_preview_node:
		remove_child(_drag_preview_node)
		_drag_preview_node.queue_free()
		_drag_preview_node = null
		set_process(false)

func _process(delta):
	if _drag_preview_node:
		_drag_preview_node.global_position = get_global_mouse_position()

func _physics_process(_delta):
	if _is_dragging and _draggable:
		var space_state = _draggable.get_world_3d().direct_space_state
		var mouse_pos: Vector2 = get_viewport().get_mouse_position()
		var origin: Vector3 = _cam.project_ray_origin(mouse_pos)
		var end: Vector3 = origin + _cam.project_ray_normal(mouse_pos) * RAYCAST_LENGTH
		var query = PhysicsRayQueryParameters3D.create(origin, end)
		query.collide_with_areas = true
		query.exclude = Globals.turret_rid_list  # Exclude placed turret Area3Ds on dragging new turret
		var rayResult: Dictionary = space_state.intersect_ray(query)
		if rayResult.size() > 0:
			var co: CollisionObject3D = rayResult.get("collider")
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

func _on_button_down():
	_is_dragging = true

func _on_button_up():
	_is_dragging = false
	if _draggable:
		_draggable.visible = false

	if _last_valid_location != Vector3.ZERO and _last_valid_location not in Globals.turret_locations_list:
		if turret_to_instantiate:
			EventBus.emit_signal("place_turret", turret_to_instantiate, _last_valid_location)
			Globals.turret_locations_list.append(_last_valid_location)
		else:
			print("Cannot place turret: No turret to instantiate")
	else:
		print("Cannot place turret")

func configure_child_mesh(n: Node, material_to_set: Material):
	for c in n.get_children():
		if c is MeshInstance3D:
			configure_mesh(c, material_to_set)
		elif c is Node:
			configure_child_mesh(c, material_to_set)

func configure_mesh(mesh_3d: MeshInstance3D, material_to_set: Material):
	for si in range(mesh_3d.mesh.get_surface_count()):
		mesh_3d.set_surface_override_material(si, material_to_set)

func set_item_data(item_data: Dictionary):
	activity_button_icon = load(item_data.icon)
	activity_draggable = load(item_data.activity_draggable)
	turret_to_instantiate = load(item_data.turret_to_instantiate)
	set_meta("turret_data", item_data)
