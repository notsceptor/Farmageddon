extends EnemyParent

var _path_progress: float = 0.0

@onready var _path_follow_3d: PathFollow3D
@onready var health_bar = $SubViewport/HealthBar3D
@onready var area_damage_timer = get_node("../../../AreaDamageTimer")

var _health = 10
var _speed = 3
var _size = 1
var _deathsound = false

var original_speed
var slow_timer

# Called when the node enters the scene tree for the first time.
func _ready():
	original_speed = _speed
	health_bar.max_value = _health
	health_bar.value = _health
	_path_follow_3d = get_node("../")
	health_bar.visible = false # Hide the health bar initially
	print(_health)

func _process(delta):
	if in_constant_aoe_damage_zone and area_damage_timer.time_left == 0:
		area_damage_timer.start()
	if _health <= 0:
		_speed = 0
		remove_enemy()
		if _deathsound == false:
			_deathsound = true
			WaveManager.enemies_on_map -= 1
			WaveManager.enemies_killed += 1
			GlobalAudioPlayer.play_scumbug_death_sound()
			CurrencyDistributor.addGold(_size * 10)
	if slow_timer != null:
		slow_timer-=delta
		if slow_timer < 0:
			_speed = original_speed

func _on_moving_state_processing(delta):
	_path_progress += delta * _speed
	_path_follow_3d.progress = _path_progress

func _on_area_3d_area_entered(area):
	if area.is_in_group("AOE"):
		in_constant_aoe_damage_zone = true
		area_damage_to_take += area.damage
	else:
		if area.damage:
			health_bar.visible = true
			_health -= area.damage
			health_bar.value -= area.damage
			if (area.slow) and (_speed > (original_speed * area.slow)):
				_speed = _speed * area.slow
			if (area.slow_duration):
				slow_timer = area.slow_duration

func _on_area_3d_area_exited(area):
	if area.is_in_group("AOE"):
		in_constant_aoe_damage_zone = false
		area_damage_to_take -= area.damage

func _on_area_damage_timer_timeout():
	health_bar.visible = true
	_health -= area_damage_to_take
	health_bar.value -= area_damage_to_take

func get_size() -> int:
	return _size
