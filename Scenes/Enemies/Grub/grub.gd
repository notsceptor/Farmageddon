extends EnemyParent

var _path_progress: float = 0.0

@onready var _path_follow_3d: PathFollow3D
@onready var health_bar = $SubViewport/HealthBar3D
@onready var area_damage_timer = get_node("../../../AreaDamageTimer")
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var grub_container = get_node("../Area3D")

var _health = 25
var _max_health: int
var _speed = 1
var _size = 1
var _deathsound = false
var _burrow_cooldown = 15.0 # 15 second cooldown between burrows
var _last_burrow_time = 0.0 # Tracks the time of the last burrow
var _is_burrowed = false
var original_speed = _speed

# Called when the node enters the scene tree for the first time.
func _ready():
	health_bar.max_value = _health
	_max_health = _health
	health_bar.value = _health
	_path_follow_3d = get_node("../")
	health_bar.visible = false  # Hide the health bar initially

func _process(delta):
	if in_constant_aoe_damage_zone and area_damage_timer.time_left == 0:
		area_damage_timer.start()
	if _health <= 0:
		_speed = 0
		remove_enemy()
		if _deathsound == false:
			_deathsound = true
			WaveManager.enemies_on_map -= 1
			GlobalAudioPlayer.play_snail_death_sound()
	if Time.get_ticks_msec() - _last_burrow_time >= _burrow_cooldown * 1000:
		burrow()
	if _is_burrowed:
		health_bar.visible = false
	elif _health != _max_health and !_is_burrowed:
		health_bar.visible = true

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
			_health -= area.damage
			health_bar.value -= area.damage
			if (area.slow) and (_speed > (original_speed * area.slow)):
				_speed = _speed * area.slow

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

func burrow():
	_last_burrow_time = Time.get_ticks_msec()
	animation_player.stop()
	animation_player.play("Burrow")
	await get_tree().create_timer(1.5).timeout
	_is_burrowed = true
	grub_container.global_position.y -= 2
	await get_tree().create_timer(3.0).timeout
	_is_burrowed = false
	animation_player.play("Unburrow")
	await get_tree().create_timer(1.5).timeout
	grub_container.global_position.y += 2
	animation_player.play("Slither")
