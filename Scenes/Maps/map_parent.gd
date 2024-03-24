extends Node3D
class_name MapParent

# THESE VARIABLES NEED TO BE ASSIGNED WHENEVER LEVELS
# ARE ADDED IN CODE ON THE MAIN NODE RIGHT SIDE
@export var tile_start:PackedScene
@export var tile_end:PackedScene
@export var tile_straight:PackedScene
@export var tile_corner:PackedScene
@export var tile_crossroads:PackedScene
@export var tile_empty:Array[PackedScene]

@export var map_length:int = 16
@export var map_height:int = 10

@export var min_path_size: int = 50
@export var max_path_size: int = 70
@export var min_loops: int = 3
@export var max_loops: int = 5

@onready var _path_generator = PathGenerator.new(map_length, map_height)

@onready var enemies_on_map: int = 0
var temp_enemy_size: int

signal no_enemies_left_on_map

func _ready():
	print("Parent loaded map")

func _complete_grid():
	for x in range(map_length):
		for y in range(map_height):
			if not _path_generator.get_path().has(Vector2i(x,y)):
				var tile:Node3D = tile_empty.pick_random().instantiate()
				add_child(tile)
				tile.global_position = Vector3(x, 0, y)
				tile.global_rotation_degrees = Vector3(0, randi_range(0,3)*90, 0)
	
func _display_path():
	var iteration_count:int = 1
	_path_generator.generate_path(true)

	while _path_generator.get_path().size() < min_path_size or _path_generator.get_path().size() > max_path_size or _path_generator.get_loop_count() < min_loops or _path_generator.get_loop_count() > max_loops:
		iteration_count += 1
		_path_generator.generate_path(true)

	print("Generated a path of %d tiles after %d iterations" % [_path_generator.get_path().size(), iteration_count])
	print(_path_generator.get_path())
	
	for i in range(_path_generator.get_path().size()):
		var tile_score:int = _path_generator.get_tile_score(i)
		
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
		tile.global_position = Vector3(_path_generator.get_path_tile(i).x, 0, _path_generator.get_path_tile(i).y)
		tile.global_rotation_degrees = tile_rotation
		
func _add_curve_point(c3d:Curve3D, v3:Vector3) ->bool:
	c3d.add_point(v3)
	return true
	
func _spawn_enemy(chosen_enemy: PackedScene):
	enemies_on_map += 1
	var enemy_to_spawn = chosen_enemy.instantiate()
	
	var c3d:Curve3D = Curve3D.new()
	
	for element in _path_generator.get_path():
		c3d.add_point(Vector3(element.x, 0.4, element.y))

	var p3d:Path3D = Path3D.new()
	add_child(p3d)
	p3d.curve = c3d
	
	var pf3d:PathFollow3D = PathFollow3D.new()
	p3d.add_child(pf3d)
	pf3d.add_child(enemy_to_spawn)
	
	temp_enemy_size = enemy_to_spawn.get_size()
	
	var curr_distance:float = 0.0
	
	while curr_distance < c3d.point_count-1:
		curr_distance += enemy_to_spawn.get_speed()
		pf3d.progress = clamp(curr_distance, 0, c3d.point_count-1.00001)
		await get_tree().create_timer(0.01).timeout
		
	p3d.queue_free() # To remove enemies at end of path
	enemies_on_map -= 1
	if enemies_on_map <= 0:
		no_enemies_left_on_map.emit()
		
func _choose_random_enemy(enemy_array: Array, wave_size: int) -> PackedScene:
	var chosen_enemy_scene: PackedScene
	var random_chosen_enemy: String = enemy_array[randi() % enemy_array.size()]
	if wave_size > 1:
		match random_chosen_enemy:
			"Scumbug":
				chosen_enemy_scene = preload("res://Scenes/Enemies/scumbug.tscn")
			"Giant Zombie Snail":
				chosen_enemy_scene = preload("res://Scenes/Enemies/giant_zombie_snail.tscn")
			"Crow":
				chosen_enemy_scene = preload("res://Scenes/Enemies/giant_crow.tscn")
	else:
		chosen_enemy_scene = preload("res://Scenes/Enemies/scumbug.tscn")
	return chosen_enemy_scene
