extends EnemyParent

var _path_progress: float = 0.0

@onready var _path_follow_3d: PathFollow3D

@onready var health_bar = $SubViewport/HealthBar3D

@onready var area_damage_timer = get_node("../../../AreaDamageTimer")

var _size_to_set: int = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	_name = "Scumbug"
	_health = 10
	health_bar.max_value = _health
	_size = _size_to_set
	Globals.temp_enemy_size = _size
	_speed = 3
	_path_follow_3d = get_node("../")

func _process(_delta):
	if in_constant_aoe_damage_zone and area_damage_timer.time_left == 0:
		area_damage_timer.start()
	if _health <= 0:
		GlobalAudioPlayer.play_scumbug_death_sound()
		remove_enemy()

func _on_moving_state_processing(delta):
	_path_progress += delta * _speed
	_path_follow_3d.progress = _path_progress

func _on_area_3d_area_entered(area):
	if area.is_in_group("AOE"):
		in_constant_aoe_damage_zone = true
		area_damage_to_take += area.damage
	else:
		if area.damage:
			_health -= area.damage
			health_bar.value -= area.damage

func _on_area_3d_area_exited(area):
	if area.is_in_group("AOE"):
		in_constant_aoe_damage_zone = false
		area_damage_to_take -= area.damage

func _on_area_damage_timer_timeout():
	_health -= area_damage_to_take
	health_bar.value -= area_damage_to_take

func get_size() -> int:
	return _size_to_set
