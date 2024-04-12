extends EnemyParent

var _path_progress: float = 0.0

@onready var _path_follow_3d: PathFollow3D
@onready var health_bar = $SubViewport/HealthBar3D
@onready var area_damage_timer = get_node("../../../AreaDamageTimer")
@onready var animation_player = $AnimationPlayer

var _health = 45
var _speed = 0.8
var _size = 3

# Called when the node enters the scene tree for the first time.
func _ready():
	animation_player.set_speed_scale(2.0)
	health_bar.max_value = _health
	health_bar.value = _health
	_path_follow_3d = get_node("../")
	health_bar.visible = false  # Hide the health bar initially

func _process(_delta):
	if in_constant_aoe_damage_zone and area_damage_timer.time_left == 0:
		area_damage_timer.start()
	if _health <= 0:
		GlobalAudioPlayer.play_snail_death_sound()
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
			health_bar.visible = true # Show the health bar when taking damage
			_speed += 0.1
			animation_player.set_speed_scale(_speed*2.0)
			_health -= area.damage
			health_bar.value -= area.damage

func _on_area_3d_area_exited(area):
	if area.is_in_group("AOE"):
		in_constant_aoe_damage_zone = false
		area_damage_to_take -= area.damage

func _on_area_damage_timer_timeout():
	health_bar.visible = true
	_speed += 0.1
	_health -= area_damage_to_take
	health_bar.value -= area_damage_to_take

func get_size() -> int:
	return _size
