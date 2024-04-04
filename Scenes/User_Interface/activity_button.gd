extends Button

@export var activity_button_icon:Texture2D
@export var activity_draggable:PackedScene
@export var turret_to_instantiate:PackedScene

signal place_turret(turret_scene, location)

var _is_dragging:bool = false
var _draggable:Node

var _cam:Camera3D
var RAYCAST_LENGTH:float = 100

var _last_valid_location:Vector3
@onready var _error_mat:BaseMaterial3D = preload("res://Models/Turrets/red_transparent.material")

# Called when the node enters the scene tree for the first time.
func _ready():
	icon = activity_button_icon
	_draggable = activity_draggable.instantiate()
	add_child(_draggable)
	_draggable.visible = false
	_cam = get_viewport().get_camera_3d()
	
func _physics_process(_delta):
	if _is_dragging:
		var space_state = _draggable.get_world_3d().direct_space_state
		var mouse_pos:Vector2 = get_viewport().get_mouse_position()
		var origin:Vector3 = _cam.project_ray_origin(mouse_pos)
		var end:Vector3 = origin + _cam.project_ray_normal(mouse_pos) * RAYCAST_LENGTH
		var query = PhysicsRayQueryParameters3D.create(origin, end)
		query.collide_with_areas = true
		query.exclude = Globals.turret_rid_list # Exclude placed turret Area3Ds on dragging new turret
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

func _on_button_down():
	_is_dragging = true

func _on_button_up():
	_is_dragging = false
	_draggable.visible = false
	
	if _last_valid_location != Vector3.ZERO and _last_valid_location not in Globals.turret_locations_list:
		print("Placing turret")
		#var activity = activity_draggable.instantiate()
		#add_child(activity)
		#activity.global_position = _last_valid_location
		place_turret.emit(turret_to_instantiate, _last_valid_location)
		Globals.turret_locations_list.append(_last_valid_location)
		
	else:
		print("Cannot place turret")
		
		
		
		
