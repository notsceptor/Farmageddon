extends EnemyParent

var _path_progress: float = 0.0

@onready var _path_follow_3d: PathFollow3D

# Called when the node enters the scene tree for the first time.
func _ready():
	_name = "Giant Zombie Snail"
	_health = 10
	_size = 2
	_speed = 8 # Sped up to allow for easier debugging
	_path_follow_3d = get_node("../")

func _on_moving_state_processing(delta):
	_path_progress += delta * _speed
	_path_follow_3d.progress = _path_progress
