extends EnemyParent

var _path_progress: float = 0.0

@onready var _path_follow_3d: PathFollow3D

@onready var health_bar = $SubViewport/HealthBar3D

signal died

# Called when the node enters the scene tree for the first time.
func _ready():
	_name = "Scumbug"
	_health = 10
	health_bar.max_value = _health
	_size = 1
	Globals.temp_enemy_size = _size
	_speed = 3
	_path_follow_3d = get_node("../")

func _on_moving_state_processing(delta):
	_path_progress += delta * _speed
	_path_follow_3d.progress = _path_progress

func _on_area_3d_area_entered(area):
	_health -= area.damage
	health_bar.value -= area.damage
	if _health <= 0:
		get_node("../../../").queue_free() # Fetches root node (container) and removes it
