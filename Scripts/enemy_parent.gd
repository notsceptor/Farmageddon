extends Node3D
class_name EnemyParent

@onready var _name: String = "default_name"
@onready var _health: int = 0
@onready var _size: int = 0
@onready var _speed: float = 0.0

var curve_3d: Curve3D

func _ready():
	curve_3d = Curve3D.new()
	for i in PathGenInstance.get_path_route():
		curve_3d.add_point(Vector3(i.x, 0, i.y))
		
	$Path3D.curve = curve_3d
	$Path3D/PathFollow3D.progress_ratio = 0

func _on_spawning_state_entered():
	print("Enemy Spawned")
	
func get_enemy_name() -> String:
	return _name
	
func get_health() -> int:
	return _health
	
func get_size() -> int:
	return _size
	
func get_speed() -> float:
	return _speed
