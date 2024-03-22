extends Node3D
class_name MapParent

# THESE VARIABLES NEED TO BE ASSIGNED WHENEVER LEVELS
# ARE ADDED IN CODE ON THE MAIN NODE RIGHT SIDE
@export var tile_start:PackedScene
@export var tile_end:PackedScene
@export var tile_straight:PackedScene
@export var tile_corner:PackedScene
@export var tile_crossroads:PackedScene
@export var tile_enemy:PackedScene
@export var tile_empty:Array[PackedScene]


@export var map_length:int = 16
@export var map_height:int = 10

@export var min_path_size: int = 50
@export var max_path_size: int = 70
@export var min_loops: int = 3
@export var max_loops: int = 5

var _wave_number: int = 1
var _wave_size: int = 5
var _path_generator: PathGenerator

func _ready():
	_path_generator = PathGenerator.new(map_length, map_height)
	_display_path()
	_complete_grid()

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

func _spawn_enemies(wave_size: int):
	print("Spawning enemies up to wave size of: " + str(wave_size))

func _on_ui_next_wave_button_pressed():
	var _wave_number_text = $UI/MarginContainer/HBoxContainer/WaveNumber
	_wave_number += 1
	_wave_size += 5
	_wave_number_text.text = "Current Wave: " + str(_wave_number)
	_spawn_enemies(_wave_size)
