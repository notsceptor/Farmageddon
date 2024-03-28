extends Node3D
class_name MapParent

var current_level_difficulty: String
var current_level_wave_number: int
var current_level_wave_size: int

@onready var full_enemy_array: Array = ["Scumbug", "Giant Zombie Snail"]

@onready var current_level_wave_number_label: Label = $UI/MarginContainer/HBoxContainer/WaveNumber
@onready var next_wave_button: Button = $UI/MarginContainer/HBoxContainer/NextWaveButton
@onready var refresh_wave_button: Button = $UI/MarginContainer2/TestRefreshMapButton

# THESE VARIABLES NEED TO BE ASSIGNED WHENEVER LEVELS
# ARE ADDED IN CODE ON THE MAIN NODE RIGHT SIDE
@export var tile_start:PackedScene
@export var tile_end:PackedScene
@export var tile_straight:PackedScene
@export var tile_corner:PackedScene
@export var tile_crossroads:PackedScene
@export var tile_empty:Array[PackedScene]
@export var debug_enemy:PackedScene

func _process(_delta):
	if Globals.wave_ongoing:
		next_wave_button.visible = false
	else:
		next_wave_button.visible = true

func _complete_grid():
	for x in range(PathGenInstance.path_config.map_length):
		for y in range(PathGenInstance.path_config.map_height):
			if not PathGenInstance.get_path_route().has(Vector2i(x,y)):
				var tile:Node3D = tile_empty.pick_random().instantiate()
				add_child(tile)
				tile.global_position = Vector3(x, 0, y)
				tile.global_rotation_degrees = Vector3(0, randi_range(0,3)*90, 0)
	
	for i in range(PathGenInstance.get_path_route().size()):
		var tile_score:int = PathGenInstance.get_tile_score(i)
		
		var tile:Node3D = tile_empty[0].instantiate()
		var tile_rotation: Vector3 = Vector3.ZERO
		
		if tile_score == 2:
			tile = tile_end.instantiate()
			tile_rotation = Vector3(0,-90,0)
		elif tile_score == 8:
			tile = tile_start.instantiate()
			tile_rotation = Vector3(0,90,0)
		elif tile_score == 10:
			tile = tile_straight.instantiate()
			tile_rotation = Vector3(0,90,0)
		elif tile_score == 1 or tile_score == 4 or tile_score == 5:
			tile = tile_straight.instantiate()
			tile_rotation = Vector3(0,0,0)
		elif tile_score == 6:
			tile = tile_corner.instantiate()
			tile_rotation = Vector3(0,180,0)
		elif tile_score == 12:
			tile = tile_corner.instantiate()
			tile_rotation = Vector3(0,90,0)
		elif tile_score == 9:
			tile = tile_corner.instantiate()
			tile_rotation = Vector3(0,0,0)
		elif tile_score == 3:
			tile = tile_corner.instantiate()
			tile_rotation = Vector3(0,270,0)
		elif tile_score == 15:
			tile = tile_crossroads.instantiate()
			tile_rotation = Vector3(0,0,0)
			
		add_child(tile)
		tile.global_position = Vector3(PathGenInstance.get_path_tile(i).x, 0, PathGenInstance.get_path_tile(i).y)
		tile.global_rotation_degrees = tile_rotation
		
func _on_ui_next_wave_button_pressed():
	print("Next wave button pressed")
	Globals.wave_ongoing = true
	
	while current_level_wave_size > 0:
		print("Wave size: " + str(current_level_wave_size))
		await get_tree().create_timer(1).timeout
		var randomly_chosen_enemy = _choose_random_enemy(full_enemy_array, current_level_wave_size)
		_spawn_enemy(randomly_chosen_enemy)

func _on_ui_refresh_map_button_pressed():
	print("Map refresh button pressed")
	_regenerate_new_map_layout(current_level_difficulty)
	
func _spawn_enemy(chosen_enemy: PackedScene):
	var enemy_to_spawn = chosen_enemy.instantiate()
	add_child(enemy_to_spawn)
		
func _choose_random_enemy(enemy_array: Array, wave_size: int) -> PackedScene:
	var chosen_enemy_scene: PackedScene
	var random_chosen_enemy: String = enemy_array[randi() % enemy_array.size()]
	if wave_size > 1:
		match random_chosen_enemy:
			"Scumbug":
				chosen_enemy_scene = preload("res://Scenes/Enemies/scumbug_container.tscn")
			"Giant Zombie Snail":
				chosen_enemy_scene = preload("res://Scenes/Enemies/giant_zombie_snail_container.tscn")
	else:
		chosen_enemy_scene = preload("res://Scenes/Enemies/scumbug_container.tscn")
	return chosen_enemy_scene
	
func _regenerate_new_map_layout(map_difficulty: String):
	var scene_to_load: String
	$UI/ReloadSceneText.visible = true
	$UI/MarginContainer/HBoxContainer/NextWaveButton.visible = false
	if map_difficulty == "easy":
		scene_to_load = ("res://Scenes/Maps/easy_map.tscn")
	TransitionLayer.reload_level(scene_to_load)

func no_enemies_left_on_map():
	$UI/MarginContainer/HBoxContainer/NextWaveButton.visible = true
	if current_level_wave_number % 5 == 0:
		_regenerate_new_map_layout(current_level_difficulty)
		$UI/MarginContainer/HBoxContainer/NextWaveButton.visible = false


