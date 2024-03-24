extends Node3D
class_name EnemyParent

@onready var _name: String = "default_name"
@onready var _health: int = 0
@onready var _size: int = 0
@onready var _speed: float = 0.0

func get_enemy_name() -> String:
	return _name
	
func get_health() -> int:
	return _health
	
func get_size() -> int:
	return _size
	
func get_speed() -> float:
	return _speed
