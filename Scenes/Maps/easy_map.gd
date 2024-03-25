extends MapParent

var enemy_array: Array = ["Scumbug", "Giant Zombie Snail"]
@onready var next_wave_button: Button = $UI/MarginContainer/HBoxContainer/NextWaveButton

@onready var cam = $Camera3D
var RAYCAST_LENGTH:float = 100

func _ready():
	_display_path()
	_complete_grid()
	
func _physics_process(_delta):
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		var space_state = get_world_3d().direct_space_state
		var mouse_pos:Vector2 = get_viewport().get_mouse_position()
		var origin:Vector3 = cam.project_ray_origin(mouse_pos)
		var end:Vector3 = origin + cam.project_ray_normal(mouse_pos) * RAYCAST_LENGTH
		var query = PhysicsRayQueryParameters3D.create(origin, end)
		query.collide_with_areas = true
		var rayResult:Dictionary = space_state.intersect_ray(query)
		if rayResult.size() > 0:
			var co:CollisionObject3D = rayResult.get("collider")
			print(co.get_groups())
		
	
func _on_ui_next_wave_button_pressed(wave_number, wave_size):
	Globals.wave_ongoing = true
	print("Starting wave: " + str(wave_number))
	print("Wave size of: " + str(wave_size))
	
	while wave_size > 0:
		var chosen_enemy = _choose_random_enemy(enemy_array, wave_size)
		_spawn_enemy(chosen_enemy)
		wave_size -= temp_enemy_size
		await get_tree().create_timer(0.2).timeout
		
func _regenerate_new_map_layout():
	$UI/ReloadSceneText.visible = true
	$UI/MarginContainer/HBoxContainer/NextWaveButton.visible = false
	TransitionLayer.reload_level("res://Scenes/Maps/easy_map.tscn")


func _on_no_enemies_left_on_map():
	next_wave_button.visible = true
	if Globals.easy_map_current_level % 5 == 0:
		_regenerate_new_map_layout()
		next_wave_button.visible = false
